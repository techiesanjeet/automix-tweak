TARGET := iphone:clang:latest:14.0
ARCHS = arm64

LIBRARY_NAME = AutoMixEngine

AutoMixEngine_FILES = AutoMixEngine.mm fishhook.c
AutoMixEngine_FRAMEWORKS = UIKit AudioToolbox Foundation CoreAudio
AutoMixEngine_CFLAGS = -fobjc-arc
AutoMixEngine_CXXFLAGS = -std=c++17

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
