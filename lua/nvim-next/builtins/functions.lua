local move = require("nvim-next.move")

local M = {}

M.builtin_f_expr = function()
    vim.notify_once("nvim-next: map `builtin_T_expr` with `{expr=true}` instead.", vim.log.levels.WARN)
    move.last_move = {
        func = "f",
        opts = { forward = true },
        additional_args = {},
    }
    return "f"
end

M.builtin_F_expr = function()
    vim.notify_once("nvim-next: map `builtin_T_expr` with `{expr=true}` instead.", vim.log.levels.WARN)
    move.last_move = {
        func = "F",
        opts = { forward = false },
        additional_args = {},
    }
    return "F"
end

M.builtin_t_expr = function()
    vim.notify_once("nvim-next: map `builtin_T_expr` with `{expr=true}` instead.", vim.log.levels.WARN)
    move.last_move = {
        func = "t",
        opts = { forward = true },
        additional_args = {},
    }
    return "t"
end

M.builtin_T_expr = function()
    vim.notify_once("nvim-next: map `builtin_T_expr` with `{expr=true}` instead.", vim.log.levels.WARN)
    move.last_move = {
        func = "T",
        opts = { forward = false },
        additional_args = {},
    }
    return "T"
end

return M
