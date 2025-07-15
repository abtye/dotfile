# git如何进行断点续传

当git项目较大或网速不快的情况下，git clone可能会中断导致要重新操作，那如何进行断点续传呢

1. 新建目录, 命令行进入目录，执行 `git init`
2. 命令行执行： `git fetch [项目地址]`
3. 若断掉后，重复执行步骤2， 直到完成下载
4. 命令行执行 `git checkout FETCH_HEAD`

5.命令行执行 `git remote add origin [项目地址]`

6. 命令行执行 `git pull origin master`

7.命令行执行 `git checkout master`

 

为了在断掉后，自动git fetch, 我写了一个bash脚本样例， 会循环执行，重试2000次，直到成功后退出

```sh
#!/bin/bash
set -x

num=1
while [ $num -le 2000 ]; do
   git fetch http://xxx.xxx.net/abc/abc-desktop.git
   if [ $? -ne 0 ]; then
       num=$(($num+1))
   else
       break
   fi
done
```
