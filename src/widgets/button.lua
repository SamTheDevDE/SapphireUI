--- Button Widget
-- @class Button
local Widget = require("core.widget")
local Renderer = require("core.renderer")
local SapphireUI = require("init")

local Button = {}
Button.__index = Button
setmetatable(Button, Widget)

--- Creates a new Button.
-- @param text The text to display on the button.
-- @param x The x-coordinate.
-- @param y The y-coordinate.
-- @param width The width of the button.
-- @param height The height of the button.
-- @param parent The parent widget.
-- @return A new Button object.
function Button.new(text, x, y, width, height, parent)
    local self = Widget.new(x, y, width, height, parent)
    self.text = text
    self.focusable = true
    self.on_click = nil
    setmetatable(self, Button)
    return self
end

--- Draws the button.
function Button:draw()
    local theme = SapphireUI.theme.Button
    local bg, fg
    if self.focused then
        bg = theme.focused_background
        fg = theme.focused_foreground
    else
        bg = theme.background
        fg = theme.foreground
    end

    Renderer.term.setBackgroundColor(bg)
    Renderer.term.setTextColor(fg)

    local text_x = self.x + math.floor((self.width - #self.text) / 2)
    local text_y = self.y + math.floor((self.height - 1) / 2)

    for i = 0, self.height - 1 do
        Renderer.term.setCursorPos(self.x, self.y + i)
        Renderer.term.write(string.rep(" ", self.width))
    end

    Renderer.term.setCursorPos(text_x, text_y)
    Renderer.term.write(self.text)
end

--- Handles an event.
-- @param event_data The event data.
function Button:handle_event(event_data)
    local event_type = event_data[1]
    if event_type == "mouse_click" and self.on_click then
        local button, x, y = event_data[2], event_data[3], event_data[4]
        if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
            self.on_click()
        end
    end
end

return Button
