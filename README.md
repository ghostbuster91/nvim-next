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

Example:

```lua
local nvim_next_builtins = require("nvim-next.builtins")
require("nvim-next").setup({
    default_mappings = true,
    items = {
        nvim_next_builtins.f,
        nvim_next_builtins.t
    }
})
```

where `f` is a structure that defines key mapping and the function to invoke:

```lua
f = {
        key_next = "f",
        key_prev = "F",
        func_next = functions.f,
        func_prev = functions.F
    },
```

The protocol for `func_next` and `func_prev` is defined as follows:
They need to accept a structure:

```lua
{ result = nil --here goes results of whatever your function returned,
               --nil if that is a first invocation ,
  repeating = true --if the call is repeated, false otherwise
}
```

The `setup` function is only a convenient way of hooking external methods in the engine.

You can also do it the other way around:

```lua
local next = require("nvim-next").setup()
vim.keymap.set("n", "f", next.wrap_f(functions.f, functions.F))
vim.keymap.set("n", "F", next.wrap_f(functions.f, functions.F))
```

## 3rd party integrations

Gitsings

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

# Credits

The initial code for that plugin was created by @kiyoon during work at https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/359
