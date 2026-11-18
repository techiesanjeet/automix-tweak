#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SMBetaPipelineInfo {
    uint32_t structSize;
    uint32_t symbolMask;
    int32_t sourceFormatAvailable;
    int32_t canReadAhead;
    int32_t nullContextProcessorAttached;
    double sampleRate;
    uint32_t formatID;
    uint32_t formatFlags;
    uint32_t bytesPerPacket;
    uint32_t framesPerPacket;
    uint32_t bytesPerFrame;
    uint32_t channelsPerFrame;
    uint32_t bitsPerChannel;
} SMBetaPipelineInfo;

// Read-only probe for the Taurus 0.60.7 Beta source pipeline. It never
// registers a processor, pulls audio, or changes playback.
int SMBetaPipelineInspect(SMBetaPipelineInfo *info);

#ifdef __cplusplus
}
#endif
