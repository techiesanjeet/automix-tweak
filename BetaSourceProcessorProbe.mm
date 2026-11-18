#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

#include "smartmix/BetaSourceProcessorProbe.h"

#include <cstring>
#include <dlfcn.h>

namespace {
using SourceFormatFunction = bool (*)(AudioStreamBasicDescription *);
using CanReadAheadFunction = bool (*)(void);
using ProcessorAttachedFunction = bool (*)(void *);

template <typename T>
T resolve(const char *name) {
    return reinterpret_cast<T>(dlsym(RTLD_DEFAULT, name));
}
}

extern "C" int SMBetaPipelineInspect(SMBetaPipelineInfo *info) {
    if (!info) return 0;
    std::memset(info, 0, sizeof(*info));
    info->structSize = sizeof(*info);

    const auto sourceFormat = resolve<SourceFormatFunction>(
        "SGAudioPipelineSourceFormat");
    const auto canReadAhead = resolve<CanReadAheadFunction>(
        "SGAudioPipelineSourceCanReadAhead");
    const auto processorAttached = resolve<ProcessorAttachedFunction>(
        "SGAudioPipelineSourceProcessorAttached");

    if (sourceFormat) info->symbolMask |= 1u;
    if (canReadAhead) info->symbolMask |= 2u;
    if (processorAttached) info->symbolMask |= 4u;

    AudioStreamBasicDescription format{};
    if (sourceFormat && sourceFormat(&format)) {
        info->sourceFormatAvailable = 1;
        info->sampleRate = format.mSampleRate;
        info->formatID = format.mFormatID;
        info->formatFlags = format.mFormatFlags;
        info->bytesPerPacket = format.mBytesPerPacket;
        info->framesPerPacket = format.mFramesPerPacket;
        info->bytesPerFrame = format.mBytesPerFrame;
        info->channelsPerFrame = format.mChannelsPerFrame;
        info->bitsPerChannel = format.mBitsPerChannel;
    }

    if (canReadAhead) info->canReadAhead = canReadAhead() ? 1 : 0;
    info->processorAttachedQueryAvailable = processorAttached ? 1 : 0;
    return 1;
}
