-- install.lua

local args = { ... }
local branch = args[1] or "main"
local install_path = args[2] or "/lib/SapphireUI"

local manifest_url = "https://raw.githubusercontent.com/YOUR_USERNAME/SapphireUI/" .. branch .. "/MANIFEST"
local base_url = "https://raw.githubusercontent.com/YOUR_USERNAME/SapphireUI/" .. branch .. "/"

local function download(url)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        return content
    end
    return nil
end

local manifest_content = download(manifest_url)
if not manifest_content then
    print("Failed to download manifest from branch: " .. branch)
    return
end

local files = {}
for file in manifest_content:gmatch("[^\\n]+") do
    table.insert(files, file)
end

for _, file_path in ipairs(files) do
    local content = download(base_url .. file_path)
    if content then
        local target_path = fs.combine(install_path, file_path)
        fs.makeDir(fs.getDir(target_path))
        local file = fs.open(target_path, "w")
        file.write(content)
        file.close()
        print("Installed: " .. target_path)
    else
        print("Failed to download: " .. file_path)
    end
end

print("SapphireUI installation complete.")
