AutoMix

AUTOMIX DISCOVERY V8 — RUNTIME CLASS / SELECTOR / PROTOCOL MAP
Bundle: com.spo.z
Version: 9.1.90 (919002269)
Date: 2026-11-13 00:54:27 +0000

READ-ONLY runtime metadata scan. Does not call Spotify playback methods, create Spotify player objects, modify audio, read audio buffers, or decrypt media. IMP addresses are reported as image-relative offsets only; they are not proof that a method is safe to hook.

LOADED DYLD IMAGES: 1341
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/MetaSmartGlassesKit.framework/MetaSmartGlassesKit
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/SpotifyShared.framework/SpotifyShared
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/SpotifyAudioProbe.dylib
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/SpotifyGlassAppGroups.dylib
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/spotifyglass.dylib
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/AutoMixEngine.dylib
  /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Frameworks/CydiaSubstrate.framework/CydiaSubstrate


FOCUSED SPOTIFY RUNTIME CLASSES

============================================================
CLASS WatchFeed_WatchFeedFeatureImpl.WatchFeedMultiPlayerSessionManager
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (10)
    multiPlayer |  | offset=16
    referrerIdentifier |  | offset=32
    pageInstanceIDProvider |  | offset=48
    videoSurfaceFactory |  | offset=64
    muteStateManager |  | offset=80
    currentSession |  | offset=96
    muteStateObservation |  | offset=112
    isSessionActive |  | offset=128
    muteIntent |  | offset=129
    _currentPlayerGroup |  | offset=136
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS WatchFeed_WatchFeedFeatureImpl.WatchFeedMultiPlayerFactoryImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (8)
    playerGroupManager |  | offset=16
    featureIdentifier |  | offset=56
    lastUBIInteractionLoggingResult |  | offset=72
    remoteConfigurationProperties |  | offset=88
    pttffBaseDate |  | offset=96
    pznPlayContextDecisionID |  | offset=112
    contextURI |  | offset=128
    customReportingAttribution |  | offset=144
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS WatchFeed_WatchFeedFeatureImpl.WatchFeedMultiPlayerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (17)
    _playbackSpeed |  | offset=16
    videoSurfaceIdentifier |  | offset=24
    currentPlaybackRequest |  | offset=40
    _currentPlayer |  | offset=200
    $__lazy_storage_$_videoView |  | offset=216
    playbackObserver |  | offset=224
    stateAdapter |  | offset=240
    waveformCancellable |  | offset=248
    featureIdentifier |  | offset=256
    contextURI |  | offset=272
    playerGroupManager |  | offset=288
    options |  | offset=328
    perceivedTimeToFirstFrameTimestamp |  | offset=368
    lastUBIInteractionLoggingResult |  | offset=384
    pznPlayContextDecisionID |  | offset=400
    customReportingAttribution |  | offset=416
    remoteConfigurationProperties |  | offset=432
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS WatchFeed_WatchFeedFeatureImpl.MultiPlayerSessionEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    sessionManager |  | offset=16
    isMultiPlayerEnabled |  | offset=56
    callback |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS WatchFeed_ComponentImpl.WatchFeedEntryPointMultiplayerWrapper
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (12)
    delegate |  | offset=16
    featureIdentifier |  | offset=32
    videoSurface |  | offset=40
    videoSurfaceIdentifier |  | offset=56
    playerGroup |  | offset=72
    activationDisposable |  | offset=88
    initialPosition |  | offset=104
    endPosition |  | offset=112
    mediaSource |  | offset=120
    canPlay |  | offset=137
    _singlePlayer |  | offset=144
    playingOrPausedCancellable |  | offset=160
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS WatchFeed_ComponentImpl.WatchFeedEntryPointMultiplayerWrapperFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    playerGroup |  | offset=16
    surfaceFactory |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS VideoRecommendations_ComponentImpl.MultiplayerPreviewVideoPlayerFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    surfaceFactory |  | offset=16
    playerGroup |  | offset=32
    dataSaverSignal |  | offset=48
    streamReportingEnabled |  | offset=56
    ubiLogger |  | offset=64
    wantsAudioFocus |  | offset=80
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTPreviewVideoPlayerFactory
      required instance getPlayerWithFeatureIdentifier: | @24@0:8@16
  INSTANCE METHODS (1)
    getPlayerWithFeatureIdentifier: | types=@24@0:8@16 | IMP=Spotify+0x7611bbc
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingTransitionIndicatorUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    iconView |  | offset=16
    $__lazy_storage_$_iconBadge |  | offset=24
    label |  | offset=32
    topLine |  | offset=40
    bottomLine |  | offset=48
    $__lazy_storage_$_view |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingTransitionElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    $__lazy_storage_$_view |  | offset=16
    eventHandler |  | offset=24
    transitionAnimator |  | offset=40
    lastVisualState |  | offset=48
    pendingAnimationWorkItem |  | offset=64
    $__lazy_storage_$_diffuser |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingTrackRowElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (21)
    $__lazy_storage_$_listRow |  | offset=16
    $__lazy_storage_$_emphasisDecorationView |  | offset=24
    $__lazy_storage_$_view |  | offset=32
    imageLoader |  | offset=40
    mixingMetadataElementView |  | offset=56
    metadataWidthMeasurer |  | offset=64
    actionIcon |  | offset=80
    eventHandler |  | offset=88
    lastMetadataSizingSignature |  | offset=104
    $__lazy_storage_$_syncChipView |  | offset=160
    $__lazy_storage_$_syncChipContainer |  | offset=168
    $__lazy_storage_$_syncChipMinWidthConstraint |  | offset=176
    $__lazy_storage_$_metadataWidthConstraint |  | offset=184
    $__lazy_storage_$_emptyTrailingView |  | offset=192
    $__lazy_storage_$_swapIconView |  | offset=200
    $__lazy_storage_$_swapButton |  | offset=208
    $__lazy_storage_$_coverArtView |  | offset=216
    isTapRegistered |  | offset=224
    isActivelyPreviewing |  | offset=225
    $__lazy_storage_$_trailingButtonStack |  | offset=232
    playbackIndicatorTitleView |  | offset=240
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (4)
    didTapMetadata | types=v16@0:8 | IMP=Spotify+0xe4d6bc
    didTapSyncChip | types=v16@0:8 | IMP=Spotify+0x3d985e8
    didTapSwap | types=v16@0:8 | IMP=Spotify+0x7354b4
    didTapTrackRow | types=v16@0:8 | IMP=Spotify+0x7fa5f94
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingTrackMatchFacade
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    metadataProvider |  | offset=16
    matcher |  | offset=32
    referenceAttributes |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingRowEmphasisContainer
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    contained |  | offset=16
    uiView | @"UIView" | offset=24
    isEmphasized |  | offset=32
    decorationView |  | offset=40
  PROPERTIES (1)
    uiView | T@"UIView",N,R,VuiView
  PROTOCOLS (1)
    LegacyUI_ECMCoreKit.ECMLegacyView
      required instance uiView | @16@0:8
  INSTANCE METHODS (1)
    uiView | types=@16@0:8 | IMP=Spotify+0x3f066c
  CLASS METHODS (0)

============================================================
CLASS _TtC25PlaylistMixing_ElementKitP33_071FE4D55679E8C23A3257E7FBF8017642MixingReferenceTrackRowMetadataViewUpdater
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    lastSizingSignature |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingReferenceTrackRowUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (13)
    imageLoader |  | offset=16
    trailingView |  | offset=32
    updateTrailingView |  | offset=40
    metadataWidthMeasurer |  | offset=56
    eventHandler |  | offset=72
    metadataAccessibilityModel |  | offset=88
    playbackAccessibilityValue |  | offset=96
    $__lazy_storage_$_coverArtView |  | offset=112
    $__lazy_storage_$_playPreviewGesture |  | offset=120
    $__lazy_storage_$_metadataWidthConstraint |  | offset=128
    $__lazy_storage_$_listRow |  | offset=136
    playbackIndicatorTitleView |  | offset=144
    $__lazy_storage_$_view |  | offset=152
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (1)
    didTapPlayPreview | types=v16@0:8 | IMP=Spotify+0xf08518
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingPlayTransitionPreviewButtonElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    previewButton |  | offset=16
    $__lazy_storage_$_view |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingMoreMenuHeaderElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    artworkView |  | offset=16
    listRow |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingMetadataProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (10)
    extendedMetadataClient |  | offset=16
    isUsingStandardKeyNotation |  | offset=32
    batchWindow |  | offset=40
    maxBatchSize |  | offset=48
    maxCacheEntries |  | offset=56
    protectedCount |  | offset=64
    cache |  | offset=72
    cacheOrder |  | offset=80
    pendingRequests |  | offset=88
    batchTimer |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingMetadataElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (12)
    imageLoader |  | offset=16
    accessibilityModel |  | offset=32
    observedContentSizeCategory |  | offset=40
    isLayoutInvalidationScheduled |  | offset=48
    $__lazy_storage_$_view |  | offset=56
    $__lazy_storage_$_keyAndDurationStackView |  | offset=64
    keyLabelView |  | offset=72
    $__lazy_storage_$_bpmStackView |  | offset=80
    $__lazy_storage_$_modificationImageView |  | offset=88
    $__lazy_storage_$_bpmWarningIcon |  | offset=96
    $__lazy_storage_$_bpmLabel |  | offset=104
    durationLabel |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingMetadataAccessibilityModel
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    metadata |  | offset=16
    observer |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC25PlaylistMixing_ElementKitP33_B4A3005065FF5CC87077A83BCE4B075212TapThrottler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    subject |  | offset=16
    cancellable |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV25PlaylistMixing_ElementKit16MixButtonElementP33_BE0763CFCD06B428D942AA9CCDC74F259ElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    view |  | offset=16
    buttonView |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl24SimpleEntityRowComponent10ViewBinder
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    ubiEventLogger |  | offset=16
    ubiImpressionToken |  | offset=32
    model |  | offset=48
    componentState |  | offset=80
    viewController |  | offset=88
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl24SimpleEntityRowComponent15ComponentBinder
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl36ChapterNavigationListButtonComponent10ViewBinder
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    viewController |  | offset=16
    ubiEventLogger |  | offset=24
    consumers |  | offset=40
    ubiImpressionToken |  | offset=56
    ubiSheetImpressionToken |  | offset=72
    model |  | offset=88
    componentState |  | offset=128
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCO39PlaylistMixing_WatchFeedIntegrationImpl36ChapterNavigationListButtonComponent15ComponentBinder
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionPlayerImpl.MixingTransitionPlayerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    player |  | offset=16
    contextURI |  | offset=24
    wasPlayingNonTransitionContext |  | offset=40
    playingTransitionContext |  | offset=48
    playGeneration |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ReorderingImpl.MixingReorderEligibilityImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    configuration |  | offset=16
    userSettings |  | offset=56
    listEndpoint |  | offset=72
    mixedPlaylistsProvider |  | offset=112
    exclusionChecker |  | offset=152
    transitionParser |  | offset=160
    cancellables |  | offset=176
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ReorderingImpl.MixedPlaylistsProviderImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dataLoader |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ReorderingImpl.ListHarmonizerReorderSessionImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (18)
    state |  | offset=16
    client |  | offset=40
    listEndpoint |  | offset=56
    playlistSynchroniser |  | offset=96
    playlistURL |  | offset=112
    isExplicitContentRestricted |  | offset=128
    canPlay19PlusContent |  | offset=129
    userSettings |  | offset=136
    saveVerificationTimeout |  | offset=152
    transitionParser |  | offset=160
    exclusionChecker |  | offset=176
    fetchedItems |  | offset=184
    previousRemovals |  | offset=192
    exclusions |  | offset=200
    chains |  | offset=208
    keepUserDefinedTransitionsTogether |  | offset=216
    saveCancellable |  | offset=224
    reorderCancellable |  | offset=232
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ReorderingImpl.ListHarmonizerClientImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dataLoader |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_WaveformKit.MixingHapticPlayer
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    engine |  | offset=16
    player |  | offset=24
    pattern |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingConfigurableStylesProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    configuration |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingUndoRedoNavigationOverlayHost
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    viewController |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingUndoRedoOverlayCoordinator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    inactivityDuration |  | offset=16
    undoRedoBarElement |  | offset=0
    registration |  | offset=24
    presentation |  | offset=88
    hideWorkItem |  | offset=96
    isPresented |  | offset=104
    $__lazy_storage_$_controlsView |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingOverlayTransitionHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    delegate |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditTransitionHeaderLoggerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    ubiLogger |  | offset=16
    headerEventFactory |  | offset=32
    undoRedoControlsEventFactory |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditTrackSwapLoggerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    ubiLogger |  | offset=16
    parentAbsoluteLocation |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditMoreMenuRowsLoggerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    ubiLogger |  | offset=16
    moreMenuEventFactory |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingWaveformLoggerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    ubiLogger |  | offset=16
    parentAbsoluteLocatoon |  | offset=32
    $__lazy_storage_$_eventFactory |  | offset=40
    $__lazy_storage_$_curvesEditFactory |  | offset=56
    fallbackURL |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEducationVideosNavigator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    linkDispatcher |  | offset=16
    pageResolver |  | offset=24
    environmentBuilder |  | offset=40
    parentLoggerProvider |  | offset=80
    navigationLogger |  | offset=96
    navigationController |  | offset=104
    mixingRootViewController |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditPermissionLoadable
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    playlistURL |  | offset=16
    $__lazy_storage_$_permission |  | offset=32
    permissionsHandler |  | offset=40
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingCachedCustomCurveHistory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    current |  | offset=16
    capacity |  | offset=208
    currentRevision |  | offset=216
    retainedRevisions |  | offset=224
    curvesByRevision |  | offset=232
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC27PlaylistMixing_MixingUIImplP33_05EDA3EDA6BFDBF67C3D082C3A3310FD16MinimapElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    view |  | offset=16
    eventHandler |  | offset=24
    minimapCoordinator |  | offset=40
    track |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingMinimapCoordinator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    outHandlers |  | offset=16
    inHandlers |  | offset=64
    lastSnappedMs |  | offset=112
    jogTimerReset |  | offset=120
    onBarChanged |  | offset=136
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV27PlaylistMixing_MixingUIImpl21MixingPlayHeadElementP33_C523A9664157F6B7591611F315A808AD9ElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    playHead |  | offset=16
    previousState |  | offset=24
    animator |  | offset=160
    trajectory |  | offset=168
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.OverlapEditorEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    dataPool |  | offset=16
    transitionDataStatement |  | offset=56
    outWaveformElement |  | offset=104
    inWaveformElement |  | offset=216
    upstreamEventHandler |  | offset=328
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingCustomizeButtonElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    fuserConnection |  | offset=16
    buttonView |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingCurveRenderer
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (11)
    shapeLayer |  | offset=16
    curveColor |  | offset=24
    backgroundColor |  | offset=32
    identifier |  | offset=40
    currentCurves |  | offset=56
    currentOpacity |  | offset=64
    bounds |  | offset=72
    displayLink |  | offset=104
    animationState |  | offset=112
    verticalCenterSnapThreshold |  | offset=176
    controlPointsLayer |  | offset=184
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (1)
    animationStep | types=v16@0:8 | IMP=Spotify+0x321d410
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingBarPickerButtonElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    fuserConnection |  | offset=16
    borderedButton |  | offset=56
    $__lazy_storage_$_view |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStyleButtonElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    fuserConnection |  | offset=16
    styleLabel |  | offset=56
    currentStyleLabel |  | offset=64
    _chevronIconView |  | offset=72
    button |  | offset=80
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.UpstreamEventPublisher
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    subject |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC27PlaylistMixing_MixingUIImplP33_BDF4826A5750025167E538B1D96B374726ProductOptInPromoElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    view |  | offset=16
    titleLabel |  | offset=24
    bodyLabel |  | offset=32
    primaryButton |  | offset=40
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV27PlaylistMixing_MixingUIImpl23MixingPlayButtonElementP33_06B7DF640CB5952209A38826F54A571A25CustomPlayButtonElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    view |  | offset=16
    showLoaderWorkItem |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingOverlayTransitionCoordinator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    isTransitioning |  | offset=16
    isPresented |  | offset=17
    views |  | offset=24
    navigationHandler |  | offset=80
    barPickerAlphaAnimator |  | offset=88
    waveformMaxHeightConstraint |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC27PlaylistMixing_MixingUIImplP33_9631C1D98072A1CAD46E07BE39C996C729MixingIconTextButtonElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    fuserConnection |  | offset=16
    dispatchEvent |  | offset=56
    label |  | offset=72
    iconView |  | offset=80
    button |  | offset=88
    longPressGesture |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (1)
    handleLongPress: | types=v24@0:8@16 | IMP=Spotify+0x36030c
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.InterruptibleAlphaAnimator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    view |  | offset=16
    animator |  | offset=24
    targetAlpha |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV27PlaylistMixing_MixingUIImpl30MixingBottomSheetPickerElementP33_F6E0A06DE39740C495DB3F86EA57D21516DefaultElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    eventHandler |  | offset=16
    view |  | offset=32
    descriptionLabel |  | offset=40
    scrollView |  | offset=48
    optionButtons |  | offset=56
    lastPickerTypeHash |  | offset=64
    scrollPositions |  | offset=72
    lastSelectedId |  | offset=80
    currentSelectedIndex |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV27PlaylistMixing_MixingUIImpl33MixingBottomSheetContainerElementP33_2F1C4DD5F6CEDC3F2766B0E31CB0E2F29ElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    eventHandler |  | offset=16
    availableStylesProvider |  | offset=32
    descriptionLabel |  | offset=72
    presentedPicker |  | offset=80
    contentElementView |  | offset=88
    $__lazy_storage_$_grabber |  | offset=96
    $__lazy_storage_$_separator |  | offset=104
    $__lazy_storage_$_view |  | offset=112
    previousUIConfiguration |  | offset=120
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC27PlaylistMixing_MixingUIImplP33_34C155B501FFAC1918BA891A3B3FAD9B21DebouncingPlayHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    player |  | offset=16
    pendingWorkItem |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingSwapTrackContext
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    trackMetadata |  | offset=16
    transitionMetadata |  | offset=64
    identity |  | offset=1984
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStylesSubscription
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    stylesLoader |  | offset=16
    subscriber |  | offset=32
    currentObservedKeys |  | offset=48
    presetStyles |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStylesDataSource
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    stylesLoader |  | offset=16
    subscription |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingShareEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    dialogPresenter |  | offset=16
    transitionHandling |  | offset=32
    listEndpoint |  | offset=48
    shareMenuFactory |  | offset=88
    getAutoTransitionURIClient |  | offset=104
    signalTimeout |  | offset=120
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingSaveIfNeededAndNavigateEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dialogPresenter |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingNoBeatMatchWarningSheetEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    linkDispatcher |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditTrackSwapSelectionEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    linkDispatcher |  | offset=16
    listEndpoint |  | offset=24
    configuration |  | offset=64
    logger |  | offset=104
    cancellable |  | offset=120
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditSaveWithTrackSwapEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    listOperation |  | offset=16
    playlistModel |  | offset=56
    transitionHandling |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditSaveTransitionEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    transitionHandling |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditMoreMenuEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    configuration |  | offset=16
    sheetPresenter |  | offset=56
    makeViewController |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditIncomingTrackSwapEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    featureId |  | offset=16
    transitionLoader |  | offset=32
    metadataClient |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditHistoryEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    capacity |  | offset=16
    undoPositions |  | offset=24
    redoPositions |  | offset=32
    currentRevision |  | offset=40
    nextRevision |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditClosePageEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    mixingPlayer |  | offset=16
    configuration |  | offset=32
    reorderEligibility |  | offset=72
    linkDispatcher |  | offset=112
    setPageStatus |  | offset=120
    closePage |  | offset=136
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingCannotSaveTransitionAsViewerEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    dialogPresenter |  | offset=16
    playlistDuplicator |  | offset=32
    playlistModel |  | offset=48
    permissionHandler |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingAutomixTransitionLoader
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    automixClient |  | offset=16
    coreAutomixTransitionLoader |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingTransitionHandlingImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    listOperation |  | offset=16
    playlistDataLoader |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStylesLoaderImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    automixClient |  | offset=16
    cancellables |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStyleCurveLoader
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    automixClient |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStyleBlockLoaderImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    automixClient |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingGetAutoTransitionURIClientImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dataLoader |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingContextMenuRegistrar
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (14)
    playlistDataLoader |  | offset=16
    mixingStateCoordinator |  | offset=32
    contextMenuActionsRegistry |  | offset=48
    snackbarPresenter |  | offset=56
    playlistDuplicator |  | offset=64
    playlistModel |  | offset=80
    linkDispatcher |  | offset=96
    playlistSortingService |  | offset=104
    mixingPermissionsHandler |  | offset=120
    autoMixEvaluator |  | offset=160
    mixingConfiguration |  | offset=200
    lexiconPlaylistURIMapping |  | offset=240
    ubiLogging |  | offset=248
    reachabilityMonitor |  | offset=264
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingReorderOverviewPageImpl.MixingReorderOverviewLoggerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    ubiLogger |  | offset=16
    eventFactory |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingReorderOverviewPageImpl.MixingReorderLoadableFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    reorderLoader |  | offset=16
    cancellable |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingReorderOverviewPageImpl.MixingReorderOverviewDataLoaderImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    listEndpoint |  | offset=16
    reorderingSession |  | offset=56
    hideUnplayableTracks |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingUserSettingsImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    userSettings |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingTrackMatcherImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    configuration |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingShuffleHandlerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    smartShuffleHandler |  | offset=16
    smartShuffleExperienceResolver |  | offset=32
    player |  | offset=72
    capturedStates |  | offset=80
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingPlaylistDuplicatorImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dataLoader |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingAutoMixEvaluatorImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingStateCoordinatorImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    listOperation |  | offset=16
    metadataInvalidationClient |  | offset=56
    configuration |  | offset=72
    listEndpoint |  | offset=112
    mixingPermissionsHandler |  | offset=152
    shuffleHandler |  | offset=192
    lexiconPlaylistURIMapping |  | offset=208
    playlistSortingService |  | offset=216
    subscriptionToken |  | offset=232
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingPlaylistModelImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    listEndpoint |  | offset=16
    unplayableTracksPreference |  | offset=56
    sortingService |  | offset=96
    transitionParser |  | offset=112
    cancellables |  | offset=128
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingImpl.MixingMetadataInvalidationClientImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    metadataClient |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV28PlaylistMixing_MessagingImpl42MixingMessagingNonBeatMatchedTracksElementP33_DBAD203173ADEE94122C521952F752989ElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    view |  | offset=16
    eventHandler |  | offset=24
    titleLabel |  | offset=40
    primaryButton |  | offset=48
    secondaryButton |  | offset=56
    bodyLabel |  | offset=64
    bulletPointsStackView |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.MixingDialogPresenterImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    popUpPresenter |  | offset=16
    snackbarPresenter |  | offset=24
    ubiLogging |  | offset=32
    parentAbsoluteLocation |  | offset=48
    messagingConfiguration |  | offset=56
    reorderEligibility |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.MessagingConfigurationImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    productState |  | offset=16
    featureProperties |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingTransitionRowFooter
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (13)
    linkDispatcher |  | offset=16
    entityModel |  | offset=24
    playlistURL |  | offset=64
    configuration |  | offset=80
    isInSearchContext |  | offset=120
    playlistMixingDialogPresenter |  | offset=128
    forcedOfflineModeManager |  | offset=144
    connectAggregatorAPI |  | offset=152
    schedulingWarningHandler |  | offset=168
    ubiLogger |  | offset=208
    parentAbsoluteLocation |  | offset=224
    $__lazy_storage_$_trackPairInfoProvider |  | offset=232
    $__lazy_storage_$_slot |  | offset=240
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingMixTrackOrderContextMenuItemAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    identifier |  | offset=16
    actionsFactoryActionIdentifier |  | offset=24
    configuration |  | offset=32
    mixingPermissionsHandler |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingMixEnablingContextMenuItemAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    identifier |  | offset=16
    actionsFactoryActionIdentifier |  | offset=24
    configuration |  | offset=32
    mixingPermissionsHandler |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingMixDuplicateContextMenuItemAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    identifier |  | offset=16
    actionsFactoryActionIdentifier |  | offset=24
    configuration |  | offset=32
    mixingPermissionsHandler |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingMetadataSecondaryAction
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    slot |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingMetadataSecondaryActionAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    identifier |  | offset=16
    configuration |  | offset=24
    extendedMetadataClient |  | offset=64
    mixingPermissionsHandler |  | offset=80
    imageLoader |  | offset=120
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingEntityModelTrackPairInfoProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    entityModel |  | offset=16
    rowIndexBuilder |  | offset=56
    disposable |  | offset=72
    rowIndexInvalidationDisposable |  | offset=88
    observedTrackPairs |  | offset=104
    rowIndexSnapshot |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingAttributesObserver
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    lock |  | offset=16
    _attributes |  | offset=24
    disposable |  | offset=32
    entityModel |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixOnShufflePrePlayInterceptor
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    uri |  | offset=16
    linkDispatcher |  | offset=32
    mixingShuffleHandler |  | offset=40
    mixingUserSettings |  | offset=56
    mixingAttributesObserver |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixOnShufflePrePlayInterceptorAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    identifier |  | offset=16
    mixingShuffleHandler |  | offset=24
    mixingUserSettings |  | offset=40
    configuration |  | offset=56
    mixingPermissionsHandler |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixOnFreePrePlayInterceptor
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (8)
    playlistURL |  | offset=16
    isMixed |  | offset=32
    canEditItems |  | offset=33
    onDemandType |  | offset=40
    linkDispatcher |  | offset=48
    mixingPermissionsHandler |  | offset=56
    mixingUserSettings |  | offset=96
    $__lazy_storage_$_dateFormatter |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixOnFreePrePlayInterceptorAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    identifier |  | offset=16
    configuration |  | offset=24
    mixingPermissionsHandler |  | offset=64
    mixingUserSettings |  | offset=104
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixButtonUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    onTapped |  | offset=16
    button |  | offset=32
    $__lazy_storage_$_view |  | offset=40
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (1)
    handleTapped | types=v16@0:8 | IMP=Spotify+0x41907ec
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixAndShuffleHeaderShuffleAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (11)
    identifier |  | offset=16
    configuration |  | offset=24
    mixingPermissionsHandler |  | offset=64
    autoMixEvaluator |  | offset=104
    mixingStateCoordinator |  | offset=144
    smartShuffleHandler |  | offset=160
    shuffleModelFactory |  | offset=176
    shuffleToggleUpsellModel |  | offset=184
    reachabilityMonitor |  | offset=192
    mixingDialogPresenterProvider |  | offset=208
    windowWidthProvider |  | offset=224
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixAndShuffleComposedUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    mixView |  | offset=16
    shuffleView |  | offset=24
    $__lazy_storage_$_view |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.HeaderShuffleActionLoggerForwarder
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    parentAbsoluteLocation |  | offset=16
    ubiLogger |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingPlugin
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dependencies |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingLifecycleProviderConfig
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    playlistURL |  | offset=16
    metadataClient |  | offset=32
    sortingPreference |  | offset=48
    lifetime |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingLifecycleAccept
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    identifier |  | offset=16
    metadataClient |  | offset=24
    sortingPreferenceProvider |  | offset=40
    mixingPermissionsHandler |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixAndShufflePlugin
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dependencies |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ListUXPluginsImpl.MixingHeaderDecorations
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    artworkColor |  | offset=16
    isMixed |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_LaterInPlaylistPageImpl.LaterInPlaylistTrackRowUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    trackRowView |  | offset=16
    transitionIndicatorView |  | offset=24
    $__lazy_storage_$_view |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC38PlaylistMixing_LaterInPlaylistPageImplP33_86B34723FEC63B53198E72BCDEED5E5F29LaterInPlaylistReferenceRowUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    referenceRowView |  | offset=16
    $__lazy_storage_$_view |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_LaterInPlaylistPageImpl.LaterInPlaylistPreviewPlayer
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    activePreviewIdentifier |  | offset=16
    singlePlayerState |  | offset=24
    multiPlayerSession |  | offset=32
    playerGroup |  | offset=48
    player |  | offset=64
    playerDisposable |  | offset=80
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_LaterInPlaylistPageImpl.LaterInPlaylistLogger
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    ubiLogger |  | offset=16
    eventFactory |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_LaterInPlaylistPageImpl.LaterInPlaylistLoadableFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    dataLoader |  | offset=16
    dataPool |  | offset=24
    imageLoader |  | offset=64
    previewPlayer |  | offset=80
    makeReferenceRowEventFactory |  | offset=96
    cancellable |  | offset=112
    dataActivation |  | offset=120
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_LaterInPlaylistPageImpl.LaterInPlaylistDataLoaderImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    listEndpoint |  | offset=16
    hideUnplayableTracks |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_CreateMenuItemImpl.MixingCreateMenuItemProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dependencies |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ConfigurationImpl.MixingShareTransitionActionsConfigurationImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    configuration |  | offset=16
    permissionsHandler |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ConfigurationImpl.MixingConfigurationImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    featureProperties |  | offset=16
    permissionsHandler |  | offset=24
    debugSettings |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ConfigurationImpl.MixingConfigurationDebugSettings
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    localSettings |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistEditing_EditPlaylistImpl.EditPlaylistMixingEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    mixingReorderingSession |  | offset=16
    mixingDialogPresenter |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlayTelemetry_BetamaxPlaybackOopsWiringImpl.MultiPlayerPlaybackStartOopsObserver
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    playbackOopsInstrumentation |  | offset=16
    clock |  | offset=56
    playbackId |  | offset=72
    clipUri |  | offset=88
    interactionId |  | offset=104
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlayTelemetry_BetamaxPlaybackOopsWiringImpl.MultiPlayerPlaybackStartOopsObserverFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    playbackOopsInstrumentation |  | offset=16
    clock |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS NowPlaying_MixingTransitionImpl.WallClockTransitionPublisher
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (19)
    $__lazy_storage_$_statePublisher |  | offset=16
    shouldAnimateStop |  | offset=24
    $__lazy_storage_$_animationStatePublisher |  | offset=32
    externalStateSubject |  | offset=40
    animationStateSubject |  | offset=48
    trackPositionTimer |  | offset=56
    clock |  | offset=72
    cancellables |  | offset=88
    phase |  | offset=96
    latestPlayerState |  | offset=200
    isNPVVisible |  | offset=208
    isMixingContext |  | offset=209
    outgoingSnapshot |  | offset=216
    incomingSnapshot |  | offset=248
    swapDetected |  | offset=273
    fadeOutFired |  | offset=274
    fadeInFired |  | offset=275
    consumedOutgoingURI |  | offset=280
    extrapolationTicker |  | offset=296
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC31NowPlaying_MixingTransitionImplP33_9842B30F24957717BA260D68CD049B1A28CustomAnimationImageProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    firstImage |  | offset=16
    secondImage |  | offset=24
    fallback |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS NowPlaying_MixingTransitionImpl.MixingTransitionElementUI
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (11)
    view |  | offset=16
    dispatchEvent |  | offset=24
    shouldAnimateStop |  | offset=40
    artworkProvider |  | offset=56
    backgroundView |  | offset=96
    lottieView |  | offset=104
    containerConstraints |  | offset=112
    appliedMargins |  | offset=120
    requestCancellable |  | offset=160
    previousTransitionState |  | offset=168
    $__lazy_storage_$_containerView |  | offset=176
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS NowPlaying_MixingTransitionImpl.MixingTransitionElementFactoryImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    transitionStatePublisher |  | offset=16
    playerStatePublisher |  | offset=24
    shouldAnimateStop |  | offset=32
    artworkProvider |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS NowPlaying_MixingTransitionImpl.DirectArtworkProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    imageLoader |  | offset=16
    component |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS NowPlaying_MixingTransitionImpl.VITArtworkProvider
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    artworkElement |  | offset=16
    extendedMetadataClient |  | offset=24
    localFileTraitsProvider |  | offset=40
    imageLoader |  | offset=80
    dataPoolProvider |  | offset=120
    $__lazy_storage_$_elementView |  | offset=136
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_UserSelectedMuteStateImpl.LocalMuteController
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    _muteState |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.RetainingDisposable
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    retained |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.SinglePlayerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    playerHolder |  | offset=16
    disposables |  | offset=24
    isInvalidated |  | offset=32
    _state |  | offset=72
    wasPlayingWhileActive |  | offset=80
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCC22MultiPlayer_PlayerImpl15PlayerGroupImplP33_EDACFB8F48EE3A3F36E0A467DE3648605Scope
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    tokens |  | offset=16
    playerPool |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.PlayerGroupImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    scope |  | offset=16
    activeSubject |  | offset=24
    muteState |  | offset=32
    stopOnDeactivate |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.EndedMultiPlayerSession
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    valid |  | offset=16
    muted |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.InternalPlayerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (24)
    player |  | offset=16
    playbackRequestFactory |  | offset=24
    extraMetadataProvider |  | offset=32
    playbackObserverFactory |  | offset=48
    audioCoordinator |  | offset=56
    audioTap |  | offset=64
    reportingContextProvider |  | offset=72
    playbackIdGenerator |  | offset=88
    useStreamReportingModule |  | offset=104
    streamReportingContext |  | offset=112
    backgroundMode |  | offset=128
    _state |  | offset=136
    currentContent |  | offset=144
    lastInteractionLoggingResult |  | offset=392
    lastLinkingID |  | offset=400
    lastEventProvenance |  | offset=416
    lastPlaybackID |  | offset=432
    availableSubtitles |  | offset=448
    pendingPlayWorkItem |  | offset=456
    wantsToPlay |  | offset=464
    trackingManager |  | offset=472
    shouldTrackNextPTTFF |  | offset=480
    error |  | offset=488
    hasStartedPlayback |  | offset=496
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.InternalAudioCoordinator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    audioSessionActivationHandler |  | offset=16
    player |  | offset=32
    audioTap |  | offset=40
    unmutedHandleProvider |  | offset=48
    unmutedHandle |  | offset=64
    volume |  | offset=80
    isMuted |  | offset=84
    hasStartedPlayback |  | offset=85
    contentIsUnmutable |  | offset=86
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.DelegatingSurfaceManager
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    observerManager |  | offset=16
    phonySurface |  | offset=24
    surfaceManager |  | offset=32
    pipControllerSource | @"<BMPiPControllerSource>" | offset=40
  PROPERTIES (1)
    pipControllerSource | T@"<BMPiPControllerSource>",N,R,VpipControllerSource
  PROTOCOLS (2)
    BMVideoSurfaceManagerObserver
      required instance surfaceManager:didAddSurface: | v32@0:8@16@24
      required instance surfaceManager:didRemoveSurface: | v32@0:8@16@24
      required instance surfaceManager:didChangePriorityForSurface: | v32@0:8@16@24
      required instance surfaceManager:surface:didChangeVisibilityPercentage: | v40@0:8@16@24q32
      optional instance surfaceManager:surfaceSizeDidChange:size: | v48@0:8@16@24{CGSize=dd}32
    BMVideoSurfaceManager
      required instance pipControllerSource | @16@0:8
      required instance addSurface: | v24@0:8@16
      required instance removeSurface: | v24@0:8@16
      required instance removeAllSurfaces | v16@0:8
      required instance addObserver: | v24@0:8@16
      required instance removeObserver: | v24@0:8@16
      required instance activeSurfaceForPlaybackIdentity: | @24@0:8@16
  INSTANCE METHODS (12)
    surfaceManager:didAddSurface: | types=v32@0:8@16@24 | IMP=Spotify+0x5dc7820
    surfaceManager:didRemoveSurface: | types=v32@0:8@16@24 | IMP=Spotify+0x7ce1c18
    surfaceManager:didChangePriorityForSurface: | types=v32@0:8@16@24 | IMP=Spotify+0x4970a5c
    surfaceManager:surface:didChangeVisibilityPercentage: | types=v40@0:8@16@24q32 | IMP=Spotify+0x7749628
    surfaceManager:surfaceSizeDidChange:size: | types=v48@0:8@16@24{CGSize=dd}32 | IMP=Spotify+0x4573ebc
    pipControllerSource | types=@16@0:8 | IMP=Spotify+0xc44868
    addSurface: | types=v24@0:8@16 | IMP=Spotify+0x24059cc
    removeSurface: | types=v24@0:8@16 | IMP=Spotify+0x1154104
    removeAllSurfaces | types=v16@0:8 | IMP=Spotify+0x64f9e40
    addObserver: | types=v24@0:8@16 | IMP=Spotify+0x7fee830
    removeObserver: | types=v24@0:8@16 | IMP=Spotify+0x4d3c88c
    activeSurfaceForPlaybackIdentity: | types=@24@0:8@16 | IMP=Spotify+0x3350a88
  CLASS METHODS (0)

============================================================
CLASS Endless_ContextMenuImpl.DJAutoMixPlugin
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    factory |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Endless_AIDJUIImpl.DJAutoMixActionTaskFactoryImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    dependencies |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTDJAutoMixActionTaskFactory
      required instance makeDJAutoMixActionTaskWithPlaylistURI: | @24@0:8@16
  INSTANCE METHODS (1)
    makeDJAutoMixActionTaskWithPlaylistURI: | types=@24@0:8@16 | IMP=Spotify+0x11c4ce0
  CLASS METHODS (0)

============================================================
CLASS Discovery_PreviewCoordinatorImpl.MultiPlayerPreviewCoordinator
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    deps |  | offset=16
    attentionTarget |  | offset=216
    effectHandler |  | offset=232
    loop |  | offset=240
    previewButtonState |  | offset=248
    disposables |  | offset=296
    currentAsset |  | offset=304
    playerGroup |  | offset=456
    state |  | offset=472
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Canvas_PlayerImpl.CanvasMultiPlayerSessionManager
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (8)
    sessionProvider |  | offset=16
    currentPlayerGroup |  | offset=32
    cachedSurfaceFactory |  | offset=48
    sessionRenewalObservers |  | offset=64
    collapseObservers |  | offset=72
    expandObservers |  | offset=80
    sessionValidityDisposable |  | offset=88
    isExpanded |  | offset=104
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC17Canvas_PlayerImplP33_A3B7E5D0C6CA29BBC1860D9F8A21E49234CanvasMultiPlayerHandlerDisposable
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    onDispose |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Canvas_PlayerImpl.CanvasMultiPlayerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (16)
    internalState |  | offset=16
    entityUri |  | offset=152
    canvasModel |  | offset=168
    modelResolver |  | offset=304
    sessionManager |  | offset=344
    canvasCacheDirectory |  | offset=352
    singlePlayer |  | offset=368
    stateDisposable |  | offset=384
    groupDisposable |  | offset=400
    modelResolverDisposable |  | offset=416
    playerView |  | offset=432
    videoSurface |  | offset=440
    activeMediaURL |  | offset=456
    surfaceIdentifier |  | offset=472
    stateHandlers |  | offset=488
    currentPlayerState |  | offset=496
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS KubrickSDK.KubrickAudioTap
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (6)
    sampleBufferAudioTap |  | offset=16
    audioDecoder |  | offset=24
    processingQueue |  | offset=32
    kubrickLogger |  | offset=40
    lock |  | offset=48
    _isEnabled |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerAPI.NoOpIdentifiableVideoSurfaceFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV37SwiftEsperanto_transition_proto_swift29Spotify_Automix_Proto_OverlapP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (19)
    _trackARowID |  | offset=16
    _trackBRowID |  | offset=32
    _startAMs |  | offset=48
    _startBMs |  | offset=52
    _durationMs |  | offset=56
    _speedA |  | offset=60
    _speedB |  | offset=68
    _durationBars |  | offset=76
    _isBeatmatched |  | offset=81
    _trackAUri |  | offset=88
    _trackBUri |  | offset=104
    _trackAPlayableUri |  | offset=120
    _trackBPlayableUri |  | offset=136
    _trackAPlayableBeatsHash |  | offset=152
    _trackBPlayableBeatsHash |  | offset=168
    _bpmA |  | offset=184
    _bpmB |  | offset=188
    _itemSpeedA |  | offset=192
    _itemSpeedB |  | offset=200
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV37SwiftEsperanto_transition_proto_swift28Spotify_Automix_Proto_PresetP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (17)
    _id |  | offset=16
    _type |  | offset=24
    _volumeStyleOverride |  | offset=40
    _eqStyleOverride |  | offset=64
    _filterFxStyleOverride |  | offset=88
    _volumeOutCurveOverride |  | offset=112
    _volumeInCurveOverride |  | offset=152
    _eqOutCurveOverrides |  | offset=192
    _eqInCurveOverrides |  | offset=328
    _filterOutCurveOverrides |  | offset=464
    _filterInCurveOverrides |  | offset=600
    _fxStyleOverride |  | offset=736
    _fxOutCurveOverrides |  | offset=760
    _fxInCurveOverrides |  | offset=896
    _jogwheelStyleOverride |  | offset=1032
    _loopingStyleOverride |  | offset=1056
    _loopingOutBlocksOverride |  | offset=1080
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV37SwiftEsperanto_transition_proto_swift35Spotify_Automix_Proto_FxStyleCurvesP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    _style |  | offset=16
    _echoDryWetOutCurves |  | offset=40
    _echoDryWetInCurves |  | offset=80
    _reverbDryWetOutCurves |  | offset=120
    _reverbDryWetInCurves |  | offset=160
    _delayDryWetOutCurves |  | offset=200
    _delayDryWetInCurves |  | offset=240
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV37SwiftEsperanto_transition_proto_swift41Spotify_Automix_Proto_FilterFxStyleCurvesP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    _style |  | offset=16
    _filterCutoffOutCurves |  | offset=40
    _filterResonanceOutCurves |  | offset=80
    _filterCutoffInCurves |  | offset=120
    _filterResonanceInCurves |  | offset=160
    _noiseColorOutCurves |  | offset=200
    _noiseColorInCurves |  | offset=240
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV37SwiftEsperanto_transition_proto_swift35Spotify_Automix_Proto_EqStyleCurvesP33_3B76012BAA4F1E88B18128D4DACFDE3413_StorageClass
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    _style |  | offset=16
    _lowEqOutCurves |  | offset=40
    _midEqOutCurves |  | offset=80
    _highEqOutCurves |  | offset=120
    _lowEqInCurves |  | offset=160
    _midEqInCurves |  | offset=200
    _highEqInCurves |  | offset=240
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCV34SwiftEsperanto_preview_proto_swift29Spotify_Automix_Proto_PreviewP33_5D34A261577B2A79CEF60060D0F4579B13_StorageClass
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (15)
    _trackUri1 |  | offset=16
    _trackUri2 |  | offset=32
    _automixMode |  | offset=48
    _transitionUri |  | offset=64
    _startPositionMs |  | offset=80
    _relativeStartPosition |  | offset=88
    _cuepoints |  | offset=96
    _stopPositionMs |  | offset=240
    _transitionRecipe |  | offset=256
    _playableTrackUri1 |  | offset=344
    _playableTrackUri2 |  | offset=360
    _contextUri |  | offset=376
    _armID |  | offset=392
    _itemSpeedA |  | offset=408
    _itemSpeedB |  | offset=416
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingTransitionParserImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingVolumeStyleCurves
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    style |  | offset=16
    fadeOutCurves |  | offset=24
    fadeInCurves |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingEqStyleCurves
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    style |  | offset=16
    lowEqOutCurves |  | offset=24
    midEqOutCurves |  | offset=32
    highEqOutCurves |  | offset=40
    lowEqInCurves |  | offset=48
    midEqInCurves |  | offset=56
    highEqInCurves |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingEffectStyleCurves
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    style |  | offset=16
    echoDryWetOutCurves |  | offset=24
    echoDryWetInCurves |  | offset=32
    reverbDryWetOutCurves |  | offset=40
    reverbDryWetInCurves |  | offset=48
    delayDryWetOutCurves |  | offset=56
    delayDryWetInCurves |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingFilterFxStyleCurves
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    style |  | offset=16
    filterCutoffOutCurves |  | offset=24
    filterResonanceOutCurves |  | offset=32
    filterCutoffInCurves |  | offset=40
    filterResonanceInCurves |  | offset=48
    noiseColorOutCurves |  | offset=56
    noiseColorInCurves |  | offset=64
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingStyleCurves
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    curves |  | offset=16
    minimum |  | offset=24
    maximum |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingStyleCurve
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    points |  | offset=16
    start |  | offset=24
    end |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionModelKit.MixingCoreAutomixTransitionLoader
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    automixClient |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Discovery_MultiPlayerKit.NoOpSimpleAttentionPlayer
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    sectionID |  | offset=16
    surfaceFactory |  | offset=32
    state |  | offset=48
    delegate |  | offset=88
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Discovery_MultiPlayerKit.NoOpSimpleAttentionPlayerFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    surfaceFactory |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Discovery_MultiPlayerKit.MultiPlayerSimpleAttentionPlayer
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (11)
    playerGroupProvider |  | offset=16
    playerGroup |  | offset=32
    attentionTarget |  | offset=48
    stopOnUnfocus |  | offset=64
    currentContent |  | offset=72
    groupActiveDisposable |  | offset=320
    stateDisposable |  | offset=336
    player |  | offset=352
    delegate |  | offset=368
    _state |  | offset=384
    $__lazy_storage_$_state |  | offset=392
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Discovery_MultiPlayerKit.EvoAttentionTargetImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    _focused |  | offset=16
    target |  | offset=24
    disposable |  | offset=32
    identifier |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.MessagingConnectNotSupportedEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    speedControlConfiguration |  | offset=16
    messageRequester |  | offset=56
    snackbarPresenter |  | offset=96
    isConnectButtonVisible |  | offset=104
    messagingLogger |  | offset=120
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.MessagingLoopController
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    dependencies |  | offset=16
    mobiusController |  | offset=184
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.MessagingLoggerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    ubiLogger |  | offset=16
    parentAbsoluteLocation |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.MultiPlayerSessionImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (7)
    reportingContext |  | offset=16
    validSubject |  | offset=48
    playerPool |  | offset=56
    muteController |  | offset=64
    muteState |  | offset=80
    lastPlayerGroup |  | offset=120
    playerLimit |  | offset=128
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.IdentifiableVideoSurfaceFactoryImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    surfaceFactory |  | offset=16
    surfaceManager |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Discovery_MultiPlayerKit.SimpleAttentionPlayerFactoryImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    playerGroupProvider |  | offset=16
    attentionTracker |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS Discovery_PreviewCoordinatorImpl.MultiPlayerPreviewCoordinatorFactory
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    deps |  | offset=16
    attentionTracker |  | offset=216
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PageBoundPlayerImpl.PageBoundMultiPlayerSessionImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (11)
    multiPlayer |  | offset=16
    reportingContext |  | offset=32
    loggerProvider |  | offset=48
    $__lazy_storage_$_surfaceFactory |  | offset=64
    activeSession |  | offset=80
    mutableIsValid |  | offset=96
    mutableMuteState |  | offset=104
    isValidDisposable |  | offset=112
    muteStateDisposable |  | offset=128
    sessionCreationGateDisposable |  | offset=144
    isSessionCreationAllowed |  | offset=160
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.InternalPlayerFactoryImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (10)
    reportingContextProvider |  | offset=16
    videoPlayerFactory |  | offset=32
    videoSurfaceManager |  | offset=40
    playbackRequestFactory |  | offset=48
    audioSessionActivationHandler |  | offset=56
    useNewMetadataProvider |  | offset=72
    useStreamReportingModule |  | offset=73
    streamReportingContextFactory |  | offset=80
    unmutedHandleProvider |  | offset=96
    externalPlaybackObserverFactories |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtCC22MultiPlayer_PlayerImpl15MultiPlayerImplP33_5DC40F581CEA7B174923B1A63F77223E14CurrentContext
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    session |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.MultiPlayerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (11)
    sharedMuteController |  | offset=16
    sharedMuteControllerWithoutContextPlayerResumeOnMuteProvider |  | offset=32
    sharedMuteState |  | offset=48
    playerPool |  | offset=88
    internalPlayerFactory |  | offset=96
    surfaceManagerFactory |  | offset=104
    delegatingSurfaceManager |  | offset=112
    sharedSurfaceManager |  | offset=120
    currentContext |  | offset=128
    $__lazy_storage_$_endedSession |  | offset=136
    lifecycleHasEnded |  | offset=144
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.AudioSessionActivationHandlerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    activator |  | offset=16
    name |  | offset=24
    audioSessionController |  | offset=40
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_UserSelectedMuteStateImpl.UserSelectedMuteControllerImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    _muteState |  | offset=16
    playbackStateLoop |  | offset=24
    isDisposed |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS _TtC37MultiPlayer_UserSelectedMuteStateImplP33_E63A39A39AE7261FCBB5F5845603874220ConnectStateObserver
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    consumer |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTConnectAggregatorStateObserver
      required instance aggregator:didUpdateAggregatorState: | v32@0:8@16@24
  INSTANCE METHODS (1)
    aggregator:didUpdateAggregatorState: | types=v32@0:8@16@24 | IMP=Spotify+0x101534c
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_UserSelectedMuteStateImpl.ConnectEventSource
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    connectAggregator |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_UserSelectedMuteStateImpl.ContextPlayerEventSource
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    playerStateObservable |  | offset=16
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_UserSelectedMuteStateImpl.ContextPlayerPlaybackEffectHandler
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    playerFactory |  | offset=16
    $__lazy_storage_$_player |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingContextMenuLoggedInUINotifier
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    dependencies |  | offset=16
    $__lazy_storage_$_contextMenuRegistrar |  | offset=96
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.LoggedInUINotifier
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    dependencies |  | offset=16
    $__lazy_storage_$_loopController |  | offset=72
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_WatchFeedIntegrationImpl.WatchFeedRegistrantPlugin
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS NowPlaying_MixingTransitionImpl.SimpleMixingTransitionPublisher
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (14)
    $__lazy_storage_$_statePublisher |  | offset=16
    shouldAnimateStop |  | offset=24
    $__lazy_storage_$_animationStatePublisher |  | offset=32
    externalStateSubject |  | offset=40
    animationStateSubject |  | offset=48
    trackPositionTimer |  | offset=56
    cancellables |  | offset=72
    phase |  | offset=80
    isNPVVisible |  | offset=137
    isPlayingRemotely |  | offset=138
    latestPlayerState |  | offset=144
    lastKnownStatePosition |  | offset=152
    lastKnownTrackURI |  | offset=160
    isTimerActive |  | offset=176
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_TransitionCurationImpl.TransitionCuratorImpl
SUPER _TtCs12_SwiftObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (4)
    metadataClient |  | offset=16
    playlistModel |  | offset=32
    listEndpoint |  | offset=48
    listOperation |  | offset=88
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS SwiftEsperanto_automix_esperanto_swift_proto_client.Spotify_Automix_Esperanto_Proto_AutomixClient
SUPER SDK_Esperanto_SwiftKit.ClientBase
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (0)
  CLASS METHODS (0)

============================================================
CLASS BMSampleBufferAudioTap
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    _isConfigured | B | offset=8
    _delegate | @"<BMAudioTapDelegate>" | offset=16
    _appStateObservable | @"<BMVideoApplicationStateObservable>" | offset=24
    _processingQueue | @"NSObject<OS_dispatch_queue>" | offset=32
    _lock | @"NSLock" | offset=40
    _output | ^{BMAudioProcessingOutput=^f^f^f^fQ[3^{BMFrequencyBin}]{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}} | offset=48
    _audioFFTer | ^{BMAudioFFTer={BMElementCount=QQ}^f^f^f^f} | offset=56
    _configuredSampleRate | d | offset=64
    _average | {BMAudioProcessingOutputAverage="lowFrequencyAverage"{BMFloatAverage="count"i"depth"i"history"^f"pointer"i}"mediumFrequencyAverage"{BMFloatAverage="count"i"depth"i"history"^f"pointer"i}"highFrequencyAverage"{BMFloatAverage="count"i"depth"i"history"^f"pointer"i}} | offset=72
  PROPERTIES (9)
    appStateObservable | T@"<BMVideoApplicationStateObservable>",&,N,V_appStateObservable
    processingQueue | T@"NSObject<OS_dispatch_queue>",&,N,V_processingQueue
    lock | T@"NSLock",&,N,V_lock
    output | T^{BMAudioProcessingOutput=^f^f^f^fQ[3^{BMFrequencyBin}]{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}},N,V_output
    audioFFTer | T^{BMAudioFFTer={BMElementCount=QQ}^f^f^f^f},N,V_audioFFTer
    average | T{BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}},N,V_average
    isConfigured | TB,N,V_isConfigured
    configuredSampleRate | Td,N,V_configuredSampleRate
    delegate | T@"<BMAudioTapDelegate>",W,N,V_delegate
  PROTOCOLS (0)
  INSTANCE METHODS (25)
    initWithAppStateObservable:delegate: | types=@32@0:8@16@24 | IMP=Spotify+0x5f459ec
    dealloc | types=v16@0:8 | IMP=Spotify+0x8402a88
    processAudioBufferList:sampleRate: | types=v32@0:8r^{AudioBufferList=I[1{AudioBuffer=II^v}]}16d24 | IMP=Spotify+0x33ccdf0
    stopProcessing | types=v16@0:8 | IMP=Spotify+0x30d830c
    configureWithSampleRate: | types=v24@0:8d16 | IMP=Spotify+0x4daa0ec
    emit | types=v16@0:8 | IMP=Spotify+0x7039510
    delegate | types=@16@0:8 | IMP=Spotify+0x73b6184
    setDelegate: | types=v24@0:8@16 | IMP=Spotify+0x340df4c
    appStateObservable | types=@16@0:8 | IMP=Spotify+0x2b05c58
    setAppStateObservable: | types=v24@0:8@16 | IMP=Spotify+0x4cab5a0
    processingQueue | types=@16@0:8 | IMP=Spotify+0x5606fd0
    setProcessingQueue: | types=v24@0:8@16 | IMP=Spotify+0x727a800
    lock | types=@16@0:8 | IMP=Spotify+0x30d338
    setLock: | types=v24@0:8@16 | IMP=Spotify+0x1492de8
    output | types=^{BMAudioProcessingOutput=^f^f^f^fQ[3^{BMFrequencyBin}]{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}}16@0:8 | IMP=Spotify+0x5efe388
    setOutput: | types=v24@0:8^{BMAudioProcessingOutput=^f^f^f^fQ[3^{BMFrequencyBin}]{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}{BMFrequencyBin={BMRange=ii}i}}16 | IMP=Spotify+0x2594ca8
    audioFFTer | types=^{BMAudioFFTer={BMElementCount=QQ}^f^f^f^f}16@0:8 | IMP=Spotify+0x376019c
    setAudioFFTer: | types=v24@0:8^{BMAudioFFTer={BMElementCount=QQ}^f^f^f^f}16 | IMP=Spotify+0x38776e0
    average | types={BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}}16@0:8 | IMP=Spotify+0x7861e84
    setAverage: | types=v88@0:8{BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}}16 | IMP=Spotify+0x1b86ac4
    isConfigured | types=B16@0:8 | IMP=Spotify+0x5981560
    setIsConfigured: | types=v20@0:8B16 | IMP=Spotify+0x74b5cb8
    configuredSampleRate | types=d16@0:8 | IMP=Spotify+0x447b4c
    setConfiguredSampleRate: | types=v24@0:8d16 | IMP=Spotify+0x1672458
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x4ec3a94
  CLASS METHODS (0)

============================================================
CLASS BMAudioTapFactory
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    _delegate | @"<BMAudioTapDelegate>" | offset=8
    _appStateObservable | @"<BMVideoApplicationStateObservable>" | offset=16
  PROPERTIES (2)
    appStateObservable | T@"<BMVideoApplicationStateObservable>",&,N,V_appStateObservable
    delegate | T@"<BMAudioTapDelegate>",W,N,V_delegate
  PROTOCOLS (0)
  INSTANCE METHODS (7)
    initWithAudioTapDelegate:appStateObservable: | types=@32@0:8@16@24 | IMP=Spotify+0x16fbee8
    createAudioTapWithPlayerItem:completion: | types=v32@0:8@16@?24 | IMP=Spotify+0x7208d90
    delegate | types=@16@0:8 | IMP=Spotify+0x4a2b648
    setDelegate: | types=v24@0:8@16 | IMP=Spotify+0x537f74c
    appStateObservable | types=@16@0:8 | IMP=Spotify+0x9165e8
    setAppStateObservable: | types=v24@0:8@16 | IMP=Spotify+0x3f86ddc
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x64d650c
  CLASS METHODS (0)

============================================================
CLASS BMAudioTap
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    _delegate | @"<BMAudioTapDelegate>" | offset=8
    _playerItem | @"AVPlayerItem" | offset=16
    _audioTap | ^{opaqueMTAudioProcessingTap=} | offset=24
    _storage | ^{BMAudioTapStorage=@{BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}}^{BMAudioProcessingOutput}^{BMAudioFFTer}@} | offset=32
    _appStateObservable | @"<BMVideoApplicationStateObservable>" | offset=40
  PROPERTIES (5)
    audioTap | T^{opaqueMTAudioProcessingTap=},N,V_audioTap
    storage | T^{BMAudioTapStorage=@{BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}}^{BMAudioProcessingOutput}^{BMAudioFFTer}@},N,V_storage
    appStateObservable | T@"<BMVideoApplicationStateObservable>",&,N,V_appStateObservable
    delegate | T@"<BMAudioTapDelegate>",W,N,V_delegate
    playerItem | T@"AVPlayerItem",R,W,N,V_playerItem
  PROTOCOLS (0)
  INSTANCE METHODS (15)
    initWithPlayerItem:appStateObservable:delegate: | types=@40@0:8@16@24@32 | IMP=Spotify+0x75f73d4
    dealloc | types=v16@0:8 | IMP=Spotify+0xef8e74
    stopProcessing | types=v16@0:8 | IMP=Spotify+0x6d1e0a8
    emit | types=v16@0:8 | IMP=Spotify+0x33a668
    isEnabled | types=B16@0:8 | IMP=Spotify+0x51468ac
    delegate | types=@16@0:8 | IMP=Spotify+0x43121a0
    setDelegate: | types=v24@0:8@16 | IMP=Spotify+0x3017b48
    playerItem | types=@16@0:8 | IMP=Spotify+0x640cc64
    audioTap | types=^{opaqueMTAudioProcessingTap=}16@0:8 | IMP=Spotify+0x7488db8
    setAudioTap: | types=v24@0:8^{opaqueMTAudioProcessingTap=}16 | IMP=Spotify+0x57dfc4
    storage | types=^{BMAudioTapStorage=@{BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}}^{BMAudioProcessingOutput}^{BMAudioFFTer}@}16@0:8 | IMP=Spotify+0x598386c
    setStorage: | types=v24@0:8^{BMAudioTapStorage=@{BMAudioProcessingOutputAverage={BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}{BMFloatAverage=ii^fi}}^{BMAudioProcessingOutput}^{BMAudioFFTer}@}16 | IMP=Spotify+0xc6718c
    appStateObservable | types=@16@0:8 | IMP=Spotify+0x15135d4
    setAppStateObservable: | types=v24@0:8@16 | IMP=Spotify+0x80cbab8
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x63d7b48
  CLASS METHODS (0)

============================================================
CLASS WatchFeed_WatchFeedFeatureImpl.WatchFeedAudioTapDelegate
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    didEmitOutput |  | offset=8
  PROPERTIES (0)
  PROTOCOLS (1)
    BMAudioTapDelegate
      required instance audioTapDidEmitOutput: | v80@0:8{BMAudioTapOutput=^f^fQ^fQ^fQQ}16
  INSTANCE METHODS (3)
    audioTapDidEmitOutput: | types=v80@0:8{BMAudioTapOutput=^f^fQ^fQ^fQQ}16 | IMP=Spotify+0x7483e04
    init | types=@16@0:8 | IMP=Spotify+0x723fc44
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x85deb38
  CLASS METHODS (0)

============================================================
CLASS _TtC25PlaylistMixing_ElementKitP33_14F2949AEC64E71495E245996B8808839ElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    view |  | offset=8
    overlayView |  | offset=16
    progressDotsView |  | offset=24
    showOverlayWorkItem |  | offset=32
    overlayBecameVisibleTime |  | offset=40
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x5d34fb0
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x5edbfe8
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ElementKit.MixingReorderButtonElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    view |  | offset=8
    eventHandler |  | offset=16
    $__lazy_storage_$_button |  | offset=32
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x22b4440
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x165aa40
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ReorderingImpl.SPTPlaylistMixing_ReorderingImplProperties
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    playlistReorderingSaveVerificationTimeoutMs |  | offset=8
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTRemoteConfigurationProperties
      required instance initWithConfigurationProvider: | @24@0:8@16
      optional instance propertyModels | @16@0:8
  INSTANCE METHODS (2)
    initWithConfigurationProvider: | types=@24@0:8@16 | IMP=Spotify+0x3e2e864
    init | types=@16@0:8 | IMP=Spotify+0x73b511c
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_WaveformKit.ScrollOffsetController
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (17)
    scrollOffset |  | offset=8
    isDragging |  | offset=16
    isDecelerating |  | offset=17
    onDragBegan |  | offset=24
    onScrollOffsetChanged |  | offset=40
    onScrollSettled |  | offset=56
    onScrollOffsetDidSet |  | offset=72
    contentWidth |  | offset=88
    insetLeft |  | offset=96
    insetRight |  | offset=104
    dragInitialOffset |  | offset=112
    decelerationVelocity |  | offset=120
    lastDecelerationTimestamp |  | offset=128
    decelerationLink |  | offset=136
    $__lazy_storage_$_panGesture |  | offset=144
    $__lazy_storage_$_stopTouchGesture |  | offset=152
    hostView |  | offset=160
  PROPERTIES (0)
  PROTOCOLS (1)
    UIGestureRecognizerDelegate
      optional instance gestureRecognizer:shouldReceiveEvent: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldReceiveTouch: | B32@0:8@16@24
      optional instance gestureRecognizerShouldBegin: | B24@0:8@16
      optional instance gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldRequireFailureOfGestureRecognizer: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldReceivePress: | B32@0:8@16@24
  INSTANCE METHODS (7)
    dealloc | types=v16@0:8 | IMP=Spotify+0x2962af0
    init | types=@16@0:8 | IMP=Spotify+0x1970d28
    handlePan: | types=v24@0:8@16 | IMP=Spotify+0x3627780
    handleStopTouch: | types=v24@0:8@16 | IMP=Spotify+0x4508b0c
    decelerationTick | types=v16@0:8 | IMP=Spotify+0x717c9dc
    gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer: | types=B32@0:8@16@24 | IMP=Spotify+0x5494020
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x41ee90
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_WaveformKit.MixingTrackWaveformElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (34)
    view |  | offset=8
    isDebugPositionEnabled |  | offset=16
    renderConfig |  | offset=17
    eventHandler |  | offset=24
    latestState |  | offset=40
    uiStateLock |  | offset=416
    _uiState |  | offset=424
    $__lazy_storage_$_waveformView |  | offset=472
    contentInsetLayoutGuide |  | offset=480
    $__lazy_storage_$_debugPositionLabel |  | offset=488
    emptyWaveformLabel |  | offset=496
    $__lazy_storage_$_contentLeadingConstraint |  | offset=504
    $__lazy_storage_$_contentTrailingConstraint |  | offset=512
    previousIsAnimating |  | offset=520
    hasRegisteredTransientSetter |  | offset=521
    hasRegisteredPlaybackSetter |  | offset=522
    hasRegisteredInteractionSetter |  | offset=523
    hasRegisteredBarSnapper |  | offset=524
    isTransientDrivingScroll |  | offset=525
    hapticPlayer |  | offset=528
    isSuppressingScrollEvents |  | offset=536
    scrollController |  | offset=544
    contentWidth |  | offset=552
    barChangeAnimation |  | offset=560
    barChangeState |  | offset=568
    renderedScaleFactor |  | offset=712
    renderedGeometryHandler |  | offset=720
    $__lazy_storage_$_waveformDiffuser |  | offset=736
    $__lazy_storage_$_beatsDiffuser |  | offset=752
    $__lazy_storage_$_layoutDiffuser |  | offset=768
    $__lazy_storage_$_panEnabledDiffuser |  | offset=784
    $__lazy_storage_$_emptyWaveformLabelsDiffuser |  | offset=800
    $__lazy_storage_$_convertPointDiffuser |  | offset=816
    offsetAnimation |  | offset=832
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x4f59158
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x819d3ac
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_WaveformKit.EasedDisplayLinkAnimation
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (5)
    displayLink |  | offset=8
    startTime |  | offset=16
    duration |  | offset=24
    onTick |  | offset=32
    onComplete |  | offset=48
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (4)
    dealloc | types=v16@0:8 | IMP=Spotify+0x6b5881c
    tick | types=v16@0:8 | IMP=Spotify+0x40940f8
    init | types=@16@0:8 | IMP=Spotify+0x419faa4
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x1debdd4
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingToastViewErrorLogger
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    ubiLogger |  | offset=8
    event |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (1)
    NSObject
      required instance retainCount | Q16@0:8
      required instance hash | Q16@0:8
      required instance autorelease | @16@0:8
      required instance superclass | #16@0:8
      required instance isEqual: | B24@0:8@16
      required instance isProxy | B16@0:8
      required instance isKindOfClass: | B24@0:8#16
      required instance class | #16@0:8
      required instance respondsToSelector: | B24@0:8:16
      required instance zone | ^{_NSZone=}16@0:8
      required instance conformsToProtocol: | B24@0:8@16
      required instance isMemberOfClass: | B24@0:8#16
      required instance retain | @16@0:8
      required instance release | Vv16@0:8
      required instance description | @16@0:8
      required instance performSelector: | @24@0:8:16
      required instance performSelector:withObject: | @32@0:8:16@24
      required instance performSelector:withObject:withObject: | @40@0:8:16@24@32
      required instance self | @16@0:8
      optional instance debugDescription | @16@0:8
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x7d3d214
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x2661ee8
  CLASS METHODS (0)

============================================================
CLASS _TtC27PlaylistMixing_MixingUIImplP33_0073E89B0092C8D3C59362C27FF0AE0D21MixingEditPopAnimator
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    animator |  | offset=8
  PROPERTIES (0)
  PROTOCOLS (1)
    UIViewControllerAnimatedTransitioning
      required instance animateTransition: | v24@0:8@16
      required instance transitionDuration: | d24@0:8@16
      optional instance animationEnded: | v20@0:8B16
      optional instance interruptibleAnimatorForTransition: | @24@0:8@16
  INSTANCE METHODS (6)
    transitionDuration: | types=d24@0:8@16 | IMP=Spotify+0x57d3d84
    interruptibleAnimatorForTransition: | types=@24@0:8@16 | IMP=Spotify+0x7f234ac
    animateTransition: | types=v24@0:8@16 | IMP=Spotify+0x571e17c
    animationEnded: | types=v20@0:8B16 | IMP=Spotify+0x241699c
    init | types=@16@0:8 | IMP=Spotify+0xf39f24
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x791f1bc
  CLASS METHODS (0)

============================================================
CLASS _TtC27PlaylistMixing_MixingUIImplP33_0073E89B0092C8D3C59362C27FF0AE0D22MixingEditPushAnimator
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    animator |  | offset=8
  PROPERTIES (0)
  PROTOCOLS (1)
    UIViewControllerAnimatedTransitioning
      required instance animateTransition: | v24@0:8@16
      required instance transitionDuration: | d24@0:8@16
      optional instance animationEnded: | v20@0:8B16
      optional instance interruptibleAnimatorForTransition: | @24@0:8@16
  INSTANCE METHODS (6)
    transitionDuration: | types=d24@0:8@16 | IMP=Spotify+0x47a9664
    interruptibleAnimatorForTransition: | types=@24@0:8@16 | IMP=Spotify+0x33ec6e8
    animateTransition: | types=v24@0:8@16 | IMP=Spotify+0x7a5d60c
    animationEnded: | types=v20@0:8B16 | IMP=Spotify+0x289d4c8
    init | types=@16@0:8 | IMP=Spotify+0x5ebaf68
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x2535314
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingEditNavigationTransition
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTNavigationControllerTransitioning
      optional instance navigationController:animationControllerForPushOperationFromViewController: | @32@0:8@16@24
      optional instance navigationController:animationControllerForPushOperationFromViewController: | @32@0:8@16@24
      optional instance navigationController:animationControllerForPopOperationToViewController: | @32@0:8@16@24
      optional instance navigationController:animationControllerForPopOperationToViewController: | @32@0:8@16@24
      optional instance navigationController:interactionControllerForAnimationController: | @32@0:8@16@24
  INSTANCE METHODS (3)
    navigationController:animationControllerForPushOperationFromViewController: | types=@32@0:8@16@24 | IMP=Spotify+0x5e07ab4
    navigationController:animationControllerForPopOperationToViewController: | types=@32@0:8@16@24 | IMP=Spotify+0x741420c
    init | types=@16@0:8 | IMP=Spotify+0x1b92274
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingOverlapEditorElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (47)
    gestureBeginGeometry |  | offset=8
    eventHandler |  | offset=32
    arrowNavigationConfig |  | offset=48
    waveformLogger |  | offset=56
    configuration |  | offset=72
    minimapCoordinator |  | offset=112
    latestState |  | offset=120
    zoomableContainer |  | offset=1024
    $__lazy_storage_$_transitionWindowWidthConstraint |  | offset=1032
    curveCustomizeState |  | offset=1040
    outConvertScrollViewPointToViewBlock |  | offset=1048
    inConvertScrollViewPointToViewBlock |  | offset=1064
    outWaveformTransientSetter |  | offset=1080
    inWaveformTransientSetter |  | offset=1096
    outBarSnapper |  | offset=1112
    inBarSnapper |  | offset=1128
    view |  | offset=1144
    outTrackWaveformElement |  | offset=1152
    outTrackWaveformView |  | offset=1264
    outStyleOverlayView |  | offset=1272
    outBlockOverlayView |  | offset=1280
    outStartTransitionPositionLabel |  | offset=1288
    outEndTransitionPositionLabel |  | offset=1296
    latestOutWaveformProps |  | offset=1304
    $__lazy_storage_$_outTrackEventHandler |  | offset=1568
    inTrackWaveformElement |  | offset=1584
    inTrackWaveformView |  | offset=1696
    inStyleOverlayView |  | offset=1704
    inStartTransitionPositionLabel |  | offset=1712
    inEndTransitionPositionLabel |  | offset=1720
    latestInWaveformProps |  | offset=1728
    $__lazy_storage_$_inTrackEventHandler |  | offset=1992
    $__lazy_storage_$_transitionWindowView |  | offset=2008
    $__lazy_storage_$_outgoingInactiveOverlay |  | offset=2016
    $__lazy_storage_$_incomingInactiveOverlay |  | offset=2024
    mutedSide |  | offset=2032
    transitionPlayer |  | offset=2040
    playerObservation |  | offset=2056
    $__lazy_storage_$_centerMarkerView |  | offset=2072
    playHeadElementView |  | offset=2080
    hapticPlayer |  | offset=2088
    $__lazy_storage_$_outJogControlView |  | offset=2096
    $__lazy_storage_$_inJogControlView |  | offset=2104
    $__lazy_storage_$_curveEditingDiffuser |  | offset=2112
    $__lazy_storage_$_jogButtonVisibilityDiffuser |  | offset=2128
    $__lazy_storage_$_transitionWindowDiffuser |  | offset=2144
    $__lazy_storage_$_playHeadDiffuser |  | offset=2160
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (5)
    outScrollViewTapped | types=v16@0:8 | IMP=Spotify+0x7411f6c
    inScrollViewTapped | types=v16@0:8 | IMP=Spotify+0x14361e0
    dealloc | types=v16@0:8 | IMP=Spotify+0x10e80f4
    init | types=@16@0:8 | IMP=Spotify+0x4b349b8
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x3921fc8
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingStyleCategoryPickerElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (9)
    eventHandler |  | offset=8
    items |  | offset=24
    trailingViews |  | offset=32
    rows |  | offset=40
    promoView |  | offset=48
    stackView |  | offset=56
    hasAppliedInitialOptInState |  | offset=64
    $__lazy_storage_$_optInDiffuser |  | offset=72
    $__lazy_storage_$_view |  | offset=88
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x491d5bc
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x39e4818
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingRootElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (65)
    view |  | offset=8
    $__lazy_storage_$_waveformContainer |  | offset=16
    $__lazy_storage_$_scrollView |  | offset=24
    scrollStartOffset |  | offset=32
    isScrollLockedToSnapPoint |  | offset=40
    isBarPickerVisible |  | offset=41
    latestState |  | offset=48
    waveformContainerHeightConstraint |  | offset=1472
    flexTopSpace |  | offset=1480
    flexBottomSpace |  | offset=1488
    trackRowsCombinedHeight |  | offset=1496
    hiddenContentHeight |  | offset=1504
    expandedSnapOffset |  | offset=1512
    collapsedPickerHeight |  | offset=1520
    stylePickerParallaxAmount |  | offset=1528
    waveformContentBaseOffset |  | offset=1536
    hasUpdatedCrossFadeOnce |  | offset=1544
    isDimmingDismissedByTap |  | offset=1545
    wasMinimapActive |  | offset=1546
    hasReportedElementDataFailure |  | offset=1547
    overlayTransitionCoordinator |  | offset=1552
    trackRowElement |  | offset=1560
    waveformEditorElement |  | offset=1736
    outMinimapElement |  | offset=2136
    inMinimapElement |  | offset=2256
    minimapCoordinator |  | offset=2376
    bottomSheetContainerElement |  | offset=2384
    bottomSheetPagerElement |  | offset=2528
    dataPool |  | offset=2672
    outTrackView |  | offset=2712
    inTrackView |  | offset=2720
    outMinimapView |  | offset=2728
    inMinimapView |  | offset=2736
    $__lazy_storage_$_outTrackContainer |  | offset=2744
    $__lazy_storage_$_inTrackContainer |  | offset=2752
    waveformEditorView |  | offset=2760
    playButtonElementView |  | offset=2768
    barPickerButtonView |  | offset=2776
    $__lazy_storage_$_barPickerAlphaAnimator |  | offset=2784
    $__lazy_storage_$_playButtonAlphaAnimator |  | offset=2792
    stylePickerElementView |  | offset=2800
    bottomSheetElementView |  | offset=2808
    pagerElementView |  | offset=2816
    disposables |  | offset=2824
    eventHandler |  | offset=2832
    overlayTransitionHandler |  | offset=2848
    configuration |  | offset=2856
    $__lazy_storage_$_waveformOverlayView |  | offset=2896
    $__lazy_storage_$_multiOptionAutoDismissGesture |  | offset=2904
    $__lazy_storage_$_scrollHintChevronOverlay |  | offset=2912
    $__lazy_storage_$_scrollHintTapGesture |  | offset=2920
    $__lazy_storage_$_stylePickerDimmingOverlay |  | offset=2928
    $__lazy_storage_$_loadingOverlay |  | offset=2936
    $__lazy_storage_$_inTrackRowDiffuser |  | offset=2944
    $__lazy_storage_$_outTrackRowDiffuser |  | offset=2960
    $__lazy_storage_$_playButtonElementDiffuser |  | offset=2976
    $__lazy_storage_$_outMinimapDiffuser |  | offset=2992
    $__lazy_storage_$_inMinimapDiffuser |  | offset=3008
    $__lazy_storage_$_stylePickerDiffuser |  | offset=3024
    $__lazy_storage_$_multiOptionAutoDropdownDiffuser |  | offset=3040
    $__lazy_storage_$_bottomSheetDiffuser |  | offset=3056
    $__lazy_storage_$_barPickerButtonDiffuser |  | offset=3072
    $__lazy_storage_$_barPickerFadeDiffuser |  | offset=3088
    $__lazy_storage_$_playButtonAlphaDiffuser |  | offset=3104
    $__lazy_storage_$_loadingOverlayDiffuser |  | offset=3120
  PROPERTIES (0)
  PROTOCOLS (2)
    UIGestureRecognizerDelegate
      optional instance gestureRecognizer:shouldReceiveEvent: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldReceiveTouch: | B32@0:8@16@24
      optional instance gestureRecognizerShouldBegin: | B24@0:8@16
      optional instance gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldRequireFailureOfGestureRecognizer: | B32@0:8@16@24
      optional instance gestureRecognizer:shouldReceivePress: | B32@0:8@16@24
    UIScrollViewDelegate
      optional instance scrollViewDidChangeAdjustedContentInset: | v24@0:8@16
      optional instance scrollViewDidEndDecelerating: | v24@0:8@16
      optional instance scrollViewWillBeginZooming:withView: | v32@0:8@16@24
      optional instance scrollViewDidEndScrollingAnimation: | v24@0:8@16
      optional instance scrollViewWillEndDragging:withVelocity:targetContentOffset: | v48@0:8@16{CGPoint=dd}24N^{CGPoint=dd}40
      optional instance scrollViewDidEndDragging:willDecelerate: | v28@0:8@16B24
      optional instance scrollViewDidZoom: | v24@0:8@16
      optional instance scrollViewDidEndZooming:withView:atScale: | v40@0:8@16@24d32
      optional instance scrollViewWillBeginDecelerating: | v24@0:8@16
      optional instance scrollViewShouldScrollToTop: | B24@0:8@16
      optional instance scrollViewDidScrollToTop: | v24@0:8@16
      optional instance scrollViewDidScroll: | v24@0:8@16
      optional instance viewForZoomingInScrollView: | @24@0:8@16
      optional instance scrollViewWillBeginDragging: | v24@0:8@16
  INSTANCE METHODS (12)
    gestureRecognizerShouldBegin: | types=B24@0:8@16 | IMP=Spotify+0x9194f10
    gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer: | types=B32@0:8@16@24 | IMP=Spotify+0x9194fcc
    scrollViewWillBeginDragging: | types=v24@0:8@16 | IMP=Spotify+0x5d3cc68
    scrollViewDidScroll: | types=v24@0:8@16 | IMP=Spotify+0x4ca050c
    scrollViewWillEndDragging:withVelocity:targetContentOffset: | types=v48@0:8@16{CGPoint=dd}24^{CGPoint=dd}40 | IMP=Spotify+0x137b67c
    scrollViewDidEndDecelerating: | types=v24@0:8@16 | IMP=Spotify+0x2dd8b2c
    scrollViewDidEndDragging:willDecelerate: | types=v28@0:8@16B24 | IMP=Spotify+0x2b6c124
    scrollHintChevronTapped: | types=v24@0:8@16 | IMP=Spotify+0x9194af8
    dismissMultiOptionAutoDropdown | types=v16@0:8 | IMP=Spotify+0x6e26a1c
    dealloc | types=v16@0:8 | IMP=Spotify+0x7a1b394
    init | types=@16@0:8 | IMP=Spotify+0x2b7a4e4
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x836061c
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingPresetEditorElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (8)
    eventHandler |  | offset=8
    availableStylesProvider |  | offset=24
    isMultiOptionAutoEnabled |  | offset=64
    $__lazy_storage_$_presetButtons |  | offset=72
    scrollView |  | offset=80
    currentSelectedIndex |  | offset=88
    $__lazy_storage_$_presetDiffuser |  | offset=96
    $__lazy_storage_$_view |  | offset=112
  PROPERTIES (0)
  PROTOCOLS (1)
    UIScrollViewDelegate
      optional instance scrollViewDidChangeAdjustedContentInset: | v24@0:8@16
      optional instance scrollViewDidEndDecelerating: | v24@0:8@16
      optional instance scrollViewWillBeginZooming:withView: | v32@0:8@16@24
      optional instance scrollViewDidEndScrollingAnimation: | v24@0:8@16
      optional instance scrollViewWillEndDragging:withVelocity:targetContentOffset: | v48@0:8@16{CGPoint=dd}24N^{CGPoint=dd}40
      optional instance scrollViewDidEndDragging:willDecelerate: | v28@0:8@16B24
      optional instance scrollViewDidZoom: | v24@0:8@16
      optional instance scrollViewDidEndZooming:withView:atScale: | v40@0:8@16@24d32
      optional instance scrollViewWillBeginDecelerating: | v24@0:8@16
      optional instance scrollViewShouldScrollToTop: | B24@0:8@16
      optional instance scrollViewDidScrollToTop: | v24@0:8@16
      optional instance scrollViewDidScroll: | v24@0:8@16
      optional instance viewForZoomingInScrollView: | @24@0:8@16
      optional instance scrollViewWillBeginDragging: | v24@0:8@16
  INSTANCE METHODS (3)
    scrollViewDidScroll: | types=v24@0:8@16 | IMP=Spotify+0x17df9ec
    init | types=@16@0:8 | IMP=Spotify+0x4031e8
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x2c20d8c
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingExpandablePresetAndStylePickerElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (13)
    eventHandler |  | offset=8
    presetEditorElement |  | offset=24
    styleCategoryPickerElement |  | offset=176
    view |  | offset=360
    $__lazy_storage_$_presetsHeader |  | offset=368
    $__lazy_storage_$_collapsedStackView |  | offset=376
    $__lazy_storage_$_presetEditorView |  | offset=384
    $__lazy_storage_$_expandedStylePicker |  | offset=392
    $__lazy_storage_$_beatmatchToggleRow |  | offset=400
    $__lazy_storage_$_expandedContentStack |  | offset=408
    $__lazy_storage_$_presetDiffuser |  | offset=416
    $__lazy_storage_$_stylePickerDiffuser |  | offset=432
    $__lazy_storage_$_beatmatchToggleDiffuser |  | offset=448
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x43da194
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x7d721f8
  CLASS METHODS (0)

============================================================
CLASS _TtCV27PlaylistMixing_MixingUIImpl18MixingPagerElement14PagerElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (12)
    eventHandler |  | offset=8
    view |  | offset=24
    $__lazy_storage_$_pageControl |  | offset=32
    $__lazy_storage_$_collectionView |  | offset=40
    renderer |  | offset=48
    bottomSheetElement |  | offset=56
    $__lazy_storage_$_scrollHandler |  | offset=200
    _containerItems |  | offset=216
    latestState |  | offset=232
    contentSizeObservation |  | offset=304
    $__lazy_storage_$_pageControlDiffuser |  | offset=312
    $__lazy_storage_$_pagerPresenterDiffuser |  | offset=328
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (3)
    pageControlValueChanged: | types=v24@0:8@16 | IMP=Spotify+0xc6b27c
    init | types=@16@0:8 | IMP=Spotify+0x3038390
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x5f9ac34
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MixingUIImpl.MixingBottomSheetStylePageElementUI
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (15)
    eventHandler |  | offset=8
    view |  | offset=24
    renderer |  | offset=32
    collectionView |  | offset=40
    $__lazy_storage_$_titleLabel |  | offset=48
    $__lazy_storage_$_colorIndicator |  | offset=56
    $__lazy_storage_$_headerView |  | offset=64
    separatorView |  | offset=72
    _optionItems |  | offset=80
    hasScrolledToInitialSelection |  | offset=89
    pendingScrollIndex |  | offset=96
    contentSizeObservation |  | offset=112
    $__lazy_storage_$_customizeButtonView |  | offset=120
    $__lazy_storage_$_headerDiffuser |  | offset=128
    $__lazy_storage_$_customizeButtonDiffuser |  | offset=144
  PROPERTIES (0)
  PROTOCOLS (0)
  INSTANCE METHODS (2)
    init | types=@16@0:8 | IMP=Spotify+0x6b1bc14
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0xd78608
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_MessagingImpl.SPTPlaylistMixing_MessagingImplProperties
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    gbbEnabled |  | offset=8
    portfolioEvaluationEnabled |  | offset=9
    needsMoreTracksSnackbarEnabled |  | offset=10
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTRemoteConfigurationProperties
      required instance initWithConfigurationProvider: | @24@0:8@16
      optional instance propertyModels | @16@0:8
  INSTANCE METHODS (2)
    initWithConfigurationProvider: | types=@24@0:8@16 | IMP=Spotify+0x57e1894
    init | types=@16@0:8 | IMP=Spotify+0x33b720c
  CLASS METHODS (0)

============================================================
CLASS _TtC32PlaylistMixing_ListUXPluginsImplP33_58C6B4B9285033A139F7E7C3B67FC06529NoOpShuffleToggleUpsellLogger
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (0)
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTShuffleToggleUpsellPresentationLogger
      required instance logHitShuffleButton | @16@0:8
  INSTANCE METHODS (2)
    logHitShuffleButton | types=@16@0:8 | IMP=Spotify+0x21cd900
    init | types=@16@0:8 | IMP=Spotify+0x3ca244
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_CreateMenuItemImpl.SPTPlaylistMixing_CreateMenuItemImplProperties
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    createNewMixedPlaylistEnabled |  | offset=8
    betaTagEnabled |  | offset=9
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTRemoteConfigurationProperties
      required instance initWithConfigurationProvider: | @24@0:8@16
      optional instance propertyModels | @16@0:8
  INSTANCE METHODS (2)
    initWithConfigurationProvider: | types=@24@0:8@16 | IMP=Spotify+0x5f88b38
    init | types=@16@0:8 | IMP=Spotify+0x2a1724
  CLASS METHODS (0)

============================================================
CLASS PlaylistMixing_ConfigurationImpl.MixingOptInProductHandlerImpl
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (3)
    configuration |  | offset=8
    productState |  | offset=48
    subject |  | offset=56
  PROPERTIES (0)
  PROTOCOLS (1)
    SPTProductStateObserver
      required instance productState:stateDidChange: | v32@0:8@16@24
  INSTANCE METHODS (4)
    productState:stateDidChange: | types=v32@0:8@16@24 | IMP=Spotify+0x75a8c44
    dealloc | types=v16@0:8 | IMP=Spotify+0x65d7c24
    init | types=@16@0:8 | IMP=Spotify+0x586dd28
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x25e72f0
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.UnsafeExtraMetadataProvider
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    metadataLock |  | offset=8
  PROPERTIES (0)
  PROTOCOLS (1)
    Betamax_SDKIntegrationAPI.SPTRawCoreStreamLoggerDataProvider
      required instance metadataForPlaybackIdentity: | @24@0:8@16
      required instance didFinishLoggingStream: | v24@0:8@16
  INSTANCE METHODS (4)
    metadataForPlaybackIdentity: | types=@24@0:8@16 | IMP=Spotify+0x53ca9cc
    didFinishLoggingStream: | types=v24@0:8@16 | IMP=Spotify+0x7a181c4
    init | types=@16@0:8 | IMP=Spotify+0x31a89fc
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x6d24b40
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.SafeExtraMetadataProvider
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (1)
    storageLock |  | offset=8
  PROPERTIES (0)
  PROTOCOLS (1)
    Betamax_SDKIntegrationAPI.SPTRawCoreStreamLoggerDataProvider
      required instance metadataForPlaybackIdentity: | @24@0:8@16
      required instance didFinishLoggingStream: | v24@0:8@16
  INSTANCE METHODS (4)
    metadataForPlaybackIdentity: | types=@24@0:8@16 | IMP=Spotify+0x41a63c0
    didFinishLoggingStream: | types=v24@0:8@16 | IMP=Spotify+0x7d2144c
    init | types=@16@0:8 | IMP=Spotify+0x81118dc
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x4dace00
  CLASS METHODS (0)

============================================================
CLASS MultiPlayer_PlayerImpl.MultiPlayerObserverBridge
SUPER NSObject
IMAGE /private/var/containers/Bundle/Application/C0E7F3D9-0A49-42FA-899C-F086D6CC508C/Spotify.app/Spotify
  IVARS (2)
    observer |  | offset=8
    sessionID |  | offset=24
  PROPERTIES (0)
  PROTOCOLS (1)
    BMPlaybackEventObserver
      required instance didCreatePlaybackWithAttributes:timestamp: | v32@0:8@16d24
      required instance didLoadManifest:timestamp: | v32@0:8@16d24
      required instance didEndPlaybackWithReason:atPosition:timestamp: | v40@0:8q16d24d32
      required instance didFailWithPlaybackError:atPosition:timestamp: | v40@0:8@16d24d32
      required instance didFailPlaybackWithRecoverableError:atPosition:timestamp: | v40@0:8@16d24d32
      required instance didPauseAtPosition:timestamp: | v32@0:8d16d24
      required instance didResumeAtPosition:timestamp: | v32@0:8d16d24
      required instance willSeekToPosition:fromPosition:isUserInitiated:timestamp: | v44@0:8d16d24B32d36
      required instance didSeekToPosition:fromPosition:isUserInitiated:timestamp: | v44@0:8d16d24B32d36
      required instance didBecomeReadyAtPosition:timestamp: | v32@0:8d16d24
      required instance didTransferBytes:forBitrate:withElapsedTime:timestamp: | v48@0:8q16d24d32d40
      required instance didStartBufferingAtPosition:timestamp: | v32@0:8d16d24
      required instance didChangeDuration:timestamp: | v32@0:8d16d24
      required instance didChangePlaybackSpeed:atPosition:timestamp: | v36@0:8f16d20d28
      required instance willChangeVideoProfile:atPosition:timestamp: | v40@0:8@16d24d32
      required instance willChangeAudioProfile:atPosition:timestamp: | v40@0:8@16d24d32
      required instance didChangeSubtitle:atPosition:timestamp: | v40@0:8@16d24d32
      required instance didChangeSurface:atPosition:timestamp: | v40@0:8@16d24d32
      required instance didChangeSurfaceVisibility:atPosition:timestamp: | v40@0:8q16d24d32
      required instance didChangeVideoDisabledState:atPosition:timestamp: | v36@0:8B16d20d28
      required instance didChangeBackgroundState:atPosition:timestamp: | v36@0:8B16d20d28
      required instance didChangePictureInPictureActiveState:atPosition:timestamp: | v36@0:8B16d20d28
      required instance didChangeExternalPlaybackState:atPosition:timestamp: | v36@0:8B16d20d28
      required instance didToggleAudio:atPosition:timestamp: | v36@0:8B16d20d28
      required instance didStartRenderingAtPosition:timestamp: | v32@0:8d16d24
      required instance didChangeMediaMetadataWithMediaType:streamingType:atPosition:timestamp: | v48@0:8q16q24d32d40
      required instance didSkipInPictureInPictureToPosition:fromPosition:timestamp: | v40@0:8d16d24d32
      required instance didForceRebufferToPosition:timestamp: | v32@0:8d16d24
      required instance willEndPlaybackWithNextIdentity:timestamp: | v32@0:8@16d24
      optional instance dispatchQueue | @16@0:8
  INSTANCE METHODS (31)
    didStartRenderingAtPosition:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0x3ac43cc
    didCreatePlaybackWithAttributes:timestamp: | types=v32@0:8@16d24 | IMP=Spotify+0x162d5a8
    didLoadManifest:timestamp: | types=v32@0:8@16d24 | IMP=Spotify+0x4328ca8
    didEndPlaybackWithReason:atPosition:timestamp: | types=v40@0:8q16d24d32 | IMP=Spotify+0x739788
    didFailWithPlaybackError:atPosition:timestamp: | types=v40@0:8@16d24d32 | IMP=Spotify+0x5ff024c
    didFailPlaybackWithRecoverableError:atPosition:timestamp: | types=v40@0:8@16d24d32 | IMP=Spotify+0x364ef5c
    didPauseAtPosition:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0x5a07350
    didResumeAtPosition:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0x6eabf70
    willSeekToPosition:fromPosition:isUserInitiated:timestamp: | types=v44@0:8d16d24B32d36 | IMP=Spotify+0x79dd304
    didSeekToPosition:fromPosition:isUserInitiated:timestamp: | types=v44@0:8d16d24B32d36 | IMP=Spotify+0x17f17fc
    didBecomeReadyAtPosition:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0x685c408
    didTransferBytes:forBitrate:withElapsedTime:timestamp: | types=v48@0:8q16d24d32d40 | IMP=Spotify+0x7fc6384
    didStartBufferingAtPosition:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0x6085ae0
    didChangeDuration:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0xbb4d00
    didChangePlaybackSpeed:atPosition:timestamp: | types=v36@0:8f16d20d28 | IMP=Spotify+0xa64f5c
    willChangeVideoProfile:atPosition:timestamp: | types=v40@0:8@16d24d32 | IMP=Spotify+0x678b144
    willChangeAudioProfile:atPosition:timestamp: | types=v40@0:8@16d24d32 | IMP=Spotify+0x69bfdec
    didChangeSubtitle:atPosition:timestamp: | types=v40@0:8@16d24d32 | IMP=Spotify+0x3760158
    didChangeSurface:atPosition:timestamp: | types=v40@0:8@16d24d32 | IMP=Spotify+0x70fa108
    didChangeSurfaceVisibility:atPosition:timestamp: | types=v40@0:8q16d24d32 | IMP=Spotify+0x50f354
    didChangeVideoDisabledState:atPosition:timestamp: | types=v36@0:8B16d20d28 | IMP=Spotify+0x23c8f90
    didChangeBackgroundState:atPosition:timestamp: | types=v36@0:8B16d20d28 | IMP=Spotify+0x6cd6988
    didChangePictureInPictureActiveState:atPosition:timestamp: | types=v36@0:8B16d20d28 | IMP=Spotify+0x1be09b8
    didChangeExternalPlaybackState:atPosition:timestamp: | types=v36@0:8B16d20d28 | IMP=Spotify+0x660b310
    didToggleAudio:atPosition:timestamp: | types=v36@0:8B16d20d28 | IMP=Spotify+0x242d060
    didChangeMediaMetadataWithMediaType:streamingType:atPosition:timestamp: | types=v48@0:8q16q24d32d40 | IMP=Spotify+0x77ff320
    didSkipInPictureInPictureToPosition:fromPosition:timestamp: | types=v40@0:8d16d24d32 | IMP=Spotify+0x60e412c
    didForceRebufferToPosition:timestamp: | types=v32@0:8d16d24 | IMP=Spotify+0x80fb870
    willEndPlaybackWithNextIdentity:timestamp: | types=v32@0:8@16d24 | IMP=Spotify+0x77d0e28
    init | types=@16@0:8 | IMP=Spotify+0x7823a3c
    .cxx_destruct | types=v16@0:8 | IMP=Spotify+0x660d72c
  CLASS METHODS (0)


SUMMARY
Spotify images: 8
Runtime classes registered: 121395
Focused classes detailed: 220
Methods enumerated: 188
Report characters before save footer: 150107
