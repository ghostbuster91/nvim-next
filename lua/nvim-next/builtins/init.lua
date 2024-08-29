local functions = require("nvim-next.builtins.functions")

return {
    f = {
        key_next = "f",
        key_prev = "F",
        func_next = functions.builtin_f_expr,
        func_prev = functions.builtin_F_expr,
        opts = {
            expr = true,
            desc = "nvim-next: builtin f/F"
        }
    },
    t = {
        key_next = "t",
        key_prev = "T",
        func_next = functions.builtin_t_expr,
        func_prev = functions.builtin_T_expr,
        opts = {
            expr = true,
            desc = "nvim-next: builtin t/T"
        }
    },
}
