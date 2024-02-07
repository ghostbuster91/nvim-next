local functions = require("nvim-next.builtins.functions")
local move = require("nvim-next.move")

return {
    f = {
        ["f"] = {
            {
                mode = { "n", "v" },
                func = move.make_forward_repeatable_move(functions.f, functions.F),
                opts = { desc = "nvim-next f" }
            },
            {
                mode = { "o" },
                func = [[v:lua.NvimNextFunctions.expr_f()]],
                opts = { desc = "nvim-next f", expr = true }
            }
        },
        ["F"] = {
            {
                mode = { "n", "v" },
                func = move.make_forward_repeatable_move(functions.F, functions.f),
                opts = { desc = "nvim-next F" }
            },
            {
                mode = { "o" },
                func = [[v:lua.NvimNextFunctions.expr_F()]],
                opts = { desc = "nvim-next F", expr = true }
            }
        },
    },
    t = {
        ["t"] = {
            {
                mode = { "n", "v" },
                func = move.make_forward_repeatable_move(functions.t, functions.T),
                opts = { desc = "nvim-next t" }
            },
            {
                mode = { "o" },
                func = [[v:lua.NvimNextFunctions.expr_t()]],
                opts = { desc = "nvim-next t", expr = true }
            }
        },
        ["T"] = {
            {
                mode = { "n", "v" },
                func = move.make_forward_repeatable_move(functions.T, functions.t),
                opts = { desc = "nvim-next T" }
            },
            {
                mode = { "o" },
                -- func = functions.expr_T,
                func = [[v:lua.NvimNextFunctions.expr_T()]],
                opts = { desc = "nvim-next T", expr = true }
            }
        },
    },
}
