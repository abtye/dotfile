-- 在倍速时自动切换配置文件和声音
mp.observe_property("speed", "number", function(_, speed)
  if speed > 2 then
    mp.set_property("profile", "fast")
--    mp.set_property("audio", "no")
    mp.set_property("glsl-shaders", "")
  else
    mp.set_property("profile", "gpu-hq")
--    mp.set_property("audio", "auto")
    mp.set_property("glsl-shaders", "~~/shaders/Anime4K_Restore_CNN_S.glsl")
  end
end)
