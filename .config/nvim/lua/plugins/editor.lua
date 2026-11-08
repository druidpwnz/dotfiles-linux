return {
  -- Git signs in the gutter + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map({ "n", "v" }, "<leader>gh", gs.stage_hunk, "Stage hunk")
        map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gL", gs.blame_line, "Blame line")
        map("n", "<leader>gd", gs.diffthis, "Diff file")
      end,
    },
  },

  -- Auto pairs
  { "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },

  -- Surround: sa (add), sd (delete), sr (replace)
  { "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },

  -- Better text objects (af/if functions, ac/ic classes, etc.)
  { "nvim-mini/mini.ai", event = "VeryLazy", opts = {} },

  -- Auto close/rename HTML/JSX tags
  { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" }, opts = {} },

  -- Highlight TODO/FIXME/NOTE comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo comments" },
    },
  },
}
