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

    M.goto_prev = prev
    M.goto_next = next


    local function setup_bindings(bufnr, bind)
        local config = configs.get_module "nvim_next.textobjects"
        for _, function_call in ipairs(nxo_mode_functions) do
            for mapping, query_metadata in pairs(config.move[function_call]) do
                local mapping_description, query, query_group

                if type(query_metadata) == "table" then
                    query = query_metadata.query
                    query_group = query_metadata.query_group or "textobjects"
                    mapping_description = query_metadata.desc
                else
                    query = query_metadata
                    query_group = "textobjects"
                    mapping_description = "nvim-next:" .. " " .. query_metadata
                end

                local fn = function()
                    M[function_call](query, query_group)
                end


                bind({ "n", "x", "o" }, mapping, fn,
                    { buffer = bufnr, silent = true, remap = false, desc = mapping_description })
            end
        end
    end

    M.attach = function(bufnr, lang)
        lang = lang or parsers.get_buf_lang(bufnr)
        if not queries.get_query(lang, "textobjects") then
            return
        end
        setup_bindings(bufnr, vim.keymap.set)
    end

    M.detach = function(bufnr)
        setup_bindings(bufnr, vim.keymap.del)
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
            move = {
                goto_next_start = {},
                goto_next_end = {},
                goto_previous_start = {},
                goto_previous_end = {},
                goto_next = {},
                goto_previous = {},
            },
        },
    }
end
