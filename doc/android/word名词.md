# 名词介绍

# GSI

Generic System Image，通用系统镜像

类似不同品牌和形态的x86电脑都能刷同一个Windows镜像

而GSI则表示安卓平台的通用镜像，只要手机支持相关的标准都可以刷，
而这个标准叫做“Project Treble”,简称PT

- GSI属于第三方系统，刷之前必须先解锁BL
- 是否支持PT可以通过`Treble Check`和`Treble Info`来查看
- PT从 Android 8 开始引入，从 Android 9 开始强制支持，支持PT则代表可以刷入GSI
- 只要手机支持SAR（System As Root），即使不支持AB分区，也要下载带AB格式的GSI刷机包

```
{arm|a64|arm64}_{a|b}{v|g}{N|S}-{vndklite|secure|personal}
|               |    |    |     |
|               |    |    |     vndklite：适用于VNDKLite设备，或常规设备可读写的 /system
|               |    |    |     secure：删除了超级用户并伪造system props，以提高通过SafetyNet的机会
|               |    |    |     personal：带有个人模组，仅供参考
|               |    |    N：无超级用户
|               |    |    S：使用PHH Superuser构建（需要app）
|               |    |    (Z)：使用eremitein的Dynamic Superuser构建（此处不提供）
|               |    |
|               |    v：原生，即无 GAPPS
|               |    g：带有常规 GAPSS
|               |    o：带有Android Go GAPPS
|               |    (f)：内置MicroG及自由开源软件的GAPPS替代方案（此处不提供）
|               |
|               a：“仅有A分区”，即system-as-system（自Android 12以来已弃用）
|               b："AB"，即system-as-root
|
arm：ARM 32位（自Android 12以来已弃用）
a64：ARM 32位，带有64位binder
arm64：ARM 64位

```

# AB分区

- Android 10 开始，大多设备都支持AB分区
- Android 12 还推出了VAB分区
