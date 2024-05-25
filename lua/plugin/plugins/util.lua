return {
	-- Indent blankline
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = function()
			return {
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"dashboard",
						"neo-tree",
						"Trouble",
						"lazy",
						"mason",
					},
				},
				scope = {
					enabled = false,
				},
			}
		end,
	},

	-- Vim surround
	{
		"tpope/vim-surround",
	},

	-- Colorizer
	{
		"norcalli/nvim-colorizer.lua",
		main = "colorizer",
		opts = {
			"*",
			DEFAULT_OPTIONS = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				mode = "background", -- Set the display mode.
			},
		},
	},

	-- Noice
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			}, -- add any options here
		},
	},

	-- Fcitx
	{
		"lilydjwg/fcitx.vim",
	},

	-- Undo tree
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 4
			vim.g.undotree_SplitWidth = 36
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle },
		},
	},

	{
		"tpope/vim-commentary",
	},
}
