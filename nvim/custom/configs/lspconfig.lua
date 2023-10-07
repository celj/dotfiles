local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

local servers = {
	"bashls",
	"cssls",
	"cssmodules_ls",
	"docker_compose_language_service",
	"dockerls",
	"hadolint",
	"html",
	"jsonls",
	"lua_ls",
	"marksman",
	"pyright",
	"rust_analyzer",
	"sqlls",
	"tailwindcss",
	"terraform_lsp",
	"texlab",
	"vimls",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
