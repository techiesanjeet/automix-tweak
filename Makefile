TARGET := iphone:clang:latest:14.0
ARCHS = arm64

LIBRARY_NAME = AutoMixEngine

AutoMixEngine_FILES = AutoMixEngine.mm SmartMixCore/src/SmartMix.cpp SmartMixCore/src/SmartMixBridge.cpp
AutoMixEngine_CFLAGS = -fobjc-arc -I$(THEOS_PROJECT_DIR)/SmartMixCore/include
AutoMixEngine_CXXFLAGS = -std=c++17 -I$(THEOS_PROJECT_DIR)/SmartMixCore/include
AutoMixEngine_FRAMEWORKS = UIKit Foundation

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
