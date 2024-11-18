local highlight = vim.api.nvim_create_namespace('EofHighlight')

local function mark()
    local line = vim.api.nvim_buf_line_count(0) - 1
    local opts
    if vim.api.nvim_get_option_value("endofline", { buf = 0 }) then
        opts = { strict = false, virt_text = { { "EOL", "EndOfBuffer" } } }
    else
        opts = { strict = false, virt_text = { { "No final EOL", "Error" } } }
    end
    vim.api.nvim_buf_clear_namespace(0, highlight, 0, -1)
    vim.api.nvim_buf_set_extmark(0, highlight, line, 0, opts)
end

local function init()
    vim.api.nvim_buf_attach(0, true, {
        on_changedtick = function()
            mark()
        end,
        on_lines = function()
            mark()
        end
    })
    mark()
end

local function setup()
    local augroup = vim.api.nvim_create_augroup("EoFMarker", { clear = true })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" },
        { group = augroup, desc = "setup events for end of file marker", callback = init })
    vim.api.nvim_create_autocmd({ "BufWritePost" },
        { group = augroup, desc = "setup events for end of file marker", callback = mark })
end

return { setup = setup };
