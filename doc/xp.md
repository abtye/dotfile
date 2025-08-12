# Qemu/Virt-Manager 安装 Windows XP SP3

## 磁盘

- SATA安装特别慢，而且安装后无法启动
- 所以只能用IDE
- 用0.1.190-1的VirtIO驱动的vfd软盘可以安装VirtIO硬盘驱动

## 芯片组与BIOS

- 芯片组只能选i440FX，Q35报错不兼容ACPI或蓝屏
- XP只能用BIOS，不能用UEFI

声卡选AC97，XP自带它的驱动
显卡QXL

密钥
```
MRX3F-47B9T-2487J-KWKMF-RPWBY
```
## 驱动包

我自己整理的XP驱动包，包括：

- ballon
- https补丁
- VirtIO磁盘驱动
- VirtIO-net驱动
- spice-guest-tools
- qxl


- [123网盘]()
- [蓝奏云]()
- [百度网盘]()
- [onedrive]()
- [mega]()





