local map = vim.keymap.set
local move = require("nvim-next.move")

return function()
    local prev_qf_item, next_qf_item = move.make_repeatable_pair(function(_)
        local status, _ = pcall(vim.cmd, "cprevious")
        if not status then
            vim.notify("No more items", vim.log.levels.INFO, { title = "Quickfix" })
        end
    end, function(_)
        local status, _ = pcall(vim.cmd, "cnext")
        if not status then
            vim.notify("No more items", vim.log.levels.INFO, { title = "Quickfix" })
        end
    end)
    return {
        setup = function()
            map("n", "]q", next_qf_item, { desc = "nvim-next: next qfix" })
            map("n", "[q", prev_qf_item, { desc = "nvim-next: prev qfix" })
        end,
        cnext = next_qf_item,
        cprevious = prev_qf_item
    }
end
