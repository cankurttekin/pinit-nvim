local Pinit = {}
Pinit.__index = Pinit

Pinit.config = {
  notes_file = nil,
}

-- Project root = folder with .git, fallback to cwd
local function find_project_root()
  local cwd = vim.fn.getcwd()
  local root = vim.fn.finddir(".git", cwd .. ";")
  if root == "" then return cwd end
  return vim.fn.fnamemodify(root, ":h")
end

-- Path where the notes file will be stored
local function get_notes_path()
  if Pinit.config.notes_file then
    return Pinit.config.notes_file
  end
  local root = find_project_root()
  return root .. "/.pinit-nvim-notes.md"
end

function Pinit:setup(user_config)
  self.config = vim.tbl_deep_extend("force", self.config, user_config or {})
  vim.api.nvim_create_user_command("PinIt", function() self:open() end, {})
end

function Pinit:open()
  local window = require("pinit.window")
  local path = get_notes_path()
  window.open(path)
end

return setmetatable({}, Pinit)
