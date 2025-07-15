#!/bin/bash

# 设置输出颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 定义语言数组
declare -A languages=(
    # 东亚语言
    ["zh-CN"]="简体中文 (Simplified Chinese)"
    ["zh-TW"]="繁体中文 (Traditional Chinese)"
    ["zh-HK"]="香港繁体 (Hong Kong Chinese)"
    ["ja"]="日语 (Japanese)"
    ["ko"]="韩语 (Korean)"
    
    # 东南亚语言
    ["th"]="泰语 (Thai)"
    ["vi"]="越南语 (Vietnamese)"
    ["km"]="柬埔寨语 (Khmer)"
    ["my"]="缅甸语 (Burmese)"
    ["lo"]="老挝语 (Lao)"
    
    # 南亚语言
    ["hi"]="印地语 (Hindi)"
    ["bn"]="孟加拉语 (Bengali)"
    ["ta"]="泰米尔语 (Tamil)"
    ["te"]="泰卢固语 (Telugu)"
    ["ml"]="马拉雅拉姆语 (Malayalam)"
    
    # 中东语言
    ["ar"]="阿拉伯语 (Arabic)"
    ["fa"]="波斯语 (Persian)"
    ["he"]="希伯来语 (Hebrew)"
    ["ur"]="乌尔都语 (Urdu)"
    
    # 欧洲语言
    ["ru"]="俄语 (Russian)"
    ["el"]="希腊语 (Greek)"
    ["uk"]="乌克兰语 (Ukrainian)"
    ["pl"]="波兰语 (Polish)"
    ["cs"]="捷克语 (Czech)"
    ["hu"]="匈牙利语 (Hungarian)"
    
    # 其他语言系统
    ["am"]="阿姆哈拉语 (Amharic)"
    ["ka"]="格鲁吉亚语 (Georgian)"
    ["ti"]="提格雷尼亚语 (Tigrinya)"
    ["si"]="僧伽罗语 (Sinhala)"
    ["bo"]="藏语 (Tibetan)"
)

echo -e "${BLUE}开始检查各种语言的字体配置...${NC}\n"

# 检查字体族
check_font_family() {
    local lang=$1
    local family=$2
    local result=$(fc-match "$family:lang=$lang" --format="%{family[0]}\n")
    echo -e "  ${GREEN}$family:${NC} $result"
}

# 主循环
for lang in "${!languages[@]}"; do
    echo -e "${BLUE}检查 ${languages[$lang]} ($lang)${NC}"
    check_font_family "$lang" "sans-serif"
    check_font_family "$lang" "serif"
    check_font_family "$lang" "monospace"
    echo ""
done

echo -e "${BLUE}字体检查完成！${NC}"
echo -e "${GREEN}提示：${NC}"
echo "1. 如果看到 'Noto Sans/Serif' 后面没有具体的语言标识，可能意味着该语言缺少专门的字体"
echo "2. 建议安装对应的 Noto 字体，例如："
echo "   - 泰语: noto-fonts-thai"
echo "   - 阿拉伯语: noto-fonts-arabic"
echo "   - 等等..." 