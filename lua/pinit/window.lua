local M = {}

local win_id = nil

--- open the notes window
--- @param file_path string
--- @param opts table user window config
function M.open(file_path, opts)
    opts = opts or {}
    local win_type = opts.type or "float"

    -- toggle: if already open, close
    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true)
        win_id = nil
        return
    end

    local buf = vim.fn.bufnr(file_path, true)
    vim.fn.bufload(buf)

    if win_type == "split" then
        -- open split
        local split_cmd = opts.split_cmd or "vsplit"
        vim.cmd(split_cmd)
        win_id = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win_id, buf)

        -- resize split
        if split_cmd == "vsplit" then
            local width = opts.width
            if width and width < 1 then
                width = math.floor(vim.o.columns * width)
            end
            if width then
                vim.cmd("vertical resize " .. width)
            end
        elseif split_cmd == "split" then
            local height = opts.height
            if height and height < 1 then
                height = math.floor(vim.o.lines * height)
            end
            if height then
                vim.cmd("resize " .. height)
            end
        end
    else
        -- floating window
        local width = opts.width
        local height = opts.height
        local border = opts.border or "single"
        if width and width < 1 then width = math.floor(vim.o.columns * width) end
        if height and height < 1 then height = math.floor(vim.o.lines * height) end

        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        win_id = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            row = row,
            col = col,
            width = width,
            height = height,
            style = "minimal",
            border = border,
            title = "PinIt",
            title_pos = "left",
        })
    end

    -- common settings
    vim.api.nvim_win_set_option(win_id, "wrap", true)
    vim.wo[win_id].number = true
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].bufhidden = "wipe"

    local function close_and_save()
        if vim.bo[buf].modified then
            vim.cmd("silent! write")
        end
        if vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
        end
        win_id = nil
    end

    for _, key in ipairs({ "q", "<Esc>" }) do
        vim.keymap.set("n", key, close_and_save, { buffer = buf, noremap = true, silent = true })
    end

    vim.api.nvim_create_autocmd({ "BufLeave", "BufHidden", "WinClosed" }, {
        buffer = buf,
        callback = function()
            if vim.bo[buf].modified then
                vim.cmd("silent! write")
            end
        end,
        once = true,
    })
end

return M
