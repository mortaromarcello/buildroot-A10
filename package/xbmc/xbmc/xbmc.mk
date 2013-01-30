################################################################################
#
## xbmc
#
#################################################################################

XBMC_VERSION = 130bd4ee55688a8ae49a04256308831363d2c58f
XBMC_SITE_METHOD = git
XBMC_SITE = https://github.com/mortaromarcello/xbmc.git
XBMC_INSTALL_STAGING = YES
XBMC_INSTALL_TARGET = YES

XBMC_DEPENDENCIES = host-lzo sdl_image

XBMC_CONF_OPT+= --enable-gles --disable-sdl --disable-x11 --disable-xrandr --disable-openmax \
  --disable-optical-drive --disable-dvdcss --disable-joystick --disable-debug \
	--disable-crystalhd --disable-vtbdecoder --disable-vaapi --disable-vdpau \
	--disable-pulse --disable-projectm --disable-optimizations --enable-cedar \
	--enable-neon --disable-libcec

XBMC_MAKE_OPT+= -j1

XBMC_DEPENDENCIES += libogg flac libmad libmpeg2 libogg \
  libsamplerate libtheora libvorbis wavpack bzip2 dbus libcdio \
  python lzo zlib libgcrypt openssl mysql_client sqlite fontconfig \
  freetype jasper jpeg libmodplug libpng libungif tiff libcurl \
  libmicrohttpd libssh2 boost fribidi ncurses pcre libnfs afpfs-ng \
	libplist libshairport libbluray readline expat libxml2 yajl libass \
	libusb-compat avahi udev tinyxml taglib18 libcec libssh

XBMC_CONF_ENV += PYTHON_VERSION="$(PYTHON_VERSION_MAJOR)"
XBMC_CONF_ENV += PYTHON_LDFLAGS="-L$(STAGING_DIR)/usr/lib/ -lpython$(PYTHON_VERSION_MAJOR) -lpthread -ldl -lutil -lm"
XBMC_CONF_ENV += PYTHON_CPPFLAGS="-I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)"
XBMC_CONF_ENV += PYTHON_SITE_PKG="$(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages"
XBMC_CONF_ENV += PYTHON_NOVERSIONCHECK="no-check"
XBMC_CONF_ENV += USE_TEXTUREPACKER_NATIVE_ROOT="$(HOST_DIR)/usr"
XBMC_CONF_ENV += INCLUDES="-I$(STAGING_DIR)/usr/include" LDFLAGS="$(TARGET_LDFLAGS)" CFLAGS="$(TARGET_CFLAGS) -Wno-psabi -Wa,-mno-warn-deprecated -Wno-deprecated-declarations" CXXFLAGS="$(TARGET_CXXFLAGS) -Wno-psabi -Wa,-mno-warn-deprecated -Wno-deprecated-declarations"

# For braindead apps like mysql that require running a binary/script
XBMC_CONF_ENV += PATH=$(STAGING_DIR)/usr/bin:$(TARGET_PATH)

define XBMC_BOOTSTRAP
  cd $(XBMC_DIR) && ./bootstrap
endef

define XBMC_INSTALL_ETC
	install -d -m 755 $(TARGET_DIR)/etc/init.d/
	install -m 755 package/xbmc/xbmc/S99xbmc $(TARGET_DIR)/etc/init.d
	install -m 644 package/xbmc/xbmc/advancedsettings.xml $(TARGET_DIR)/usr/share/xbmc/system/
endef

define XBMC_CLEAN_UNUSED_ADDONS
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/screensaver.rsxs.plasma
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.milkdrop
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.projectm
  rm -rf $(TARGET_DIR)/usr/share/xbmc/addons/visualization.itunes
endef

define XBMC_CLEAN_CONFLUENCE_SKIN
  find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.png -delete
  find $(TARGET_DIR)/usr/share/xbmc/addons/skin.confluence/media -name *.jpg -delete
endef

define XBMC_STRIP_BINARIES
  find $(TARGET_DIR)/usr/lib/xbmc/ -name "*.so" -exec $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) {} \;
  $(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/xbmc/xbmc.bin
endef

XBMC_PRE_CONFIGURE_HOOKS += XBMC_BOOTSTRAP
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_INSTALL_ETC
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_UNUSED_ADDONS
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_CLEAN_CONFLUENCE_SKIN
ifneq ($(BR2_ENABLE_DEBUG),y)
XBMC_POST_INSTALL_TARGET_HOOKS += XBMC_STRIP_BINARIES
endif

$(eval $(autotools-package))
