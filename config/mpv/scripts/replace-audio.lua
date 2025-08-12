-- 修改extensions来增加更多格式支持

local utils = require 'mp.utils'

function replace_audio()
    local video_path = mp.get_property("path")
    if not video_path or video_path:sub(1, 1) == "?" then return end
    
    local video_dir, video_filename = utils.split_path(video_path)
    local audio_dir = utils.join_path(video_dir, "audio")
    
    -- 检查audio目录是否存在
    local dir_info = utils.file_info(audio_dir)
    if not dir_info or not dir_info.is_dir then return end
    
    -- 提取视频文件名（不含扩展名）
    local base_name = video_filename:match("(.+)%..+$") or video_filename
    
    -- 支持的音频扩展名
    local extensions = {".mp3", ".m4a", ".flac", ".wav", ".ogg", ".aac"}
    
    -- 查找匹配的音频文件
    for _, ext in ipairs(extensions) do
        local audio_path = utils.join_path(audio_dir, base_name .. ext)
        if utils.file_info(audio_path) then
            mp.commandv("audio-add", audio_path, "select")
            mp.osd_message("已替换音频: " .. audio_path)
            return
        end
    end
end

-- 视频加载完成后触发检测
mp.register_event("file-loaded", replace_audio)
