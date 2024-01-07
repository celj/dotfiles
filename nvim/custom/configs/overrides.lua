local M = {}

M.treesitter = {
	ensure_installed = {
		"bash",
		"bibtex",
		"comment",
		"css",
		"csv",
		"dockerfile",
		"gitignore",
		"html",
		"http",
		"javascript",
		"json",
		"json5",
		"jsonc",
		"latex",
		"lua",
		"make",
		"markdown",
		"python",
		"regex",
		"rust",
		"sql",
		"terraform",
		"toml",
		"tsv",
		"tsx",
		"typescript",
		"vim",
		"xml",
		"yaml",
	},
	indent = {
		enable = true,
	},
}

M.mason = {
	ensure_installed = {
		"bash-language-server",
		"bibtex-tidy",
		"css-lsp",
		"cssmodules-language-server",
		"docker-compose-language-service",
		"dockerfile-language-server",
		"gitlint",
		"html-lsp",
		"latexindent",
		"lua-language-server",
		"markdownlint",
		"marksman",
		"prettier",
		"ruff",
		"rust-analyzer",
		"rustfmt",
		"shfmt",
		"sqlfluff",
		"sqlls",
		"stylua",
		"tailwindcss-language-server",
		"taplo",
		"terraform-ls",
		"texlab",
		"typescript-language-server",
		"typst-lsp",
		"vim-language-server",
		"xmlformatter",
		"yaml-language-server",
	},
}

M.nvimtree = {
	git = {
		enable = true,
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.copilot = {
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<C-y>",
		},
	},
}

return M
