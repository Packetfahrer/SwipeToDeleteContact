ARCHS = armv7 armv7s arm64

ADDITIONAL_OBJCFLAGS = -fno-objc-arc
ADDITIONAL_LDFLAGS += -Wl,-segalign,4000

TARGET = iphone:clang:latest:7
export SDKVERSION  = 7

THEOS_BUILD_DIR = Packages

#export THEOS_DEVICE_IP = ip4s
export THEOS_DEVICE_IP = ip6

export THEOS=/usr/local/theos
include $(THEOS)/makefiles/common.mk

AGGREGATE_NAME = SwipeToDeleteContactTweak
SUBPROJECTS = SwipeToDeleteContactiOS9 SwipeToDeleteContactiOS8

include $(THEOS_MAKE_PATH)/aggregate.mk


TWEAK_NAME = SwipeToDeleteContact

SwipeToDeleteContact_FILES = SwipeToDeleteContact.xm
SwipeToDeleteContact_FRAMEWORKS =  UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += swipetodeletecontact
include $(THEOS_MAKE_PATH)/aggregate.mk
