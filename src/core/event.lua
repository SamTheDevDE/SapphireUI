-- lua/SapphireUI/core/event.lua

local Event = {}

function Event.poll(ui_manager)
    while true do
        local event_data = {os.pullEvent()}
        local event_type = event_data[1]

        if ui_manager:handle_event(event_type, table.unpack(event_data, 2)) then
            ui_manager:draw()
        end

        if event_type == "key" and event_data[2] == keys.leftCtrl and event_data[3] == keys.c then
            break
        end
    end
end

return Event
