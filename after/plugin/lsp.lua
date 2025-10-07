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
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      --           require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp_mappings,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer',  keyword_length = 3 },
    { name = 'vsnip' }, -- For vsnip users.
    --{ name = 'luasnip', keyword_length = 2 },
  }
}

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
  -- LSP keymaps moved to remap.lua
  -- This function now only handles buffer-local setup if needed
end

require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      vim.lsp.config[server_name] = {
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
      }
    end,
  },
})

-- Fix Undefined global 'vim'
vim.lsp.config.lua_ls = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

-- Explicitly configure ElixirLS to ensure on_attach is called
vim.lsp.config.elixirls = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  cmd = { "elixir-ls" },
  settings = {
    elixirLS = {
      -- Disable ElixirLS formatter to avoid conflicts - use mix formatter via null-ls instead
      enableTestLenses = false,
      fetchDeps = false,
      dialyzerEnabled = true,
      formatProvider = false, -- Important: disable to prevent formatting conflicts
    }
  }
}

vim.lsp.config.html = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  filetypes = { "html", "jsx" }
}

vim.lsp.config.marksman = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  filetypes = { "markdown", "markdown.mdx" }
}

-- Tailwind CSS setup
vim.lsp.config.tailwindcss = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  root_dir = function(fname)
    -- Handle case where fname might be a buffer number instead of a string
    local path = fname
    if type(fname) == "number" then
      path = vim.api.nvim_buf_get_name(fname)
      if path == "" then
        path = vim.fn.getcwd()
      end
    end

    return vim.fs.find({
      'assets/tailwind.config.js',
      'tailwind.config.js',
      'postcss.config.js'
    }, { upward = true, path = path })[1]
  end,
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
}

vim.diagnostic.config({
  virtual_text = true
})

-- TypeScript LSP setup
vim.lsp.config.ts_ls = {
  on_attach = lsp_attach,
  capabilities = lsp_capabilities,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
  cmd = { "typescript-language-server", "--stdio" },
}

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd, -- Use Prettier for JS/TS/JSON/CSS/HTML/Markdown/YAML
    null_ls.builtins.formatting.mix,       -- Use mix for Elixir
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ex", "*.exs", "*.heex", "*.js", "*.ts", "*.tsx", "*.json", "*.css", "*.html", "*.md", "*.yaml" },
  callback = function()
    -- Skip formatting for lazy.lua to prevent corruption
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("lazy%.lua$") then
      return
    end

    vim.lsp.buf.format({
      async = true,
      filter = function(client)
        local filetype = vim.bo.filetype

        -- Prettier for JS, TS, JSON, etc.
        local prettier_filetypes = { "javascript", "typescript", "typescriptreact", "json", "css", "html", "markdown",
          "yaml" }
        if vim.tbl_contains(prettier_filetypes, filetype) then
          return client.name == "null-ls" -- Ensures Prettier from null-ls is used
        end

        -- Use mix formatter via null-ls for Elixir and HEEX files
        if filetype == "elixir" or filetype == "heex" then
          return client.name == "null-ls"
        end

        -- Fallback to any available LSP formatter (e.g., Lua)
        return true
      end,
    })
  end,
})
