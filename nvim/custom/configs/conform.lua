local options = {
  lsp_fallback = true,

  formatters_by_ft = {
    css = { "prettier" },
    graphql = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    latex = { "latexindent" },
    lua = { "stylua" },
    markdown = { "prettier" },
    python = { "ruff_format" },
    rust = { "rustfmt" },
    scss = { "prettier" },
    sh = { "shfmt" },
    sql = { "sqlfluff" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    xml = { "xmlformat" },
    yaml = { "prettier" },
  }
}

require("conform").setup(options)

-- require("conform").formatters.sqlfluff = {
--   inherit = true,
--   command = "sqlfluff",
--   args = { "format", "--dialect", "postgres" },
--   lsp_fallback = true,
--   stdin = false,
-- }