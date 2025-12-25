-- lua/SapphireUI/widgets/button.lua

local Widget = require("lib/SapphireUI.core.widget")

local Button = {}
Button.__index = Button
setmetatable(Button, { __index = Widget })

function Button.new(options)
    if options == nil then
        options = {}
    elseif type(options) ~= "table" then
        error("Expected options to be a table, got " .. type(options))
    end

    local self = setmetatable(Widget.new(options), Button)
    
    -- Button-specific properties
    self.text = options.text or "Button"
    self.onClick = options.onClick or nil
    self.backgroundColor = options.backgroundColor or colors.lightGray
    self.textColor = options.textColor or colors.black
    self.hoverBackgroundColor = options.hoverBackgroundColor or colors.white
    self.hoverTextColor = options.hoverTextColor or colors.black
    self.hovered = false
    
    return self
end

function Button:draw(term, theme)
    if not self.visible then return end

    local old_bg = term.getBackgroundColor()
    local old_fg = term.getTextColor()

    -- Use hover colors if hovering, otherwise use normal colors
    local bg = self.hovered and self.hoverBackgroundColor or self.backgroundColor
    local fg = self.hovered and self.hoverTextColor or self.textColor

    term.setBackgroundColor(bg)
    term.setTextColor(fg)

    -- Draw button background
    for i = 0, self.height - 1 do
        term.setCursorPos(self.x, self.y + i)
        term.write(string.rep(" ", self.width))
    end

    -- Draw button text (centered)
    local text_x = self.x + math.floor((self.width - #self.text) / 2)
    local text_y = self.y + math.floor((self.height - 1) / 2)
    term.setCursorPos(text_x, text_y)
    term.write(self.text)

    term.setBackgroundColor(old_bg)
    term.setTextColor(old_fg)

    -- Draw children
    for _, child in ipairs(self.children) do
        child:draw(term, theme)
    end
end

function Button:handle_event(event_type, x, y, button)
    if not self.visible then return false end

    if event_type == "mouse_move" then
        self.hovered = x >= self.x and x < self.x + self.width and
                       y >= self.y and y < self.y + self.height
        return false
    end

    if event_type == "mouse_click" and button == 1 then
        if x >= self.x and x < self.x + self.width and
           y >= self.y and y < self.y + self.height then
            if self.onClick then
                self.onClick()
                return true
            end
        end
    end

    -- Handle children
    for _, child in ipairs(self.children) do
        if child:handle_event(event_type, x, y, button) then
            return true
        end
    end

    return false
end

return Button
