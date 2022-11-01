QTBASEPX_VERSION = 5.12.12
QTBASEPX_SITE = https://download.qt.io/archive/qt/5.12/$(QTBASEPX_VERSION)/submodules
QTBASEPX_SOURCE = qtbase-everywhere-src-$(QTBASEPX_VERSION).tar.xz
QTBASEPX_DEPENDENCIES = host-pkgconf eudev libglib2a zlib jpeg libpng tiff freetype dbus openssl sqlite alsa-lib 
QTBASEPX_INSTALL_STAGING = YES

define QTBASEPX_CONFIGURE_CMDS

	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) confclean
	(cd $(@D) && MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" ./configure \
		-prefix /usr \
		-hostprefix $(HOST_DIR)/usr \
		-release \
		-device pi3-g++ \
		-make libs \
		-make tools \
		-device-option CROSS_COMPILE=$(TARGET_CROSS) \
		-device-option DISTRO=bsquask \
		-sysroot $(STAGING_DIR) \
		-opensource \
		-confirm-license \
		-no-qpa-platform-guard \
		-no-openssl \
		-nomake examples \
		-nomake tests \
		-skip qtpim \
		-skip qtdocgallery \
		-skip qtgamepad \
		-skip qtserialbus \
		-skip qtserialport \
		-skip qtspeech \
		-skip qtwebengine \
		-no-feature-accessibility \
		-no-harfbuzz \
		-no-gui \
		-no-widgets \
		-no-eglfs \
		-no-opengl \
		-no-cups \
		-no-gif \
	)
endef

define QTBASEPX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTBASEPX_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTBASEPX_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins $(TARGET_DIR)/usr
endef

define QTBASEPX_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt*.so.*
endef

$(eval $(generic-package))
