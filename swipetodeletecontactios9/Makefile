#make package FINALPACKAGE=1


ARCHS = armv7 armv7s arm64
ADDITIONAL_OBJCFLAGS = -fno-objc-arc

TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

export THEOS=/usr/local/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwipeToDeleteContactiOS9
SwipeToDeleteContactiOS9_FILES = SwipeToDeleteContactiOS9.xm
SwipeToDeleteContactiOS9_FRAMEWORKS = UIKit ContactsUI Contacts
SwipeToDeleteContactiOS9_CFLAGS = -Wno-error
SwipeToDeleteContactiOS9_INSTALL_PATH = /Library/Application Support/SwipeToDeleteContact



include $(THEOS_MAKE_PATH)/tweak.mk


before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"

