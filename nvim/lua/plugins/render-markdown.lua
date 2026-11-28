return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      -- The boxed/aligned table renderer pads cells to their full content
      -- width and never wraps, so long cells (e.g. Description columns in
      -- ISSUES.md-style tables) run off-screen. Disable it so tables fall
      -- back to raw text, which respects normal line wrap.
      pipe_table = {
        enabled = false,
      },
    },
  },
}
