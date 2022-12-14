#############################################################
#
# libglib2
#
#############################################################
LIBGLIB2A_VERSION_MAJOR = 2.30
LIBGLIB2A_VERSION_MINOR = 3
LIBGLIB2A_VERSION = $(LIBGLIB2A_VERSION_MAJOR).$(LIBGLIB2A_VERSION_MINOR)
LIBGLIB2A_SOURCE = glib-$(LIBGLIB2A_VERSION).tar.xz
LIBGLIB2A_SITE = http://ftp.gnome.org/pub/gnome/sources/glib/$(LIBGLIB2A_VERSION_MAJOR)

LIBGLIB2A_INSTALL_STAGING = YES
LIBGLIB2A_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

LIBGLIB2A_CONF_ENV = \
		ac_cv_func_posix_getpwuid_r=yes glib_cv_stack_grows=no \
		glib_cv_uscore=no ac_cv_func_strtod=yes \
		ac_fsusage_space=yes fu_cv_sys_stat_statfs2_bsize=yes \
		ac_cv_func_closedir_void=no ac_cv_func_getloadavg=no \
		ac_cv_lib_util_getloadavg=no ac_cv_lib_getloadavg_getloadavg=no \
		ac_cv_func_getgroups=yes ac_cv_func_getgroups_works=yes \
		ac_cv_func_chown_works=yes ac_cv_have_decl_euidaccess=no \
		ac_cv_func_euidaccess=no ac_cv_have_decl_strnlen=yes \
		ac_cv_func_strnlen_working=yes ac_cv_func_lstat_dereferences_slashed_symlink=yes \
		ac_cv_func_lstat_empty_string_bug=no ac_cv_func_stat_empty_string_bug=no \
		vb_cv_func_rename_trailing_slash_bug=no ac_cv_have_decl_nanosleep=yes \
		jm_cv_func_nanosleep_works=yes gl_cv_func_working_utimes=yes \
		ac_cv_func_utime_null=yes ac_cv_have_decl_strerror_r=yes \
		ac_cv_func_strerror_r_char_p=no jm_cv_func_svid_putenv=yes \
		ac_cv_func_getcwd_null=yes ac_cv_func_getdelim=yes \
		ac_cv_func_mkstemp=yes utils_cv_func_mkstemp_limitations=no \
		utils_cv_func_mkdir_trailing_slash_bug=no \
		jm_cv_func_gettimeofday_clobber=no \
		gl_cv_func_working_readdir=yes jm_ac_cv_func_link_follows_symlink=no \
		utils_cv_localtime_cache=no ac_cv_struct_st_mtim_nsec=no \
		gl_cv_func_tzset_clobber=no gl_cv_func_getcwd_null=yes \
		gl_cv_func_getcwd_path_max=yes ac_cv_func_fnmatch_gnu=yes \
		am_getline_needs_run_time_check=no am_cv_func_working_getline=yes \
		gl_cv_func_mkdir_trailing_slash_bug=no gl_cv_func_mkstemp_limitations=no \
		ac_cv_func_working_mktime=yes jm_cv_func_working_re_compile_pattern=yes \
		ac_use_included_regex=no gl_cv_c_restrict=no \
		ac_cv_path_GLIB_GENMARSHAL=$(HOST_DIR)/usr/bin/glib-genmarshal ac_cv_prog_F77=no \
		ac_cv_func_posix_getgrgid_r=no glib_cv_long_long_format=ll \
		ac_cv_func_printf_unix98=yes ac_cv_func_vsnprintf_c99=yes \
		gt_cv_c_wchar_t=$(if $(BR2_USE_WCHAR),yes,no)

# old uClibc versions don't provide qsort_r
ifeq ($(BR2_UCLIBC_VERSION_0_9_31)$(BR2_UCLIBC_VERSION_0_9_32)$(BR2_TOOLCHAIN_CTNG_uClibc)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)$(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEEL_V2)$(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEBE_V2),y)
LIBGLIB2A_CONF_ENV += glib_cv_have_qsort_r=no
else
LIBGLIB2A_CONF_ENV += glib_cv_have_qsort_r=yes
endif

# old toolchains don't have working inotify support
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEEL_V2)$(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEBE_V2),y)
LIBGLIB2A_CONF_ENV += ac_cv_header_sys_inotify_h=no
endif

HOST_LIBGLIB2A_CONF_OPTS = \
		--disable-gtk-doc \
		--enable-debug=no \
		--disable-dtrace \
		--disable-systemtap \
		--disable-gcov

LIBGLIB2A_DEPENDENCIES = host-pkgconf host-libglib2a libffi zlib $(if $(BR2_NEEDS_GETTEXT),gettext)

HOST_LIBGLIB2A_DEPENDENCIES = host-pkgconf host-libffi host-zlib

ifneq ($(BR2_ENABLE_LOCALE),y)
LIBGLIB2A_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBGLIB2A_CONF_OPTS += --with-libiconv=gnu
LIBGLIB2A_DEPENDENCIES += libiconv
endif

define LIBGLIB2A_REMOVE_DEV_FILES
	rm -rf $(TARGET_DIR)/usr/lib/glib-2.0
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gettext
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/glib-2.0
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,glib-genmarshal glib-gettextize glib-mkenums gobject-query gtester gtester-report)
endef

ifneq ($(BR2_HAVE_DEVFILES),y)
LIBGLIB2A_POST_INSTALL_TARGET_HOOKS += LIBGLIB2A_REMOVE_DEV_FILES
endif

define LIBGLIB2A_REMOVE_GDB_FILES
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gdb
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/glib-2.0
endef

ifneq ($(BR2_PACKAGE_GDB),y)
LIBGLIB2A_POST_INSTALL_TARGET_HOOKS += LIBGLIB2A_REMOVE_GDB_FILES
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

LIBGLIB2A_HOST_BINARY = $(HOST_DIR)/usr/bin/glib-genmarshal
