include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=20170506
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/shadowsocksr/shadowsocksr-libev.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=39ec29efede90edcd095596dead3692ea3ad7491
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MAINTAINER:=breakwa11

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Lightweight Secured Socks5 Proxy
  URL:=https://github.com/shadowsocksr/shadowsocksr-libev
endef

define Package/shadowsocksr-libev
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpcre +libpthread +zlib +libsodium
endef


define Package/shadowsocksr-server
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread +libpcre +zlib +libsodium
endef

define Package/shadowsocksr-libev/description
ShadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-server/description=$(Package/shadowsocksr-libev/description)


CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert 

ifeq ($(BUILD_VARIANT),openssl)
	CONFIGURE_ARGS += --with-crypto-library=openssl
endif
ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif
ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-tunnel $(1)/usr/bin/ssr-tunnel
endef


define Package/shadowsocksr-server/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-server $(1)/usr/bin/ssr-server
endef

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-server))