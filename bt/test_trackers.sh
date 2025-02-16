#!/bin/bash

# 检查是否提供了文件名作为参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <file>"
    exit 1
fi

input_file="$1"
output_file="trackers_best.txt"

# 检查文件是否存在
if [ ! -f "$input_file" ]; then
    echo -e "\033[31m 输入文件不存在 \033[0m"
    exit 1
fi

# 清空输出文件
> "$output_file"

# 计算行号
a=0
lines=`cat $input_file | wc -l`
# 读取文件并逐行处理
while IFS= read -r tracker; do
    a=`expr $a + 1`
    echo `expr $a \* 100 / $lines`% $a \/ $lines
    protocol=$(echo "$tracker" | grep -oE '^[a-z]+')

    case $protocol in
        http)
            if curl -s -f -m 1 "$tracker" &>/dev/null; then
                echo -e "\033[32m 成功： $tracker \033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m 失败： $tracker \033[0m"
            fi
            ;;
        https)
            if curl -s -f -m 1 "$tracker" &>/dev/null; then
                echo -e "\033[32m 成功： $tracker \033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m 失败： $tracker \033[0m"
            fi
            ;;
        udp)
            host=$(echo "$tracker" | cut -d'/' -f3)
            port=$(echo "$host" | cut -d':' -f2)
            host=$(echo "$host" | cut -d':' -f1)
            if nc -zuv -w 1 "$host" "$port" &>/dev/null; then
                echo -e "\033[32m 成功： $tracker \033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m 失败： $tracker \033[0m"
            fi
            ;;
        wss)
            if wscat -c "$tracker" --timeout 1 &>/dev/null; then
                echo -e "\033[32m 成功： $tracker \033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m 失败： $tracker \033[0m"
            fi
            ;;
        *)
            echo -e "\033[31m 未知协议： $protocol \033[0m"
            ;;
    esac
done < "$input_file"

echo "完成"
