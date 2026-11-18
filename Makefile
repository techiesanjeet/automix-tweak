TARGET := iphone:clang:latest:14.0
ARCHS = arm64

LIBRARY_NAME = AutoMixEngine

AutoMixEngine_FILES = AutoMixEngine.mm SmartMixCore/src/SmartMix.cpp SmartMixCore/src/SmartMixBridge.cpp SmartMixCore/src/PreparedPCM.cpp SmartMixCore/src/Resampler.cpp BeatThisCoreML.mm
AutoMixEngine_CFLAGS = -fobjc-arc -I$(THEOS_PROJECT_DIR)/SmartMixCore/include
AutoMixEngine_CCFLAGS = -std=c++17 -I$(THEOS_PROJECT_DIR)/SmartMixCore/include
AutoMixEngine_FRAMEWORKS = UIKit Foundation CoreML Accelerate

BUNDLE_NAME = SmartMixResources
SmartMixResources_INSTALL_PATH = /Library/Application\\ Support/AutoMix
SmartMixResources_RESOURCE_DIRS = Resources

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
include $(THEOS)/makefiles/bundle.mk
