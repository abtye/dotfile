# Chromium Flags 文档

# 输入法

~~Chromium 大概在 135.0.7049.95 默认启用了 Wayland text-input-v3，该功能会破坏重复键功能，从而影响到B站视频右键3倍速，所以禁用。而 gtk4 看不到输入框。综上使用 text-input-v1~~

测试Chromium 138.0.7204.168修复了

在`~/.config/chromium.conf`中添加以下内容来使用 text-input-v3
```
--enable-wayland-ime --wayland-text-input-version=3
```



# 解决密钥环问题

最简单的方式是`--password-store=basic`，但是实在太不安全了。
gnome-libsecret 的密码不随用户密码改变，可以在`seahorse>密码>右键Login>更改密码`修改

```
--password-store=gnome-libsecret
```

```bash
# 禁用垂直同步
--disable-gpu-vsync
# 忽略GPU黑名单，强制启用硬件解码
--ignore-gpu-blocklist
# Wayland
# --ozone-platform=wayland
# GPU光栅化
# --enable-gpu-rasterization
# QUIC/HTTP3
# --enable-quic
# 零拷贝
# --enable-zero-copy
# 平滑滚动
# --enable-smooth-scrolling
# 钱包服务沙盒
#--wallet-service-use-sandbox=0
# Ozone平台，Wayland窗口装饰，WebRTC的Pipewire支持
# Vulkan,VAAPI,TLSv1.3,多线程下载,HEVC
# 命令行报错“Wayland 与 Vulkan 不兼容”，但实际没影响
# AcceleratedVideoDecodeLinuxGL 和 Vulkan 同时开启视频会白屏

# 硬件解码方案1，无 Vulkan
#--enable-features=AcceleratedVideoDecodeLinuxGL,PlatformHEVCEncoderSupport

# --enable-features=UseOzonePlatform,WaylandWindowDecorations,PlatformHEVCEncoderSupport,EnableTLS13EarlyData,WebRtcPipeWireCamera,CanvasOopRasterization,WebRTCPipeWireCapturer,AcceleratedVideoDecodeLinuxGL

# 硬件解码方案2，无 Video Enhance
--enable-features=VaapiVideoDecoder,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE,VaapiIgnoreDriverChecks,PlatformHEVCEncoderSupport,WaylandTextInputV3
#UseOzonePlatform,WaylandWindowDecorations,PlatformHEVCEncoderSupport,EnableTLS13EarlyData,WebRtcPipeWireCamera,CanvasOopRasterization,WebRTCPipeWireCapturer,
```