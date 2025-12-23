--- SapphireUI Core
-- @class SapphireUI
local SapphireUI = {}

SapphireUI.version = "0.1.0"

-- Core components
SapphireUI.Widget = require("core.widget")
SapphireUI.Renderer = require("core.renderer")
SapphireUI.Event = require("core.event")

-- Global state
SapphireUI.running = false
SapphireUI.active_screen = nil
SapphireUI.theme = require("SapphireUI.themes.default")

--- Initializes the UI framework.
-- @param term The terminal object to draw on.
function SapphireUI.init(term)
    SapphireUI.Renderer.term = term or term_native or window
    SapphireUI.Event.start()
end

--- Sets the active screen to be rendered.
-- @param screen A widget object to be set as the active screen.
function SapphireUI.set_screen(screen)
    SapphireUI.active_screen = screen
end

--- Main loop for the UI framework.
function SapphireUI.run()
    SapphireUI.running = true
    while SapphireUI.running do
        local event_data = {SapphireUI.Event.pull()}
        
        if event_data[1] == "terminate" then
            SapphireUI.running = false
        end

        if SapphireUI.active_screen then
            SapphireUI.active_screen:handle_event(event_data)
            if not SapphireUI.running then break end
            SapphireUI.Renderer.draw(SapphireUI.active_screen)
        end
        
        sleep(0)
    end
end

--- Stops the main loop.
function SapphireUI.quit()
    SapphireUI.running = false
end

return SapphireUI
