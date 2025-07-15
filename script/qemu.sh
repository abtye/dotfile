#!/usr/bin/bash

sudo pacman -S --needed qemu-base \
qemu-hw-display-qxl \
qemu-hw-display-virtio-gpu \
qemu-hw-display-virtio-gpu-gl \
qemu-hw-display-virtio-gpu-pci \
qemu-hw-display-virtio-gpu-pci-gl \
qemu-hw-usb-host \
qemu-hw-usb-redirect \
qemu-ui-spice-app \
qemu-audio-spice
