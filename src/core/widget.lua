--- Base Widget Class
-- @class Widget
local Widget = {}
Widget.__index = Widget

--- Creates a new Widget.
-- @param x The x-coordinate of the widget.
-- @param y The y-coordinate of the widget.
-- @param width The width of the widget.
-- @param height The height of the widget.
-- @param parent The parent widget.
-- @return A new Widget object.
function Widget.new(x, y, width, height, parent)
    local self = setmetatable({}, Widget)
    self.x = x or 1
    self.y = y or 1
    self.width = width or 10
    self.height = height or 5
    self.parent = parent
    self.children = {}
    self.visible = true
    self.focusable = false
    self.focused = false
    return self
end

--- Adds a child widget to this widget.
-- @param child The child widget to add.
function Widget:add_child(child)
    child.parent = self
    table.insert(self.children, child)
end

--- Handles an event.
-- This is a placeholder and should be overridden by subclasses.
-- @param event_data The event data.
function Widget:handle_event(event_data)
    for _, child in ipairs(self.children) do
        if child.visible then
            child:handle_event(event_data)
        end
    end
end

--- Draws the widget.
-- This is a placeholder and should be overridden by subclasses.
function Widget:draw()
    -- Base draw function, does nothing.
end

return Widget
