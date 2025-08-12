# 解决TCL无法adb install安装app的问题

问题:
开启adb后，电视能连接成功，但是使用adb install安装app会提示错误“install apk has be disabled from pm by system default!”
解决方法：
命令依次如下：

```bash
adb shell
setprop persist.TCL.debug.installapk 1
setprop persist.tcl.installapk.enable 1
```
