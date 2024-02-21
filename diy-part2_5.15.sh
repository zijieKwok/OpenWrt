#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/net/alist
rm -rf feeds/packages/net/aria2
rm -rf feeds/packages/net/ariang
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-msd_lite
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/luci/applications/luci-app-openclash

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
#echo 'src-git homeproxy https://github.com/immortalwrt/homeproxy' >> feeds.conf.default
git_sparse_clone master https://github.com/kiddin9/openwrt-packages aria2
git_sparse_clone master https://github.com/kiddin9/openwrt-packages ariang
#it_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-vlmcsd
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-kodexplorer
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-usb-printer
git_sparse_clone luci https://github.com/chenmozhijin/turboacc luci-app-turboacc

git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan

# 添加额外插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/luci-app-ddns-go
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git clone --depth=1 https://github.com/zijieKwok/istoreos-nas-packages package/luci-app-linkease
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-filebrowser
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-pushbot
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-qbittorrent
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-turboacc
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-usb-printer
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-easymesh

# 科学上网插件
git clone --depth=1 https://github.com/immortalwrt/homeproxy package/luci-app-homeproxy
git clone --depth=1 https://github.com/zijieKwok/passwall-packages package/passwall-packages
git clone --depth=1 https://github.com/zijieKwok/JacKwok-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
git_sparse_clone dev https://github.com/vernesong/OpenClash luci-app-openclash

# Themes
git clone --depth=1 https://github.com/zijieKwok/istoreos-nas-packages package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# DDNS-GO依赖
git_sparse_clone main https://github.com/sirpdboy/luci-app-ddns-go ddns-go


# 在线用户
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-onliner
sudo chmod -Rf 755 package/luci-app-onliner

# 晶晨宝盒
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-amlogic
#sed -i "s|firmware_repo.*|firmware_repo 'https://github.com/ophub/luci-app-amlogic'|g" package/luci-app-amlogic/root/etc/config/amlogic
#sed -i "s|kernel_path.*|kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic
#sed -i "s|ARMv8|ARMv8_PLUS|g" package/luci-app-amlogic/root/etc/config/amlogic

# SmartDNS
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# MosDNS
#git_sparse_clone main https://github.com/kenzok8/small-package luci-app-mosdns
#git_sparse_clone main https://github.com/kenzok8/small-package mosdns
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# DDNS.to
git_sparse_clone main https://github.com/kenzok8/small-package luci-app-ddnsto
git_sparse_clone main https://github.com/kenzok8/small-package ddnsto

# Alist
#git_sparse_clone main https://github.com/kenzok8/small-package luci-app-alist
#git_sparse_clone main https://github.com/kenzok8/small-package alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# iStore
# git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
# git_sparse_clone main https://github.com/linkease/istore luci
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-store
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-lib-taskd
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-lib-xterm
git_sparse_clone master https://github.com/kiddin9/openwrt-packages taskd
