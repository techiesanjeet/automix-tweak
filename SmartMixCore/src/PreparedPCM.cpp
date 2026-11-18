#include "smartmix/PreparedPCM.hpp"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <limits>

namespace smartmix {

PreparedPCMSubstitution::PreparedPCMSubstitution(std::size_t capacityFrames,
                                                 unsigned maxChannels)
    : capacityFrames_(capacityFrames), maxChannels_(maxChannels) {
    if (maxChannels_ == 0 || maxChannels_ > 8 ||
        capacityFrames_ > std::numeric_limits<std::size_t>::max() / maxChannels_) {
        return;
    }
    storage_.resize(capacityFrames_ * maxChannels_);
}

bool PreparedPCMSubstitution::arm(const float* pcm, std::size_t frames,
                                  unsigned channels, double sampleRate,
                                  std::uint64_t sourceEpoch,
                                  std::uint64_t startSourceFrame) {
    if (storage_.empty() || !pcm || frames == 0 || frames > capacityFrames_ ||
        channels == 0 || channels > maxChannels_ ||
        frames > std::numeric_limits<std::size_t>::max() / channels ||
        frames > std::numeric_limits<std::uint64_t>::max() - startSourceFrame ||
        !std::isfinite(sampleRate) || sampleRate < 8000.0 || sampleRate > 192000.0) {
        return false;
    }
    const std::size_t sampleCount = frames * static_cast<std::size_t>(channels);
    for (std::size_t i = 0; i < sampleCount; ++i) {
        if (!std::isfinite(pcm[i])) return false;
    }

    State observed = state_.load(std::memory_order_acquire);
    for (;;) {
        if (observed != State::Empty && observed != State::Completed &&
            observed != State::Cancelled) return false;
        if (state_.compare_exchange_weak(observed, State::Preparing,
                                         std::memory_order_acq_rel,
                                         std::memory_order_acquire)) break;
    }

    std::memcpy(storage_.data(), pcm, sampleCount * sizeof(float));
    activeFrames_ = frames;
    channels_ = channels;
    sampleRate_ = sampleRate;
    sourceEpoch_ = sourceEpoch;
    startSourceFrame_ = startSourceFrame;
    consumedFrames_ = 0;
    expectedSourceFrame_ = startSourceFrame;

    State preparing = State::Preparing;
    if (!state_.compare_exchange_strong(preparing, State::Armed,
                                        std::memory_order_release,
                                        std::memory_order_acquire)) {
        if (preparing == State::CancelRequested) {
            state_.store(State::Cancelled, std::memory_order_release);
        }
        return false;
    }
    return true;
}

void PreparedPCMSubstitution::finishCancelled() noexcept {
    state_.store(State::Cancelled, std::memory_order_release);
}

void PreparedPCMSubstitution::requestCancel() noexcept {
    State observed = state_.load(std::memory_order_acquire);
    while (observed == State::Preparing || observed == State::Armed ||
           observed == State::Playing) {
        if (state_.compare_exchange_weak(observed, State::CancelRequested,
                                         std::memory_order_acq_rel,
                                         std::memory_order_acquire)) return;
    }
}

bool PreparedPCMSubstitution::process(float* output, std::size_t frames,
                                      unsigned channels, double sampleRate,
                                      std::uint64_t sourceEpoch,
                                      std::uint64_t callbackSourceFrame) noexcept {
    if (!output || frames == 0) return false;
    State current = state_.load(std::memory_order_acquire);
    if (current == State::CancelRequested) {
        finishCancelled();
        return false;
    }
    if (current != State::Armed && current != State::Playing) return false;

    if (channels != channels_ ||
        frames > std::numeric_limits<std::size_t>::max() / channels ||
        !std::isfinite(sampleRate) || std::abs(sampleRate - sampleRate_) > 0.5 ||
        sourceEpoch != sourceEpoch_ ||
        frames > std::numeric_limits<std::uint64_t>::max() - callbackSourceFrame) {
        finishCancelled();
        return false;
    }

    std::size_t destinationOffset = 0;
    std::size_t sourceOffset = 0;
    std::size_t copyFrames = 0;

    if (current == State::Armed) {
        if (callbackSourceFrame > startSourceFrame_) {
            finishCancelled(); // the scheduled start was missed
            return false;
        }
        const std::uint64_t callbackEnd = callbackSourceFrame +
            static_cast<std::uint64_t>(frames);
        if (callbackEnd <= startSourceFrame_) return false;

        State armed = State::Armed;
        if (!state_.compare_exchange_strong(armed, State::Playing,
                                            std::memory_order_acq_rel,
                                            std::memory_order_acquire)) {
            if (armed == State::CancelRequested) finishCancelled();
            return false;
        }

        destinationOffset = static_cast<std::size_t>(
            startSourceFrame_ - callbackSourceFrame);
        copyFrames = std::min(frames - destinationOffset, activeFrames_);
        sourceOffset = 0;
    } else {
        if (callbackSourceFrame != expectedSourceFrame_) {
            finishCancelled(); // seek, skip, dropped callback, or clock jump
            return false;
        }
        sourceOffset = consumedFrames_;
        copyFrames = std::min(frames, activeFrames_ - consumedFrames_);
    }

    if (copyFrames == 0) {
        finishCancelled();
        return false;
    }

    const std::size_t sampleBytes = copyFrames *
        static_cast<std::size_t>(channels_) * sizeof(float);
    std::memcpy(output + destinationOffset * channels_,
                storage_.data() + sourceOffset * channels_, sampleBytes);

    consumedFrames_ += copyFrames;
    expectedSourceFrame_ = startSourceFrame_ +
        static_cast<std::uint64_t>(consumedFrames_);

    if (consumedFrames_ >= activeFrames_) {
        State playing = State::Playing;
        if (!state_.compare_exchange_strong(playing, State::Completed,
                                            std::memory_order_release,
                                            std::memory_order_acquire) &&
            playing == State::CancelRequested) {
            finishCancelled();
        }
    } else if (state_.load(std::memory_order_acquire) == State::CancelRequested) {
        finishCancelled();
    }
    return true;
}

} // namespace smartmix
