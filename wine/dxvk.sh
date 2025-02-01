#!/bin/bash

# 定义目录变量
DXVK_DIR="$PWD/dxvk"
WINE_SYSTEM32="$HOME/.wine/drive_c/windows/system32"
WINE_SYSWOW64="/home/lin/.wine/drive_c/windows/syswow64"

# 检查dxvk目录是否存在
if [ ! -d "$DXVK_DIR" ]; then
    echo "dxvk目录不存在"
    exit 1
fi

# 复制DLL文件到对应的Wine目录
cp -v "$DXVK_DIR/x64/"*.dll "$WINE_SYSTEM32/"
cp -v "$DXVK_DIR/x32/"*.dll "$WINE_SYSWOW64/"

# 遍历x64和x32目录中的DLL文件，并添加注册表覆盖项目
for ARCH in "x64" "x32"; do
    DLL_DIR="$DXVK_DIR/$ARCH"
    for DLL in "$DLL_DIR"/*.dll; do
        # 获取不带扩展名的DLL文件名
        DLL_NAME=$(basename "$DLL" .dll)
        # 生成命令
        WINE_REG_CMD="wine reg add 'HKEY_CURRENT_USER\\Software\\Wine\\DllOverrides' /v \"$DLL_NAME\" /d native /f"
        
        # 执行注册表添加命令
        echo -e "\033[32m 执行：$WINE_REG_CMD \033[0m"
        eval $WINE_REG_CMD
    done
done

echo -e "\033[32m完成\033[0m"
