#!/usr/bin/bash

# 红色高亮警告
RED='\033[0;31m'
NC='\033[0m' # 无颜色
echo -e "${RED}警告！本脚本会清除zh_CN以外的所有locale！${NC}"

# 黄色强调提示
YELLOW='\033[1;33m'
read -p "$(echo -e ${YELLOW}"确认执行请输入大写 YES: "${NC}) " confirm

if [ "$confirm" != "YES" ]; then
    echo "操作已取消"
    exit 1
fi

find /usr/share/locale -mindepth 1 -maxdepth 1 -not \( -name "locale.alias" -o -name "zh_CN" \) -exec sudo rm -rf {} +
