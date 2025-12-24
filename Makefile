# 使用最新的 Clang，目标 iOS 版本设为 14.0 (支持触感反馈)
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GodMode

GodMode_FILES = Tweak.xm
# 确保链接这些框架
GodMode_FRAMEWORKS = UIKit WebKit AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk
