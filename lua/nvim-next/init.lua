local move = require("nvim-next.move")
local functions = require("nvim-next.builtins.functions")

local default_config = {
    default_mappings = {
        enable = true,
        repeat_style = "original" -- or directional
    },
    items = {}
}

local function setup(config)
    _G.NvimNextFunctions = functions -- todo should be autoload?
    config = vim.deepcopy(config or {})
    config = vim.tbl_deep_extend("force", {}, default_config, config)
    if config.default_mappings.enable then
        if config.default_mappings.repeat_style == "original" then
            vim.keymap.set({ "n", "v" }, ";", move.repeat_last_move, { desc = "nvim-next", noremap = true })
            vim.keymap.set({ "n", "v" }, ',', move.repeat_last_move_opposite, { desc = "nvim-prev", noremap = true })
        elseif config.default_mappings.repeat_style == "directional" then
            vim.keymap.set({ "n", "v" }, ";", move.repeat_last_move_forward, { desc = "nvim-next", noremap = true })
            vim.keymap.set({ "n", "v" }, ',', move.repeat_last_move_opposite_backward,
                { desc = "nvim-prev", noremap = true })
        else
            vim.notify(
                "Unrecognized repeat_style value:" .. vim.inspect(config.default_mappings.repeat_style),
                vim.log.levels.ERROR
            )
        end
    end
    for _, item in ipairs(config.items) do
        for key, bindings in pairs(item) do
            for _, binding in ipairs(bindings) do
                vim.keymap.set(binding.mode, key, binding.func, binding.opts)
            end
        end
    end

    return move
end

return {
    setup = setup,
}
