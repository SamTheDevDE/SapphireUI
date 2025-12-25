-- lua/SapphireUI/widgets/label.lua

local Widget = require("lib/SapphireUI.core.widget")

local Label = {}
Label.__index = Label
setmetatable(Label, { __index = Widget })

function Label.new(options)
    if options == nil then
        options = {}
    elseif type(options) ~= "table" then
        error("Expected options to be a table, got " .. type(options))
    end

    -- Set default width based on text if not provided
    if not options.width and options.text then
        options.width = #options.text
    elseif not options.width then
        options.width = 0
    end

    -- Height is always 1 for labels
    if not options.height then
        options.height = 1
    end

    local self = setmetatable(Widget.new(options), Label)
    
    -- Label-specific properties
    self.text = options.text or ""
    self.textColor = options.textColor or colors.white
    self.backgroundColor = options.backgroundColor or nil
    
    return self
end

function Label:setText(text)
    self.text = text
    self.width = #text
end

function Label:draw(term, theme)
    if not self.visible then return end

    local old_fg = term.getTextColor()
    local old_bg = nil
    
    if self.backgroundColor then
        old_bg = term.getBackgroundColor()
        term.setBackgroundColor(self.backgroundColor)
    end

    term.setTextColor(self.textColor)
    term.setCursorPos(self.x, self.y)
    
    -- Pad text to label width if needed
    local display_text = self.text
    if #self.text < self.width then
        display_text = self.text .. string.rep(" ", self.width - #self.text)
    end
    
    term.write(display_text)

    term.setTextColor(old_fg)
    if old_bg then
        term.setBackgroundColor(old_bg)
    end

    -- Draw children
    for _, child in ipairs(self.children) do
        child:draw(term, theme)
    end
end

function Label:handle_event(event_type, ...)
    if not self.visible then return false end
    
    -- Labels typically don't handle events, but pass to children
    for _, child in ipairs(self.children) do
        if child:handle_event(event_type, ...) then
            return true
        end
    end

    return false
end

return Label
