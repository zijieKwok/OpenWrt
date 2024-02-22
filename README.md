# OpenWrt

[![GitHub Repo stars](https://img.shields.io/github/stars/zijieKwok/OpenWrt-K)](https://github.com/zijieKwok/OpenWrt-K/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/zijieKwok/OpenWrt-K)](https://github.com/zijieKwok/OpenWrt-K/forks?include=active%2Carchived%2Cinactive%2Cnetwork&page=1&period=2y&sort_by=stargazer_counts)
[![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/t/zijieKwok/OpenWrt-K)](https://github.com/zijieKwok/OpenWrt-K/commits)
[![GitHub last commit (by committer)](https://img.shields.io/github/last-commit/zijieKwok/OpenWrt-K)](https://github.com/zijieKwok/OpenWrt-K/commits)
[![Workflow Status](https://github.com/zijieKwok/OpenWrt-K/actions/workflows/build-openwrt.yml/badge.svg)](https://github.com/zijieKwok/OpenWrt-K/actions)
> OpenWRT软件包与固件自动云编译



## 固件介绍

1. 基于OpenWrt官方源码编译，默认ip：```192.168.2.1```  默认密码：```password```
WiFi名称:AreyouOK 无密码
2. 自带丰富的LuCI插件与软件包（见内置功能）
3. 自带SmartDNS+AdGuard Home配置（AdGuard Home 默认密码：```password```）
4. 随固件编译几乎全部kmod（无sfe），拒绝kernel版本不兼容(kmod在Releases allkmod.zip中，建议与固件一同下载)
5. 只提供x86_64格式固件下载

### 内置功能

已内置以下软件包：

1. LuCI插件：    
  [luci-app-argon-config](https://github.com/jerrykuku/luci-app-argon-config):Argon 主题设置  
  luci-app-quickstart：quickstart是iStoreOS界面  
  luci-app-iStore： 软件商店  
  luci-app-ddns：动态 DNS  
  [luci-app-diskman](https://github.com/lisaac/luci-app-diskman)：DiskMan 磁盘管理  
  luci-app-fileassistant：文件助手  
  luci-app-firewall：防火墙   
  luci-app-opkg：软件包  
  luci-app-onliner：在线用户
 [luci-app-openclash](https://github.com/vernesong/OpenClash):可运行在 OpenWrt 上的 Clash 客户端  
  [luci-app-passwall](https://github.com/xiaorouji/openwrt-passwall)：passwall  
  luci-app-samba4：samba网络共享  
  [luci-app-smartdns](https://github.com/pymumu/luci-app-smartdns)：SmartDNS 服务器  
  [luci-app-socat](https://github.com/chenmozhijin/luci-app-socat)：Socat网络工具  
  luci-app-ttyd：ttyd 终端  
  [luci-app-turboacc](https://github.com/chenmozhijin/turboacc)：Turbo ACC 网络加速  
  luci-app-upnp：通用即插即用（UPnP）  
  luci-app-udpxy：组播转http
  luci-app-omcproxy：组播代理
  [luci-app-pushbot](https://github.com/zzsj0928/luci-app-pushbot))：全能推送  
  luci-app-socat：端口转发 
  tailscale：内网穿透

3. LuCI主题：[Argon](https://github.com/jerrykuku/luci-theme-argon)

    > + 以上软件包都在生成在Releases的package.zip文件中，可安装使用。

4. 网卡驱动：  
  kmod-8139cp  
  kmod-8139too  
  kmod-alx  
  kmod-amazon-ena  
  kmod-amd-xgbe  
  kmod-bnx2  
  kmod-bnx2x  
  kmod-e1000  
  kmod-e1000e  
  kmod-forcedeth  
  kmod-i40e  
  kmod-iavf  
  kmod-igb  
  kmod-igbvf  
  kmod-igc  
  kmod-ixgbe  
  kmod-libphy  
  kmod-macvlan  
  kmod-mii  
  kmod-mlx4-core  
  kmod-mlx5-core  
  kmod-net-selftests  
  kmod-pcnet32  
  kmod-phy-ax88796b  
  kmod-phy-realtek  
  kmod-phy-smsc   
  kmod-r8152  
  kmod-r8168  
  kmod-tg3  
  kmod-tulip  
  kmod-via-velocity  
  kmod-vmxnet3


## 感谢

 感谢以下项目与各位制作软件包大佬的付出
+ [沉默の金](https://github.com/chenmozhijin/OpenWrt-K)
+ [iStoreOS官网](https://github.com/istoreos/istoreos)
+ [OpenWrt官网](https://github.com/openwrt/openwrt/)
+ [lede](https://github.com/coolsnowwolf/lede)
+ [Lienol](https://github.com/Lienol/openwrt)
+ [immortalwrt](https://github.com/immortalwrt/immortalwrt/)
+ [wongsyrone](https://github.com/wongsyrone/lede-1)
+ [Github Actions](https://github.com/features/actions)
+ [softprops](https://github.com/ncipollo/release-action)
+ [dev-drprasad](https://github.com/mknejp/delete-release-assets)
