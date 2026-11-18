#pragma once

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SMBeatThisModel SMBeatThisModel;

// Loads a compiled .mlmodelc from a local filesystem path. No network access.
SMBeatThisModel *SMBeatThisCreateFromPath(const char *compiledModelPath);

// Looks for BeatThisSmall0.mlmodelc in the installed SmartMixResources.bundle.
SMBeatThisModel *SMBeatThisCreateInstalled(void);

void SMBeatThisDestroy(SMBeatThisModel *model);

// Background-worker API only. Requires exactly 1500 x 128 float32 log-mel
// values and writes 1500 beat and 1500 downbeat logits.
int SMBeatThisPredict(SMBeatThisModel *model,
                      const float *spectrogram,
                      size_t frames,
                      size_t melBins,
                      float *beatLogits,
                      float *downbeatLogits);

// Worker-only convenience API: extracts the pinned Beat This log-mel frontend
// from mono 22050 Hz PCM and pads the spectrogram to one 1500-frame model chunk.
// Padding is limited to the upstream six-frame overlap border.
int SMBeatThisPredictMonoChunk(SMBeatThisModel *model,
                               const float *mono22050,
                               size_t audioFrames,
                               size_t leftPadFrames,
                               size_t rightPadFrames,
                               float *beatLogits,
                               float *downbeatLogits);

#ifdef __cplusplus
}
#endif
