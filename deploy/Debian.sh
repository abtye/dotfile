#!/usr/bin/bash

sudo apt update -y
# Kernel
sudo apt install -y linux-image-amd64 
# DE
sudo apt install -y labwc foot foot-themes wofi mako-notifier brightnessctl nwg-look mpv waybar
# Fcitx 5
sudo apt install -y fcitx5 fcitx5-rime fcitx5-frontend-all
# Tool
sudo apt install -y vim git fzf fish ffmpeg apt-file
# Audio
sudo apt install -y pipewire pipewire-pulse pipewire-jack 
# Driver
sudo apt install -y intel-media-va-driver 
# Font
sudo apt install -y fonts-noto-cjk fonts-noto-color-emoji
# Network
sudo apt install -y network-manager network-manager-l10n

sudo apt install -y
sudo apt install -y
sudo apt install -y
sudo apt install -y


sudo pacman -S --needed sof-firmware
sudo pacman -S --needed vim git fzf fish ffmpeg fuse2 libdecor libnotify grim slurp earlyoom cliphist chrony
sudo pacman -S --needed foot wofi mako jq brightnessctl nwg-look xdg-desktop-portal-wlr xdg-desktop-portal-gtk waybar wl-clipboard mate-polkit qt6ct sound-theme-freedesktop zenity
sudo pacman -S --needed fcitx5-im fcitx-rime kwindowsystem
sudo pacman -S --needed vulkan-intel vpl-gpu-rt intel-compute-runtime intel-media-driver intel-ucode
sudo pacman -S --needed adobe-source-han-sans-cn-fonts adobe-source-han-sans-kr-fonts otf-codenewroman-nerd otf-font-awesome noto-fonts-emoji noto-fonts
sudo pacman -S --needed wireless-regdb networkmanager
sudo pacman -S --needed pipewire-alsa pipewire-pulse pipewire-jack
sudo pacman -S --needed gst-plugin-pipewire gst-plugin-qsv gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer-vaapi
