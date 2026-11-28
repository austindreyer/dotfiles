-- LazyVim's markdown extra wires up markdownlint-cli2 as a linter, which
-- flags style issues (table formatting, line length, etc.) as inline
-- diagnostics on any markdown file. That's too strict for casual notes, so
-- disable it here. Preview (<leader>cp) and render-markdown.nvim rendering
-- are separate plugins and are unaffected.
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = nil
    end,
  },
}
