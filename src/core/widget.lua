-- lua/SapphireUI/core/widget.lua

local Widget = {}
Widget.__index = Widget

function Widget.new(options)
    local self = setmetatable({}, Widget)
    self.x = options.x or 1
    self.y = options.y or 1
    self.width = options.width or 0
    self.height = options.height or 0
    self.parent = options.parent or nil
    self.children = {}
    self.visible = options.visible ~= false -- Default to true

    -- Allow setting other properties from options
    for k, v in pairs(options) do
        if self[k] == nil then
            self[k] = v
        end
    end

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
