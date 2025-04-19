echo -e "\033[32m CPU 可用调度策略 \033[0m"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors
echo -e "----------"

echo -e "\033[32m CPU 当前调度策略 \033[0m"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo -e "----------"

echo -e "\033[32m 电池剩余 \033[0m"
cat /sys/class/power_supply/BAT0/capacity
cat /sys/class/power_supply/BAT0/status
echo -e "----------"

echo -e "\033[32m IO 调度器 \033[0m"
cat /sys/block/*/queue/scheduler
echo -e "----------"

echo -e "\033[32m CPU 时钟源 \033[0m"
echo ">---可用时钟源"
cat /sys/devices/system/clocksource/clocksource*/available_clocksource
echo ">---当前时钟源"
cat /sys/devices/system/clocksource/clocksource*/current_clocksource
echo -e "----------"

echo -e "\033[32m 内存脏数据写回时间（ms） \033[0m"
cat /proc/sys/vm/dirty_writeback_centisecs
echo -e "----------"

echo -e "\033[32m 内核参数 \033[0m"
cat /proc/cmdline
echo -e "----------"
