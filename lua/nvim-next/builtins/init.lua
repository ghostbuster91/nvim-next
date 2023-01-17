local functions = require("nvim-next.builtins.functions")
local move = require("nvim-next.move")

return {
    f = {
        key_next = "f",
        key_prev = "F",
        func_next = move.make_forward_repeatable_move(functions.f, functions.F),
        func_prev = move.make_backward_repeatable_move(functions.F, functions.f)
    },
    t = {
        key_next = "t",
        key_prev = "T",
        func_next = move.make_forward_repeatable_move(functions.t, functions.T),
        func_prev = move.make_forward_repeatable_move(functions.T, functions.t)
    },
}
