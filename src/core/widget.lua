-- lua/SapphireUI/core/widget.lua

local Widget = {}
Widget.__index = Widget

function Widget.new(x, y, width, height, parent)
    local self = setmetatable({}, Widget)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.parent = parent
    self.children = {}
    self.visible = true
    return self
end

function Widget:add_child(child)
    table.insert(self.children, child)
    child.parent = self
end

function Widget:draw(term)
    if not self.visible then return end
    for _, child in ipairs(self.children) do
        child:draw(term)
    end
end

function Widget:handle_event(event_type, ...)
    if not self.visible then return false end
    for _, child in ipairs(self.children) do
        if child:handle_event(event_type, ...) then
            return true
        end
    end
    return false
end

return Widget
