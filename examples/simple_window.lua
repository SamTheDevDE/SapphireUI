-- SapphireUI System Monitor Example

-- This example demonstrates a dynamic window with periodically updating content,
-- simulating a live system monitor.

-- Make sure SapphireUI is installed or we are in the dev environment.
if not package.loaded["SapphireUI.init"] then
    -- For local development, find the project root and add the 'src' directory to the path.
    if fs.exists("../src") then
        -- This tells Lua to look for a 'SapphireUI' folder in the project root.
        -- We then use package.cpath to "alias" 'SapphireUI' to the 'src' folder.
        package.path = fs.combine("..", "?.lua;") .. package.path
        package.cpath = fs.combine("..", "SapphireUI=src;") .. package.cpath
    -- For installed environments, point to the default lib path
    else
        local path = "/lib/SapphireUI"
        package.path = package.path .. ";" .. path .. "/?.lua;" .. path .. "/?/init.lua"
    end
end

-- In the dev environment, the 'src' folder acts as the root for the library.
-- The 'init.lua' inside 'src' is the entry point for the "SapphireUI" module.
local SapphireUI = require("SapphireUI.init")

-- Create a UI Manager instance
local ui = SapphireUI.UIManager.new()

-- Create a main frame
local mainFrame = ui:add("Frame", {
    x = 8,
    y = 4,
    width = 36,
    height = 11,
    backgroundColor = SapphireUI.themes.default.frame.background,
    title = "System Monitor",
    titleColor = SapphireUI.themes.default.frame.title,
    draggable = true
})

-- ============================================================================
-- Labels for Stats
-- ============================================================================

local cpuLabel = mainFrame:add("Label", {
    x = 4,
    y = 4,
    text = "CPU Usage: ...",
    textColor = SapphireUI.themes.default.label.text
})

local memLabel = mainFrame:add("Label", {
    x = 4,
    y = 5,
    text = "Memory:    ...",
    textColor = SapphireUI.themes.default.label.text
})

-- ============================================================================
-- Close Button
-- ============================================================================

local closeButton = mainFrame:add("Button", {
    x = 12,
    y = 8,
    width = 11,
    height = 3,
    text = "Close",
    backgroundColor = SapphireUI.themes.default.button.background,
    textColor = SapphireUI.themes.default.button.text,
    hoverBackgroundColor = SapphireUI.themes.default.button.hover,
})

closeButton.onClick = function()
    ui:stop() -- Stop the UI manager's event loop
end

-- ============================================================================
-- Dynamic Update Logic
-- ============================================================================

-- This function will be called periodically by a timer event.
local function updateStats()
    -- Generate some fake data
    local cpuUsage = math.random(5, 40)
    local memUsage = math.random(200, 250) + math.random()

    -- Update the label text
    cpuLabel:setText(string.format("CPU Usage: %d%%", cpuUsage))
    memLabel:setText(string.format("Memory:    %.2f MB", memUsage))
end

-- We add a custom event handler to the UI manager to listen for timer events.
ui:onEvent("timer", function(eventData)
    -- The first timer event will be from our os.startTimer call.
    -- We restart the timer to create a loop and then update the stats.
    os.startTimer(1) -- Fire again in 1 second
    updateStats()
end)

-- ============================================================================
-- Run UI
-- ============================================================================

-- Initial update before starting
updateStats()

-- Start the timer loop
os.startTimer(1)

-- Start the main UI event loop
ui:run()

-- After the loop stops, print a message
term.clear()
term.setCursorPos(1,1)
print("System Monitor example closed.")

