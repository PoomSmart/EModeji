ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest
	ARCHS = x86_64 i386
else
	ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
		TARGET = iphone:clang:latest:15.0
	else
		export PREFIX = $(THEOS)/toolchain/Xcode11.xctoolchain/usr/bin/
		TARGET = iphone:clang:14.5:11.0
	endif
endif

INSTALL_TARGET_PROCESSES = Camera

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EModeji
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

all::
ifeq ($(SIMULATOR),1)
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
endif
