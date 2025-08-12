# Virtualbox

> 最后修改于 2025-03-08  
> 本文专门为 Arch Linux 用户编写，可能不适用与其他 Linux 发行版

- [Virtualbox官网](https://www.virtualbox.org/)
- [国内下载镜像](https://mirrors.cernet.edu.cn/list/virtualbox)
- [Arch Linux 的相关 Wiki](https://wiki.archlinuxcn.org/wiki/VirtualBox/)

## Arch Linux

- 如果使用 linux 内核，安装`virtualbox-host-modules-arch`
- 如果使用 linux-lts 内核，安装`virtualbox-host-modules-lts`
- 其它的内核，请安装`virtualbox-host-dkms`

## 解决 Kernel driver not installed

```bash
# 查看内核版本
uname -r
# 输出类似于：
# 6.6.4-zen1-1-zen
```

根据不同的内核下载不同的头文件（以zen内核为例）

```bash
sudo pacman -Sy linux-zen-headers
```

如果没有内核头文件会报错

```
=== Building 'vboxdrv' module ===
make[1]: 进入目录“/usr/src/vboxhost-7.0.12_OSE/vboxdrv”
/usr/src/vboxhost-7.0.12_OSE/vboxdrv/Makefile-header.gmk:250: *** Error: unable to find the headers of the Linux kernel to build against (KERN_DIR=/lib/modules/6.6.4-zen1-1-zen/build). Specify KERN_VER=<version> (currently 6.6.4-zen1-1-zen) and run Make again。 停止。
make[1]: 离开目录“/usr/src/vboxhost-7.0.12_OSE/vboxdrv”
make: *** [Makefile:78：vboxdrv] 错误 2
```

### 编译并加载模块

```bash
# dkms
cd /usr/src/vboxhost-*
sudo make
sudo modprobe ./vboxdrv.ko ./vboxnetadp.ko ./vboxnetflt.ko
```

```bash
# 使用 virtualbox-host-modules
cd /usr/lib/modules/替换这个/extramodules
sudo modprobe ./vboxdrv.ko.zst ./vboxnetadp.ko.zst ./vboxnetflt.ko.zst
```

## 如果你还使用 Qemu 或 Virt-Manager

可能需要卸载 kvm 模块和停止 libvirtd

```bash
sudo rmmod kvm kvm-intel kvm-amd
sudo systemctl stop libvirtd libvirtd.socket libvirtd-admin.socket libvirtd-ro.socket
```

## 无法访问USB

需要将用户添加到 vboxusers 组
```bash
sudo gpasswd -a $USER vboxusers
# 重新登录后才能生效
```
