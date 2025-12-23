--- Event Manager
-- @class Event
local Event = {}

local event_queue = {}

--- Starts listening for events.
function Event.start()
    os.pullEvent = os.pullEventRaw
end

--- Pulls an event from the queue.
-- @return The event data.
function Event.pull()
    local event_data = {os.pullEvent()}
    return event_data
end

return Event
