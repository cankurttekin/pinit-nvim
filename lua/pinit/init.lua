local Pinit = {}
Pinit.__index = Pinit

local Config = require("pinit.config")
local Utils = require("pinit.utils")
local Window = require("pinit.window")

Pinit.config = Config.defaults

-- get notes path
function Pinit:get_notes_path()
    local project_name = Utils.get_project_name()
    local filename = project_name .. ".md"

    if self.config.notes_dir then
        local base_dir = vim.fn.expand(self.config.notes_dir)
        vim.fn.mkdir(base_dir, "p") -- ensure exists
        return base_dir .. "/" .. filename
    end

    return Utils.find_project_root() .. "/.pinit-nvim-notes.md"
end

-- set user config & command
function Pinit:setup(user_config)
    self.config = Config.merge(user_config)
    vim.api.nvim_create_user_command("PinIt", function() self:open() end, {})
end

function Pinit:open()
    Window.open(self:get_notes_path(), self.config.window)
end

return setmetatable({}, Pinit)
