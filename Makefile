include $(TOPDIR)/rules.mk

PKG_NAME:=ratelimit
PKG_RELEASE:=1

PKG_MAINTAINER:=John Crispin <john@phrozen.org>

include $(INCLUDE_DIR)/package.mk

define Package/ratelimit
  SECTION:=net
  CATEGORY:=Network
  TITLE:=client devices ratelimiting daemon
  DEPENDS:=+tc +kmod-ifb
  PKGARCH:=all
endef

define Package/ratelimit/description
  This daemon provides a stateful interface to the HTB traffic shaper,
  enabling per-client bandwidth limits assignment.
endef

define Package/ratelimit/conffiles
/etc/config/ratelimit
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile/Default

endef
Build/Compile = $(Build/Compile/Default)

define Package/ratelimit/install
	$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,ratelimit))
