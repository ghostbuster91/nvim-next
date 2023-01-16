local M = {}

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

M.make_repeatable_move = function(func, opposite)
    return function()
        local result = func({ repeating = false })
        M.last_move = { func = func, opts = { result = result, repeating = true }, opposite = opposite }
    end
end

M.make_repeatable_pair = function(func_prev, func_next)
    local wrapped_next = M.make_repeatable_move(func_next, func_prev)
    local wrapped_prev = M.make_repeatable_move(func_prev, func_next)
    return wrapped_prev, wrapped_next
end

return M
