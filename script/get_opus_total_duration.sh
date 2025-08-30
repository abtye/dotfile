A=$1
if [$A]; then
    echo 1
fi

exit
find . -type f -name "*.opus" -exec ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 {} \; | awk '{sum += $1} END
 {printf "总时长: %d小时%d分钟%.2f秒\n", sum/3600, sum%3600/60, sum%60}'
