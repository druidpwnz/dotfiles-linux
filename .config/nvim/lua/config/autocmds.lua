local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank() end,
})

-- Restore cursor position when reopening a file
autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 2-space indent for web/config languages
autocmd("FileType", {
  group = group,
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc", "yaml", "html", "css", "scss", "markdown" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Close helper windows with q
autocmd("FileType", {
  group = group,
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
})

-- Equalize splits on resize
autocmd("VimResized", {
  group = group,
  command = "tabdo wincmd =",
})
