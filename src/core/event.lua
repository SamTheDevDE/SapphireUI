--- Event Manager
-- @class Event
local Event = {}

--- Pulls an event from the queue.
-- @return The event data.
function Event.pull()
    local event_data = {os.pullEvent()}
    return event_data
end

return Event
