#!/bin/bash

# 配置目录
CONFIG_DIR="$PWD/../config"

# 用户配置目录
USER_CONFIG_DIR="$HOME/.config"

# 要替换的目录
CONFIG_FOLDERS=(
    "vim"
    "fcitx5"
    "fontconfig"
    "foot"
    "fsearch"
    "labwc"
    "mako"
    "mpv"
    "waybar"
    "wofi"
)

# 删除旧配置
for folder in "${CONFIG_FOLDERS[@]}"; do
    # 解析目标路径，如果是目录则添加斜杠
    source_path="$CONFIG_DIR/$folder"
    target_path="$USER_CONFIG_DIR/$folder"
    # 判断目标文件是否存在，有则删除
    if [ -e "$target_path" ]; then
        rm -rvf "$target_path"
    fi
    ln -svf "$source_path" "$target_path"
    # 检查是否存在并删除文件或目录

done

# 链接文件
ln -svf $CONFIG_DIR/1.fish $USER_CONFIG_DIR/fish/conf.d/1.fish
ln -svf $CONFIG_DIR/color.fish $USER_CONFIG_DIR/fish/conf.d/color.fish
ln -svf $CONFIG_DIR/chromium-flags.conf $USER_CONFIG_DIR/chromium-flags.conf
ln -svf $CONFIG_DIR/drirc $HOME/.drirc
mkdir -p /home/lin/.local/share/themes/Onyx-black/openbox-3
ln -svf $CONFIG_DIR/labwc.themerc /home/lin/.local/share/themes/Onyx-black/openbox-3/themerc

echo "配置更新成功"
