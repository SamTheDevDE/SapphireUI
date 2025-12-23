--- Renderer
-- @class Renderer
local Renderer = {}

Renderer.term = nil

--- Draws a widget and its children.
-- @param widget The widget to draw.
function Renderer.draw(widget)
    if not Renderer.term then
        error("Renderer.term is not set. Call SapphireUI.init(term) first.")
    end

    Renderer.term.clear()
    if widget.visible then
        widget:draw()
        for _, child in ipairs(widget.children) do
            Renderer.draw_child(child)
        end
    end
    Renderer.term.setCursorPos(1, 1) -- Hide cursor
end

--- Draws a child widget.
-- @param widget The child widget to draw.
function Renderer.draw_child(widget)
    if widget.visible then
        widget:draw()
        for _, child in ipairs(widget.children) do
            Renderer.draw_child(child)
        end
    end
end

return Renderer
