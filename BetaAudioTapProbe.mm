#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <atomic>
#include <cstdint>
#include <cstring>

namespace {
struct AMTapSlot {
    std::atomic<uintptr_t> object{0};
    std::atomic<uint64_t> callbacks{0};
    std::atomic<uint64_t> words[8];
    AMTapSlot() {
        for (auto &word : words) word.store(0, std::memory_order_relaxed);
    }
};

static AMTapSlot gSlots[8];
static std::atomic<uint64_t> gTotalCallbacks{0};
static std::atomic<uint64_t> gOverflowCallbacks{0};
static std::atomic<int> gInstallState{0}; // 0 pending, 1 installed, 2 class missing, 3 method missing, 4 ABI mismatch
static IMP gOriginalImplementation = nullptr;

using AMTapImplementation = void (*)(id, SEL, const void *);

static void AMTapDidEmitOutput(id self, SEL selector, const void *opaqueOutput) {
    // BMAudioTapOutput is a 64-byte by-value Objective-C struct. On arm64
    // this ABI supplies its address in x2. Read only the descriptor words;
    // never dereference the audio buffer pointers contained in those words.
    gTotalCallbacks.fetch_add(1, std::memory_order_relaxed);
    const uintptr_t identity = reinterpret_cast<uintptr_t>((__bridge void *)self);
    AMTapSlot *slot = nullptr;

    for (auto &candidate : gSlots) {
        uintptr_t current = candidate.object.load(std::memory_order_relaxed);
        if (current == identity) {
            slot = &candidate;
            break;
        }
        if (current == 0) {
            uintptr_t expected = 0;
            if (candidate.object.compare_exchange_strong(expected, identity,
                    std::memory_order_relaxed, std::memory_order_relaxed) || expected == identity) {
                slot = &candidate;
                break;
            }
        }
    }

    if (slot) {
        const uint64_t previous = slot->callbacks.fetch_add(1, std::memory_order_relaxed);
        if (previous == 0 && opaqueOutput) {
            uint64_t words[8] = {};
            std::memcpy(words, opaqueOutput, sizeof(words));
            for (unsigned i = 0; i < 8; ++i)
                slot->words[i].store(words[i], std::memory_order_relaxed);
        }
    } else {
        gOverflowCallbacks.fetch_add(1, std::memory_order_relaxed);
    }

    IMP original = gOriginalImplementation;
    if (original) reinterpret_cast<AMTapImplementation>(original)(self, selector, opaqueOutput);
}
} // namespace

extern "C" void AMBetaAudioTapProbeInstall(void) {
    int expected = 0;
    if (!gInstallState.compare_exchange_strong(expected, -1, std::memory_order_relaxed)) return;

    Class tapClass = objc_getClass("_TtC22MultiPlayer_PlayerImpl19MultiPlayerAudioTap");
    if (!tapClass) {
        gInstallState.store(2, std::memory_order_release);
        NSLog(@"[AutoMixTapProbe] MultiPlayerAudioTap class not loaded");
        return;
    }

    SEL selector = sel_registerName("audioTapDidEmitOutput:");
    Method method = class_getInstanceMethod(tapClass, selector);
    if (!method) {
        gInstallState.store(3, std::memory_order_release);
        NSLog(@"[AutoMixTapProbe] audioTapDidEmitOutput: method not found");
        return;
    }

    const char *encoding = method_getTypeEncoding(method);
    if (!encoding || !strstr(encoding, "BMAudioTapOutput") ||
        !strstr(encoding, "v80@0:8")) {
        gInstallState.store(4, std::memory_order_release);
        NSLog(@"[AutoMixTapProbe] unexpected callback ABI: %s", encoding ?: "(null)");
        return;
    }

    gOriginalImplementation = method_getImplementation(method);
    if (!gOriginalImplementation) {
        gInstallState.store(3, std::memory_order_release);
        return;
    }

    IMP replaced = method_setImplementation(method, reinterpret_cast<IMP>(AMTapDidEmitOutput));
    if (replaced && replaced != gOriginalImplementation) gOriginalImplementation = replaced;
    gInstallState.store(1, std::memory_order_release);
    NSLog(@"[AutoMixTapProbe] chained read-only tap observer installed; ABI=%s", encoding);
}

extern "C" NSString *AMBetaAudioTapProbeReport(void) {
    const int state = gInstallState.load(std::memory_order_acquire);
    NSString *status = @"not attempted";
    switch (state) {
        case 1: status = @"installed; original callback is chained"; break;
        case 2: status = @"target class not loaded"; break;
        case 3: status = @"callback method not found"; break;
        case 4: status = @"callback ABI did not match; no hook installed"; break;
        case -1: status = @"installation in progress"; break;
        default: break;
    }

    NSMutableString *report = [NSMutableString stringWithFormat:
        @"Hook status: %@\nCallback calls observed: %llu\nOverflow callbacks: %llu\n",
        status,
        (unsigned long long)gTotalCallbacks.load(std::memory_order_relaxed),
        (unsigned long long)gOverflowCallbacks.load(std::memory_order_relaxed)];

    unsigned unique = 0;
    for (unsigned i = 0; i < 8; ++i) {
        const uintptr_t identity = gSlots[i].object.load(std::memory_order_relaxed);
        if (!identity) continue;
        ++unique;
        [report appendFormat:@"Tap instance %u callback count: %llu\n",
            i + 1, (unsigned long long)gSlots[i].callbacks.load(std::memory_order_relaxed)];
        [report appendString:@"  First callback descriptor words:"];
        for (unsigned j = 0; j < 8; ++j) {
            [report appendFormat:@" %@0x%016llx", j ? @"" : @"",
                (unsigned long long)gSlots[i].words[j].load(std::memory_order_relaxed)];
        }
        [report appendString:@"\n"];
    }
    [report appendFormat:@"Distinct tap instances observed: %u (capacity 8)\n", unique];
    [report appendString:@"PCM samples were not read, copied, or changed. The original Taurus callback is called unchanged.\n"];
    return report;
}
