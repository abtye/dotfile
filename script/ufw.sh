#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root" >&2
    echo "请以root权限运行这个脚本" >&2
    exit 1
fi

if ! command -v ufw &> /dev/null; then
    echo "Please install ufw" >&2
    echo "请安装ufw" >&2
    exit 1
fi

# qbittorrent
ufw allow 63970/tcp
ufw allow 63970/udp
# Local net 局域网
ufw allow from 10.0.0.0/8
ufw allow from 172.16.0.0/12
ufw allow from 192.168.0.0/16
ufw allow from fe80::/10
# waydroid
ufw allow 53
ufw allow 67
ufw reload

echo "-------------------------------------------------------------------"
echo "Done.This is current config."
echo "配置完成。以下是当前配置"

ufw status verbose
