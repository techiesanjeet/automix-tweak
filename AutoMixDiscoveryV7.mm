#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#import <dispatch/dispatch.h>
#import <string.h>

static NSString *V7S(const char *s) { return s ? [NSString stringWithUTF8String:s] : @""; }
static BOOL V7Has(NSString *s, NSArray<NSString *> *terms) {
    NSString *v = s.lowercaseString;
    for (NSString *t in terms) if ([v containsString:t]) return YES;
    return NO;
}
static NSArray<NSString *> *V7Terms(void) {
    return @[@"automix",@"mixing",@"crossfade",@"cross_fade",@"transition",@"overlap",
      @"multiplayer",@"playerpool",@"player_pool",@"internalplayer",@"playergroup",
      @"audiocoordinator",@"audiotap",@"audioengine",@"mixer",@"mixingimpl",
      @"transitionplayer",@"transitionloader",@"mixingevaluator",@"evaluator",
      @"playbackrequest",@"unmutedhandle",@"mute",@"volume",@"gain",@"fade",
      @"render",@"output",@"prepare",@"activate",@"deactivate",@"synchronize",
      @"beatmatch",@"bpm",@"tempo",@"waveform",@"deck",@"trackplayer",@"playerimpl"];
}
static BOOL V7SpotifyPath(const char *p) {
    NSString *s=V7S(p).lowercaseString;
    return [s containsString:@"spotify.app/"] || [s containsString:@"/spotify"];
}
static void V7ScanImage(const struct mach_header *mh, intptr_t slide, NSString *path,
                        NSMutableString *out, NSUInteger *symbolCount, NSUInteger *matchCount) {
    if (!mh || mh->magic != MH_MAGIC_64) return;
    const struct mach_header_64 *h=(const struct mach_header_64 *)mh;
    struct load_command *cmd=(struct load_command *)((uintptr_t)h+sizeof(struct mach_header_64));
    struct symtab_command *symtab=NULL;
    struct segment_command_64 *linkedit=NULL;
    NSMutableArray *sections=[NSMutableArray array];
    for (uint32_t i=0;i<h->ncmds;i++) {
        if (!cmd || cmd->cmdsize < sizeof(struct load_command)) break;
        if (cmd->cmd==LC_SYMTAB && cmd->cmdsize>=sizeof(struct symtab_command))
            symtab=(struct symtab_command *)cmd;
        if (cmd->cmd==LC_SEGMENT_64 && cmd->cmdsize>=sizeof(struct segment_command_64)) {
            struct segment_command_64 *seg=(struct segment_command_64 *)cmd;
            if (strncmp(seg->segname,"__LINKEDIT",16)==0) linkedit=seg;
            uint32_t max=(uint32_t)((cmd->cmdsize-sizeof(struct segment_command_64))/sizeof(struct section_64));
            struct section_64 *sec=(struct section_64 *)(seg+1);
            for (uint32_t j=0;j<MIN(seg->nsects,max);j++) {
                NSString *sn=[NSString stringWithFormat:@"%s,%s",sec[j].segname,sec[j].sectname];
                if ([sn.lowercaseString containsString:@"swift"] || [sn.lowercaseString containsString:@"objc"])
                    [sections addObject:sn];
            }
        }
        cmd=(struct load_command *)((uintptr_t)cmd+cmd->cmdsize);
    }
    [out appendFormat:@"\nIMAGE %@\nSWIFT/OBJC SECTIONS: %@\n",path,
      sections.count ? [sections componentsJoinedByString:@"; "] : @"(none found)"];
    if (!symtab || !linkedit || symtab->nsyms==0 || symtab->strsize==0) {
        [out appendString:@"SYMBOL TABLE: unavailable/stripped in loaded image\n"];
        return;
    }
    uintptr_t base=(uintptr_t)(slide + (intptr_t)linkedit->vmaddr - (intptr_t)linkedit->fileoff);
    const struct nlist_64 *symbols=(const struct nlist_64 *)(base+symtab->symoff);
    const char *strings=(const char *)(base+symtab->stroff);
    [out appendFormat:@"SYMBOL TABLE: %u entries; scanning targeted names\n",symtab->nsyms];
    NSUInteger imageMatches=0;
    for (uint32_t i=0;i<symtab->nsyms;i++) {
        uint32_t idx=symbols[i].n_un.n_strx;
        if (!idx || idx>=symtab->strsize) continue;
        const char *raw=strings+idx;
        size_t remain=symtab->strsize-idx;
        if (!memchr(raw,0,remain)) continue;
        NSString *name=V7S(raw);
        if (name.length<3) continue;
        (*symbolCount)++;
        if (([name hasPrefix:@"_$s"] || [name hasPrefix:@"$s"] ||
             [name hasPrefix:@"_T0"] || [name hasPrefix:@"_$S"]) && V7Has(name,V7Terms())) {
            [out appendFormat:@"  %@ | type=0x%x | sect=%u\n",name,symbols[i].n_type,symbols[i].n_sect];
            imageMatches++; (*matchCount)++;
            if (*matchCount>=1800) break;
        }
    }
    [out appendFormat:@"MATCHED SWIFT SYMBOLS IN IMAGE: %lu\n",(unsigned long)imageMatches];
}
static void V7AppendRuntimeClass(NSMutableString *out, Class c) {
    NSString *name=V7S(class_getName(c));
    [out appendFormat:@"\nCLASS %@\n",name];
    Class sup=class_getSuperclass(c);
    [out appendFormat:@"SUPER %@",sup?V7S(class_getName(sup)):@"(none)"];
    unsigned int n=0; Ivar *iv=class_copyIvarList(c,&n);
    [out appendFormat:@" | IVARS %u\n",n];
    for (unsigned int i=0;i<n;i++) {
        NSString *ivn=V7S(ivar_getName(iv[i]));
        if (V7Has(ivn,V7Terms()) || n<=18)
            [out appendFormat:@"  %@ : %@ @%td\n",ivn,V7S(ivar_getTypeEncoding(iv[i])),ivar_getOffset(iv[i])];
    }
    free(iv);
    Method *m=class_copyMethodList(c,&n);
    [out appendFormat:@"DIRECT METHODS %u\n",n];
    NSUInteger shown=0;
    for (unsigned int i=0;i<n && shown<100;i++) {
        NSString *sel=NSStringFromSelector(method_getName(m[i]));
        if (V7Has(sel,V7Terms())) {
            [out appendFormat:@"  %@ | %@\n",sel,V7S(method_getTypeEncoding(m[i]))]; shown++;
        }
    }
    free(m);
}
static NSString *V7Path(void) {
    NSArray *d=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [(d.firstObject?:NSTemporaryDirectory()) stringByAppendingPathComponent:@"AutoMixDiscoveryV7.txt"];
}
static NSString *V7Scan(void) {
    NSMutableString *r=[NSMutableString stringWithFormat:
      @"AUTOMIX DISCOVERY V7 — SWIFT SYMBOLS + MACH-O + RUNTIME METADATA\nBundle: %@\nVersion: %@ (%@)\nDate: %@\n",
      NSBundle.mainBundle.bundleIdentifier?:@"unknown",
      NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]?:@"unknown",
      NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"]?:@"unknown",[NSDate date]];
    [r appendString:@"\nREAD-ONLY diagnostic. It does not call Spotify playback methods, alter audio, decrypt media, or guarantee that symbols are present. Runtime Mach-O symbol tables may be stripped; absence is inconclusive.\n"];
    uint32_t imageN=_dyld_image_count(); NSUInteger spotifyImages=0,symbols=0,matches=0;
    [r appendFormat:@"\n========== LOADED SPOTIFY MACH-O IMAGES (%u total dyld images) ==========\n",imageN];
    for (uint32_t i=0;i<imageN;i++) {
        const char *p=_dyld_get_image_name(i);
        if (!V7SpotifyPath(p)) continue;
        spotifyImages++;
        V7ScanImage(_dyld_get_image_header(i),_dyld_get_image_vmaddr_slide(i),V7S(p),r,&symbols,&matches);
        if (matches>=1800) break;
    }
    [r appendFormat:@"\nSpotify images scanned: %lu\nSymbol entries visited: %lu\nTargeted Swift symbol matches: %lu\n",
      (unsigned long)spotifyImages,(unsigned long)symbols,(unsigned long)matches];
    [r appendString:@"\n========== SPOTIFY RUNTIME CLASSES ==========\n"];
    int total=objc_getClassList(NULL,0);
    Class __unsafe_unretained *list=(Class __unsafe_unretained *)calloc((size_t)MAX(total,1),sizeof(Class));
    int filled=list?objc_getClassList(list,total):0; NSUInteger classMatches=0;
    NSArray *ct=@[@"automix",@"mixing",@"transition",@"overlap",@"multiplayer",@"playerpool",
      @"player_pool",@"internalplayer",@"playergroup",@"audiocoordinator",@"audiotap",
      @"transitionplayer",@"transitionloader",@"evaluator",@"audioengine",@"mixingimpl"];
    for (int i=0;i<filled;i++) {
        Class c=list[i]; if (!c || !V7SpotifyPath(class_getImageName(c))) continue;
        if (V7Has(V7S(class_getName(c)),ct)) { V7AppendRuntimeClass(r,c); classMatches++; }
    }
    free(list);
    [r appendFormat:@"\nMatched runtime classes: %lu\nReport chars: %lu\n",(unsigned long)classMatches,(unsigned long)r.length];
    NSError *e=nil; BOOL ok=[r writeToFile:V7Path() atomically:YES encoding:NSUTF8StringEncoding error:&e];
    [r appendFormat:@"\nSaved: %@ (%@)\n",ok?@"YES":@"NO",V7Path()];
    if(e)[r appendFormat:@"Write error: %@\n",e];
    return r;
}
static UIViewController *V7Top(void) {
    UIWindow *w=nil;
    for (UIScene *s in UIApplication.sharedApplication.connectedScenes) {
        if (![s isKindOfClass:UIWindowScene.class] || s.activationState!=UISceneActivationStateForegroundActive) continue;
        for (UIWindow *x in ((UIWindowScene *)s).windows) if(x.isKeyWindow){w=x;break;}
        if(w)break;
    }
    UIViewController *v=w.rootViewController;
    while(v.presentedViewController)v=v.presentedViewController;
    if([v isKindOfClass:UINavigationController.class])v=((UINavigationController *)v).visibleViewController;
    if([v isKindOfClass:UITabBarController.class])v=((UITabBarController *)v).selectedViewController;
    return v;
}
static void V7Run(void) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0), ^{
        NSString *report=V7Scan();
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *vc=V7Top();
            if(!vc){NSLog(@"[AutoMixDiscoveryV7] %@",V7Path());return;}
            UIAlertController *a=[UIAlertController alertControllerWithTitle:@"AutoMix Discovery V7"
              message:[NSString stringWithFormat:@"Scan finished. Full report saved in Documents/AutoMixDiscoveryV7.txt (%lu chars).",(unsigned long)report.length]
              preferredStyle:UIAlertControllerStyleAlert];
            [a addAction:[UIAlertAction actionWithTitle:@"Copy Full Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *x){UIPasteboard.generalPasteboard.string=report;}]];
            [a addAction:[UIAlertAction actionWithTitle:@"Share Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *x){
                UIActivityViewController *u=[[UIActivityViewController alloc]initWithActivityItems:@[[NSURL fileURLWithPath:V7Path()]] applicationActivities:nil];
                if(u.popoverPresentationController)u.popoverPresentationController.sourceView=vc.view;
                [vc presentViewController:u animated:YES completion:nil];
            }]];
            [a addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
            [vc presentViewController:a animated:YES completion:nil];
        });
    });
}
__attribute__((constructor)) static void AutoMixDiscoveryV7(void) {
    @autoreleasepool {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(8*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            UIWindow *w=nil;
            for(UIScene *s in UIApplication.sharedApplication.connectedScenes){
                if(![s isKindOfClass:UIWindowScene.class]||s.activationState!=UISceneActivationStateForegroundActive)continue;
                for(UIWindow *x in ((UIWindowScene *)s).windows)if(x.isKeyWindow){w=x;break;}
                if(w)break;
            }
            if(!w)return;
            UIButton *b=[UIButton buttonWithType:UIButtonTypeSystem];
            b.frame=CGRectMake(MAX(12,w.bounds.size.width-108),MAX(90,w.bounds.size.height-194),96,44);
            b.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
            b.backgroundColor=[UIColor colorWithRed:.12 green:.48 blue:.88 alpha:.96];
            [b setTitle:@"SCAN V7" forState:UIControlStateNormal];
            [b setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            b.titleLabel.font=[UIFont boldSystemFontOfSize:14]; b.layer.cornerRadius=11;
            [b addAction:[UIAction actionWithHandler:^(__unused UIAction *a){V7Run();}] forControlEvents:UIControlEventTouchUpInside];
            [w addSubview:b];
        });
    }
}