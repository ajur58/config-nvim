require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'elixirls',
    'rust_analyzer',
    'marksman',
    'html',
    'tailwindcss',
    'ts_ls',
    'cssls',
    'eslint',
    'jsonls',
  },
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "prettierd",
    "eslint_d",
    "stylua",
  },
  auto_update = true, -- Auto-update installed tools
})

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp_mappings,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer',  keyword_length = 3 },
  }
}

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  -- LSP keymaps moved to remap.lua
  -- This function now only handles buffer-local setup if needed
end

-- Default handler for mason-lspconfig
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
      })
    end,

    -- Custom handlers for specific servers
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      })
    end,

    ["elixirls"] = function()
      lspconfig.elixirls.setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        cmd = { "elixir-ls" },
        settings = {
          elixirLS = {
            enableTestLenses = false,
            fetchDeps = false,
            dialyzerEnabled = true,
          }
        }
      })
    end,

    ["html"] = function()
      lspconfig.html.setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        filetypes = { "html", "jsx" }
      })
    end,

    ["marksman"] = function()
      lspconfig.marksman.setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        filetypes = { "markdown", "markdown.mdx" }
      })
    end,

    ["tailwindcss"] = function()
      lspconfig.tailwindcss.setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        filetypes = {
          "aspnetcorerazor",
          "astro",
          "astro-markdown",
          "blade",
          "django-html",
          "htmldjango",
          "edge",
          "eelixir",
          "elixir",
          "ejs",
          "erb",
          "eruby",
          "gohtml",
          "haml",
          "handlebars",
          "hbs",
          "html",
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
          "svelte"
        },
        init_options = {
          userLanguages = {
            elixir = "html-eex",
            eruby = "erb",
            heex = "phoenix-heex",
            svelte = "html"
          },
        },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classList", "ngClass" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning"
            },
            validate = true
          }
        }
      })
    end,

    ["ts_ls"] = function()
      lspconfig.ts_ls.setup({
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
        cmd = { "typescript-language-server", "--stdio" },
      })
    end,
  },
})

vim.diagnostic.config({
  virtual_text = true
})
