-- lua/SapphireUI/widgets/frame.lua

local Widget = require("lib/SapphireUI.core.widget")

local Frame = {}
Frame.__index = Frame
setmetatable(Frame, { __index = Widget })

function Frame.new(options)
    if options == nil then
        options = {}
    elseif type(options) ~= "table" then
        error("Expected options to be a table, got " .. type(options))
    end

    local self = setmetatable(Widget.new(options), Frame)
    
    -- Frame-specific properties
    self.title = options.title or ""
    self.backgroundColor = options.backgroundColor or colors.black
    self.foregroundColor = options.foregroundColor or colors.white
    self.titleColor = options.titleColor or colors.white
    self.borderColor = options.borderColor or colors.white
    self.draggable = options.draggable or false
    self.dragging = false
    self.drag_start_x = 0
    self.drag_start_y = 0

    return self
end

function Frame:draw(term, theme)
    if not self.visible then return end

    local old_bg = term.getBackgroundColor()
    local old_fg = term.getTextColor()

    term.setBackgroundColor(self.backgroundColor)
    term.setTextColor(self.foregroundColor)

    -- Draw background
    for i = 0, self.height - 1 do
        term.setCursorPos(self.x, self.y + i)
        term.write(string.rep(" ", self.width))
    end

    -- Draw title if present
    if self.title and #self.title > 0 then
        term.setTextColor(self.titleColor)
        local title_x = self.x + math.floor((self.width - #self.title) / 2)
        term.setCursorPos(title_x, self.y)
        term.write(self.title)
    end

    term.setBackgroundColor(old_bg)
    term.setTextColor(old_fg)

    -- Draw children
    for _, child in ipairs(self.children) do
        child:draw(term, theme)
    end
end

function Frame:handle_event(event_type, x, y, button)
    if not self.visible then return false end

    -- Handle dragging
    if self.draggable then
        if event_type == "mouse_click" and button == 1 then
            if x >= self.x and x < self.x + self.width and
               y >= self.y and y == self.y then
                self.dragging = true
                self.drag_start_x = x - self.x
                self.drag_start_y = y - self.y
                return true
            end
        elseif event_type == "mouse_drag" and self.dragging then
            self.x = x - self.drag_start_x
            self.y = y - self.drag_start_y
            return true
        elseif event_type == "mouse_up" then
            self.dragging = false
            return true
        end
    end

    -- Handle children
    for _, child in ipairs(self.children) do
        if child:handle_event(event_type, x, y, button) then
            return true
        end
    end

    return false
end

return Frame
