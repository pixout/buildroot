QTXMLPATTERNSPX_VERSION = 5.12.12
QTXMLPATTERNSPX_SITE = https://download.qt.io/archive/qt/5.12/$(QTXMLPATTERNSPX_VERSION)/submodules
QTXMLPATTERNSPX_SOURCE = qtxmlpatterns-everywhere-src-$(QTXMLPATTERNSPX_VERSION).tar.xz
QTXMLPATTERNSPX_DEPENDENCIES = qtbasepx
QTXMLPATTERNSPX_INSTALL_STAGING = YES

define QTXMLPATTERNSPX_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTXMLPATTERNSPX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTXMLPATTERNSPX_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTXMLPATTERNSPX_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5XmlPatterns*.so.* $(TARGET_DIR)/usr/lib
endef

define QTXMLPATTERNSPX_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5XmlPatterns*.so.*
endef

$(eval $(generic-package))
