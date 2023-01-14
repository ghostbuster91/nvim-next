local functions = require("nvim-next.builtins.functions")

return {
    f = {
        key_next = "f",
        key_prev = "F",
        func_next = functions.f,
        func_prev = functions.F
    },
    t = {
        key_next = "t",
        key_prev = "T",
        func_next = functions.t,
        func_prev = functions.T
    },
}
