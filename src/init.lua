-- SapphireUI/src/init.lua
-- This is the main entry point for the SapphireUI library.
-- It packages up the core components into a single table to be returned by require().

local SapphireUI = {}

-- The UIManager is the primary class for creating and managing UI instances.
SapphireUI.UIManager = require("lib/SapphireUI.ui_manager")

-- Themes are exposed so users can easily reference theme colors and styles
-- when creating their widgets.
SapphireUI.themes = {
    default = require("lib/SapphireUI.themes.default")
}

return SapphireUI
