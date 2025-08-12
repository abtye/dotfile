# Vmware Player

> 最后修改2025-03-08  
> 本文专门为 Arch Linux 用户编写，可能不适用与其他 Linux 发行版

解决 Vmware Player 在 Linux上无法启动的问题

> 似乎要安装内核头文件

## 第一次安装

找到下载的文件

```bash
# 给可执行权限
chmod +x ./VMware-Player-*-.bundle
sudo ./VMware-Player-*-.bundle
```

在询问`System service script directory (Commonly /etc/init.d): 时，输入/etc/systemd/system`

Vmware 屏幕大小适配有点差，分辨率比较小的屏幕按钮可能会被挡住。此时按住 Windows 键 + 鼠标按住能强制拖动窗口。

## 已经安装过了

先卸载

```bash
sudo vmware-installer -u vmware-player
```

1. 不要保留配置文件
2. 然后向上面一样，重新安装就可以了