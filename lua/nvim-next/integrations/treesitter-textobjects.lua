local move = require("nvim-next.move")

local nxo_mode_functions = {
    "goto_next_start",
    "goto_next_end",
    "goto_previous_start",
    "goto_previous_end",
    "goto_next",
    "goto_previous",
}
local function setup_next(queries)
    local configs = require "nvim-treesitter.configs"
    local ts_move = require "nvim-treesitter.textobjects.move"
    local parsers = require "nvim-treesitter.parsers"
    local M = {}

    local prev_start, next_start = move.make_repeatable_pair(function(opts)
        ts_move.goto_previous_start(unpack(opts.args or {}))
    end, function(opts)
        ts_move.goto_next_start(unpack(opts.args or {}))
    end)

    M.goto_previous_start = prev_start
    M.goto_next_start = next_start

    local prev_end, next_end = move.make_repeatable_pair(function(opts)
        ts_move.goto_previous_end(unpack(opts.args or {}))
    end, function(opts)
        ts_move.goto_next_end(unpack(opts.args or {}))
    end)

    M.goto_previous_end = prev_end
    M.goto_next_end = next_end

    local prev, next = move.make_repeatable_pair(function(opts)
        ts_move.goto_previous(unpack(opts.args or {}))
    end, function(opts)
        ts_move.goto_next(unpack(opts.args or {}))
    end)

    M.goto_previous = prev
    M.goto_next = next

    M.keymaps_per_buf = {}

    local function setup_bindings(bufnr)
        local keymap_modes = { "n", "x", "o" }
        local config = configs.get_module "nvim_next"
        for _, function_call in ipairs(nxo_mode_functions) do
            for mapping, query_metadata in pairs(config.textobjects.move[function_call]) do
                local mapping_description, query, query_group

                if type(query_metadata) == "table" then
                    query = query_metadata.query
                    query_group = query_metadata.query_group or "textobjects"
                    mapping_description = "nvim-next:" .. " " .. query_metadata.desc
                else
                    query = query_metadata
                    query_group = "textobjects"
                    mapping_description = "nvim-next:" .. " " .. query_metadata
                end

                local fn = function()
                    M[function_call](query, query_group)
                end

                for _, mode in pairs(keymap_modes) do
                    local status, _ = pcall(
                        vim.keymap.set,
                        mode,
                        mapping,
                        fn,
                        { buffer = bufnr, silent = true, remap = false, desc = mapping_description }
                    )
                    if status then
                        M.keymaps_per_buf[bufnr] = M.keymaps_per_buf[bufnr] or {}
                        table.insert(M.keymaps_per_buf[bufnr], { mode = mode, lhs = mapping })
                    end
                end
            end
        end
    end

    M.attach = function(bufnr, lang)
        lang = lang or parsers.get_buf_lang(bufnr)
        if not queries.get_query(lang, "textobjects") then
            return
        end
        setup_bindings(bufnr)
    end

    M.detach = function(bufnr)
        local keymaps_per_buf = M.keymaps_per_buf[bufnr] or {}

        bufnr = bufnr or vim.api.nvim_get_current_buf()

        for _, keymap in ipairs(keymaps_per_buf) do
            -- Even if it fails make it silent
            pcall(vim.keymap.del, { keymap.mode }, keymap.lhs, { buffer = bufnr })
        end
        M.keymaps_per_buf[bufnr] = nil
    end

    return M
end

return function()
    local queries = require "nvim-treesitter.query"
    local nvim_next = setup_next(queries)
    require("nvim-treesitter").define_modules {
        nvim_next = {
            attach = nvim_next.attach,
            detach = nvim_next.detach,
            is_supported = function(lang)
                return queries.has_query_files(lang, "textobjects")
            end,
            textobjects = {
                move = {
                    goto_next_start = {},
                    goto_next_end = {},
                    goto_previous_start = {},
                    goto_previous_end = {},
                    goto_next = {},
                    goto_previous = {},
                },
            }
        },
    }
end
