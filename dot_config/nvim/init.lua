local vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then -- Use uv.fs_stat instead of loop.fs_stat
	vim.fn.system({
		"git",
		"clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

	{ "github/copilot.vim" },

	{
		"marcusfschmidt/vim-matlab",
		build = ":UpdtateRemotePlugins",
		init = function()
			vim.g.matlab_auto_mappings = 0
		end
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},

	{ 'echasnovski/mini.indentscope' },
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		priority = 1000,
		opts = {
			flavour = "macchiato",
			transparent_background = true,
			term_colors = true,
		},
		init = function()
			vim.cmd.colorscheme "catppuccin"
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { "nushell/tree-sitter-nu" },
		build = ':TSUpdate',
		opts = {
			ensure_installed = { "lua", "rust", "toml" },
			auto_install = true,
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			}
		},
	},

	{
		'lervag/vimtex',
		config = function()
			vim.g.vimtex_view_method = 'zathura'
			vim.g.vimtex_compiler_method = 'latexrun'
			vim.g.vimtex_compiler_latexrun = { options = { '-verbose-cmds', '--latex-args="-syntax=1"', '--bibtex-cmd=biber' }, }
			vim.g.vimtex_compiler_latexrun_engines = {
				_ = 'xelatex',
				pdflatex = 'pdflatex',
				lualatex = 'lualatex',
				xelatex =
				'xelatex',
			}
		end
	},

	{
		'mbbill/undotree',
		event = "BufAdd",
		keys = {
			{ "<leader>uu", ":UndotreeToggle<CR>", mode = { "n" }, desc = "undotree toggle", },
		}
	},


	{
		'williamboman/mason.nvim',
		opts = {
			ui = {
				icons = {
					package_installed = "",
					package_pending = "",
					package_uninstalled = "",
				},
			}
		}
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			local lsp_conf = require('lspconfig')
			lsp_conf.lua_ls.setup {}
			lsp_conf.matlab_ls.setup {}
			lsp_conf.phpactor.setup {}
			lsp_conf.pylyzer.setup {}
			lsp_conf.ltex.setup { settings = { ltex = { language = "da_DK" } } }
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = {
				php = { "php_cs_fixer" },
				json = { "dprint" },
				markdown = { "dprint" },
				html = { "dprint" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = true,
			},
		}
	},

	-- Linting with nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				python = { "ruff" },
				php = { "phpcs", "phpstan" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},


	{ 'mrcjkb/rustaceanvim',         version = '^5', lazy = false },

	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				theme = 'material',
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diagnostics' },
				lualine_c = { 'filename' },
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { '%p%%/%L' },
				lualine_z = { { 'datetime', style = '%H:%M' } }
			},
			inactive_sections = {
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
			},
		}
	},

	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ 'numToStr/Comment.nvim' },

	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function() return vim.fn.executable("make") == 1 end,
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,               -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case",   -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		}
	},

	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = false,
		},
		keys = {
			{
				"<C-j>",
				function()
					local ls = require('luasnip')
					if ls.jumpable() then
						ls.jump(-1)
					end
				end,
				mode = { "i", "s" },
				desc = "luasnip jump back",
			},
			{
				"<C-l>",
				function()
					local ls = require('luasnip')
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end,
				mode = { "i", "s" },
				desc = "luasnip expand_or_jump",
			},
			{
				"<C-k>",
				function()
					local ls = require('luasnip')
					if ls.choice_active() then
						ls.change_choice(-1)
					end
				end,
				mode = { "i", "s" },
				desc = "luasnip expand_or_jump",
			},
		},
		config = function()
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snips/" })
		end
	},

	-- Completion framework:
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',
			'saadparwaiz1/cmp_luasnip',
			'f3fora/cmp-spell',
		},

		config = function()
			local cmp = require 'cmp'
			cmp.setup({
				snippet = {
					expand = function(args)
						require 'luasnip'.lsp_expand(args.body)
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
					{ name = 'path' },                                  -- file paths
					{ name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
					{ name = 'nvim_lsp_signature_help' },               -- display function signatures with current parameter emphasized
					{ name = 'buffer',                 keyword_length = 2 }, -- source current buffer
					{ name = 'luasnip' },
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					fields = { 'menu', 'abbr', 'kind' },
					format = function(entry, item)
						local menu_icon = {
							nvim_lsp = 'λ',
							luasnip = '⋗',
							buffer = '󰅩',
							path = '',
							spell = ' ',
						}
						item.menu = menu_icon[entry.source.name]
						return item
					end,
				},
			})
		end,
	},
	{ 'stevearc/oil.nvim', dependencies = { "nvim-tree/nvim-web-devicons" } },
})

--[[ opts.lua ]]
local opt = vim.opt

opt.updatetime = 250   -- Faster CursorHold event
opt.lazyredraw = true  -- Avoid unnecessary redraws
opt.redrawtime = 10000 -- Increase redraw time limit

-- [[ Context ]]
opt.number = true
opt.relativenumber = true
opt.scrolloff = 6
opt.wrap = true
opt.spell = true
opt.spelllang = 'en'
opt.cursorline = true

-- [[ undotree instead of swap file ]]
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.config/nvim/undotree_undofiles"
opt.undofile = true


-- [[ Search ]]
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- [[ White space ]]
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- [[ comlitions ]]
opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
opt.shortmess = vim.opt.shortmess + { c = true }

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
kset('n', '<leader><leader>d', bul.diagnostics, {})
kset('n', '<leader>bb', bul.buffers, {})
kset('n', '<leader><leader>s', bul.spell_suggest, {})

-- move stuff in VISUAL mode
kset("v", "<S-Up>", ":m '<-2<CR>gv=gv")
kset("v", "<S-Down>", ":m '>+1<CR>gv=gv")
kset("v", "K", ":m '<-2<CR>gv=gv")
kset("v", "<J>", ":m '>+1<CR>gv=gv")

vim.diagnostic.config({
	virtual_text = true,
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

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<S-Right>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
