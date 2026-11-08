local parsers = {
  "bash", "c", "cpp", "css", "diff", "dockerfile", "go", "html", "javascript",
  "json", "lua", "luadoc", "markdown", "markdown_inline", "python", "query",
  "regex", "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          vim.wo.foldlevel = 99
        end
      end,
    })
  end,
}
