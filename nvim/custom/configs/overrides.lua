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
		"black",
		"css-lsp",
		"cssmodules-language-server",
		"deno",
		"docker-compose-language-service",
		"dockerfile-language-server",
		"flake8",
		"gitlint",
		"html-lsp",
		"latexindent",
		"lua-language-server",
		"markdownlint",
		"marksman",
		"prettier",
		"pyright",
		"rust-analyzer",
    "shfmt",
		"sqlfluff",
		"sqlls",
		"stylua",
		"tailwindcss-language-server",
		"taplo",
		"terraform-ls",
		"texlab",
		"typescript-language-server",
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
