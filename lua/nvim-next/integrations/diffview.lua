local move = require("nvim-next.move")

return function(diff_actions)
    return {
        next_conflict = move.make_forward_repeatable_move(
            function()
                diff_actions.next_conflict()
            end,
            function()
                diff_actions.goto_prev()
            end
        ),
        prev_conflict = move.make_backward_repeatable_move(
            function()
                diff_actions.prev_conflict()
            end,
            function()
                diff_actions.next_conflict()
            end
        )
    }
end
