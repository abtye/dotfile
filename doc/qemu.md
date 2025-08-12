# Qemu 和 Virt-Manager

> 最后修改于 2025-03-08

## 注意
1. VrtiIO 显卡不兼容 Xe 模块
2. Labwc 使用 QXL 会闪屏，用 VirtIO 会卡，鼠标倒转
3. 虚拟机中，还是建议选择 GNOME

## Virt-Manager 激活网络
```bash
sudo virsh net-autostart default
sudo virsh net-start default
sudo virsh net-list --all
```

如果失败了，尝试关闭所有占用53端口的进程
```bash
# 查看哪些进程占用53端口
sudo lsof -i :53
```
或停止dnsmasq
```bash
sudo systemctl stop dnsmasq.service
```

## 剪贴板

1. Virt-Manager > 显示虚拟机硬件详情 > 添加硬件 > 通道  
2. 名称选`com.redhat.spice.0`或`org.qemu.guest_agent.0`
3. 设备类型选`qemu-vdagent`
4. 勾选共享剪贴板
5. 虚拟客户机还要安装 qemu-vdagent 或 spice