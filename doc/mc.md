# 我的世界 Minecraft

## Wayland

```
-XX:+UnlockExperimentalVMOptions -Dorg.lwjgl.glfw.libname=/path/to/libglfw.so.3.5
```

## 优化

- Sodium
- Sodium Extra
- Iris Shader
- Indium
- Lithium

## 间歇泉服务器

1. 下载`fabric-server-mc.x.x.x.-loader.x.x.x-launcher.jar`，放到一个目录里
2. 运行`java -Xmx4G -jar fabric-server-xxx.jar nogui`
3. 修改`eula.txt`
4. 修改`server.properties`的`online-mode`为`false`以支持盗版
5. 修改`config/Geyser-Fabric/config.yml`的`auth-type`为`offline`
