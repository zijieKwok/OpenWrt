# 文件名: diy-part2.sh
# 描述: OpenWrt DIY script part 2 (放在安装feeds之后)
#!/bin/bash

function merge_package() {
    # 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
    if [[ $# -lt 3 ]]; then
    	echo "Syntax error: [$#] [$*]" >&2
        return 1
    fi
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" target_dir="$3" && shift 3
    rootdir="$PWD"
    localdir="$target_dir"
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    # 使用循环逐个移动文件夹
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}

# 修改管理地址
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 交换LAN/WAN口
sed -i 's/"eth1 eth2" "eth0"/"eth1 eth2" "eth0"/g' target/linux/x86/base-files/etc/board.d/02_network
sed -i "s/'eth1 eth2' 'eth0'/'eth1 eth2' 'eth0'/g" target/linux/x86/base-files/etc/board.d/02_network
sed -i "s/lan 'eth0'/lan 'eth0'/g" package/base-files/files/etc/board.d/99-default_network
sed -i "s/wan 'eth1'/wan 'eth1'/g" package/base-files/files/etc/board.d/99-default_network
sed -i "s/net\/eth1/net\/eth1/g" package/base-files/files/etc/board.d/99-default_network

# 修改默认皮肤
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 修改主机名以及一些显示信息
sed -i "s/hostname='*.*'/hostname='OpenWrt'/" package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_ID='*.*'/DISTRIB_ID='OpenWrt'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt'/g"  package/base-files/files/etc/openwrt_release
sed -i '/(<%=pcdata(ver.luciversion)%>)/a\      built by ywt114' package/lean/autocore/files/x86/index.htm
echo -n "$(date +'%Y%m%d')" > package/base-files/files/etc/openwrt_version
curl -fsSL https://raw.githubusercontent.com/ywt114/diy/main/banner_OPENWRT > package/base-files/files/etc/banner

# 修改部分默认设置
sed -i "/exit 0/i sed -i '\/oui\/d' \/etc\/opkg\/distfeeds.conf" package/lean/default-settings/files/zzz-default-settings
sed -i "s/option check_signature/# option check_signature/g" package/system/opkg/Makefile
# echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/x86_64" >> package/system/opkg/files/customfeeds.conf
echo "src/gz openwrt_kenzok8 https://op.dllkids.xyz/packages/x86_64" >> package/system/opkg/files/customfeeds.conf
sed -i "s/mirrors.cloud.tencent.com\/lede/mirrors.cloud.tencent.com\/openwrt/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i 's\/root::0:0:99999:7:::/# sed -i 's\/root::0:0:99999:7:::/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i 's\/root:::0:99999:7:::/# sed -i 's\/root:::0:99999:7:::/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i '\/REDIRECT --to-ports/# sed -i '\/REDIRECT --to-ports/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/echo 'iptables -t/echo '# iptables -t/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/echo '\[ -n/echo '# \[ -n/g" package/lean/default-settings/files/zzz-default-settings

# 开启wifi选项
sed -i 's/disabled=*.*/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ssid=*.*/ssid=OpenWrt/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 添加关机按钮到系统选项
curl -fsSL https://raw.githubusercontent.com/ywt114/diy/main/poweroff.htm > feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_system/poweroff.htm
curl -fsSL https://raw.githubusercontent.com/ywt114/diy/main/system.lua > feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua

# 删除替换默认源插件和添加插件
# find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
# find ./ | grep Makefile | grep pdnsd-alt | xargs rm -f
\rm -rf feeds/packages/net/v2ray-geodata feeds/packages/net/pdnsd-alt
# \rm -rf feeds/packages/lang/golang
# git clone --depth=1 -b 21.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
git clone --depth=1 -b master https://github.com/sbwml/luci-app-alist package/lean/alist
\rm -rf feeds/packages/net/mosdns feeds/luci/applications/luci-app-mosdns feeds/packages/utils/v2dat
git clone --depth=1 -b v5 https://github.com/sbwml/luci-app-mosdns package/lean/mosdns
\rm -rf feeds/luci/applications/luci-app-adbyby-plus
git clone --depth=1 -b main https://github.com/ywt114/luci-app-adbyby-plus-lite package/lean/luci-app-adbyby-plus-lite
\rm -rf feeds/packages/net/msd_lite
git clone --depth=1 -b main https://github.com/ywt114/luci-app-msd_lite package/lean/msd_lite
git clone --depth=1 -b master https://github.com/ywt114/luci-app-gpsysupgrade package/lean/luci-app-gpsysupgrade
\rm -rf feeds/packages/net/smartdns feeds/luci/applications/luci-app-smartdns
git clone --depth=1 -b master https://github.com/pymumu/openwrt-smartdns package/lean/smartdns
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/lean/luci-app-smartdns
git clone --depth=1 -b master https://github.com/kenzok8/small package/lean/small
\rm -rf package/lean/small/luci-app-bypass package/lean/small/luci-app-vssr package/lean/small/luci-app-passwall2
git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-chatgpt-web package/lean/luci-app-chatgpt-web
git clone --depth=1 -b master https://github.com/sirpdboy/luci-app-advanced package/lean/luci-app-advanced
git clone --depth=1 -b master https://github.com/sirpdboy/luci-app-autotimeset package/lean/luci-app-autotimeset
sed -i 's/control"/system"/g' package/lean/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/control]/system]/g' package/lean/luci-app-autotimeset/luasrc/view/autotimeset/log.htm
git clone --depth=1 -b master https://github.com/kenzok8/openwrt-packages package/lean/openwrt-packages
\cp -rf package/lean/openwrt-packages/luci-app-openclash package/lean/small
\rm -rf package/lean/openwrt-packages
\rm -rf feeds/packages/net/socat feeds/luci/applications/luci-app-socat
git clone --depth=1 -b master https://github.com/xiangfeidexiaohuo/extra-ipk package/lean/extra-ipk
\cp -rf package/lean/extra-ipk/op-socat package/lean/socat
\cp -rf package/lean/extra-ipk/op-homebox package/lean/homebox
\rm -rf package/lean/extra-ipk
\rm -rf feeds/packages/net/adguardhome feeds/luci/applications/luci-app-adguardhome
git clone --depth=1 -b main https://github.com/sirpdboy/sirpdboy-package package/lean/sirpdboy-package
\cp -rf package/lean/sirpdboy-package/adguardhome package/lean
\cp -rf package/lean/sirpdboy-package/luci-app-adguardhome package/lean
\rm -rf package/lean/sirpdboy-package
git clone --depth=1 -b main https://github.com/linkease/openwrt-app-actions package/lean/openwrt-app-actions
\cp -rf package/lean/openwrt-app-actions/applications/luci-app-multiaccountdial package/lean
\rm -rf package/lean/openwrt-app-actions
git clone --depth=1 -b main https://github.com/linkease/istore package/lean/istore
# sed -i 's/+luci-lib-ipkg/+luci-base/g' package/lean/istore/luci/luci-app-store/Makefile
\cp -rf package/lean/istore/luci/* package/lean
\cp -rf package/lean/istore/translations package/lean
\rm -rf package/lean/istore
git clone --depth=1 -b main https://github.com/linkease/nas-packages-luci package/lean/nas-packages-luci
sed -i 's/istorex_template")).leaf/istorex_template"), _("iStoreX"), 3).leaf/g' package/lean/nas-packages-luci/luci/luci-app-istorex/luasrc/controller/istorex.lua
\cp -rf package/lean/nas-packages-luci/luci/* package/lean
\rm -rf package/lean/nas-packages-luci
git clone --depth=1 -b master https://github.com/linkease/nas-packages package/lean/nas-packages
\cp -rf package/lean/nas-packages/network/services/* package/network/services
\cp -rf package/lean/nas-packages/multimedia package
\rm -rf package/lean/nas-packages

# 取消部分config配置
sed -i 's/iperf3-ssl[[:space:]]*//g' target/linux/x86/Makefile
# sed -i '/CONFIG_PACKAGE_kmod-usb-audio/d' ./.config
# echo "# CONFIG_PACKAGE_kmod-usb-audio is not set" >> ./.config
# echo "# CONFIG_PACKAGE_kmod-media-core is not set" >> ./.config

# 修改vermagic版本号
# curl -fsSL https://raw.githubusercontent.com/ywt114/diy/main/vermagic-5.15 > vermagic
# sed -i 's/grep '\''=\[ym\]'\'' $(LINUX_DIR)\/.config.set | LC_ALL=C sort | $(MKHASH) md5 >/cp $(TOPDIR)\/vermagic/g' include/kernel-defaults.mk
# sed -i 's/$(SCRIPT_DIR)\/kconfig.pl $(LINUX_DIR)\/.config | $(MKHASH) md5/cat $(LINUX_DIR)\/.vermagic/g' package/kernel/linux/Makefile

sed -i 's/Variable1 = "*.*"/Variable1 = "ywt114"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable2 = "*.*"/Variable2 = "OpenWrt"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable3 = "*.*"/Variable3 = "x86_64"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable4 = "*.*"/Variable4 = "5.15"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable1 = "*.*"/Variable1 = "ywt114"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable2 = "*.*"/Variable2 = "OpenWrt"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable3 = "*.*"/Variable3 = "x86_64"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable4 = "*.*"/Variable4 = "5.15"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
