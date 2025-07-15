echo -e "\x1b[32m如果为0说明正常\x1b[0m"
sudo smartctl -a /dev/nvme0 | grep "Media and Data Integrity Errors"
