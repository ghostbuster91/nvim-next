local M = {}

M.last_move = nil
-- { func: (args)=>(), args = { ... }, opposite: (args)=>() }

M.repeat_last_move = function(opts_ext)
    if M.last_move then
        opts_ext = opts_ext or {}
        local opts = vim.tbl_deep_extend("force", {}, M.last_move.opts, opts_ext)

        -- the idea of handling f/F/t/T this way is copied
        -- directly from the https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/622
        -- all credits go to @kiyoon
        if M.last_move.func == "f" or M.last_move.func == "t" then
            vim.cmd([[normal! ]] .. vim.v.count1 .. ";")
        elseif M.last_move.func == "F" or M.last_move.func == "T" then
            if opts.directional then
                vim.cmd([[normal! ]] .. vim.v.count1 .. ",")
            else
                vim.cmd([[normal! ]] .. vim.v.count1 .. ";")
            end
        else
            if opts.directional then
                M.last_move.forward(opts)
            else
                M.last_move.func(opts)
            end
        end
    end
end

M.repeat_last_move_opposite = function(opts_ext)
    if M.last_move then
        opts_ext = opts_ext or {}
        local opts = vim.tbl_deep_extend("force", {}, M.last_move.opts, opts_ext)

        if M.last_move.func == "f" or M.last_move.func == "t" then
            vim.cmd([[normal! ]] .. vim.v.count1 .. ",")
        elseif M.last_move.func == "F" or M.last_move.func == "T" then
            if opts.directional then
                vim.cmd([[normal! ]] .. vim.v.count1 .. ";")
            else
                vim.cmd([[normal! ]] .. vim.v.count1 .. ",")
            end
        else
            if opts.directional then
                M.last_move.backward(opts)
            else
                M.last_move.opposite(opts)
            end
        end
    end
end

M.repeat_last_move_forward = function()
    if M.last_move then
        M.repeat_last_move({ directional = true })
    end
end

M.repeat_last_move_opposite_backward = function()
    if M.last_move then
        M.repeat_last_move_opposite({ directional = true })
    end
end

M.make_repeatable_move = function(k)
    local k_copy = vim.deepcopy(k)
    return function(...)
        local args = { ... }
        local result = k.func({ repeating = false, args = args })
        local last_move = { opts = { result = result, repeating = true, args = args } }
        M.last_move = vim.tbl_deep_extend("force", {}, k_copy, last_move)
    end
end

M.make_forward_repeatable_move = function(func, opposite)
    local k = {
        forward = func,
        backward = opposite,
        opposite = opposite,
        func = func
    }
    return M.make_repeatable_move(k);
end

M.make_backward_repeatable_move = function(func, opposite)
    local k = {
        forward = opposite,
        backward = func,
        opposite = opposite,
        func = func
    }
    return M.make_repeatable_move(k);
end

M.make_repeatable_pair = function(func_prev, func_next)
    local wrapped_next = M.make_forward_repeatable_move(func_next, func_prev)
    local wrapped_prev = M.make_backward_repeatable_move(func_prev, func_next)
    return wrapped_prev, wrapped_next
end

return M
