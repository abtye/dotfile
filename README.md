# 自用 Arch Linux 配置

## 内核参数

- `nowatchdog`关闭看门狗
- `nosoftlockup softlockup_panic=0`禁用软锁
- `nohpet clocksource=tsc tsc=reliable`禁用HPET，使用TSC
- `quiet=3`减少日志输出
- `drm.debug=0`禁用DRM调试
- `psi=1`Waydroid需要
- `nmi_watchdog=0`关闭NMI，提高性能
- `i915.force_probe=!9a78 xe.force_probe=9a78`使用Xe模块，而不是i915，提高性能

## Virt-Manager

### 注意
1. VrtiIO显卡不兼容Xe模块
2. Labwc使用QXL会闪屏，用VirtIO会卡，鼠标倒转
3. 虚拟机中，还是建议选择GNOME

### 客户机程序
```
spice-vdagent
virglrenderer
```

### Virt-Manager激活网络
```bash
sudo virsh net-autostart default
sudo virsh net-list --all
```

### 剪贴板



## Virtualbox

### 无法使用

下载内核的headers  
在`/usr/src/vboxhost*`下编译内核模块，并使用`insmod`或`modprobe`插入
```
vboxdrv.ko
vboxnetadp.ko
vboxnetflt.ko
```

### 不能枚举USB设备

```bash
sudo usermod -a -G vboxusers $USER
```

### 扩展包

https://www.virtualbox.org/wiki/Downloads  
virtualbox-ext-vnc

## Cloudflare Warp

启用MASQUE协议：把`mdm.xml`放到`/var/lib/cloudflare-warp/`下  
使用`warp-cli settings | grep protocol`查看

## 多显示器
```bash
wlr-randr --dryrun
```

## 检测
| 命令                              | 检测               | 来自          |
| --------------------------------- | ------------------ | ------------- |
| `gst-inspect-1.0 va`              | VA-API             | gstreamer     |
| `gst-inspect-1.0 qsv`             | QSV                | gstreamer     |
| `vainfo`                          | VA-API             | libva-utils   |
| `clinfo`                          | OpenCL             | clinfo        |
| `vulkaninfo`                      | Vulkan             | vulkan-tools  |
| `glxinfo -B`                      | OpenGL             | mesa-utils    |
| `eglinfo -B`                      | OpenGL ES          | mesa-utils    |
| `xeyes`                           | X11                | xorg-eyes     |
| `evhz`                            | 鼠标回报率         | evhz(AUR)     |
| `xev`                             | OpenBox和Labwc按键 | xorg-xev      |
| `wayland-info \| grep text_input` | Wayland输入法协议  | wayland-utils |
|                                   |                    |               |
|                                   |                    |               |
|                                   |                    |               |
|                                   |                    |               |
|                                   |                    |               |


## 关闭CoreDump

```conf
/etc/systemd/coredump.conf
[Coredump]
Storage=none
ProcessSizeMax=0
```
修改完成后重启systemd
```bash
sudo systemctl daemon-reload
```


## 输入法

Chromium 使用`--gtk-version=4`来支持输入法时，如果 Fcitx5 不启用"在程序中显示预编辑文本"，是看不到输入法的

而如果开启"在程序中显示预编辑文本"，在 Sublime Text 中又看不到输入法了，二者相互冲突

从 Chromium 129，Electron 33 开始支持了 text-input-v3 ，原本以为可以不用打 text-input-v1 补丁了，但是居然有不能按键重复的问题

具体表现为在网址栏输入一堆字，按住方向键不会重复，以及b站无法使用右方向键3倍速

所以`chromium.conf`调整为
```conf
--gtk-version=3
--enable-wayland-ime
--wayland-text-input-version=1
```

## Python venv

`--system-site-packages`使用系统包

```bash
python -m venv --system-site-packages venv
```

## Intel libhoudini

libnb.so 库允许 libhoudini 在 AMD 处理器上运行

## 将 Thunar 设为默认文件管理器

```bash
# 查看当前默认文件管理器
xdg-mime query default inode/directory
# 设置为 Thunar
xdg-mime default thunar.desktop inode/directory
```

