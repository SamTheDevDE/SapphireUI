-- lua/SapphireUI/ui_manager.lua

local Widget = require("lib/SapphireUI.core.widget")
local Event = require("lib/SapphireUI.core.event")
local Button = require("lib/SapphireUI.widgets.button")
local Frame = require("lib/SapphireUI.widgets.frame")
local Label = require("lib/SapphireUI.widgets.label")

local UIManager = {}
UIManager.__index = UIManager

-- Widget type registry
local WIDGET_TYPES = {
    Button = Button,
    Frame = Frame,
    Label = Label
}

function UIManager.new(terminal)
    local self = setmetatable({}, UIManager)
    self.term = terminal
    self.width, self.height = self.term.getSize()
    self.root = Widget.new({
        x = 1,
        y = 1,
        width = self.width,
        height = self.height,
        manager = nil
    })
    self.root.manager = self
    self.widgets = {}
    self.theme = require("lib/SapphireUI.themes.default")
    self.running = false
    self.event_handlers = {}
    return self
end

function UIManager:set_theme(theme)
    self.theme = theme
end

function UIManager:create_widget(widget_type, options)
    if type(widget_type) ~= "string" then
        error("Expected widget_type to be a string, got " .. type(widget_type))
    end
    
    if options == nil then
        options = {}
    elseif type(options) ~= "table" then
        error("Expected options to be a table, got " .. type(options))
    end

    local widget_class = WIDGET_TYPES[widget_type]
    if not widget_class then
        error("Unknown widget type: " .. tostring(widget_type))
    end

    options.manager = self
    local widget = widget_class.new(options)
    table.insert(self.widgets, widget)
    return widget
end

function UIManager:add(widget_type, options)
    if type(widget_type) ~= "string" then
        error("Expected widget_type to be a string, got " .. type(widget_type))
    end
    
    if options == nil then
        options = {}
    elseif type(options) ~= "table" then
        error("Expected options to be a table, got " .. type(options))
    end
    
    return self:create_widget(widget_type, options)
end

function UIManager:draw()
    self.term.clear()
    self.root:draw(self.term, self.theme)
end

function UIManager:handle_event(event_type, ...)
    return self.root:handle_event(event_type, ...)
end

function UIManager:onEvent(event_type, callback)
    if not self.event_handlers[event_type] then
        self.event_handlers[event_type] = {}
    end
    table.insert(self.event_handlers[event_type], callback)
end

function UIManager:stop()
    self.running = false
end

function UIManager:run()
    self:draw()
    self.running = true
    Event.poll(self)
end

return UIManager
