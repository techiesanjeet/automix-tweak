TARGET := iphone:clang:latest:14.0
ARCHS = arm64

LIBRARY_NAME = AutoMixEngine
# The compiled Beat This model is embedded in a dedicated Mach-O section so
# a single injected dylib is self-contained on non-jailbroken SideStore builds.
AutoMixEngine_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

AutoMixEngine_FILES = AutoMixEngine.mm AutoMixDiscoveryV6.mm SmartMixCore/src/SmartMix.cpp SmartMixCore/src/SmartMixBridge.cpp SmartMixCore/src/PreparedPCM.cpp SmartMixCore/src/Resampler.cpp SmartMixCore/src/AudioInputAdapter.cpp SmartMixCore/src/BeatThisSpectrogram.cpp SmartMixCore/src/BeatThisPostprocessor.cpp SmartMixCore/src/BeatThisChunking.cpp BeatThisCoreML.mm BetaSourceProcessorProbe.mm BetaRenderBoundaryProbe.mm BetaAudioTapProbe.mm BetaPlaybackTimingProbe.mm
AutoMixEngine_CFLAGS = -fobjc-arc -I$(THEOS_PROJECT_DIR)/SmartMixCore/include
AutoMixEngine_CCFLAGS = -std=c++17 -I$(THEOS_PROJECT_DIR)/SmartMixCore/include
AutoMixEngine_FRAMEWORKS = UIKit Foundation CoreML Accelerate AudioToolbox
AutoMixEngine_LDFLAGS += -Wl,-sectcreate,__DATA,__smrtmix,$(THEOS_PROJECT_DIR)/model-build/SmartMixResources.smar

BUNDLE_NAME = SmartMixResources
SmartMixResources_INSTALL_PATH = /Library/Application\ Support/AutoMix
SmartMixResources_RESOURCE_DIRS = Resources

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS)/makefiles/package.mk
