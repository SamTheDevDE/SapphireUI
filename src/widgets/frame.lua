--- Frame Widget
-- @class Frame
local Widget = require("core.widget")
local Renderer = require("core.renderer")
local SapphireUI = require("init")

local Frame = {}
Frame.__index = Frame
setmetatable(Frame, Widget)

--- Creates a new Frame.
-- @param x The x-coordinate.
-- @param y The y-coordinate.
-- @param width The width.
-- @param height The height.
-- @param parent The parent widget.
-- @return A new Frame object.
function Frame.new(x, y, width, height, parent)
    local self = Widget.new(x, y, width, height, parent)
    setmetatable(self, Frame)
    return self
end

--- Draws the frame.
function Frame:draw()
    local theme = SapphireUI.theme.Frame
    Renderer.term.setBackgroundColor(theme.background)
    Renderer.term.setTextColor(theme.foreground)
    
    local w, h = self.width, self.height
    local x, y = self.x, self.y

    for i = y, y + h - 1 do
        Renderer.term.setCursorPos(x, i)
        Renderer.term.write(string.rep(" ", w))
    end
end

return Frame
