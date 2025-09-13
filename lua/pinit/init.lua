local Pinit = {}
Pinit.__index = Pinit

Pinit.config = {
  notes_dir = nil,

  window = {
    type = "float",         -- "float" | "split"
    width = 0.5,            -- fraction or absolute width
    height = 0.5,           -- fraction or absolute height
    split_cmd = "vsplit",   -- "split", "vsplit", "tabnew" 
    border = "single",      -- "single" | "double" | "rounded" | "solid" | "shadow"
  },
}

-- find the root folder with .git, fallback to cwd
local function find_project_root()
  local cwd = vim.fn.getcwd()
  local root = vim.fn.finddir(".git", cwd .. ";")
  if root == "" then return cwd end
  return vim.fn.fnamemodify(root, ":h")
end

local function get_project_name()
  local git_root = find_project_root()

  -- try git remote URL
  local remote_url = vim.fn.system({ "git", "-C", git_root, "remote", "get-url", "origin" })
  remote_url = vim.fn.trim(remote_url or "")

  if remote_url ~= "" and vim.v.shell_error == 0 then
    -- extract repo name from URL
    local name = remote_url:match("^.+/(.+)%.git$") or remote_url:match("^.+/(.+)$")
    if name and name ~= "" then
      return name
    end
  end

  -- fallback use directory name
  local dir_name = vim.fn.fnamemodify(git_root, ":t")
  if dir_name == "" or dir_name == "." then
    dir_name = "project"
  end

  return dir_name
end

function Pinit:get_notes_path()
  local project_name = get_project_name()
  local filename = project_name .. ".md"

  if self.config.notes_dir then
    local base_dir = vim.fn.expand(self.config.notes_dir)
    vim.fn.mkdir(base_dir, "p") -- ensure it exists
    return base_dir .. "/" .. filename
  end

  return find_project_root() .. "/.pinit-nvim-notes.md"
end

function Pinit:setup(user_config)
  self.config = vim.tbl_deep_extend("force", self.config, user_config or {})
  vim.api.nvim_create_user_command("PinIt", function() self:open() end, {})
end

function Pinit:open()
  local window = require("pinit.window")
  local path = self:get_notes_path()
  window.open(path, self.config.window)
end

return setmetatable({}, Pinit)
