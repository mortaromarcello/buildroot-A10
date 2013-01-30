#############################################################
#
# allwinner-mali
#
#############################################################
ALLWINNER_MALI_VERSION = 1.2.0.9310
ALLWINNER_MALI_SITE = http://malideveloper.arm.com/downloads
ALLWINNER_MALI_INSTALL_STAGING = YES
ALLWINNER_MALI_INSTALL_TARGET = YES

define ALLWINNER_MALI_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) VERSION=r3p0 ABI=armhf prefix=$(STAGING_DIR)/usr/ framebuffer
	$(MAKE) -C $(@D) prefix=$(STAGING_DIR)/usr/ headers
	install -m 666 $(@D)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0/simple-framework/inc/mali/EGL/fbdev_window.h \
		 $(STAGING_DIR)/usr/include/EGL/
	install -m 666 $(@D)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0/inc/EGL/eglplatform.h \
		 $(STAGING_DIR)/usr/include/EGL/
	install -m 666 $(@D)/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0/inc/EGL/eglext.h \
		 $(STAGING_DIR)/usr/include/EGL/
endef

define ALLWINNER_MALI_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) VERSION=r3p0 ABI=armhf prefix=$(TARGET_DIR)/usr/ framebuffer
endef

define ALLWINNER_MALI_BUILD_CMDS
	wget -c http://malideveloper.arm.com/downloads/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0.9310_Linux.tar.gz \
			-O $(BUILDROOT_DL_DIR)dl/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0.9310_Linux.tar.gz
	tar -xzvf $(BUILDROOT_DL_DIR)dl/Mali_OpenGL_ES_2.0_SDK_for_Linux_On_ARM_v1.2.0.9310_Linux.tar.gz -C $(@D)
endef

$(eval $(generic-package))
