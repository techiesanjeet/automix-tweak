TARGET := iphone:clang:latest:14.0
ARCHS = arm64

LIBRARY_NAME = AutoMixDiscovery
AutoMixDiscovery_FILES = AutoMixDiscovery.mm
AutoMixDiscovery_FRAMEWORKS = UIKit Foundation
AutoMixDiscovery_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
