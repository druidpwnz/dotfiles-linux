-- snacks.nvim: file explorer, fuzzy finder, dashboard, terminal, notifications, indent guides
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    explorer = { enabled = true, replace_netrw = true },
    picker = {
      enabled = true,
      sources = { explorer = { hidden = true } },
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    terminal = { enabled = true },
  },
  keys = {
    -- Explorer
    { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
    -- Find
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word / selection", mode = { "n", "x" } },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help pages" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last search" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Search in buffer" },
    -- Buffers
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    -- Git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },
    -- Terminal
    { "<F7>", function() Snacks.terminal.toggle(nil, { win = { position = "float", border = "rounded" } }) end, desc = "Toggle floating terminal", mode = { "n", "i", "t" } },
    { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
    { "<C-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
    -- Misc
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
  },
}
