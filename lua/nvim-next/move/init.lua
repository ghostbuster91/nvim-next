local M = {}

M.last_move = nil
-- { func: (args)=>(), args = { ... }, opposite: (args)=>() }

M.repeat_last_move = function(opts_ext)
    if M.last_move then
        opts_ext = opts_ext or {}
        local opts = vim.tbl_deep_extend("force", {}, M.last_move.opts, opts_ext)
        if opts.force_forward then
            M.last_move.forward(opts)
        elseif opts.force_backward then
            M.last_move.backward(opts)
        else
            M.last_move.func(opts)
        end
    end
end

M.repeat_last_move_opposite = function(opts_ext)
    if M.last_move then
        opts_ext = opts_ext or {}
        local opts = vim.tbl_deep_extend("force", {}, M.last_move.opts, opts_ext)
        if opts.force_forward then
            M.last_move.forward(opts)
        elseif opts.force_backward then
            M.last_move.backward(opts)
        else
            M.last_move.opposite(opts)
        end

    end
end

M.repeat_last_move_forward = function()
    if M.last_move then
        M.repeat_last_move { force_forward = true }
    end
end

M.repeat_last_move_opposite_backward = function()
    if M.last_move then
        M.repeat_last_move_opposite { force_backward = true }
    end
end

M.make_repeatable_move = function(k)
    local k_copy = vim.deepcopy(k)
    return function()
        local result = k.func({ repeating = false })
        local last_move = { opts = { result = result, repeating = true } }
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
