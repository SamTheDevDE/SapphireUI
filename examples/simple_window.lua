-- SapphireUI Simple Window Example

-- Make sure SapphireUI is installed or we are in the dev environment.
if not package.loaded["SapphireUI.init"] then
    -- For local development, point to the 'src' directory
    if fs.exists("../src") then
        package.path = package.path .. ";../?.lua;../?/init.lua"
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
    x = 5,
    y = 3,
    width = 41,
    height = 13,
    backgroundColor = SapphireUI.themes.default.frame.background,
    title = "My First Window",
    titleColor = SapphireUI.themes.default.frame.title,
    draggable = true
})

-- Add a label to the frame
mainFrame:add("Label", {
    x = 3,
    y = 3,
    text = "Welcome to SapphireUI!",
    textColor = SapphireUI.themes.default.label.text
})

-- Add a button to the frame
local closeButton = mainFrame:add("Button", {
    x = 15,
    y = 10,
    width = 11,
    height = 3,
    text = "Close",
    backgroundColor = SapphireUI.themes.default.button.background,
    textColor = SapphireUI.themes.default.button.text,
    hoverBackgroundColor = SapphireUI.themes.default.button.hover,
})

-- Set the button's action
closeButton.onClick = function()
    ui:stop() -- Stop the UI manager's event loop
end

-- Start the UI event loop
ui:run()

-- After the loop stops, print a message
term.clear()
term.setCursorPos(1,1)
print("UI was closed.")

