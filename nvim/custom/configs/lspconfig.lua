local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

local servers = {
	"bashls",
	"cssls",
	"cssmodules_ls",
	"docker_compose_language_service",
	"dockerls",
	"html",
	"jsonls",
	"lua_ls",
	"marksman",
	"ruff_lsp",
	"rust_analyzer",
	"sqlls",
	"tailwindcss",
	"terraform_lsp",
	"texlab",
	"typst_lsp",
	"vimls",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
		on_attach = on_attach,
		root_dir = lspconfig.util.root_pattern(".git"),
		single_file_support = true,
	})
end
