local move = require("nvim-next.move")

return function(gs)
    local prev_wrapped = move.make_backward_repeatable_move(
        function(opts)
            gs.prev_hunk(table.unpack(opts.args or {}))
        end,
        function(opts)
            gs.next_hunk(table.unpack(opts.args or {}))
        end)
    local next_wrapped = move.make_forward_repeatable_move(
        function(opts)
            gs.next_hunk(table.unpack(opts.args or {}))
        end,
        function(opts)
            gs.prev_hunk(table.unpack(opts.args or {}))
        end
    )
    return {
        on_attach = function(bufnr)
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() next_wrapped() end)
                return '<Ignore>'
            end, { expr = true })

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() prev_wrapped() end)
                return '<Ignore>'
            end, { expr = true })
        end,
        next_hunk = next_wrapped,
        prev_hunk = prev_wrapped
    }
end
