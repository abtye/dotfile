#!/usr/bin/bash
echo '/usr/lib/modules/6.13.7-arch1-1/extramodules'
sudo rmmod kvm
sudo modprobe vboxdrv
sudo modprobe vboxnetadp
sudo modprobe vboxnetflt

