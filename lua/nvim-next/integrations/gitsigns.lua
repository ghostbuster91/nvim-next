local move = require("nvim-next.move")

return function(gs)
    local next_hunk = function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end
    local prev_hunk = function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
    end

    local prev_wrapped, next_wrapped = move.make_repeatable_pair(prev_hunk, next_hunk)
    return {
        on_attach = function(bufnr)
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map('n', ']c', next_hunk, { expr = true })
            map('n', '[c', prev_hunk, { expr = true })
        end,
        next_hunk = next_wrapped,
        prev_hunk = prev_wrapped
    }
end
