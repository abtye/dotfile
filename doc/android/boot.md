# Boot 分区

## 注意

- 部分厂商对系统底层进行了魔改，不一定支持GSI【1】
- 出厂安卓13的联发科别用GSI，百分百挂【1】
- Root的三种方法（Magisk,KernelSU,APatch）都需要原版boot镜像

## 注释

1. 详见 B站@晨钟酱Official BV1m6421c7sb 手机硬核折腾指南：没刷机包也能获取Root权限？ 00:21

# 提取boot镜像

详见 B站@晨钟酱Official BV1m6421c7sb 手机硬核折腾指南：没刷机包也能获取Root权限？

- 深刷提取法
- GSI提取法
- 侧载提取法

## 深刷法

手机在深度刷机模式下，可根据分区表来提取分区

适用于联发科、高通的老设备

联发科 MTK Clinet
高通 QPT

## GSI提取法

适用于支持Project Treble的设备，通过刷入GSI获取adb shell的Root权限

在adb shell中通过su获取root权限的系统版本号一般有`userdebug`

> root的adb shell给Shiziku授权可以获得大致与root相当的权限

分区的位置和设备的闪存类型有关

### 提取分区

| 分区类型                                                       | 提取                                 |
| -------------------------------------------------------------- | ------------------------------------ |
| Aonly                                                          | `boot.img`                           |
| AB/VAB                                                         | `boot_a.img`和`boot_b.img`           |
| 情况3 | `init_boot_a.img`和`init_boot_b.img` |

情况3：AB/VAB且<font color="#FF0000">出厂版本</font>为Android 13或以上，并且要使用magisk来获取root

> B站视频弹幕
> 要注意一个叫vbmeta的东西，这个可能会引起不开机
> 情况3不准确 是内核为5.1x-android13以上的是init_boot 有些机器出厂a13但是内核是12 就没有init_boot

#### 找分区表

```bash
# eMMC
find /dev/block/platform -name 'by-name' -type d
# 上面这行命令会返回一个路径，cd进入即可

# UFS
cd /dev/block/by-name
```

#### 找到boot分区的实际位置

```bash
ls -l boot
# 返回值类似
eMMC：boot -> /dev/block/mmcblk0p8
UFS： boot -> /dev/block/sdc29
```

#### 提取

```bash
dd if=<分区设备> of=<输出的img路径>
# 如 dd if=/dev/block/sda1 of=/sdcard/boot.img
```

### 刷入分区

#### 方案1

```bash
# 先重启到bootloader
adb reboot bootloader
```

刷入
```bash
# A-only
fastboot flash boot '<magisk修补后的boot.img>'
```
```bash
# AB
fastboot flash boot_a '<magisk修补后的boot_a.img>'
fastboot flash boot_b '<magisk修补后的boot_b.img>'
```
```bash
# 情况3
fastboot flash init_boot_a '<magisk修补后的init_boot_a.img>'
fastboot flash init_boot_b '<magisk修补后的init_boot_b.img>'
```

刷完后重启，手机就有了Root权限

#### 方案2

在adb shell中执行

**不要复制粘贴，一行行执行**
```bash
# 获取root权限
su
# 刷入
dd if='<magisk修补后的boot.img>' of='<原boot分区块设备>'
```

同样的，要注意分区的三种情况

### 总结

1. 安装Treble Check工具，判断手机是否支持PT
2. 根据是否支持AB分区、是否支持SAR、处理器架构、Android版本来选择合适的GSI
3. 下载后解压，使用fastboot将GSI刷入System分区<font color='#FF0000'>（这种方法会把手机原版的系统覆盖掉）</font>
4. 进入GSI后打开开发者选项，获取命令行Shell root权限
5. 使用emmc闪存的手机需要先查找镜像位置，再进入。而UFS闪存的镜像位置一般固定
6. 使用ls—l命令确定boot分区实际位置
7. 使用dd命令将boot分区提取到存储根目录下*
8. 使用Magisk修补boot分区
9. 使用fastboot或dd命令刷写修补后的boot
10. 重启手机，打开Magisk查看是否成功获取Root

> 注意AB分区的手机需同时提取boot_a(b)或init_boot_a(b)



## 侧载提取法

支持AB分区的设备可以通过DSU（动态系统更形）将GSI安装到另一个槽位。重启后进入临时的GSI，提取分区后再重启即可回到原版系统

- 只要手机支持SAR（System As Root），即使不支持AB分区，也要下载带AB格式的GSI刷机包
- 使用[DSU SideLoader](https://github.com/VegaBobo/DSU-Sideloader/releases)
- 视频教程BV1m6421c7sb 06:56