-- lua/SapphireUI/widgets/label.lua

local Widget = require("lib/SapphireUI.core.widget")

local Label = {}
Label.__index = Label
setmetatable(Label, { __index = Widget })

function Label.new(text, x, y, parent)
    local self = setmetatable(Widget.new(x, y, #text, 1, parent), Label)
    self.text = text
    return self
end

function Label:draw(term, theme)
    if not self.visible then return end

    local old_fg = term.getTextColor()
    term.setTextColor(theme.label_fg or colors.white)
    term.setCursorPos(self.x, self.y)
    term.write(self.text)
    term.setTextColor(old_fg)

    for _, child in ipairs(self.children) do
        child:draw(term, theme)
    end
end

return Label
