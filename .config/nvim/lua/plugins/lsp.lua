-- Language servers installed automatically via Mason.
-- Add/remove servers here; per-server settings go in `server_settings`.
local servers = {
  "lua_ls",        -- Lua
  "pyright",       -- Python
  "ruff",          -- Python lint/format
  "ts_ls",         -- JavaScript / TypeScript
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "bashls",
  "clangd",        -- C / C++
  "rust_analyzer", -- Rust
  "marksman",      -- Markdown
  "dockerls",
}
if vim.fn.executable("go") == 1 then
  table.insert(servers, "gopls")
end

local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim", "Snacks" } },
      },
    },
  },
  jsonls = {
    settings = { json = { validate = { enable = true } } },
  },
}

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = { ui = { border = "rounded" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      -- formatters / linters used by conform.nvim
      ensure_installed = { "stylua", "prettier", "shfmt", "clang-format" },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      for name, cfg in pairs(server_settings) do
        vim.lsp.config(name, cfg)
      end

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = { exclude = { "stylua" } },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
          end

          map("gd", function() Snacks.picker.lsp_definitions() end, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gr", function() Snacks.picker.lsp_references() end, "References")
          map("gI", function() Snacks.picker.lsp_implementations() end, "Goto implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto type definition")
          map("K", function() vim.lsp.buf.hover() end, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ss", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },
}
