LIBNIH_VERSION = 1.0.3-27
LIBNIH_SITE = https://github.com/pixout/libnih/archive/refs/tags
LIBNIH_SOURCE = $(LIBNIH_VERSION).tar.gz
HOST_LIBNIH_DEPENDENCIES = host-dbus host-expat
LIBNIH_DEPENDENCIES = dbus expat pkgconf host-libnih
LIBNIH_INSTALL_STAGING = YES

HOST_LIBNIH_AUTORECONF = YES

define HOST_LIBNIH_CONFIG_CMDS
	(cd $(@D) && rm -rf config.cache; \
	        $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
endef

LIBNIH_AUTORECONF = YES

LIBNIH_CONF_OPTS += NIH_DBUS_TOOL=$(HOST_DIR)/usr/bin/nih-dbus-tool

$(eval $(autotools-package))
$(eval $(host-autotools-package))
