local move = require("nvim-next.move")

local prev_key = '[c'
local next_key = ']c'

return function(gs)
    local next_hunk = function(opts)
        local opts = opts or {}
        if vim.wo.diff then return opts.mapping or next_key end
        vim.schedule(function() gs.next_hunk(opts) end)
        return '<Ignore>'
    end
    local prev_hunk = function(opts)
        local opts = opts or {}
        if vim.wo.diff then return opts.mapping or prev_key end
        vim.schedule(function() gs.prev_hunk(opts) end)
        return '<Ignore>'
    end

    local prev_wrapped = function(opts)
        return move.make_backward_repeatable_move(
            function()
                prev_hunk(opts)
            end,
            function()
                next_hunk(opts)
            end)
    end
    local next_wrapped = function(opts)
        return move.make_forward_repeatable_move(
            function()
                next_hunk(opts)
            end,
            function()
                prev_hunk(opts)
            end
        )
    end
    return {
        on_attach = function(bufnr)
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map('n', next_key, next_wrapped({ mapping = next_key }), { expr = true })
            map('n', prev_key, prev_wrapped({ mapping = prev_key }), { expr = true })
        end,
        next_hunk = next_wrapped,
        prev_hunk = prev_wrapped
    }
end
