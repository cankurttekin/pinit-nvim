<div align="center">

# PinIt
##### taking project-git- specific notes blazingly fast.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.8+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

<img alt="PinIt" height="280" src="/assets/screenshot.png" />
</div>

## Installation

**Using [packer.nvim](https://github.com/wbthomason/packer.nvim):**

```lua
use "cankurttekin/pinit-nvim"
```

## Commands
```
:PinIt toggle window
```

## Setup
```lua
local pinit = require("pinit")

pinit:setup({
    notes_dir = "~/.pinitnotes",   -- optional: directory to store notes (default: project root)
    window = {
        type = "float",            -- optional: "float" | "split" (default: "float")
        width = 0.8,               -- optional: fraction or absolute size (default: 0.5)
        height = 0.8,            -- optional: fraction or absolute size (default: 0.5)
        border = "rounded",        -- optional: "single" | "double" | "rounded" | "solid" | "shadow" (default: "single")
    },
})

vim.keymap.set("n", "<leader>pn", function()
  pinit:open()
end, { desc = "Toggle pinit" })
```
