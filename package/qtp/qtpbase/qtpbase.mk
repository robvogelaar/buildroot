################################################################################
#
# qtpbase
#
################################################################################
#
## find output/target -name '*Qt*' | xargs rm -rf && find output/host -name '*Qt*' | xargs rm -rf
#
#
############

QTPBASE_VERSION_MAJOR = 5.4
QTPBASE_VERSION = 5.4.2

QTPBASE_SITE = http://download.qt-project.org/official_releases/qt/$(QTPBASE_VERSION_MAJOR)/$(QTPBASE_VERSION)/submodules/
QTPBASE_SOURCE = qtbase-opensource-src-$(QTPBASE_VERSION).tar.xz

QTPBASE_DEPENDENCIES = host-pkgconf zlib pcre libgles libegl dbus icu libpng jpeg sqlite

QTPBASE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
QTPBASE_EGLFS_PLATFORM_HOOKS_SOURCES = \
	$(@D)/mkspecs/devices/linux-mipsel-broadcom-97425-g++/qeglfshooks_bcm_dawn.cpp
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
QTPBASE_EGLFS_PLATFORM_HOOKS_SOURCES = \
	$(@D)/mkspecs/devices/linux-rasp-pi-g++/qeglfshooks_pi.cpp
endif

QTPBASE_CONFIGURE_OPTS += \
  -no-c++11 \
  -confirm-license \
  -dbus-linked \
  -device-option QT_QPA_DEFAULT_PLATFORM="eglfs" \
  -eglfs \
  -fontconfig \
  -gui \
  -icu \
  -largefile \
  -no-cups \
  -no-directfb \
  -no-glib \
  -no-gtkstyle \
  -no-iconv \
  -no-kms \
  -no-linuxfb \
  -no-nis \
  -no-pch \
  -no-reduce-relocations \
  -no-sql-mysql \
  -no-tslib \
  -no-xcb \
  -no-xcursor \
  -no-xfixes \
  -no-xinerama \
  -no-xinput \
  -no-xinput2 \
  -no-xrandr \
  -no-xrender \
  -no-xshape \
  -no-xsync \
  -no-xvideo \
  -nomake examples \
  -opengl es2 \
  -opensource \
  -openssl-linked \
  -optimized-qmake \
  -plugin-sql-sqlite \
  -shared \
  -system-libjpeg \
  -system-libpng \
  -system-pcre \
  -system-sqlite \
  -system-zlib \
  -widgets \
  -release

define QTPBASE_CONFIGURE_CMDS
	(cd $(@D); \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		PKG_CONFIG_LIBDIR="$(STAGING_DIR)/usr/lib/pkgconfig" \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" \
		./configure \
		-v \
		-prefix /usr \
		-hostprefix $(HOST_DIR)/usr \
		-headerdir /usr/include/qt5 \
		-sysroot $(STAGING_DIR) \
		-plugindir /usr/lib/qt/plugins \
		-examplesdir /usr/lib/qt/examples \
		-no-rpath \
		-nomake tests \
		-device buildroot \
		-device-option CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
		-device-option BR_COMPILER_CFLAGS="$(TARGET_CFLAGS)" \
		-device-option BR_COMPILER_CXXFLAGS="$(TARGET_CXXFLAGS)" \
		-device-option EGLFS_PLATFORM_HOOKS_SOURCES="$(QTPBASE_EGLFS_PLATFORM_HOOKS_SOURCES)" \
	   -device-option QMAKE_LIBS_EGL="" \
	   -device-option QMAKE_LIBS_OPENGL_ES2="" \
	   -device-option QMAKE_LIBS_OPENGL_ES1="" \
		$(QTPBASE_CONFIGURE_OPTS) \
	)
endef

define QTPBASE_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define QTPBASE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTPBASE_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Core.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5DBus.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Gui.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Network.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5OpenGL.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5PrintSupport.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Sql.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Widgets.so.* $(TARGET_DIR)/usr/lib ; \
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Xml.so.* $(TARGET_DIR)/usr/lib ;
endef

define QTPBASE_INSTALL_TARGET_PLUGINS
	if [ -d $(STAGING_DIR)/usr/lib/qt/plugins/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/qt/plugins ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/* $(TARGET_DIR)/usr/lib/qt/plugins ; \
	fi
endef

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
define QTPBASE_INSTALL_TARGET_FONTS
	mkdir -p $(TARGET_DIR)/usr/share/fonts
	cp -dpfr $(@D)/lib/fonts/* $(TARGET_DIR)/usr/share/fonts
endef
else
define QTPBASE_INSTALL_TARGET_FONTS
	if [ -d $(STAGING_DIR)/usr/lib/fonts/ ] ; then \
		mkdir -p $(TARGET_DIR)/usr/lib/fonts ; \
		cp -dpfr $(STAGING_DIR)/usr/lib/fonts/* $(TARGET_DIR)/usr/lib/fonts ; \
	fi
endef
endif

define QTPBASE_INSTALL_TARGET_CMDS
	$(QTPBASE_INSTALL_TARGET_LIBS)
	$(QTPBASE_INSTALL_TARGET_PLUGINS)
	$(QTPBASE_INSTALL_TARGET_FONTS)
endef

$(eval $(generic-package))
