local M = {}

M.defaults = {
    notes_dir = nil,
    window = {
        type = "float",
        width = 0.6,
        height = 0.6,
        split_cmd = "vsplit",
        border = "single",
        style = "minimal",
        title = "PinIt",
        title_pos = "left",
    },
}

function M.merge(user_config)
    return vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

return M
