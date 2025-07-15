#!/bin/bash

# 检查是否提供了目录参数，如果没有则使用当前目录
DIR=${1:-.}

# 遍历目录中的所有JPEG文件
for FILE in "$DIR"/{1..10}.jpg; do
    # 检查文件是否存在
    if [[ -f "$FILE" ]]; then
        # 提取文件名（不带扩展名）
        BASENAME=$(basename "$FILE" .jpg)
        # 生成AVIF文件的目标路径
        OUTPUT="$DIR/$BASENAME.avif"
        # 使用GraphicsMagick进行转换，并设置最高画质（Q:100）
        magick convert -quality 100 "$FILE" "$OUTPUT"
        echo "Converted $FILE to $OUTPUT"
    else
        echo "File $FILE does not exist, skipping."
    fi
done
