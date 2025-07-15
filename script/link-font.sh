#!/bin/bash

# 定义源字体目录和目标链接目录
SOURCE_FONTS_DIR="/mnt/data/super-font超级字体整合包 XZ"
TARGET_LINKS_DIR="$HOME/.config/mpv/fonts"

# 检查源目录是否存在
if [ ! -d "$SOURCE_FONTS_DIR" ]; then
    echo "错误：源字体目录不存在 $SOURCE_FONTS_DIR"
    exit 1
fi

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_LINKS_DIR" || {
    echo "错误：无法创建目标目录 $TARGET_LINKS_DIR"
    exit 1
}

# 声明关联数组用于跟踪已处理的字体名称
declare -A processed_fonts

# 先处理.otf文件（优先级最高）
find "$SOURCE_FONTS_DIR" -type f -iname "*.otf" | while read -r font_file; do
    # 获取不含扩展名的文件名（小写处理）
    filename=$(basename "$font_file" | awk '{print tolower($0)}')
    font_name=${filename%.*}
    
    # 如果尚未处理过这个字体名称
    if [ -z "${processed_fonts[$font_name]}" ]; then
        # 创建软链接（保持原文件名大小写）
        original_filename=$(basename "$font_file")
        ln -sf "$font_file" "$TARGET_LINKS_DIR/$original_filename"
        processed_fonts[$font_name]=1
        echo "已创建链接(OTF优先): $TARGET_LINKS_DIR/$original_filename → $font_file"
    fi
done

# 然后处理.ttf和.ttc文件
find "$SOURCE_FONTS_DIR" -type f \( -iname "*.ttf" -o -iname "*.ttc" \) | while read -r font_file; do
    # 获取不含扩展名的文件名（小写处理）
    filename=$(basename "$font_file" | awk '{print tolower($0)}')
    font_name=${filename%.*}
    
    # 如果尚未处理过这个字体名称
    if [ -z "${processed_fonts[$font_name]}" ]; then
        # 创建软链接（保持原文件名大小写）
        original_filename=$(basename "$font_file")
        ln -sf "$font_file" "$TARGET_LINKS_DIR/$original_filename"
        processed_fonts[$font_name]=1
        echo "已创建链接: $TARGET_LINKS_DIR/$original_filename → $font_file"
    else
        original_filename=$(basename "$font_file")
        echo "跳过: $original_filename (已有更高优先级的OTF版本)"
    fi
done

echo "字体链接创建完成！"
echo "总计处理字体数量: ${#processed_fonts[@]}"
