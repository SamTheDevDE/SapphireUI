-- lua/SapphireUI/core/event.lua

local Event = {}

function Event.poll(ui_manager)
    while ui_manager.running do
        local event_data = {os.pullEvent()}
        local event_type = event_data[1]

        -- Call custom event handlers if registered
        if ui_manager.event_handlers[event_type] then
            for _, handler in ipairs(ui_manager.event_handlers[event_type]) do
                handler(table.unpack(event_data, 2))
            end
        end

        -- Handle widget events
        ui_manager:handle_event(event_type, table.unpack(event_data, 2))
        ui_manager:draw()

        -- Check for exit key combination (Ctrl+C)
        if event_type == "key" and event_data[2] == keys.c then
            ui_manager:stop()
        end
    end
end

return Event
