require('nvim-treesitter.configs').setup {
    -- one of "all", "maintained" (parsers with maintainers),
    -- or a list of languages
    ensure_installed = {
      "css",
      "html",
      "xml",
      "yaml",
      "json",
      "vim",
      "vimdoc",

      "cmake",
      "make",
      "meson",
      "ninja",

      "markdown",
      "markdown_inline",

      "groovy",
      "bash",
      "python",
      "javascript",
      "perl",

      "lua",
      "luadoc",
      "luap",

      "go",
      "gowork",
      "gomod",
      "gosum",

      "rust",
      "c",
      "cpp",

      "llvm",

      "sql",
      "regex",

      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",

      "glsl",
      "gdscript",
      "godot_resource",

      "proto",
      "diff",
      "dot",
    },

    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    }
}

require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- Set up nvim-tree
local function nvim_tree_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.marks.clear()

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<space>',     api.marks.toggle,                opts('Toggle Bookmark'))
  vim.keymap.set('n', '<esc>',       api.tree.close,                  opts('Close'))

  vim.keymap.set('n', 'd',    api.marks.bulk.delete,                 opts('Delete Bookmarked'))
  vim.keymap.set('n', 'm',    api.marks.bulk.move,                   opts('Move Bookmarked'))
end

require('nvim-tree').setup({
  on_attach = nvim_tree_on_attach,
  disable_netrw = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  view = {
    side = "left",
    width = {
      min = 35,
      max = 40,
    },
  },
})

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
    completion = {
      autocomplete = false,
    },
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
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
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
            { name = 'buffer' },
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
capabilities.textDocument.completion.completionItem.snippetSupport = false

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
          "--header-insertion=never",
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
                  ["schema.json"] = "/*"
              },
          },
      }
  })
end

if vim.fn.executable('pylsp') ~= 0 then
  require('lspconfig')['pylsp'].setup {
      settings = {
          pylsp = {
              plugins = {
                  pycodestyle = {
                      ignore = { 'W391' },
                      maxLineLength = 100
                  }
              }
          }
      }
  }
end

if vim.fn.executable('bash-language-server') ~= 0 then
  -- ubuntu: snap install yaml-language-server
  require('lspconfig')['bashls'].setup({})
end

if vim.fn.executable('cargo') ~= 0 then
  require('lspconfig').rust_analyzer.setup({})
end

if vim.fn.executable('lua-language-server') ~= 0 then
  require('lspconfig').lua_ls.setup({
      settings = {
          Lua = {
              runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
              },
              diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
              },
              workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                  enable = false,
              },
          },
      },
  })
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
local actions = require("telescope.actions")

require("telescope").setup {
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      mappings = {
        i = {
          ["<Tab>"] = actions.cycle_history_prev,
          ["<S-Tab>"] = actions.cycle_history_next,
          ["<Up>"] = actions.move_selection_previous,
          ["<Down>"] = actions.move_selection_next,
          ["<C-Space>"] = actions.toggle_selection,
        },
        n = {
          ["<CR>"] = actions.add_selection + actions.send_selected_to_qflist + actions.open_qflist,
          ["<Space>"] = actions.toggle_selection,
        },
      }
    },
    pickers = {
        find_files = {
            cwd = vim.fn.getcwd(),
        },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        },
      },
    },
}

require("telescope").load_extension("ui-select")

require('winbar').setup({
    enabled = true,
    show_file_path = true,
    show_symbols = true,
    --  icons = {
    --      file_icon_default = 'F',
    --      seperator = '>',
    --      editor_state = '●',
    --      lock_icon = 'L',
    --  },
})

require('lspsaga').setup({
    diagnostic = {
        keys = {
            quit = '<Esc>',
            quit_in_show = { 'q', '<ESC>' },
        },
    },
    rename = {
        quit = "<Esc>",
    },
    finder = {
        layout = 'normal',
        keys = {
            toggle_or_open = { "o", "<CR>" },
            quit = { "q", "<Esc>" },
            shuttle = { "[w", "<TAB>" },
        },
    },
    outline = {
        layout = 'float',
        win_position = "left",
        keys = {
            toggle_or_jump = { "o", "<SPACE>" },
            jump = { "e", "<CR>" },
            quit = { "q", "<ESC>" },
        },
    },
    callhierarchy = {
        layout = 'normal',
        keys = {
          toggle_or_req = { "u", "<SPACE>" },
          edit = { "e", "<CR>" },
          quit = { "q", "<ESC>" },
          shuttle = { "[w", "<TAB>" },
        }
    }
})

require("lsp-rooter").setup({})

require('illuminate').configure()

-- Session Manager configuration
local Path = require('plenary.path')
local config = require('session_manager.config')
local session_manager = require('session_manager')
local fixed_cwd = vim.fn.getcwd()

-- save session to startup's directory, not to last cwd
local function session_manager_save_current_session_fixed()
  if vim.fn.argc() > 0 then
    return
  end
  if fixed_cwd then
    require('session_manager.utils').save_session(config.dir_to_session_filename(fixed_cwd).filename)
  end
end

session_manager.setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
  session_filename_to_dir = session_filename_to_dir,
  dir_to_session_filename = dir_to_session_filename,
  autoload_mode = config.AutoloadMode.CurrentDir,
  autosave_last_session = true,
  autosave_ignore_not_normal = true,
  autosave_ignore_dirs = {},
  autosave_ignore_filetypes = {
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_buftypes = {},
  autosave_only_in_session = false,
  max_path_length = 80,
})

session_manager.save_current_session = session_manager_save_current_session_fixed

-- Lualine configuration
local function lualine_getcwdname()
  local cwd = vim.fn.getcwd()
  local homedir = vim.fn.expand('~')
  local prefix = ''

  if cwd ~= fixed_cwd then
    prefix = vim.fn.fnamemodify(fixed_cwd, ":t")..':'
  end

  if fixed_cwd == homedir then
    prefix = '~:'
  end

  if cwd == homedir then
    return prefix..'~'
  end

  return prefix..vim.fn.fnamemodify(cwd, ":t")
end

require('lualine').setup({
  options = {
    theme = 'everforest',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' }
  },
  tabline = {
    lualine_a = { 'tabs' },
    lualine_b = { },
    lualine_c = {
      {
        'buffers',
        -- use_mode_colors = true,
        buffers_color = {
          active = 'lualine_c_insert',
          inactive = 'lualine_c_inactive',
        },
        symbols = {
          modified = ' ●',
          alternate_file = '',
          directory = '',
        },
      }
    },
    lualine_x = { 'encoding', 'fileformat' },
    lualine_y = { 'diff', 'diagnostics', lualine_getcwdname },
    lualine_z = { 'branch' }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = {
      { 'filename', path = 1 }
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'location', 'progress' },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { 'filename', path = 1 }
    },
    lualine_x = { 'filetype', 'location' },
    lualine_y = {},
    lualine_z = {}
  },
})

require("trouble").setup({
  action_keys = {
    close = { "<Esc>", "q" },
    jump = { "<tab>", "<2-leftmouse>" },
    jump_close = { "o", "<cr>" },
    toggle_fold = { "zA", "za", "<space>" },
  },
})

local function exists(filename)
  local stat = vim.loop.fs_stat(filename)
  return stat and stat.type or false
end

local function find_git_rootdir(fullfilename)
  local path = vim.fn.fnamemodify(fullfilename, ":h")

  if fullfilename == path then
    return nil
  end

  if exists(Path:new(path, ".git").filename) == 'directory' then
    return path
  end

  return find_git_rootdir(path)
end

function _G.save_buffers_and_git_push_force()
  local current_file_name = vim.fn.expand("%:p")
  local tempfilename = vim.fn.tempname()
  local gitroot = find_git_rootdir(current_file_name)
  local file = io.open(tempfilename, "w")

  if file == nil then
    print("Can not open temporary file")
  else
    if gitroot == nil then
      print("File " .. current_file_name .." has no git tree")
      return
    end

    file:write("echo rootdir is '" .. gitroot .. "'\n")
    file:write("echo List files what pending to save:\n")
    file:write("echo " .. current_file_name .. "\n")
    file:write("cd '" .. gitroot .. "'\n")
    file:write("BRANCH=`git rev-parse --abbrev-ref HEAD`\n")
    file:write("[ $? -eq 0 ] || exit 1\n")
    file:write("[ ${BRANCH} == 'master' -o ${BRANCH} == 'main' ] && echo -e '\\e[0;31m Push to master and main branch not allowed\\e[0m' && exit 1\n")

    for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
      local buffilename = vim.api.nvim_buf_get_name(bufid)

      if buffilename:sub(1, #gitroot) ~= gitroot then
        file:write("echo -e '\\e[0;37m" .. buffilename .. "\\e[0m: skip'\n")
      else
        if vim.api.nvim_get_option_value('modified', { buf = bufid }) then
          file:write("echo -e '\\e[0;33m" .. buffilename .. "\\e[0m: save modified buffer'\n")
          vim.api.save_buffer(bufid)
        end

        file:write("echo -e '\\e[0;32m" .. buffilename .. "\\e[0m: perform git add'\n")
        file:write("git add '" .. buffilename:sub(#gitroot + 2) .. "'\n")
      end
    end

    file:write("git status\n")
    file:write("git commit -a -m 'temporary commit'\n")
    file:write("git push origin HEAD -f")
    file:close()

    vim.cmd("terminal bash '" .. tempfilename .. "'")
  end
end
