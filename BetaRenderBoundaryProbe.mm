#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#include <cstdlib>
#include <cstring>

namespace {
static NSString *AMImageForSymbol(const char *name) {
    void *address = dlsym(RTLD_DEFAULT, name);
    if (!address) return @"not exported";
    Dl_info info{};
    if (dladdr(address, &info) && info.dli_fname)
        return [NSString stringWithFormat:@"present at %p in %s", address, info.dli_fname];
    return [NSString stringWithFormat:@"present at %p; image unknown", address];
}

static BOOL AMContainsAny(NSString *value, NSArray<NSString *> *terms) {
    NSString *lower = value.lowercaseString;
    for (NSString *term in terms) if ([lower containsString:term]) return YES;
    return NO;
}

static NSString *AMClassMethodSummary(Class cls) {
    unsigned count = 0;
    Method *methods = class_copyMethodList(cls, &count);
    NSMutableArray<NSString *> *matches = [NSMutableArray array];
    NSArray *terms = @[@"audio", @"render", @"tap", @"buffer", @"processor", @"pipeline", @"unit", @"output"];
    for (unsigned i = 0; i < count; ++i) {
        SEL selector = method_getName(methods[i]);
        NSString *name = NSStringFromSelector(selector);
        if (!AMContainsAny(name, terms)) continue;
        const char *encoding = method_getTypeEncoding(methods[i]);
        [matches addObject:[NSString stringWithFormat:@"%@ [%s]", name, encoding ?: "?"]];
        if (matches.count >= 32) break;
    }
    free(methods);
    return matches.count ? [matches componentsJoinedByString:@"\n    "] : @"(no matching direct methods)";
}
} // namespace

// Passive inventory only. It deliberately does not call undocumented
// SGAudioPipeline functions, register/replace a processor, instantiate audio
// units, hook AudioUnitRender, or inspect any PCM buffers.
extern "C" NSString *AMBetaRenderBoundaryProbeReport(void) {
    NSMutableString *report = [NSMutableString stringWithString:
        @"BETA SOURCE-PROCESSOR OWNERSHIP + RENDER-BOUNDARY INVENTORY\n"
         "Mode: read-only symbol/image and Objective-C metadata inspection.\n"
         "No private function was called; no processor was installed; no audio was read or changed.\n\n"];

    NSArray<NSString *> *symbols = @[
        @"SGAudioPipelineAvailable",
        @"SGAudioPipelineTapped",
        @"SGAudioPipelineSetSourceProcessor",
        @"SGAudioPipelineSourceProcessorAttached",
        @"SGAudioPipelineSourceFormat",
        @"SGAudioPipelineSourcePrefix",
        @"SGAudioPipelineSourceAheadFrames",
        @"SGAudioPipelineSourceCanReadAhead",
        @"SGAudioPipelinePull",
        @"SGAudioPipelinePullOriginal",
        @"SGAudioPipelineRegister",
        @"AudioUnitRender",
        @"AudioUnitSetProperty",
        @"AudioUnitGetProperty",
        @"AudioUnitInitialize",
        @"AudioUnitUninitialize",
        @"AudioComponentInstanceGetComponent",
        @"AudioComponentGetDescription",
        @"AudioOutputUnitStart",
        @"AUGraphStart"
    ];
    [report appendString:@"SYMBOL PRESENCE AND OWNING IMAGE (presence is not proof of a callable ABI):\n"];
    for (NSString *symbol in symbols)
        [report appendFormat:@"%@: %@\n", symbol, AMImageForSymbol(symbol.UTF8String)];

    [report appendString:@"\nRELEVANT LOADED IMAGES:\n"];
    uint32_t imageCount = _dyld_image_count();
    unsigned emittedImages = 0;
    for (uint32_t i = 0; i < imageCount; ++i) {
        const char *path = _dyld_get_image_name(i);
        if (!path) continue;
        NSString *image = [NSString stringWithUTF8String:path];
        if (!AMContainsAny(image, @[@"betamax", @"audiotoolbox", @"avfaudio", @"coremedia",
                                     @"spotifyglass", @"taurus"])) continue;
        [report appendFormat:@"%@\n", image];
        if (++emittedImages >= 100) break;
    }
    if (!emittedImages) [report appendString:@"(no matching loaded images)\n"];

    [report appendString:@"\nRELEVANT RUNTIME CLASSES AND DIRECT METHODS:\n"];
    int total = objc_getClassList(NULL, 0);
    if (total > 0) {
        Class *classes = (Class *)calloc((size_t)total, sizeof(Class));
        if (classes) {
            int count = objc_getClassList(classes, total);
            unsigned emittedClasses = 0;
            for (int i = 0; i < count && emittedClasses < 160; ++i) {
                Class cls = classes[i];
                if (!cls) continue;
                NSString *name = NSStringFromClass(cls) ?: @"";
                if (!AMContainsAny(name, @[@"sourceprocessor", @"audiopipeline", @"audiounit",
                                            @"audioengine", @"audiorender", @"samplebuffer",
                                            @"audiotap", @"betamax"])) continue;
                const char *imagePath = class_getImageName(cls);
                [report appendFormat:@"\n%@ | image=%@\n    %@\n",
                    name, imagePath ? [NSString stringWithUTF8String:imagePath] : @"unknown",
                    AMClassMethodSummary(cls)];
                ++emittedClasses;
            }
            if (!emittedClasses) [report appendString:@"(no matching runtime classes)\n"];
            free(classes);
        } else {
            [report appendString:@"(class inventory allocation failed)\n"];
        }
    } else {
        [report appendString:@"(runtime class inventory unavailable)\n"];
    }

    [report appendString:
        @"\nINTERPRETATION:\n"
         "- The image listed beside an exported symbol identifies where that symbol resolves; it does not identify who owns a live processor slot.\n"
         "- A setter/registration symbol is intentionally not called because its ABI, context ownership, and chaining contract are not yet proven.\n"
         "- AudioUnit API presence and class metadata do not prove that Taurus music uses AudioUnitRender. A later targeted render trace is only justified after this inventory identifies the actual graph/API path.\n"];
    return report;
}
