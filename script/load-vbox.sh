#!/usr/bin/bash
echo '/usr/lib/modules/6.13.5-arch1-1/extramodules'
sudo modprobe vboxdrv
sudo modprobe vboxnetadp
sudo modprobe vboxnetflt

