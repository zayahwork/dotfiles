return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "NvimTreeToggle",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File tree" },
    },
    opts = {},
  },
}
