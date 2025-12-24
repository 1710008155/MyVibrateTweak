TARGET := iphone:clang:latest:7.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GodMode

GodMode_FILES = Tweak.xm
GodMode_FRAMEWORKS = UIKit WebKit AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk
