-- SapphireUI Installer & Updater
-- To use this installer, you need to upload your project to a public GitHub repository.
-- Then, update the repo_owner and repo_name variables below.

local repo_owner = "SamTheDevDE" -- <-- IMPORTANT: CHANGE THIS
local repo_name = "SapphireUI"   -- <-- IMPORTANT: CHANGE THIS
local branch = "main"

local repo_path = repo_owner .. "/" .. repo_name
local base_url = "https://raw.githubusercontent.com/" .. repo_path .. "/" .. branch .. "/"

local lib_dir = "/lib/SapphireUI"
local version_file_path = lib_dir .. "/.version"

local files_to_install = {
    -- Library files
    { remote = "src/init.lua",        local_path = lib_dir .. "/init.lua" },
    { remote = "src/core/event.lua",   local_path = lib_dir .. "/core/event.lua" },
    { remote = "src/core/renderer.lua",local_path = lib_dir .. "/core/renderer.lua" },
    { remote = "src/core/widget.lua",  local_path = lib_dir .. "/core/widget.lua" },
    { remote = "src/themes/default.lua", local_path = lib_dir .. "/themes/default.lua" },
    { remote = "src/widgets/button.lua", local_path = lib_dir .. "/widgets/button.lua" },
    { remote = "src/widgets/frame.lua",  local_path = lib_dir .. "/widgets/frame.lua" },
    { remote = "src/widgets/label.lua",  local_path = lib_dir .. "/widgets/label.lua" },
    -- Executable files
    { remote = "startup.lua",       local_path = "/startup.lua" },
    { remote = "simple_window.lua", local_path = "/simple_window.lua" },
}

local function download(url, path)
    print("Downloading " .. url .. " to " .. path)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        local dir = path:match("(.*/)")
        if dir and not fs.exists(dir) then
            fs.makeDir(dir)
        end
        local file = fs.open(path, "w")
        file.write(content)
        file.close()
        return true
    else
        printError("Failed to download from " .. url)
        return false
    end
end

local function get_remote_version()
    print("Checking for new version...")
    local response = http.get(base_url .. "src/init.lua")
    if response then
        local content = response.readAll()
        response.close()
        local version = content:match('version%s*=%s*["\'](.-)["\']')
        return version
    end
    return nil
end

local function get_local_version()
    if fs.exists(version_file_path) then
        local file = fs.open(version_file_path, "r")
        local version = file.readAll()
        file.close()
        return version
    end
    return nil
end

local function compare_versions(v1, v2)
    local function split(s)
        local t = {}
        for part in s:gmatch("%d+") do
            table.insert(t, tonumber(part))
        end
        return t
    end

    local t1 = split(v1)
    local t2 = split(v2)

    for i = 1, math.max(#t1, #t2) do
        local n1 = t1[i] or 0
        local n2 = t2[i] or 0
        if n1 > n2 then return 1
        elseif n1 < n2 then return -1
        end
    end
    return 0
end

-- Main logic
local remote_version = get_remote_version()
if not remote_version then
    printError("Could not retrieve remote version. Aborting.")
    return
end
print("Remote version: " .. remote_version)

local local_version = get_local_version()
if local_version then
    print("Local version: " .. local_version)
else
    print("No local version found. Installing.")
end

if not local_version or compare_versions(remote_version, local_version) == 1 then
    print("New version available. Installing files...")
    local all_successful = true
    for _, file_info in ipairs(files_to_install) do
        local success = download(base_url .. file_info.remote, file_info.local_path)
        if not success then
            all_successful = false
            break
        end
    end

    if all_successful then
        print("Installation successful!")
        local version_file = fs.open(version_file_path, "w")
        version_file.write(remote_version)
        version_file.close()
        print("To get started, run 'startup' or reboot.")
    else
        printError("Installation failed.")
    end
else
    print("You are already on the latest version.")
end
