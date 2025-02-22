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

Virt-Manager激活网络
```bash
sudo virsh net-autostart default
sudo virsh net-list --all
```

## Cloudflare Warp

启用MASQUE协议：把`mdm.xml`放到`/var/lib/cloudflare-warp/`下  
使用`warp-cli settings | grep protocol`查看

## 多显示器
```bash
wlr-randr --dryrun
```
