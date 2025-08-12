# 蓝牙传输文件

## 安装软件

```bash
sudo pacman -S bluez bluez-obex blueman
```

## 开启蓝牙

根据Arch Wiki：自2024年以来，`bluez-obex`和`bluez-mesh`已从bluez中分离出来。
因此，如果您计划通过蓝牙传输文件，则需要安装`bluez obex`并启用用户服务`obex.service`

```bash
sudo rfkill unblock bluetooth
sudo systemctl start bluetooth.service
systemctl --user start obex.service
```

然后打开blueman传输即可

## 关闭

```bash
sudo rfkill block bluetooth
sudo systemctl stop bluetooth.service
systemctl --user stop obex.service
```
