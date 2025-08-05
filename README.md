# pinit.nvim

A Neovim plugin for taking project specific notes blazingly fast.

- Saves markdown notes in your project directory 

---

## Installation

**Using [packer.nvim](https://github.com/wbthomason/packer.nvim):**

```lua
use({
  "cankurttekin/pinit-nvim",
  config = function()
    require("pinit"):setup()
  end,
})
```

## Commands
```
:PinIt toggle window
```

## Configuration
```lua
local pinit = require("pinit")

pinit:setup({
  -- notes_file = "/custom/path.md"
})

vim.keymap.set("n", "<leader>pn", function()
  pinit:open()
end, { desc = "Toggle pinit" })
```
