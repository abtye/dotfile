#!/usr/bin/bash

# 检测是否安装了waydroid
if ! command -v waydroid >/dev/null 2>&1; then
    echo 'waydroid 未安装!'
    exit
fi

# 虚拟 WiFi
waydroid prop set persist.waydroid.fake_wifi "*"
# 直接访问热插拔设备
waydroid prop set persist.waydroid.uevent true
# 宽
#waydroid prop set persist.waydroid.width 1920
# 高
#waydroid prop set persist.waydroid.height 1040

