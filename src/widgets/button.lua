-- lua/SapphireUI/widgets/button.lua

local Widget = require("lib/SapphireUI.core.widget")

local Button = {}
Button.__index = Button
setmetatable(Button, { __index = Widget })

function Button.new(text, x, y, width, height, parent)
    local self = setmetatable(Widget.new(x, y, width, height, parent), Button)
    self.text = text
    self.on_click = nil
    return self
end

function Button:draw(term, theme)
    if not self.visible then return end

    local old_bg = term.getBackgroundColor()
    local old_fg = term.getTextColor()

    term.setBackgroundColor(theme.button_bg or colors.gray)
    term.setTextColor(theme.button_fg or colors.black)

    term.setCursorPos(self.x, self.y)
    for i = 1, self.height do
        term.write(string.rep(" ", self.width))
        term.setCursorPos(self.x, self.y + i)
    end

    term.setCursorPos(self.x + math.floor((self.width - #self.text) / 2), self.y + math.floor((self.height - 1) / 2))
    term.write(self.text)

    term.setBackgroundColor(old_bg)
    term.setTextColor(old_fg)

    for _, child in ipairs(self.children) do
        child:draw(term, theme)
    end
end

function Button:handle_event(event_type, x, y, button)
    if not self.visible then return false end

    if event_type == "mouse_click" and button == 1 and
       x >= self.x and x < self.x + self.width and
       y >= self.y and y < self.y + self.height then
        if self.on_click then
            self.on_click()
            return true
        end
    end

    for _, child in ipairs(self.children) do
        if child:handle_event(event_type, x, y, button) then
            return true
        end
    end

    return false
end

return Button
