local M = {}

local builtins = require("nvim-next.builtins")

M.last_move = nil
-- { func: (args)=>(), args = { ... }, opposite: (args)=>() }

M.repeat_last_move = function()
    if M.last_move then
        M.last_move.func(M.last_move.opts)
    end
end

M.repeat_last_move_opposite = function()
    if M.last_move then
        M.last_move.opposite(M.last_move.opts)
    end
end

local function wrap_f(func, opposite)
    return function()
        local result = func({ repeating = false })
        M.last_move = { func = func, opts = { result = result, repeating = true }, opposite = opposite }
    end
end

M.wrap_f = wrap_f

local function setup_bidirectional(key_next, key_prev, func_next, func_prev, desc)
    local wrapped_next = wrap_f(func_next, func_prev)
    local wrapped_prev = wrap_f(func_prev, func_next)
    vim.keymap.set({ "n" }, key_next, wrapped_next, { desc = desc })
    vim.keymap.set({ "n" }, key_prev, wrapped_prev, { desc = desc })
end

M.setup_bidirectional = setup_bidirectional

local function setup(config)
    if config.default_mappings then
        vim.keymap.set({ "n" }, ";", M.repeat_last_move)
        vim.keymap.set({ "n" }, ",", M.repeat_last_move_opposite)
    end
    for _, i in ipairs(config.items) do
        setup_bidirectional(i.key_next, i.key_prev, i.func_next, i.func_prev)
    end
    return M
end

return {
    setup = setup,
}
