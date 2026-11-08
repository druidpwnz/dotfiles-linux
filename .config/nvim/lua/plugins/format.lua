return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "v" }, desc = "Format" },
    {
      "<leader>uf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
      end,
      desc = "Toggle format on save",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      rust = { "rustfmt", lsp_format = "fallback" },
      go = { "gofmt" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function()
      if vim.g.disable_autoformat then return end
      return { timeout_ms = 1000 }
    end,
  },
}
