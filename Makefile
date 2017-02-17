ARCHS = armv7 arm64
THEOS_DEVICE_IP = 127.0.0.1 -p 2222
GO_EASY_ON_ME=1
DEBUG=0
FINALPACKAGE=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = noClose
noClose_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
