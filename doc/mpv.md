# MPV

## Shader

测试视频

- 《轻音少女第二季》第一集00:00:44.044


但是设备性能跟不上 Anime4K，开启后 mistimed 和 delayed 都一直增加

> 使用`Tab`或`Shift + I`查看

Anime4K 全开和只开`Restore_CNN_S`差不多

`Anime4K 全开 > Restore_CNN_S > AMD_FSR_RCAS_luma_RT > adaptive_sharpen_luma_RT`

```
第一次测试
Anime4K S 20921 40649
AMD       17037 33643
Anime4K S 21472 43591
```

### 注释

- `adaptive sharpen luma RT`边缘锯齿化严重
- `adaptive sharpen RT`
- `AMD FSR RCAS luma RT` 优秀
- `AMD_FSR_RCAS_rgb_RT` 略有区别
- `AMD_FSR_rgb_RT` 略有区别
- `AMD_FSR_RT` 略有区别
- 只开`Anime4K_Clamp_Highlights`和`Anime4K_Restore_CNN_M`画面会变暗，如果去掉`Anime4K_Clamp_Highlights`或加上`Anime4K_Upscale_CNN_x2_M`就会恢复

