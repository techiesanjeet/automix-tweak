#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <mach-o/loader.h>
#include <dlfcn.h>
#include <cstdint>
#include <cstring>
#include <unordered_map>

extern "C" NSString *AMBetaSourceProcessorCallsiteReport(void) {
    NSMutableString *report = [NSMutableString stringWithString:
        @"BETA SOURCE-PROCESSOR STATIC CALL-SITE SCAN\n"
         "Mode: read-only scan of loaded arm64 __text for direct BL instructions.\n"
         "No private function is called; no code is patched; no processor is registered; no audio is read.\n\n"];

#if defined(__arm64__)
    const char *names[] = {
        "SGAudioPipelineAvailable",
        "SGAudioPipelineTapped",
        "SGAudioPipelineSetSourceProcessor",
        "SGAudioPipelineSourceProcessorAttached",
        "SGAudioPipelineSourceFormat",
        "SGAudioPipelineSourcePrefix",
        "SGAudioPipelineSourceAheadFrames",
        "SGAudioPipelineSourceCanReadAhead",
        "SGAudioPipelinePull",
        "SGAudioPipelinePullOriginal",
        "SGAudioPipelineRegister"
    };
    std::unordered_map<uintptr_t, const char *> targets;
    for (const char *name : names) {
        void *p = dlsym(RTLD_DEFAULT, name);
        if (p) targets.emplace(reinterpret_cast<uintptr_t>(p), name);
        [report appendFormat:@"%s: %@\n", name, p ? @"resolved" : @"not exported"];
    }

    if (targets.empty()) {
        [report appendString:@"No source-processor symbols resolved; call-site scan skipped.\n"];
        return report;
    }

    [report appendString:@"\nDIRECT BL CALL SITES (offsets are relative to each image's __text start):\n"];
    uint32_t imageCount = _dyld_image_count();
    unsigned totalHits = 0;
    for (uint32_t imageIndex = 0; imageIndex < imageCount; ++imageIndex) {
        const char *path = _dyld_get_image_name(imageIndex);
        if (!path) continue;
        if (!strstr(path, "spotifyglass") &&
            !(strstr(path, ".app/") && !strstr(path, "/Frameworks/"))) continue;

        const struct mach_header *rawHeader = _dyld_get_image_header(imageIndex);
        if (!rawHeader || rawHeader->magic != MH_MAGIC_64) continue;
        const auto *header = reinterpret_cast<const struct mach_header_64 *>(rawHeader);
        unsigned long textSize = 0;
        const uint8_t *textStart = reinterpret_cast<const uint8_t *>(
            getsectiondata(header, "__TEXT", "__text", &textSize));
        if (!textStart || textSize < sizeof(uint32_t)) continue;

        unsigned imageHits = 0;
        for (uintptr_t offset = 0; offset + sizeof(uint32_t) <= textSize; offset += 4) {
            uint32_t instruction = 0;
            memcpy(&instruction, textStart + offset, sizeof(instruction));
            if ((instruction & 0xFC000000u) != 0x94000000u) continue; // ARM64 BL imm26
            int32_t imm26 = static_cast<int32_t>(instruction & 0x03FFFFFFu);
            if (imm26 & 0x02000000) imm26 |= static_cast<int32_t>(0xFC000000u);
            const uintptr_t pc = reinterpret_cast<uintptr_t>(textStart + offset);
            const uintptr_t destination = static_cast<uintptr_t>(
                static_cast<int64_t>(pc) + (static_cast<int64_t>(imm26) << 2));
            auto found = targets.find(destination);
            if (found == targets.end()) continue;
            [report appendFormat:@"%@ <- %s +0x%lx\n",
                [NSString stringWithUTF8String:found->second],
                path, static_cast<unsigned long>(offset)];
            ++imageHits;
            ++totalHits;
            if (imageHits >= 80) {
                [report appendString:@"  (per-image hit limit reached)\n"];
                break;
            }
        }
    }
    if (!totalHits) {
        [report appendString:@"No direct BL call sites found in scanned app images. This does not exclude indirect BLR calls, Swift thunks, or calls from unscanned images.\n"];
    } else {
        [report appendFormat:@"\nTotal direct call-site matches: %u\n", totalHits];
    }
    [report appendString:
        @"\nLIMITATIONS:\n"
         "- This is static call-site evidence, not proof that a call executes during playback.\n"
         "- Indirect calls (BLR), tail branches, stubs, and compiler-generated dispatch may not appear as direct matches.\n"
         "- A zero result is inconclusive; a nonzero result identifies candidate call sites for focused follow-up.\n"];
#else
    [report appendString:@"This diagnostic is implemented for arm64 only.\n"];
#endif
    return report;
}
