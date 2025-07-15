local assdraw = require 'mp.assdraw'
local msg = require 'mp.msg'

mp.observe_property("sub-text", "string", function(_, value)
    if value and value:match("^{\\\\.*\\fn[^\\}]*}.*") then
        local new_text = value:gsub("\\fn([^\\}]+)", function(font)
            local fonts = mp.get_property_native("options/fonts")
            local exists = false
            for _, f in ipairs(fonts) do
                if f:lower() == font:lower() then exists = true end
            end
            return exists and ("\\fn"..font) or "\\fnLast Resort"
        end)
        mp.set_property("sub-text", new_text)
    end
end)
