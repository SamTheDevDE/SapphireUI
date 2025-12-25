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
    if type(options) ~= "table" then
        options = {}
    end
    
    local widget = self:create_widget(widget_type, options)
    table.insert(self.widgets, widget)
    return widget
end

function UIManager:create_widget(widget_type, options)
    if type(options) ~= "table" then
        error("Expected options to be a table, got " .. type(options))
    end
    
    local widget_class = self.widget_types[widget_type]
    if not widget_class then
        error("Unknown widget type: " .. tostring(widget_type))
    end
    
    options.manager = self
    local widget = widget_class.new(options)
    return widget
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
