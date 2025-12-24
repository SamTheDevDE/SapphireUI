-- sapui.lua - TUI Installer for SapphireUI

-- ============================================================================
-- Configuration
-- ============================================================================
local GITHUB_USERNAME = "SamTheDevDE" -- IMPORTANT: Change this!
local REPO_NAME = "SapphireUI"
local INSTALL_PATH = "/lib/SapphireUI"
local VERSION_FILE = fs.combine(INSTALL_PATH, ".version")
local term = term

-- ============================================================================
-- TUI State and Drawing
-- ============================================================================
local TUI = {}
TUI.menu_options = {}
TUI.selected_index = 1
TUI.log_messages = {}
local screen_width, screen_height = term.getSize()

function TUI.log(message)
    table.insert(TUI.log_messages, 1, message)
    if #TUI.log_messages > 5 then
        table.remove(TUI.log_messages)
    end
end

function TUI.draw()
    term.clear()
    term.setCursorPos(1, 1)

    -- Header
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.white)
    term.write(string.format(" SapphireUI Installer %s", string.rep(" ", screen_width - 24)))

    -- Status Box
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, 3)
    term.setTextColor(colors.white)
    term.write("  Installed: ")
    term.setTextColor(colors.yellow)
    term.write(Installer.local_version)

    term.setCursorPos(1, 4)
    term.setTextColor(colors.white)
    term.write("  Latest:    ")
    term.setTextColor(colors.yellow)
    term.write(Installer.remote_version)

    -- Menu
    term.setCursorPos(1, 6)
    for i, option in ipairs(TUI.menu_options) do
        if i == TUI.selected_index then
            term.setBackgroundColor(colors.lightGray)
            term.setTextColor(colors.black)
            term.write(string.format("> %s", option.text))
        else
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
            term.write(string.format("  %s", option.text))
        end
        term.setCursorPos(1, 6 + i)
    end

    -- Log Box
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, 13)
    term.setTextColor(colors.gray)
    term.write(string.rep("-", screen_width))
    term.setCursorPos(1, 14)
    term.setTextColor(colors.white)
    term.write(" Log:")
    for i, msg in ipairs(TUI.log_messages) do
        term.setCursorPos(1, 14 + i)
        term.setTextColor(colors.lightGray)
        term.write("  " .. msg)
    end

    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, screen_height)
end

-- ============================================================================
-- Installer Logic
-- ============================================================================
local Installer = {}
Installer.local_version = "Checking..."
Installer.remote_version = "Checking..."

function Installer.download(url)
    local response = http.get(url)
    if response and response.getResponseCode() == 200 then
        local content = response.readAll()
        response.close()
        return content
    end
    if response then response.close() end
    return nil
end

function Installer.parse_json(json_string)
    if not json_string then return nil end
    local version = json_string:match('"version"%s*:%s*"([^"]+)"')
    local files_str = json_string:match('"files"%s*:%s*%[([^%]]+)%]')
    if not version or not files_str then return nil end
    local files = {}
    for file in files_str:gmatch('"([^"]+)"') do
        table.insert(files, file)
    end
    return { version = version, files = files }
end

function Installer.get_local_version()
    if fs.exists(VERSION_FILE) then
        local file = fs.open(VERSION_FILE, "r")
        Installer.local_version = file.readAll()
        file.close()
    else
        Installer.local_version = "Not Installed"
    end
end

function Installer.check_for_updates()
    TUI.log("Checking for latest version...")
    TUI.draw()
    local manifest_url = string.format("https://%s.github.io/%s/main/install_manifest.json", GITHUB_USERNAME, REPO_NAME)
    local content = Installer.download(manifest_url)
    if content then
        local manifest = Installer.parse_json(content)
        if manifest then
            Installer.remote_version = manifest.version
            TUI.log("Latest version is " .. Installer.remote_version)
        else
            Installer.remote_version = "Error"
            TUI.log("Failed to parse manifest.")
        end
    else
        Installer.remote_version = "Error"
        TUI.log("Failed to download manifest.")
    end
end

function Installer.install_or_update()
    TUI.log("Starting installation...")
    TUI.draw()
    local manifest_url = string.format("https://%s.github.io/%s/main/install_manifest.json", GITHUB_USERNAME, REPO_NAME)
    local manifest_content = Installer.download(manifest_url)
    if not manifest_content then
        TUI.log("Error: Failed to download manifest.")
        return
    end
    local manifest = Installer.parse_json(manifest_content)
    if not manifest then
        TUI.log("Error: Failed to parse manifest.")
        return
    end

    TUI.log("Installing version " .. manifest.version)
    TUI.draw()
    fs.makeDir(INSTALL_PATH)
    local base_url = string.format("https://raw.githubusercontent.com/%s/%s/main/", GITHUB_USERNAME, REPO_NAME)

    for i, file_path in ipairs(manifest.files) do
        TUI.log(string.format("Downloading (%d/%d)...", i, #manifest.files))
        TUI.draw()
        local content = Installer.download(base_url .. file_path)
        if content then
            local target_path = fs.combine(INSTALL_PATH, file_path:gsub("src/", ""))
            fs.makeDir(fs.getDir(target_path))
            local file = fs.open(target_path, "w")
            file.write(content)
            file.close()
        else
            TUI.log("Error downloading " .. file_path)
        end
    end

    local file = fs.open(VERSION_FILE, "w")
    file.write(manifest.version)
    file.close()
    Installer.local_version = manifest.version
    TUI.log("Installation complete!")
end

function Installer.remove()
    TUI.log("Removing SapphireUI...")
    TUI.draw()
    if fs.exists(INSTALL_PATH) then
        fs.delete(INSTALL_PATH)
        Installer.local_version = "Not Installed"
        TUI.log("Removal complete.")
    else
        TUI.log("Directory not found.")
    end
end

-- ============================================================================
-- Main App
-- ============================================================================
local function main()
    TUI.menu_options = {
        { text = "Install / Update", action = Installer.install_or_update },
        { text = "Check for Updates", action = Installer.check_for_updates },
        { text = "Remove", action = Installer.remove },
        { text = "Quit", action = function() return false end }
    }

    -- Initial state
    Installer.get_local_version()
    Installer.check_for_updates()

    while true do
        TUI.draw()
        local event, key = os.pullEvent("key")

        if key == keys.q or key == keys.escape then
            break
        elseif key == keys.up then
            TUI.selected_index = math.max(1, TUI.selected_index - 1)
        elseif key == keys.down then
            TUI.selected_index = math.min(#TUI.menu_options, TUI.selected_index + 1)
        elseif key == keys.enter then
            local option = TUI.menu_options[TUI.selected_index]
            if option.action then
                if option.action() == false then
                    break
                end
            end
            -- Refresh versions after action
            Installer.get_local_version()
        end
    end
end

-- Run app
term.clear()
term.setCursorBlink(false)
main()
term.clear()
term.setCursorPos(1, 1)
term.setCursorBlink(true)
print("SapphireUI Installer exited.")
