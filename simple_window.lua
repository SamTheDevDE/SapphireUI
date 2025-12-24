-- Import necessary SapphireUI components
local SapphireUI = require("src")
local Frame = require("widgets.frame")
local Label = require("widgets.label")
local Button = require("widgets.button")

-- Define the SimpleWindow class
local SimpleWindow = {}
SimpleWindow.__index = SimpleWindow

--- Creates a new SimpleWindow instance.
-- @return (SimpleWindow) A new instance of SimpleWindow.
function SimpleWindow.new()
    local self = setmetatable({}, SimpleWindow)

    -- Initialize the SapphireUI environment
    SapphireUI.init(term)

    -- Create the main screen
    local screen_width, screen_height = term.getSize()
    self.main_screen = Frame.new(1, 1, screen_width, screen_height)

    -- Create and add UI elements
    self:_create_widgets()

    return self
end

--- Creates and configures the widgets for the window.
-- @param self The SimpleWindow instance.
function SimpleWindow:_create_widgets()
    -- Create and add a title label
    local title_label = Label.new("Welcome to SapphireUI!", 2, 2, self.main_screen)
    self.main_screen:add_child(title_label)

    -- Create a button that changes the label's text when clicked
    local my_button = Button.new("Click Me", 5, 5, 15, 3, self.main_screen)
    my_button.on_click = function()
        title_label.text = "Button Clicked!"
    end
    self.main_screen:add_child(my_button)

    -- Create a button to exit the UI
    local quit_button = Button.new("Quit", 5, 9, 15, 3, self.main_screen)
    quit_button.on_click = function()
        SapphireUI.quit()
    end
    self.main_screen:add_child(quit_button)
end

--- Runs the application's UI.
-- @param self The SimpleWindow instance.
function SimpleWindow:run()
    -- Set the main screen and start the UI event loop
    SapphireUI.set_screen(self.main_screen)
    SapphireUI.run()

    -- This message is printed after the UI loop has been terminated
    print("SapphireUI has been shut down.")
end

-- Create an instance of the window and run it
local app = SimpleWindow.new()
app:run()

