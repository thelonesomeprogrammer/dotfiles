local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require('lazy').setup({

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = {
        registers = true,
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20,
        },
        presets = {
          operators = true, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with window
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      motions = {
        count = true,
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left].
        padding = { 0, 1, 0, 1 }, -- extra window padding [top, right, bottom, left]
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        zindex = 1000, -- positive value to position WhichKey above other floating windows.
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
      show_help = true, -- show a help message in the command line for using WhichKey
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      triggers = "auto", -- automatically setup triggers
      triggers_nowait = {
        -- spelling
        "z=",
      },
    }
  },

  { 'echasnovski/mini.indentscope' },

  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },


  { 'nvim-treesitter/nvim-treesitter',build = ':TSUpdate' },

  'lervag/vimtex',

  'mbbill/undotree',

 { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'simrat39/rust-tools.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'jay-babu/mason-null-ls.nvim',

  'nvim-lualine/lualine.nvim',

  'nvim-tree/nvim-web-devicons',

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup(
      {
        ---Add a space b/w comment and the line    
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
            ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode    
        toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
              ---Block-comment toggle keymap
          block = 'gbc',
        },
            ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = 'gc',
          ---Block-comment keymap
          block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
          ---Add comment on the line above    
          above = 'gcO',
          ---Add comment on the line below    
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings    
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc--[[ ` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
              ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
        },
            ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment    
        post_hook = nil,
      })
    end,
  },

  'nvim-lua/plenary.nvim',

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    extensions = {
          fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
          },
    }
  },
  {
    "L3MON4D3/LuaSnip",
        -- install jsregexp (optional!:).
    build = "make install_jsregexp"
  },

  -- Completion framework:
  'hrsh7th/nvim-cmp',

  -- LSP completion source:
  'hrsh7th/cmp-nvim-lsp',

  -- Useful completion sources:
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'saadparwaiz1/cmp_luasnip',
  'f3fora/cmp-spell',

  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {enable = false},
          shortcut = {
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
          },
        },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {"MunifTanjim/nui.nvim"}
  },
})

--[[ opts.lua ]]
local vim = vim
local opt = vim.opt

    -- [[ Context ]]
opt.number = true
opt.relativenumber = true
opt.scrolloff = 6
opt.wrap = true
opt.spell = true
opt.spelllang = 'da'
opt.cursorline = true

-- [[ undotree instead of swap file ]]
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.config/nvim/undotree_undofiles"
opt.undofile = true

-- [[ File types ]]
opt.encoding = 'utf8'
opt.fileencoding = 'utf8'

    -- [[ Theme ]]
opt.syntax = "ON"
opt.termguicolors = true

-- [[ Search ]]
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- [[ White space ]]
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- [[ Splits ]]
opt.splitright = true
opt.splitbelow = true

-- [[ comlitions ]]
opt.completeopt = {'menuone', 'noselect', 'noinsert'}
opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

-- [[ key map ]]
vim.g.mapleader = " "
local kset = vim.keymap.set
-- built-in
kset('n', '<leader>fe', vim.cmd.Ex, {})
kset('n', '<space>e', vim.diagnostic.open_float)
kset('n', '[d', vim.diagnostic.goto_prev)
kset('n', ']d', vim.diagnostic.goto_next)
kset('n', '<space>q', vim.diagnostic.setloclist)

-- telescope
local bul = require('telescope.builtin')
kset('n', '<leader>ff', bul.find_files, {})
kset('n', '<leader>fg', bul.git_files, {})
kset('n', '<leader>bb', bul.buffers, {})

-- luasnip
local ls = require('luasnip')
kset({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

kset({ "i", "s" }, "<C-j>", function()
  if ls.jumpable() then
    ls.jump(-1)
  end
end, { silent = true })

kset({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

kset({ "i", "s" }, "<C-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)


-- keyboard
function Keyboard()
  kset({'n','v'},"m","i",{})
  kset({'n','v'},"i","k",{})
  kset({'n','v'},"e","j",{})
  kset({'n','v'},"n","h",{})
  kset({'n','v'},"o","l",{})
  kset({'n','v'},"l","a",{})
end
--Keyboard()

    -- move stuff in VISUAL mode 
kset("v", "<S-Up>", ":m '<-2<CR>gv=gv")
kset("v", "<S-Down>", ":m '>+1<CR>gv=gv")
kset("v", "K", ":m '<-2<CR>gv=gv")
kset("v", "<J>", ":m '>+1<CR>gv=gv")


-- undotree
kset("n","<leader>uu", vim.cmd.UndotreeToggle)

-- [[ plug-in conf ]]
require("mason").setup({
  ui = {
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    },
  }
})

require("mason-lspconfig").setup()
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {}
lspconfig.csharp_ls.setup {}
lspconfig.pylyzer.setup {}
lspconfig.arduino_language_server.setup {
    cmd = {
        "arduino-language-server",
        "-cli", "/usr/bin/arduino-cli",
        "-clangd", "/usr/bin/clangd"
    }
}
lspconfig.ltex.setup { settings = { ['ltex'] = { language="da_DK" } } }
lspconfig.rust_analyzer.setup {}
require("mason-null-ls").setup({
  ensure_installed = {
    -- Opt to list sources here, when available in mason.
  },
  automatic_installation = false,
  handlers = {},
})

require("null-ls").setup({
  sources = {
    -- Anything not supported by mason.
  }
})



vim.g.vimtex_view_method = 'zathura'

local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
      },
})

vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.cmd([[ 
set signcolumn=no
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])


require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'%p%%/%L'},
    lualine_z = { {'datetime',style='%H:%M'}}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snips/" })
require("luasnip").config.setup({ store_selection_keys = "<A-p>" })

vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]) --}}}

    -- Virtual Text
---local types = require("luasnip.util.types")
ls.config.set_config({
  history = true, --keep around last snippet local to jump back
  updateevents = "TextChanged,TextChangedI", --update changes as you type
  enable_autosnippets = false,
})

-- More Settings --

vim.keymap.set("n", "<Leader><CR>", "<cmd>LuaSnipEdit<cr>", { silent = true, noremap = true })
vim.cmd([[autocmd BufEnter */snippets/*.lua nnoremap <silent> <buffer> <CR> /-- End Refactoring --<CR>O<Esc>O]])

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
          require'luasnip'.lsp_expand(args.body)
    end
  },

  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    {
      name = 'spell',
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
      },
    },
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'luasnip'},
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon ={
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = '󰅩',
        path = '',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
})




require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}


require('mini.indentscope').setup()

require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
    },
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
