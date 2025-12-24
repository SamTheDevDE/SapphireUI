-- lua/SapphireUI/ui_manager.lua

local Widget = require("lib/SapphireUI.core.widget")
local Event = require("lib/SapphireUI.core.event")

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new(terminal)
    local self = setmetatable({}, UIManager)
    self.term = terminal
    self.width, self.height = self.term.getSize()
    self.root = Widget.new(1, 1, self.width, self.height, nil)
    self.root.manager = self -- Widgets need a reference to the manager
    self.active_screen = self.root
    self.theme = {}
    return self
end

function UIManager:set_screen(screen)
    self.active_screen = screen
    self.root:add_child(screen)
end

function UIManager:set_theme(theme)
    self.theme = theme
end

function UIManager:add(widget_type, options)
    local new_widget = self:create_widget(widget_type, options)
    self.active_screen:add_child(new_widget)
    return new_widget
end

function UIManager:create_widget(widget_type, options)
    local widget_name = string.lower(widget_type)
    local WidgetClass = require("lib/SapphireUI.widgets." .. widget_name)

    -- Combine theme defaults with provided options
    local final_options = {}
    local theme_defaults = self.theme[widget_name] or {}
    for k, v in pairs(theme_defaults) do
        final_options[k] = v
    end
    for k, v in pairs(options) do
        final_options[k] = v
    end

    local new_widget = WidgetClass.new(final_options)
    new_widget.manager = self -- Pass manager reference to the new widget
    return new_widget
end

function UIManager:draw()
    self.term.clear()
    self.active_screen:draw(self.term, self.theme)
end

function UIManager:handle_event(event_type, ...)
    return self.active_screen:handle_event(event_type, ...)
end

function UIManager:run()
    self:draw()
    Event.poll(self)
end

return UIManager
