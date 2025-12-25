-- lua/SapphireUI/widgets/frame.lua

local Widget = require("lib/SapphireUI.core.widget")

local Frame = {}
Frame.__index = Frame
setmetatable(Frame, { __index = Widget })

function Frame.new(options)
    local self = setmetatable(Widget.new(options), Frame)

    -- Allow setting other properties from options
    for k, v in pairs(options) do
        if self[k] == nil then
            self[k] = v
        end
    end

    return self
end

function Frame:draw(term, theme)
    if not self.visible then return end

    local old_bg = term.getBackgroundColor()
    term.setBackgroundColor(theme.frame_bg or colors.black)
    term.setCursorPos(self.x, self.y)
    for i = 1, self.height do
        term.write(string.rep(" ", self.width))
        term.setCursorPos(self.x, self.y + i)
    end

    term.setBackgroundColor(old_bg)

    for _, child in ipairs(self.children) do
        child:draw(term, theme)
    end
end

return Frame
