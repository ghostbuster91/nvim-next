# nvim-next

Repeateable movements reborn!

By default vim allows repating default movements like `f`/`F`/`t`/`T` and others using `;` and `,`.
However, the builtin mechanism is not extendable and as soon as we start using some custom movements we are left to implement
the repeating on your own. Some plugins provide that options some don't. But even when they do,
they do it in a way that steals `;` for themselves.

While I don't use repeating movments often with default motions,
I would like to use them with motions like next-treesitter-method, next-diagnostic, next-git-change, etc that comes from many different plugins.

This plugin is a repeatable movments engine that other plugins can hook into.
You can think of it as of `nvim-cmp` but for movements.

The idea is that other plugins like for example git-signs will expose logic to perform some movement,
and then we will wrap it with an adapter and plug into that engine.

## Current state of the project

The project is in a very early state. In addition to that, it is also my first neovim plugin. Expect unexpected. Having said that, I am using it on a dialy basis and I am planning to keep it like that.

## Getting started

Frist you need to initialize nvim-next. This will map `;` and `,` to respetive nvim-next functions. Here you might also want to override the builtin `f`/`t` functions to have a consistent bevahior with the rest of the movements.

```lua
local nvim_next_builtins = require("nvim-next.builtins")
 require("nvim-next").setup({
     default_mappings = {
         repeat_style = "original",
     },
     items = {
         nvim_next_builtins.f,
         nvim_next_builtins.t
     }
 })
```

The `repeat_style` parameter contols if the repetition preserves the `original` direction of the move, or if it uses the direction (`directional`) of the repeat key: `;` - forward, `,` - backward.

Any mappings including `f`/`t` can be also set later using following syntax:

```lua
local next = require("nvim-next").setup()
vim.keymap.set("n", "f", next.make_repeatable_pair(functions.F, functions.f)) -- (prev, next)
vim.keymap.set("n", "F", next.make_repeatable_pair(functions.f, functions.F))
```

## 3rd party integrations

Nvim-next comes with multiple integrations out of the box for many popular plugins. Can't find your favorite one? Don't hesitate and create an issue. PRs are more than welcome.

- [Gitsigns](#gitsigns)
- [Diagnostics](#diagnostics)
- [Treesitter text-objects](#treesitter-text-objects)
- [Quickfix](#quickfix-list)

### [Gitsigns](https://github.com/lewis6991/gitsigns.nvim)

```lua
local next_integrations = require("nvim-next.integrations")
require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        local nngs = next_integrations.gitsigns(gs)
        -- Navigation
        map('n', ']c', nngs.next_hunk, { expr = true })
        map('n', '[c', nngs.prev_hunk, { expr = true })
    end,
})
```

### Diagnostics

```lua
local next_integrations = require("nvim-next.integrations")
local nndiag = next_integrations.diagnostic()
vim.keymap.set("n", "[d", nndiag.goto_prev({ severity = { min = diag.severity.WARN } }), { desc = "previous diagnostic" })
vim.keymap.set("n", "]d", nndiag.goto_next({ severity = { min = diag.severity.WARN } }), { desc = "next diagnostic" })
```

### [Treesitter text-objects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)

```lua
-- first initialize intgration module
require("nvim-next.integrations").treesitter_textobjects()
-- setup treesitter
require("nvim-treesitter.configs").setup({
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
    nvim_next = {
        enable = true,
        textobjects = {
            --instead of defining the move section in the textobjects scope we move it under nvim_next
            move = {
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = { query = "@class.outer", desc = "Next class start" },
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            }
        }
    }
})
```

### Quickfix list

```lua
local next_integrations = require("nvim-next.integrations")
local nqf = next_integrations.quickfix()
vim.keymap.set("n", "[d", nqf.cprevious, { desc = "previous quickfix list item" })
vim.keymap.set("n", "]d", nqf.cnext, { desc = "next quickfix list item" })
```

## Writing a custom adapter

TODO

The protocol for `func_next` and `func_prev` is defined as follows:
They need to accept a structure:

```lua
{ result = nil --here goes results of whatever your function returned,
               --nil if that is a first invocation ,
  repeating = true --if the call is repeated, false otherwise
}
```

Example:

```lua
local next_move = require("nvim-next.move")
local prev_qf_item, next_qf_item = next_move.make_repeatable_pair(function(_)
    local status, err = pcall(vim.cmd, "cprevious")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO)
    end
end, function(_)
    local status, err = pcall(vim.cmd, "cnext")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO)
    end
end)

map("n", "]q", next_qf_item, { desc = "nvim-next: next qfix" })
map("n", "[q", prev_qf_item, { desc = "nvim-next: prev qfix" })
```

# Credits

The initial code for that plugin was created by @kiyoon during work at https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/359
