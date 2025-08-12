在`build.prop`中添加下面两行代码来在系统启动时自动开放无线调试端口
```conf
service.adb.tcp.port=5555
persist.service.adb.enable=1
```


