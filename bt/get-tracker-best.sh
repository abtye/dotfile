#!/bin/bash

# 定义下载链接
url1="https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_best.txt"
url2="https://cdn.jsdelivr.net/gh/XIU2/TrackersListCollection@master/best.txt"
url3="https://cdn.jsdelivr.net/gh/adysec/tracker@main/trackers_best.txt"
url4="https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/AT_best.txt"

# 定义下载函数，最多尝试3次
download_file() {
    local url=$1
    local output_file=$2
    local retries=3
    local attempt=0

    while [ $attempt -lt $retries ]; do
        if curl -s -o "$output_file" "$url"; then
            return 0
        else
            attempt=$((attempt + 1))
            echo "Download attempt $attempt failed for $url"
        fi
    done

    echo "Failed to download $url after $retries attempts"
    return 1
}

# 下载文件
download_file "$url1" "file1.txt" || exit 1
download_file "$url2" "file2.txt" || exit 1
download_file "$url3" "file3.txt" || exit 1
download_file "$url4" "file4.txt" || exit 1

# 合并文件并去重、去空行
cat file1.txt file2.txt file3.txt file4.txt | sort | uniq | sed '/^\s*$/d' > all.txt

# 调用测试脚本
./test_trackers.sh all.txt

# 清理临时文件
rm -f file1.txt file2.txt file3.txt file4.txt
