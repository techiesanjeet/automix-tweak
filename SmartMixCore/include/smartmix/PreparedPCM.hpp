#pragma once

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <vector>

namespace smartmix {

// Callback-side PCM substitution for a fully rendered transition. The host
// must prefill output with original Taurus PCM; process() overwrites only the
// exact scheduled interval and never allocates, locks, or waits.
class PreparedPCMSubstitution {
public:
    enum class State : std::uint8_t {
        Empty, Preparing, Armed, Playing, CancelRequested, Completed, Cancelled
    };
    static_assert(std::atomic<State>::is_always_lock_free,
                  "Prepared PCM callback state must be lock-free");

    explicit PreparedPCMSubstitution(std::size_t capacityFrames,
                                     unsigned maxChannels = 2);

    // Worker-thread only. PCM is copied into fixed storage before the slot is
    // published to the audio thread. A completed/cancelled slot can be reused.
    bool arm(const float* interleavedPCM, std::size_t frames, unsigned channels,
             double sampleRate, std::uint64_t sourceEpoch,
             std::uint64_t startSourceFrame);

    // Real-time audio-thread only; one callback thread must own this object.
    // Returns true if any output frames were replaced by prepared PCM.
    bool process(float* output, std::size_t frames, unsigned channels,
                 double sampleRate, std::uint64_t sourceEpoch,
                 std::uint64_t callbackSourceFrame) noexcept;

    // May be called from a worker. The audio thread acknowledges cancellation
    // before the slot becomes reusable, preventing buffer overwrite mid-copy.
    void requestCancel() noexcept;

    State state() const noexcept { return state_.load(std::memory_order_acquire); }

private:
    void finishCancelled() noexcept;

    std::vector<float> storage_;
    const std::size_t capacityFrames_;
    const unsigned maxChannels_;
    std::atomic<State> state_{State::Empty};

    // Published before Armed with release/acquire ordering. These fields are
    // immutable while Armed/Playing/CancelRequested.
    std::size_t activeFrames_{0};
    unsigned channels_{0};
    double sampleRate_{0.0};
    std::uint64_t sourceEpoch_{0};
    std::uint64_t startSourceFrame_{0};

    // Audio-thread-owned playback cursor; initialized by arm() before publish.
    std::size_t consumedFrames_{0};
    std::uint64_t expectedSourceFrame_{0};
};

} // namespace smartmix
