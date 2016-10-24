################################################################################
#
# qtpwebkit
#
################################################################################
#
## find output/target -name '*Qt*Web*' | xargs rm -rf && find output/host -name '*Qt*Web*' | xargs rm -rf
#
# SDK3.1.7 .. 3.1.11
# git@github.com:Metrological/qtwebkit.git - branch:qt5.4 - commit:fe3dba3a52ca361458be25f5bb6a4711fffc6c19 - date:Dec 28, 2015
#
############

#QTPWEBKIT_VERSION = fe3dba3a52ca361458be25f5bb6a4711fffc6c19
QTPWEBKIT_VERSION = dcacbc49ccc91789a6c50dbd2c11e3052109dbf6

QTPWEBKIT_SITE = git@github.com:Metrological/qtwebkit.git
QTPWEBKIT_SITE_METHOD = git


QTPWEBKIT_DEPENDENCIES = qtpbase sqlite host-ruby host-gperf host-bison host-flex

QTPWEBKIT_INSTALL_STAGING = YES

QTPWEBKIT_BUILDDIR = $(@D)/release

QTPWEBKIT_MAKE_ENV = $(TARGET_MAKE_ENV) QMAKEPATH=$(@D)/Tools/qmake/

define QTPWEBKIT_CONFIGURE_CMDS
	(mkdir -p $(QTPWEBKIT_BUILDDIR); cd $(QTPWEBKIT_BUILDDIR); \
		$(QTPWEBKIT_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake WEBKIT_CONFIG+=accelerated_2d_canvas CONFIG+=release CONFIG-=webkit2 \
			 ../WebKit.pro \
	)
endef

define QTPWEBKIT_BUILD_CMDS
	$(QTPWEBKIT_MAKE_ENV) $(MAKE) -C $(QTPWEBKIT_BUILDDIR)
endef

define QTPWEBKIT_INSTALL_STAGING_CMDS
	$(QTPWEBKIT_MAKE_ENV) $(MAKE) -C $(QTPWEBKIT_BUILDDIR) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

define QTPWEBKIT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/root/.cache
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebKit*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(QTPWEBKIT_BUILDDIR)/bin/* $(TARGET_DIR)/usr/bin/
	$(QTPWEBKIT_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
