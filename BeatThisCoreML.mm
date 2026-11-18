#import <CoreML/CoreML.h>
#import <Foundation/Foundation.h>

#include "smartmix/BeatThisCoreML.h"
#include "smartmix/BeatThisSpectrogram.hpp"

#include <cmath>
#include <dlfcn.h>
#include <cstring>
#include <new>
#include <vector>

struct SMBeatThisModel {
    void *model;
};

namespace {
constexpr std::size_t kBeatThisFrames = 1500;
constexpr std::size_t kBeatThisMelBins = 128;

bool copyLogits(MLMultiArray *array, float *destination) {
    if (!array || !destination || array.dataType != MLMultiArrayDataTypeFloat32 ||
        array.shape.count != 2 || array.shape[0].unsignedIntegerValue != 1 ||
        array.shape[1].unsignedIntegerValue != kBeatThisFrames ||
        array.strides.count != 2) return false;

    const std::size_t stride = array.strides[1].unsignedIntegerValue;
    const float *values = static_cast<const float *>(array.dataPointer);
    if (!values) return false;
    for (std::size_t i = 0; i < kBeatThisFrames; ++i) {
        const float value = values[i * stride];
        if (!std::isfinite(value)) return false;
        destination[i] = value;
    }
    return true;
}
}

extern "C" SMBeatThisModel *SMBeatThisCreateFromPath(const char *compiledModelPath) {
    if (!compiledModelPath || !compiledModelPath[0]) return nullptr;
    @autoreleasepool {
        if (@available(iOS 16.0, *)) {
            NSString *path = [NSString stringWithUTF8String:compiledModelPath];
            if (!path) return nullptr;
            NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
            MLModelConfiguration *configuration = [[MLModelConfiguration alloc] init];
            configuration.computeUnits = MLComputeUnitsAll;
            NSError *error = nil;
            MLModel *loaded = [MLModel modelWithContentsOfURL:url
                                                configuration:configuration
                                                        error:&error];
            if (!loaded) return nullptr;
            SMBeatThisModel *handle = new (std::nothrow) SMBeatThisModel;
            if (!handle) return nullptr;
            handle->model = (__bridge_retained void *)loaded;
            return handle;
        }
    }
    return nullptr;
}

extern "C" SMBeatThisModel *SMBeatThisCreateInstalled(void) {
    @autoreleasepool {
        NSMutableArray<NSString *> *candidates = [NSMutableArray array];
        Dl_info imageInfo = {};
        if (dladdr((void *)SMBeatThisCreateInstalled, &imageInfo) &&
            imageInfo.dli_fname) {
            NSString *imagePath = [NSString stringWithUTF8String:imageInfo.dli_fname];
            NSString *imageDirectory = imagePath.stringByDeletingLastPathComponent;
            [candidates addObject:[imageDirectory
                stringByAppendingPathComponent:@"SmartMixResources.bundle"]];
            [candidates addObject:[[imageDirectory
                stringByAppendingPathComponent:@"../Application Support/AutoMix"]
                stringByAppendingPathComponent:@"SmartMixResources.bundle"]];
        }
        [candidates addObject:
            @"/Library/Application Support/AutoMix/SmartMixResources.bundle"];
        [candidates addObject:
            @"/var/jb/Library/Application Support/AutoMix/SmartMixResources.bundle"];
        NSString *appBundle = NSBundle.mainBundle.bundlePath;
        [candidates addObject:[appBundle
            stringByAppendingPathComponent:@"SmartMixResources.bundle"]];
        [candidates addObject:[[appBundle
            stringByAppendingPathComponent:@"Frameworks"]
            stringByAppendingPathComponent:@"SmartMixResources.bundle"]];

        NSFileManager *files = NSFileManager.defaultManager;
        for (NSString *bundlePath in candidates) {
            BOOL isDirectory = NO;
            if (![files fileExistsAtPath:bundlePath isDirectory:&isDirectory] ||
                !isDirectory) continue;
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            NSURL *modelURL = [bundle URLForResource:@"BeatThisSmall0"
                                       withExtension:@"mlmodelc"];
            if (modelURL) return SMBeatThisCreateFromPath(modelURL.path.UTF8String);
        }
        return nullptr;
    }
}

extern "C" void SMBeatThisDestroy(SMBeatThisModel *model) {
    if (!model) return;
    @autoreleasepool {
        MLModel *released = (__bridge_transfer MLModel *)model->model;
        model->model = nullptr;
        delete model;
        (void)released;
    }
}

extern "C" int SMBeatThisPredict(SMBeatThisModel *model,
                                  const float *spectrogram,
                                  std::size_t frames,
                                  std::size_t melBins,
                                  float *beatLogits,
                                  float *downbeatLogits) {
    if (!model || !model->model || !spectrogram || !beatLogits || !downbeatLogits ||
        frames != kBeatThisFrames || melBins != kBeatThisMelBins) return 0;
    MLModel *loadedModel = (__bridge MLModel *)model->model;

    const std::size_t inputCount = frames * melBins;
    for (std::size_t i = 0; i < inputCount; ++i) {
        if (!std::isfinite(spectrogram[i])) return 0;
    }

    @autoreleasepool {
        if (@available(iOS 16.0, *)) {
            NSError *error = nil;
            MLMultiArray *input = [[MLMultiArray alloc]
                initWithShape:@[@1, @(kBeatThisFrames), @(kBeatThisMelBins)]
                     dataType:MLMultiArrayDataTypeFloat32
                        error:&error];
            if (!input || !input.dataPointer) return 0;
            std::memcpy(input.dataPointer, spectrogram, inputCount * sizeof(float));

            MLDictionaryFeatureProvider *provider = [[MLDictionaryFeatureProvider alloc]
                initWithDictionary:@{
                    @"spectrogram": [MLFeatureValue featureValueWithMultiArray:input]
                }
                             error:&error];
            if (!provider) return 0;
            id<MLFeatureProvider> prediction =
                [loadedModel predictionFromFeatures:provider error:&error];
            if (!prediction) return 0;

            MLMultiArray *beat = [[prediction featureValueForName:@"beat_logits"]
                multiArrayValue];
            MLMultiArray *downbeat = [[prediction featureValueForName:@"downbeat_logits"]
                multiArrayValue];
            if (!copyLogits(beat, beatLogits) ||
                !copyLogits(downbeat, downbeatLogits)) return 0;
            return 1;
        }
    }
    return 0;
}

extern "C" int SMBeatThisPredictMonoChunk(SMBeatThisModel *model,
                                           const float *mono22050,
                                           std::size_t audioFrames,
                                           std::size_t leftPadFrames,
                                           std::size_t rightPadFrames,
                                           float *beatLogits,
                                           float *downbeatLogits) {
    constexpr std::size_t kBorder = 6;
    constexpr std::size_t kModelFrames = 1500;
    if (!model || !mono22050 || !beatLogits || !downbeatLogits ||
        leftPadFrames > kBorder || rightPadFrames > kBorder ||
        leftPadFrames + rightPadFrames >= kModelFrames) return 0;

    const std::size_t melFrames = kModelFrames - leftPadFrames - rightPadFrames;
    if (smartmix::beatThisSpectrogramFrameCount(audioFrames) != melFrames) return 0;

    std::vector<float> paddedSpectrogram(kModelFrames * smartmix::kBeatThisMelBins, 0.0f);
    float *melDestination = paddedSpectrogram.data() +
        leftPadFrames * smartmix::kBeatThisMelBins;
    if (!smartmix::computeBeatThisSpectrogram(
            mono22050, audioFrames, melDestination, melFrames)) return 0;

    return SMBeatThisPredict(model, paddedSpectrogram.data(),
                             kModelFrames, smartmix::kBeatThisMelBins,
                             beatLogits, downbeatLogits);
}
