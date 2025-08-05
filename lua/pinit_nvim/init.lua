local M = {}

local window = require("pinit_nvim.window")
local config = {
    notes_file = nil,
}

-- todo:
-- project root = folder with .git, fallback to cwd
local function find_project_root()
    local cwd = vim.fn.getcwd()
    local root = vim.fn.finddir(".git", cwd .. ";")
    if root == "" then return cwd end
    return vim.fn.fnamemodify(root, ":h")
end

-- path where the notes file will be stored
local function get_notes_path()
    if config.notes_file then
        return config.notes_file
    end
    local root = find_project_root()
    return root .. "/.pinit-nvim-notes.md"
end

-- open floating note
function M.open()
    local path = get_notes_path()
    window.open(path)
end

-- setup
function M.setup(user_config)
    config = vim.tbl_deep_extend("force", config, user_config or {})
    vim.api.nvim_create_user_command("PinIt", M.open, {})
end

return M
