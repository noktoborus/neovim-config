require('nvim-treesitter.configs').setup {
  -- one of "all", "maintained" (parsers with maintainers),
  -- or a list of languages
  ensure_installed = { "c", "yaml", "rust", "vim", "json", "meson" },

  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  }
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  },
  {
  --  { name = 'buffer' },
  }
  )
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  },
  {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

if vim.fn.executable('clangd') ~= 0 then
  -- ubuntu/termux: apt install clangd
  require('lspconfig')['clangd'].setup({
    root_dir = require("lspconfig.util").root_pattern(".git", ".hg"),
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--function-arg-placeholders=0",
      "--pch-storage=memory",
      "--pretty",
    }
  })
end

if vim.fn.executable('yaml-language-server') ~= 0 then
  -- ubuntu: snap install yaml-language-server
  require('lspconfig')['yamlls'].setup({
    capabilities = capabilities,
    settings = {
      yaml = {
        format = { enable = true },
        completion = { enable = true },
        hover = { enable = true },
        schemas = {
          ["schema.json"] = "/*",
        },
      },
    }
  })
end

if vim.fn.executable('cargo') ~= 0 then
  require('lspconfig').rust_analyzer.setup({})
end

require('gitsigns').setup {
  numhl = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}

-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      cwd_to_path = false,
      grouped = true,
      respect_gitignore = false,
      hidden = true,
      path = "%:p:h",
      dir_icon = "📁",
    },
  },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension("file_browser")

require('winbar').setup({
  enabled = true,

  show_file_path = true,
  show_symbols = true,

  icons = {
      file_icon_default = 'F',
      seperator = '>',
      editor_state = '●',
      lock_icon = 'L',
  },
})

require('lspsaga').init_lsp_saga({
  preview_lines_above = 2,
  max_preview_lines = 10,
  show_outline = {
    win_position = 'left',
    --set special filetype win that outline window split.like NvimTree neotree
    -- defx, db_ui
    win_with = '',
    win_width = 30,
    auto_enter = true,
    auto_preview = true,
    virt_text = '┃',
    jump_key = '<CR>',
    -- auto refresh when change buffer
    auto_refresh = true,
  },
  code_action_lightbulb = {
      enable = true,
      enable_in_insert = true,
      cache_code_action = true,
      sign = true,
      update_time = 150,
      sign_priority = 20,
      virtual_text = true,
  },
  code_action_keys = {
    quit = '<Esc>',
    exec = '<CR>',
  },
  rename_action_quit = '<Esc>',
  symbol_in_winbar = {
    in_custom = false,
    enable = true,
    separator = ' > ',
    show_file = true,
    -- define how to customize filename, eg: %:., %
    -- if not set, use default value `%:t`
    -- more information see `vim.fn.expand` or `expand`
    -- ## only valid after set `show_file = true`
    file_formatter = "",
    click_support = false,
  },
})
