# ADB和Fastboot命令

## ADB

- 重启到9008 `adb reboot edl`
- 重启到BootLoader `adb reboot bootloader`


## Fastboot

- 刷入分区`fastboot flash <分区> <分区.img的路径>`

<分区>有`boot,system`等

- 格式化data`fastboot erase userdata`
