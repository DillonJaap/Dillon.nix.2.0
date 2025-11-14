-- Modern, best-practice Neovim LSP configuration
local lspconfig = require("lspconfig")
local wk = require("which-key")

--------------------------------------------------------------------------------
-- Helper to register LSP keymaps
--------------------------------------------------------------------------------
local function register_lsp_keys(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  local mappings = {
    -- Diagnostics
    { key = "[d", fn = vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
    { key = "]d", fn = vim.diagnostic.goto_next, desc = "Next Diagnostic" },
    { key = "<leader>e", fn = vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { key = "<leader>lq", fn = vim.diagnostic.setloclist, desc = "Send to Loclist" },

    -- LSP navigation
    { key = "gD", fn = vim.lsp.buf.declaration, desc = "Go to Declaration" },
    { key = "gd", cmd = "<cmd>Telescope lsp_definitions<cr>", desc = "Go to Definition" },
    { key = "gi", cmd = "<cmd>Telescope lsp_implementations<cr>", desc = "Go to Implementation" },
    { key = "gr", cmd = "<cmd>Telescope lsp_references<cr>", desc = "Go to References" },
    { key = "gT", cmd = "<cmd>Telescope lsp_type_definitions<cr>", desc = "Go to Type Definition" },

    -- Actions
    { key = "<leader>lh", fn = vim.lsp.buf.signature_help, desc = "Signature Help" },
    { key = "<leader>ln", fn = vim.lsp.buf.rename, desc = "Rename Symbol" },
    { key = "<leader>la", fn = vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
    { key = "K", fn = vim.lsp.buf.hover, desc = "Hover Documentation" },

    -- Workspace
    { key = "<leader>lwa", fn = vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder" },
    { key = "<leader>lwr", fn = vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
    {
      key = "<leader>lwl",
      fn = function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      desc = "List Workspace Folders",
    },

    -- Calls
    { key = "<leader>lC", fn = vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
    { key = "<leader>lO", fn = vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },
    { key = "<leader>lc", cmd = "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Incoming Calls (Telescope)" },
    { key = "<leader>lo", cmd = "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Outgoing Calls (Telescope)" },
  }

  for _, map in ipairs(mappings) do
    if map.cmd then
      vim.keymap.set(map.mode or "n", map.key, map.cmd, opts)
    else
      vim.keymap.set(map.mode or "n", map.key, map.fn, opts)
    end
  end

  wk.add({
    { "<leader>l", group = "LSP" },
    { "<leader>lw", group = "Workspace" },
  })
end

--------------------------------------------------------------------------------
-- Common attach + capabilities
--------------------------------------------------------------------------------
local function on_attach(client, bufnr)
  register_lsp_keys(bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end)

--------------------------------------------------------------------------------
-- Language servers
--------------------------------------------------------------------------------

-- Lua (Neovim)
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      completion = { callSnippet = "Replace" },
    },
  },
})

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      buildFlags = { "-tags=integration,e2e" },
    },
  },
})

-- SQL
lspconfig.sqlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sql", "mysql", "sql.tmpl" },
})

-- OCaml
lspconfig.ocamllsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "dune", "exec", "--", "ocamllsp" },
})

-- HTML
lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "templ" },
})

-- Apex
lspconfig.apex_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "apexcode", "apex" },
})

-- Templ
lspconfig.templ.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "templ" },
})

-- PHP
lspconfig.intelephense.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Odin
lspconfig.ols.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Nix
lspconfig.nil_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Terraform
lspconfig.terraformls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Cypher
lspconfig.cypher_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Volar (Vue)
lspconfig.volar.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "vue-language-server", "--stdio" },
  init_options = { vue = { hybridMode = false } },
  filetypes = { "javascript", "typescript", "vue" },
})

-- Gleam
lspconfig.gleam.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- YAML
lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TailwindCSS (now includes "gleam" in filetypes)
-- TailwindCSS (default filetypes + gleam)
lspconfig.tailwindcss.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html",
    "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby",
    "gohtml", "haml", "handlebars", "hbs", "html", "htmlangular",
    "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx",
    "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig",
    "css", "less", "postcss", "sass", "scss", "stylus", "sugarss",
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "vue", "svelte", "gleam",
  },
  settings = {
    tailwindCSS = {
      includeLanguages = { gleam = "html" },
      experimental = {
        classRegex = {
          { '\\w+\\.class\\("([^"]*)"\\)', '([^"]*)' },
          { "\\w+\\.class\\('([^']*)'\\)", "([^']*)" },
          { 'class\\("([^"]*)"\\)', '([^"]*)' },
          { "class\\('([^']*)'\\)", "([^']*)" },
          -- multiline support
          { '\\w+\\.class\\([\\s\\n]*"([^"]*)"[\\s\\n,]*\\)', '([^"]*)' },
          { "\\w+\\.class\\([\\s\\n]*'([^']*)'[\\s\\n,]*\\)", "([^']*)" },
          { 'class\\([\\s\\n]*"([^"]*)"[\\s\\n,]*\\)', '([^"]*)' },
          { "class\\([\\s\\n]*'([^']*)'[\\s\\n,]*\\)", "([^']*)" },
        },
      },
    },
  },
})
