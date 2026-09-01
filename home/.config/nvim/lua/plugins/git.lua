return {
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufWinEnter",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 300 },
    },
  },
}
