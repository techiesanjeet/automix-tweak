TARGET := iphone:clang:latest:14.0
ARCHS = arm64

LIBRARY_NAME = AutoMixProbe
AutoMixProbe_FILES = AutoMixProbe.mm
AutoMixProbe_FRAMEWORKS = UIKit Foundation
AutoMixProbe_CFLAGS = -fobjc-arc
AutoMixProbe_CXXFLAGS = -std=c++17

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
