#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <unistd.h>

static BOOL ContainsAny(NSString *s, NSArray<NSString *> *terms) {
    NSString *lower = s.lowercaseString;
    for (NSString *term in terms) if ([lower containsString:term]) return YES;
    return NO;
}
static NSString *Safe( const char *s ) { return s ? [NSString stringWithUTF8String:s] : @""; }
static NSString *ImageForClass(Class cls) {
    const char *p = class_getImageName(cls);
    return p ? Safe(p) : @"(unknown image)";
}
static void AppendDirectClass(NSMutableString *out, Class cls) {
    NSString *name = Safe(class_getName(cls));
    [out appendFormat:@"\n===== CLASS %@ =====\nIMAGE %@\n", name, ImageForClass(cls)];
    Class parent = class_getSuperclass(cls);
    [out appendFormat:@"SUPER %@\n", parent ? Safe(class_getName(parent)) : @"(none)"];

    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    [out appendFormat:@"IVARS %u\n", count];
    for (unsigned int i=0; i<count; i++) {
        Ivar iv = ivars[i];
        [out appendFormat:@"  %@ | type=%@ | offset=%td\n",
         Safe(ivar_getName(iv)), Safe(ivar_getTypeEncoding(iv)), ivar_getOffset(iv)];
    }
    free(ivars);

    objc_property_t *props = class_copyPropertyList(cls, &count);
    [out appendFormat:@"PROPERTIES %u\n", count];
    for (unsigned int i=0; i<count; i++) {
        [out appendFormat:@"  %@ | %@\n", Safe(property_getName(props[i])), Safe(property_getAttributes(props[i]))];
    }
    free(props);

    Protocol *__unsafe_unretained *protocols = class_copyProtocolList(cls, &count);
    [out appendFormat:@"DIRECT_PROTOCOLS %u\n", count];
    for (unsigned int i=0; i<count; i++) [out appendFormat:@"  %@\n", Safe(protocol_getName(protocols[i]))];
    free(protocols);

    Method *methods = class_copyMethodList(cls, &count);
    [out appendFormat:@"DIRECT_INSTANCE_METHODS %u\n", count];
    unsigned int shown = MIN(count, 60);
    for (unsigned int i=0; i<shown; i++) {
        SEL sel = method_getName(methods[i]);
        [out appendFormat:@"  %@ | types=%@\n", NSStringFromSelector(sel), Safe(method_getTypeEncoding(methods[i]))];
    }
    if (count > shown) [out appendFormat:@"  ... %u methods omitted (limit 60)\n", count-shown];
    free(methods);

    Method *classMethods = class_copyMethodList(object_getClass(cls), &count);
    [out appendFormat:@"DIRECT_CLASS_METHODS %u\n", count];
    shown = MIN(count, 30);
    for (unsigned int i=0; i<shown; i++) {
        [out appendFormat:@"  %@ | types=%@\n", NSStringFromSelector(method_getName(classMethods[i])), Safe(method_getTypeEncoding(classMethods[i]))];
    }
    if (count > shown) [out appendFormat:@"  ... %u class methods omitted (limit 30)\n", count-shown];
    free(classMethods);
}

__attribute__((constructor)) static void AutoMixDiscoveryV5(void) {
    @autoreleasepool {
        // Let the host finish loading its image/class metadata before scanning.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @autoreleasepool {
                NSArray *terms = @[@"automix", @"mixing", @"crossfade", @"cross-fade", @"transition",
                                   @"multiplayer", @"multi_player", @"playerpool", @"player_pool",
                                   @"internalplayer", @"playergroup", @"audioCoordinator", @"audiocoordinator",
                                   @"audiotap", @"overlap", @"deck", @"playback", @"tracklist"];
                int total = objc_getClassList(NULL, 0);
                if (total <= 0) { NSLog(@"[AutoMixDiscoveryV5] class enumeration failed"); return; }
                Class __unsafe_unretained *classes = (Class __unsafe_unretained *)calloc((size_t)total, sizeof(Class));
                if (!classes) { NSLog(@"[AutoMixDiscoveryV5] allocation failed"); return; }
                int filled = objc_getClassList(classes, total);
                NSMutableArray<NSString *> *matches = [NSMutableArray array];
                for (int i=0; i<filled; i++) {
                    NSString *name = Safe(class_getName(classes[i]));
                    if (ContainsAny(name, terms)) [matches addObject:name];
                }
                [matches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                NSMutableString *report = [NSMutableString stringWithFormat:
                    @"AUTOMIX COMPREHENSIVE DISCOVERY V5\nBundle: %@\nVersion: %@\nDate: %@\n"
                    "READ-ONLY CLASS/METADATA SCAN. Does not instantiate Spotify objects, invoke Spotify methods, "
                    "inspect audio buffers, decode media, or access track contents.\n"
                    "Runtime classes: %d | matched classes: %lu | detail cap: 240 classes\n"
                    "Swift-only method bodies may not be exposed through Objective-C runtime metadata.\n",
                    NSBundle.mainBundle.bundleIdentifier ?: @"(unknown)",
                    NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"(unknown)",
                    [NSDate date], filled, (unsigned long)matches.count];

                NSUInteger limit = MIN(matches.count, (NSUInteger)240);
                for (NSUInteger i=0; i<limit; i++) {
                    Class cls = objc_getClass(matches[i].UTF8String);
                    if (cls) AppendDirectClass(report, cls);
                }
                if (matches.count > limit) [report appendFormat:@"\nMATCHES OMITTED AFTER CAP: %lu\n", (unsigned long)(matches.count-limit)];

                NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *dir = dirs.firstObject ?: NSTemporaryDirectory();
                NSString *path = [dir stringByAppendingPathComponent:@"AutoMixDiscoveryV5.txt"];
                NSError *err = nil;
                BOOL ok = [report writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
                NSLog(@"[AutoMixDiscoveryV5] %@ report=%@ chars=%lu matched=%lu",
                      ok ? @"SUCCESS" : @"FAILED", path, (unsigned long)report.length, (unsigned long)matches.count);
                if (err) NSLog(@"[AutoMixDiscoveryV5] write error %@", err);
                free(classes);
            }
        });
    }
}
