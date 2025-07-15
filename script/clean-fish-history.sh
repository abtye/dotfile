#!/usr/bin/fish

history delete --prefix "c " "cat " "cd" "chmod " "clear " "cp " "echo " "history " "ll " "ls " "mpv " "mv " "pac " "rm " "wc " "spac " "sudo " "vim " "ks " "sed " "systemctl"
history delete --excat labwc poweroff reboot
history delete --prefix sort base

echo -e "\033[31m现行数"
history | wc -l
echo -e "\033[0m"
