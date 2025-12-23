--- Label Widget
-- @class Label
local Widget = require("core.widget")
local Renderer = require("core.renderer")
local SapphireUI = require("init")

local Label = {}
Label.__index = Label
setmetatable(Label, Widget)

--- Creates a new Label.
-- @param text The text to display.
-- @param x The x-coordinate.
-- @param y The y-coordinate.
-- @param parent The parent widget.
-- @return A new Label object.
function Label.new(text, x, y, parent)
    local self = Widget.new(x, y, #text, 1, parent)
    self.text = text
    setmetatable(self, Label)
    return self
end

--- Draws the label.
function Label:draw()
    local theme = SapphireUI.theme.Label
    Renderer.term.setBackgroundColor(theme.background)
    Renderer.term.setTextColor(theme.foreground)
    Renderer.term.setCursorPos(self.x, self.y)
    Renderer.term.write(self.text)
end

return Label
