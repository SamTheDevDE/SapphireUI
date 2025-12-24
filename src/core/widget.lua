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

function Widget:add(widget_type, options)
    local manager = self.manager
    if not manager then
        local root = self
        while root.parent do
            root = root.parent
        end
        manager = root.manager
    end

    if not manager then
        error("Widget is not attached to a UIManager")
    end

    local new_widget = manager:create_widget(widget_type, options)
    self:add_child(new_widget)
    return new_widget
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
