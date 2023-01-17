local move = require("nvim-next.move")

return function()
    return {
        goto_next = function(opts)
            return move.make_forward_repeatable_move(
                function()
                    vim.diagnostic.goto_next(opts)
                end,
                function()
                    vim.diagnostic.goto_prev(opts)
                end
            )
        end,
        goto_prev = function(opts)
            return move.make_backward_repeatable_move(
                function()
                    vim.diagnostic.goto_prev(opts)
                end,
                function()
                    vim.diagnostic.goto_next(opts)
                end
            )
        end
    }
end
