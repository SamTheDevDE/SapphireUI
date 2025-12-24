-- examples/simple_window.lua

package.path = package.path .. ";./lua/?.lua"

local UIManager = require("SapphireUI.ui_manager")
local Frame = require("SapphireUI.widgets.frame")
local Label = require("SapphireUI.widgets.label")
local Button = require("SapphireUI.widgets.button")
local DefaultTheme = require("SapphireUI.themes.default")

local term = term

local ui = UIManager.new(term)
ui:set_theme(DefaultTheme)

local main_screen = Frame.new(1, 1, ui.width, ui.height)

local title_label = Label.new("Welcome to SapphireUI!", 2, 2, main_screen)
main_screen:add_child(title_label)

local my_button = Button.new("Click Me", 5, 5, 15, 3, main_screen)
my_button.on_click = function()
    title_label.text = "Button Clicked!"
end
main_screen:add_child(my_button)

local quit_button = Button.new("Quit", 5, 9, 15, 3, main_screen)
quit_button.on_click = function()
    -- No proper quit mechanism yet, so just error out
    error("Quit button clicked")
end
main_screen:add_child(quit_button)

ui:set_screen(main_screen)
ui:run()
