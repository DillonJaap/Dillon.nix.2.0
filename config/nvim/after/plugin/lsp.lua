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

-------------------------------------------------------------------------------
-- Configure language servers
-------------------------------------------------------------------------------
vim.lsp.config("lua_ls", {
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
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			buildFlags = { "-tags=integration,e2e" },
		},
	},
})

vim.lsp.config("sqlls", {
	settings = {},
	filetypes = { "sql", "mysql", "sql.tmpl" },
})

vim.lsp.config("ocamllsp", {
	manual_install = true,
	cmd = { "dune", "tools", "exec", "ocamllsp" },
})

vim.lsp.config("html", { filetypes = { "templ", "html" } })
vim.lsp.config("apex_ls", { filetypes = { "apexcode", "apex" } })
vim.lsp.config("templ", { filetypes = { "templ" } })
vim.lsp.config("intelephense", {})
vim.lsp.config("ols", {})
vim.lsp.config("nil_ls", {})
vim.lsp.config("terraformls", {})
vim.lsp.config("cypher_ls", {})

vim.lsp.config("volar", {
	cmd = { "vue-language-server", "--stdio" },
	init_options = {
		vue = {
			hybridMode = false,
		},
	},
	filetypes = {
		"javascript",
		"typescript",
		"vue",
	},
})

vim.lsp.config("gleam", {})
vim.lsp.config("yamlls", {})
vim.lsp.config("tailwindcss", {
	filetypes = {
		"gleam",
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"clojure",
		"django-html",
		"htmldjango",
		"edge",
		"eelixir",
		"elixir",
		"ejs",
		"erb",
		"eruby",
		"gohtml",
		"gohtmltmpl",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"htmlangular",
		"html-eex",
		"heex",
		"jade",
		"leaf",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"templ",
	},
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ "\\w+\\.class\\(\"([^\"]*)\"\\)",                    "([^\"]*)" },
					{ "\\w+\\.class\\('([^']*)'\\)",                       "([^']*)" },
					{ "class\\(\"([^\"]*)\"\\)",                           "([^\"]*)" },
					{ "class\\('([^']*)'\\)",                              "([^']*)" },

					-- Multiline patterns with flexible whitespace and comma handling
					{ "\\w+\\.class\\([\\s\\n]*\"([^\"]*)\"[\\s\\n,]*\\)", "([^\"]*)" },
					{ "\\w+\\.class\\([\\s\\n]*'([^']*)'[\\s\\n,]*\\)",    "([^']*)" },
					{ "class\\([\\s\\n]*\"([^\"]*)\"[\\s\\n,]*\\)",        "([^\"]*)" },
					{ "class\\([\\s\\n]*'([^']*)'[\\s\\n,]*\\)",           "([^']*)" },
				}
			},
			includeLanguages = {
				gleam = "html"
			}
		}
	}
})

-- require("lspconfig").ts_ls.setup({
-- 	init_options = {
-- 		plugins = {
-- 			{
-- 				name = "@vue/typescript-plugin",
-- 				location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
-- 				languages = { "javascript", "typescript", "vue" },
-- 			},
-- 		},
-- 	},
-- 	filetypes = {
-- 		"javascript",
-- 		"typescript",
-- 		"vue",
-- 	},
-- })

lsp.setup()
