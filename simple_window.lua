-- Set up package path to find SapphireUI
local script_path = (...):match("(.-)[^/\\]*$") or ""
package.path = package.path .. ";" .. script_path .. "src/?.lua"

local SapphireUI = require("init")
local Frame = require("widgets.frame")
local Label = require("widgets.label")
local Button = require("widgets.button")

-- Initialize the UI
SapphireUI.init(term)

-- Create a main screen (a frame that fills the screen)
local screen_width, screen_height = term.getSize()
local main_screen = Frame.new(1, 1, screen_width, screen_height)

-- Create a label
local title_label = Label.new("Welcome to SapphireUI!", 2, 2, main_screen)
main_screen:add_child(title_label)

-- Create a button
local my_button = Button.new("Click Me", 5, 5, 15, 3, main_screen)
my_button.on_click = function()
    title_label.text = "Button Clicked!"
end
main_screen:add_child(my_button)

-- Create another button to quit
local quit_button = Button.new("Quit", 5, 9, 15, 3, main_screen)
quit_button.on_click = function()
    SapphireUI.quit()
end
main_screen:add_child(quit_button)

-- Set the active screen and run the UI
SapphireUI.set_screen(main_screen)
SapphireUI.run()

print("SapphireUI has been shut down.")
