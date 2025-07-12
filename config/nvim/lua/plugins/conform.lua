return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			odinfmt = {
				-- Change where to find the command if it isn't in your path.
				command = "odinfmt",
				args = { "-stdin" },
				stdin = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				vue = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				go = { "gopls", "goimports", "goimports-revisor", stop_after_first = false },
				odin = { "odinfmt" },
			},
		})
	end,
}
