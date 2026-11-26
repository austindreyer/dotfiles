return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Default line_length (1000) flags any file averaging >1000 bytes/line
      -- as a "bigfile" and force-disables wrap/syntax/treesitter/LSP. Dense
      -- prose files (e.g. ISSUES.md-style running logs) can hit that at a
      -- perfectly normal total file size, so raise it. size (1.5MB) is left
      -- at default and still catches genuinely huge files.
      bigfile = { line_length = 10000 },
    },
  },
}
