local register_lsp_keys = function(bufno)
	local lsp_keymaps = {
		-- diagnostics
		{ "[d",         vim.diagnostic.goto_next,                  desc = "goto next diagnostic" },
		{ "]d",         vim.diagnostic.goto_prev,                  desc = "goto prev diagnostic" },
		{ "<leader>e",  vim.diagnostic.open_float,                 desc = "Open floating diagnostic" },
		{ "<leader>lq", vim.diagnostic.setqflist,                  desc = "diagnostic setloclist" },
		{ "gD",         vim.lsp.buf.declaration,                   desc = "Goto Declaration" },
		{ "gr",         "<cmd>Telescope lsp_references<cr>",       desc = "Goto References" },
		{ "gi",         "<cmd>Telescope lsp_implementations<cr>",  desc = "Goto Implementations" },
		{ "gd",         "<cmd>Telescope lsp_definitions<cr>",      desc = "Goto Definitions" },
		{ "gT",         "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definitions" },
		{
			"<leader>lc",
			"<cmd>Telescope lsp_incoming_calls<cr>",
			desc = "Incoming calls",
			mode = { "n", "v" },
		},
		{
			"<leader>lo",
			"<cmd>Telescope lsp_outgoing_calls<cr>",
			desc = "Outgoing calls",
			mode = { "n", "v" },
		},

		-- quickfix
		{ "<leader>lr", vim.lsp.buf.references,      desc = "References" },
		{ "<leader>li", vim.lsp.buf.implementation,  desc = "Implementations" },
		{ "<leader>ld", vim.lsp.buf.definition,      desc = "Definitions" },
		{ "<leader>lt", vim.lsp.buf.type_definition, desc = "Type Definitions" },
		{
			"<leader>lC",
			vim.lsp.buf.incoming_calls,
			desc = "Incoming calls",
			mode = { "n", "v" },
		},
		{
			"<leader>lO",
			vim.lsp.buf.outgoing_calls,
			desc = "Outgoing calls",
			mode = { "n", "v" },
		},

		-- workspaces
		{ "<leader>lwa", vim.lsp.buf.add_workspace_folder,    desc = "Add workspace folder" },
		{ "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
		{
			"<leader>lwl",
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			desc = "List workspace folders",
		},

		-- lsp misc actions
		{ "K",          vim.lsp.buf.hover,          desc = "Show Documentation/Definition" },
		{ "<leader>lh", vim.lsp.buf.signature_help, desc = "Signature help" },
		{ "<leader>ln", vim.lsp.buf.rename,         desc = "Rename" },
		--{ "<leader>lf", vim.lsp.buf.format,         desc = "Format code" },
		{
			"<leader>la",
			vim.lsp.buf.code_action,
			desc = "Code action",
			mode = { "n", "v" },
		},
	}
	require("which-key").add({ lsp_keymaps })
end

local custom_on_attach = function(client, bufnr)
	-- local opts = { noremap = true, silent = true }
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	register_lsp_keys(bufnr)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	})
end

require("neodev").setup({
	pathStrict = true,
	-- add any options here, or leave empty to use the default settings
})

local lsp = require("lsp-zero")

lsp.on_attach(custom_on_attach)

--lsp.lsp_flags(lsp_flags)

-- Configure language servers
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
}))

require("lspconfig").gopls.setup({
	settings = {
		gopls = {
			buildFlags = { "-tags=integration,e2e" },
		},
	},
})

require("lspconfig").sqlls.setup({
	settings = {},
	filetypes = { "sql", "mysql", "sql.tmpl" },
})

require("lspconfig").ocamllsp.setup({})

require("lspconfig").html.setup({
	filetypes = { "templ", "html" },
})

require("lspconfig").apex_ls.setup({
	filetypes = { "apexcode", "apex" },
})

require("lspconfig").templ.setup({
	filetypes = { "templ" },
})

require("lspconfig").intelephense.setup({})

require("lspconfig").ols.setup({})
require("lspconfig").nil_ls.setup({})
require("lspconfig").volar.setup({
	cmd = { "vue-language-server", "--stdio" },
})

require("lspconfig").ts_ls.setup({
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
				languages = { "javascript", "typescript", "vue" },
			},
		},
	},
	filetypes = {
		"javascript",
		"typescript",
		"vue",
	},
})

lsp.setup()
