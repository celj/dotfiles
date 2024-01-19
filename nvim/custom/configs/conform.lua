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
		typst = { "typstfmt" },
		xml = { "xmlformat" },
		yaml = { "prettier" },
		go = { "gofmt" },
	},
}

require("conform").setup(options)
