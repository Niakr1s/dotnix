return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = { "lua" },
      auto_install = false,
    })
  end,
}
