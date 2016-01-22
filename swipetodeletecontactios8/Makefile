ARCHS = armv7 arm64

TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

export THEOS=/usr/local/theos

ADDITIONAL_LDFLAGS += -Wl,-segalign,4000

export THEOS_DEVICE_IP = 192.168.178.52

THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwipeToDeleteContactiOS8
SwipeToDeleteContactiOS8_CFLAGS = -fno-objc-arc
SwipeToDeleteContactiOS8_FILES = SwipeToDeleteContactiOS8.xm
SwipeToDeleteContactiOS8_FRAMEWORKS =  UIKIT Foundation AddressBookUI AddressBook
SwipeToDeleteContactiOS8_PRIVATE_FRAMEWORKS = Preferences
SwipeToDeleteContactiOS8_INSTALL_PATH = /Library/Application Support/SwipeToDeleteContact



include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"
