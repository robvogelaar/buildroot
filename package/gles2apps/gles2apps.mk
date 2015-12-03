################################################################################
#
# gles2apps
#
################################################################################

##GLES2APPS_VERSION = 551757d9d1bb7664d9c77c23e9081fb5e6b2113b
GLES2APPS_VERSION = master
GLES2APPS_SITE = git@github.com:robvogelaar/gles2apps.git
GLES2APPS_SITE_METHOD = git

## GLES2APPS_SITE = /home/rev/git/gles2apps
## GLES2APPS_SITE_METHOD = local

GLES2APPS_INSTALL_STAGING = YES
GLES2APPS_LICENSE = GPL

GLES2APPS_DEPENDENCIES = libgles libegl freetype libpng

GLES2APPS_AUTORECONF = YES

$(eval $(autotools-package))
