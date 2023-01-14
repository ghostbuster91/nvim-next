local M = {}
-- implements naive f, F, t, T with repeat support
local function builtin_find(forward, inclusive, char, repeating)
    -- forward = true -> f, t
    -- inclusive = false -> t, T
    -- if repeating with till (t or T, inclusive = false) then search from the next character
    -- returns nil if cancelled or char
    char = char or vim.fn.nr2char(vim.fn.getchar())
    repeating = repeating or false

    if char == vim.fn.nr2char(27) then
        -- escape
        return nil
    end

    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)

    -- find the count-th occurrence of the char in the line
    local found
    for _ = 1, vim.v.count1 do
        if forward then
            if not inclusive and repeating then
                cursor[2] = cursor[2] + 1
            end
            found = line:find(char, cursor[2] + 2, true)
        else
            -- reverse find from the cursor position
            if not inclusive and repeating then
                cursor[2] = cursor[2] - 1
            end

            found = line:reverse():find(char, #line - cursor[2] + 1, true)
            if found then
                found = #line - found + 1
            end
        end

        if not found then
            return char
        end

        if forward then
            if not inclusive then
                found = found - 1
            end
        else
            if not inclusive then
                found = found + 1
            end
        end

        cursor[2] = found - 1
        repeating = true -- after the first iteration, search from the next character if not inclusive.
    end

    -- move to the found position
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
    return char
end

local function builtin_find_next(inclusive, char, repeating)
    local res = builtin_find("forward", inclusive, char, repeating)
    return res
end

local function builtin_find_prev(inclusive, char, repeating)
    local res = builtin_find(not "forward", inclusive, char, repeating)
    return res
end

M.f = function(char, repeating)
    return builtin_find_next("inclusive", char, repeating)
end

M.F = function(char, repeating)
    return builtin_find_prev("inclusive", char, repeating)
end

M.t = function(char, repeating)
    return builtin_find_next(not "inclusive", char, repeating)
end

M.T = function(char, repeating)
    return builtin_find_prev(not "inclusive", char, repeating)
end

return M
