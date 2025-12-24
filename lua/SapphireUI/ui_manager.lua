-- lua/SapphireUI/ui_manager.lua

local Widget = require("SapphireUI.core.widget")
local Event = require("SapphireUI.core.event")

local UIManager = {}
UIManager.__index = UIManager

function UIManager.new(terminal)
    local self = setmetatable({}, UIManager)
    self.term = terminal
    self.width, self.height = self.term.getSize()
    self.root = Widget.new(1, 1, self.width, self.height, nil)
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
