#!/bin/bash

# 启用错误检查和安全特性
set -euo pipefail

# 定义常量
readonly TRACKER_URLS=(
    "https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_best.txt"
    "https://cdn.jsdelivr.net/gh/XIU2/TrackersListCollection@master/best.txt"
    "https://cdn.jsdelivr.net/gh/adysec/tracker@main/trackers_best.txt"
    "https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/AT_best.txt"
    "https://newtrackon.com/api/live"
)

# 临时文件目录
readonly TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# 下载函数，带重试机制
download_file() {
    local url=$1
    local output_file=$2
    local max_retries=3
    local retry_delay=2
    
    for ((attempt=1; attempt<=max_retries; attempt++)); do
        if curl -sSf --connect-timeout 30 --max-time 60 -o "$output_file" "$url"; then
            return 0
        fi
        
        echo "Download attempt $attempt failed for $url" >&2
        if [[ $attempt -lt $max_retries ]]; then
            sleep $retry_delay
        fi
    done
    
    echo "Error: Failed to download $url after $max_retries attempts" >&2
    return 1
}

# 并行下载所有文件
download_all_files() {
    local pid_list=()
    local file_index=1
    
    for url in "${TRACKER_URLS[@]}"; do
        local output_file="$TEMP_DIR/file${file_index}.txt"
        download_file "$url" "$output_file" &
        pid_list+=($!)
        ((file_index++))
    done
    
    # 等待所有下载完成
    for pid in "${pid_list[@]}"; do
        wait "$pid" || echo "某个下载进程失败" >&2
    done
}

# 合并和去重处理
merge_and_filter() {
    local output_file="$1"
    
    # 合并文件，去重，去除空行和注释行
    cat "$TEMP_DIR"/file*.txt | \
        grep -v '^\s*$' | \
        grep -v '^\s*#' | \
        sort -u > "$output_file"
    
    echo "成功创建 $(wc -l < "$output_file") 行 tracker list"
}

main() {
    local output_file="all.txt"
    
    echo "开始下载"
    download_all_files
    
    echo "合并文件"
    merge_and_filter "$output_file"
    
    if [[ -x "./testv2.sh" ]]; then
        echo "进行测试"
        ./testv2.sh "$output_file"
    else
        echo "找不到 testv2.sh 或 不可执行" >&2
    fi
    
    echo "完成"
}

main
