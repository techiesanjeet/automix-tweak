TARGET := iphone:clang:latest:14.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = Spotify

LIBRARY_NAME = AutoMixDiagnostic
AutoMixDiagnostic_FILES = AutoMixDiagnostic.mm
AutoMixDiagnostic_FRAMEWORKS = UIKit Foundation
AutoMixDiagnostic_CFLAGS = -fobjc-arc
AutoMixDiagnostic_CCFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/library.mk
