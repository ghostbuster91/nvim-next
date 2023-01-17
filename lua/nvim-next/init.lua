local move = require("nvim-next.move")

local function setup(config)
    config = config or { default_mappings = true, items = {} }
    if config.default_mappings then
        vim.keymap.set({ "n" }, ";", move.repeat_last_move, { desc = "nvim-next", noremap = true })
        vim.keymap.set({ "n" }, ',', move.repeat_last_move_opposite, { desc = "nvim-prev", noremap = true })
    end
    for _, i in ipairs(config.items) do

        vim.keymap.set({ "n" }, i.key_prev, i.func_prev, i.opts)
        vim.keymap.set({ "n" }, i.key_next, i.func_next, i.opts)
    end
    return move
end

return {
    setup = setup,
}
