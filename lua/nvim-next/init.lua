local M = {}

local builtins = require("nvim-next.builtins")

M.last_move = nil
-- { func: (args)=>(), args = { ... }, opposite: (args)=>() }

M.builtin_f = function()
    local char = builtins.f()
    M.last_move = { func = builtins.f, args = { char, "repeating" }, opposite = builtins.F }
end

M.builtin_F = function()
    local char = builtins.F()
    M.last_move = { func = builtins.F, args = { char, "repeating" }, opposite = builtins.f }
end

M.builtin_t = function()
    local char = builtins.t()
    M.last_move = { func = builtins.t, args = { char, "repeating" },
        opposite = builtins.T }
end

M.builtin_T = function()
    local char = builtins.T()
    M.last_move = { func = builtins.T, args = { char, "repeating" },
        opposite = builtins.t }
end

M.repeat_last_move = function()
    print("repeat")
    if M.last_move then
        print("last_move")
        M.last_move.func(unpack(M.last_move.args))
    end
end

M.repeat_last_move_opposite = function()
    print("repeat neg")
    if M.last_move then
        local args = { unpack(M.last_move.args) } -- copy the table
        M.last_move.opposite(unpack(args))
    end
end

local function wrap_f(func, opposite)
    local wrapped = function()
        vim.notify("running wrapped function")
        print("running wrapped function")
        local char = func()
        M.last_move = { func = func, args = { char, "repeating" }, opposite = opposite }
    end
    return wrapped
end

local function setup_bi_dir(key_next, key_prev, func_next, func_prev, desc)
    local wrapped_next = wrap_f(func_next, func_prev)
    local wrapped_prev = wrap_f(func_prev, func_next)
    print("keynext :" .. key_next)
    print("keyperv :" .. key_prev)
    vim.keymap.set({ "n" }, key_next, wrapped_next, { desc = desc })
    vim.keymap.set({ "n" }, key_prev, wrapped_prev, { desc = desc })
end

local function setup(items)
    vim.keymap.set({ "n" }, ";", M.repeat_last_move)
    vim.keymap.set({ "n" }, ",", M.repeat_last_move_opposite)

    vim.notify("running setup")
    print("running setup")
    for _, i in ipairs(items) do
        print("setting up" .. i.key_next)
        setup_bi_dir(i.key_next, i.key_prev, i.func_next, i.func_prev)
    end
    M.items = items
    return M
end

return {
    setup = setup,
    debug = function()
        setup {
            {
                key_next = "f",
                key_prev = "F",
                func_next = builtins.f,
                func_prev = builtins.F
            },
            {
                key_next = "t",
                key_prev = "T",
                func_next = builtins.t,
                func_prev = builtins.T
            }
        }
    end
}
