local move = require("nvim-next.move")

local M = {}

M.builtin_f_expr = function()
    move.last_move = {
        func = "f",
        opts = {},
        additional_args = {},
    }
    return "f"
end

M.builtin_F_expr = function()
    move.last_move = {
        func = "F",
        opts = {},
        additional_args = {},
    }
    return "F"
end

M.builtin_t_expr = function()
    move.last_move = {
        func = "t",
        opts = {},
        additional_args = {},
    }
    return "t"
end

M.builtin_T_expr = function()
    move.last_move = {
        func = "T",
        opts = {},
        additional_args = {},
    }
    return "T"
end

return M
