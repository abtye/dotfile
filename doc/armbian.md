# 远程桌面

[安卓远控软件](https://github.com/iiordanov/remote-desktop-clients)

最后支持Android 4.4的版本

## VNC

[VNC-Viewer汉化版](https://github.com/w311ang/VNC-Viewer_Android_zh-CN/releases)

freebVNC v5.9.4 仍支持Android 4.4，SDK版本为16

### Host

```bash
WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 sway &
WAYLAND_DISPLAY=wayland-1 wayvnc 0.0.0.0 -g
```

- VNC 协议不支持声音
- labwc 不行
- 同时开启labwc和sway，再在tty2中启动labwc或sway，没有声音（识别不到任何音频输出设备）

### Guest

```
remmina # 远程桌面
remmina-plugin-vnc # VNC
```

- tigervnc 不可用：看不到鼠标
- 安装`adwaita-icon-theme`后依然看不到按钮图标

## RDP

freeaRDP

- v3.9.3 SDK 8
- v3.9.4 SDK 21

v3.7.5发行说明  
Implemented audio support with a newer version of FreeRDP.  
用新版FreeRDP实现了音频支持

## SPICE

很卡，而且用freeaSPICE在玩客云上没声音，调不了画质，不如VNC和RDP

# xrandr 等命令报错 Can't open display

在命令前加上`DISPLAY=:0`


# 无法启动桌面

通过 lightdm 来进入 flwm

- 可能还要安装 xinit xserver-xorg
- 2025年07月21日测试：无法使用 labwc

# 画面歪斜

> 这个问题很奇怪，用`xrandr`来回旋转几次，改变一下`mode`分辨率大小，也许就可以了

```bash
xrandr --output HDMI-1 --rotate normal --mode 1600x900
```

# 声音

使用`aplay -l`，没声卡，所以没声音
