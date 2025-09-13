local M = {}
local win_id = nil

local function calc_size(value, total)
    if value and value < 1 then return math.floor(total * value) end
    return value
end

function M.open(file_path, opts)
    opts = opts or {}
    local win_type = opts.type or "float"

    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
        return
    end

    local buf = vim.fn.bufnr(file_path, true)
    vim.fn.bufload(buf)

    if win_type == "split" then
        vim.cmd(opts.split_cmd or "vsplit")
        win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win_id, buf)

        if opts.split_cmd == "vsplit" then
            local width = calc_size(opts.width, vim.o.columns)
            if width then vim.cmd("vertical resize " .. width) end
        else
            local height = calc_size(opts.height, vim.o.lines)
            if height then vim.cmd("resize " .. height) end
        end
    else
        local width = calc_size(opts.width, vim.o.columns)
        local height = calc_size(opts.height, vim.o.lines)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        win_id = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            row = row,
            col = col,
            width = width,
            height = height,
            style = opts.style or "minimal",
            border = opts.border or "single",
            title = opts.title or "PinIt",
            title_pos = opts.title_pos or "left",
        })
    end

    vim.api.nvim_win_set_option(win_id, "wrap", true)
    vim.wo[win_id].number = true
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].bufhidden = "wipe"

    local function close_and_save()
        if vim.bo[buf].modified then vim.cmd("silent! write") end
        if vim.api.nvim_win_is_valid(win_id) then vim.api.nvim_win_close(win_id, true) end
        win_id = nil
    end

    for _, key in ipairs({ "q", "<Esc>" }) do
        vim.keymap.set("n", key, close_and_save, { buffer = buf, noremap = true, silent = true })
    end

    vim.api.nvim_create_autocmd({ "BufLeave", "BufHidden", "WinClosed" }, {
        buffer = buf,
        callback = function()
            if vim.bo[buf].modified then vim.cmd("silent! write") end
        end,
        once = true,
    })
end

return M
