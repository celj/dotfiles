local null_ls = require("null-ls")

local b = null_ls.builtins

local sources = {
	-- linting
	b.diagnostics.gitlint,
	b.diagnostics.hadolint,
	b.diagnostics.markdownlint,
	b.diagnostics.ruff,
	b.diagnostics.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }),

	-- formatting
	b.formatting.deno_fmt,
	b.formatting.latexindent,
	b.formatting.shfmt,
	b.formatting.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }),
	b.formatting.stylua,
	b.formatting.xmlformat,
	b.formatting.ruff,
	b.formatting.rustfmt,

	-- prettier
	b.formatting.prettier.with({
		filetypes = {
			"css",
			"graphql",
			"html",
			"scss",
			"yaml",
		},
	}),
}

null_ls.setup({
	debug = true,
	sources = sources,
})
