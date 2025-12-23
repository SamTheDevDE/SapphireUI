-- luacheck configuration file

-- Exclude dependency and configuration directories
exclude_files = {
    ".luarocks/",
    ".github/"
}

-- Define standard ComputerCraft globals to avoid warnings
read_globals = {
    "http",
    "fs",
    "term",
    "colors",
    "sleep",
    "shell",
    "os",
    "printError",
    "window",
    "term_native",
    "parallel"
}
