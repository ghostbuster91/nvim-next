local move = require("nvim-next.move")

local default_config = {
    default_mappings = {
        enable = true,
        repeat_style = "original" -- or directional
    },
    items = {}
}

local function setup(config)
    config = vim.deepcopy(config or {})
    config = vim.tbl_deep_extend("force", {}, default_config, config)
    if config.default_mappings.enable then
        if config.default_mappings.repeat_style == "orignal" then
            vim.keymap.set({ "n" }, ";", move.repeat_last_move, { desc = "nvim-next", noremap = true })
            vim.keymap.set({ "n" }, ',', move.repeat_last_move_opposite, { desc = "nvim-prev", noremap = true })
        elseif config.default_mappings.repeat_style == "directional" then
            vim.keymap.set({ "n" }, ";", move.repeat_last_move_forward, { desc = "nvim-next", noremap = true })
            vim.keymap.set({ "n" }, ',', move.repeat_last_move_opposite_backward, { desc = "nvim-prev", noremap = true })
        else
            vim.notify(
                "Unrecognized repeat_style value:" .. vim.inspect(config.default_mappings.repeat_style),
                vim.log.levels.ERROR
            )
        end
    end
    for _, i in ipairs(config.items) do

        vim.keymap.set({ "n", "x", "o" }, i.key_prev, i.func_prev, i.opts)
        vim.keymap.set({ "n", "x", "o" }, i.key_next, i.func_next, i.opts)
    end
    return move
end

return {
    setup = setup,
}
