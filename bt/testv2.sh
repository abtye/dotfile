#!/bin/bash

# 检查是否提供了文件名作为参数
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <file>"
    exit 1
fi

input_file="$1"
output_file="trackers_best.txt"
log_file="/tmp/bt-test.log"
timeout=1

# 清空输出文件和日志文件
> "$output_file"
> "$log_file"

# 检查文件是否存在
if [ ! -f "$input_file" ]; then
    echo -e "\033[31m输入文件不存在\033[0m" | tee -a "$log_file"
    exit 1
fi

# 检查必要命令
required_commands=("curl" "nc" "wscat")
missing_commands=()

for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        missing_commands+=("$cmd")
    fi
done

if [ ${#missing_commands[@]} -gt 0 ]; then
    echo "以下命令未安装: ${missing_commands[*]}" | tee -a "$log_file"
    exit 1
fi

# 计算总行数
total_lines=$(wc -l < "$input_file")
current_line=0

# 记录开始时间
start_time=$(date +%s)

# 读取文件并逐行处理
while IFS= read -r tracker; do
    ((current_line++))
    progress=$((current_line * 100 / total_lines))
    echo -ne "\r${progress}% ${current_line}/${total_lines}"
    
    protocol=$(echo "$tracker" | grep -oE '^[a-z]+')
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    log_entry="$timestamp [$protocol] $tracker"

    case $protocol in
        http|https)
            if curl -s -f -m $timeout "$tracker" &>/dev/null; then
                echo -e "\033[32m成功: $tracker\033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m失败: $tracker\033[0m"
                echo "失败: $log_entry" >> "$log_file"
            fi
            ;;
        udp)
            host=$(echo "$tracker" | cut -d'/' -f3)
            port=$(echo "$host" | cut -d':' -f2)
            host=$(echo "$host" | cut -d':' -f1)
            if nc -zuv -w $timeout "$host" "$port" &>/dev/null; then
                echo -e "\033[32m成功: $tracker\033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m失败: $tracker\033[0m"
                echo "失败: $log_entry" >> "$log_file"
            fi
            ;;
        wss)
            if wscat -c "$tracker" --timeout $timeout &>/dev/null; then
                echo -e "\033[32m成功: $tracker\033[0m"
                echo "$tracker" >> "$output_file"
            else
                echo -e "\033[31m失败: $tracker\033[0m"
                echo "失败: $log_entry" >> "$log_file"
            fi
            ;;
        *)
            echo -e "\033[31m未知协议: $tracker\033[0m"
            echo "未知协议: $log_entry" >> "$log_file"
            ;;
    esac
done < "$input_file"

# 计算总耗时
end_time=$(date +%s)
duration=$((end_time - start_time))

echo -e "\n\n完成! 耗时: ${duration}秒"
echo "有效tracker已保存到: $output_file"
echo "共 `wc -l < $output_file` 行"
echo "失败和未知协议的tracker已记录到: $log_file"
