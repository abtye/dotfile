#!/usr/bin/bash
sudo pacman -S --needed sof-firmware
sudo pacman -S --needed vim git fzf fish ffmpeg fuse2 libdecor libnotify grim slurp earlyoom cliphist chrony vnstat stubby
sudo pacman -S --needed foot wofi mako jq brightnessctl nwg-look xdg-desktop-portal-wlr xdg-desktop-portal-gtk waybar wl-clipboard mate-polkit qt6ct sound-theme-freedesktop zenity
sudo pacman -S --needed fcitx5-im fcitx-rime kwindowsystem
sudo pacman -S --needed vulkan-intel vpl-gpu-rt intel-compute-runtime intel-media-driver intel-ucode
sudo pacman -S --needed adobe-source-han-sans-cn-fonts adobe-source-han-sans-kr-fonts otf-codenewroman-nerd otf-font-awesome noto-fonts-emoji noto-fonts
sudo pacman -S --needed wireless-regdb networkmanager
sudo pacman -S --needed pipewire-alsa pipewire-pulse pipewire-jack
sudo pacman -S --needed gst-plugin-pipewire gst-plugin-qsv gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer-vaapi

systemctl enable dnsmasq stubby chronyd vnstatd
