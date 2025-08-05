local M = {}

local win_id = nil
local open_buf = nil

function M.open(file_path)
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
    open_buf = nil
    return
  end

  local buf = vim.fn.bufnr(file_path, true)
  vim.fn.bufload(buf)

  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  win_id = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "single",
    title = "PinIt",
    title_pos = "left",
  })

  open_buf = buf

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
    open_buf = nil
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
