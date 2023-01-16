local move = require("nvim-next.move")

local function setup(config)
    if config.default_mappings then
        vim.keymap.set({ "n" }, ";", move.repeat_last_move)
        vim.keymap.set({ "n" }, ",", move.repeat_last_move_opposite)
    end
    for _, i in ipairs(config.items) do
        local wrapped_prev, wrapped_next = move.make_repeatable_pair(i.func_prev, i.func_next)
        vim.keymap.set({ "n" }, i.key_prev, wrapped_prev, i.opts)
        vim.keymap.set({ "n" }, i.key_next, wrapped_next, i.opts)
    end
    return move
end

return {
    setup = setup,
}
