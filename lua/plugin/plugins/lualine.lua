-- Lualine
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VimEnter",
	opts = function()
		local mocha = require("catppuccin.palettes").get_palette("mocha")

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = {
					normal = { c = { fg = mocha.lavender, bg = mocha.surface0 } },
					inactive = { c = { fg = mocha.lavender, bg = mocha.surface0 } },
				},
				disabled_filetypes = { "TelescopePrompt", "neo-tree", "toggleterm" },
				ignore_focus = { "TelescopePrompt", "neo-tree", "toggleterm" },
				globalstatus = true,
			},
			extensions = { "lazy", "nvim-tree", "toggleterm" },
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left({
			function()
				return "▊"
			end,
			color = { fg = mocha.blue }, -- Sets highlighting of component
			padding = { left = 0, right = 1 }, -- We don't need space before this
		})

		ins_left({
			-- mode component
			function()
				return ""
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = mocha.red,
					i = mocha.green,
					v = mocha.blue,
					[""] = mocha.blue,
					V = mocha.blue,
					c = mocha.mauve,
					no = mocha.red,
					s = mocha.orange,
					S = mocha.orange,
					[""] = mocha.orange,
					ic = mocha.yellow,
					R = mocha.pink,
					Rv = mocha.pink,
					cv = mocha.red,
					ce = mocha.red,
					r = mocha.sky,
					rm = mocha.sky,
					["r?"] = mocha.sky,
					["!"] = mocha.red,
					t = mocha.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({
			-- filesize component
			"filesize",
			cond = conditions.buffer_not_empty,
		})

		ins_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = mocha.mauve, gui = "bold" },
		})

		ins_left({ "location" })

		ins_left({ "progress", color = { fg = mocha.fg, gui = "bold" } })

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			error = " ",
			warn = "󱧡 ",
			info = "󰌵 ",
			hint = "󰛨 ",
			diagnostics_color = {
				color_error = { fg = mocha.red },
				color_warn = { fg = mocha.yellow },
				color_info = { fg = mocha.sky },
			},
		})

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left({
			function()
				return "%="
			end,
		})

		ins_left({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
				local clients = vim.lsp.get_active_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = " LSP:",
			color = { fg = mocha.rosewater, gui = "bold" },
		})

		-- Add components to right sections
		ins_right({
			"o:encoding", -- option component same as &encoding in viml
			fmt = string.upper, -- I'm not sure why it's upper case either ;)
			cond = conditions.hide_in_width,
			color = { fg = mocha.green, gui = "bold" },
		})

		ins_right({
			"fileformat",
			fmt = string.upper,
			icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
			color = { fg = mocha.green, gui = "bold" },
		})

		ins_right({
			"branch",
			icon = "",
			color = { fg = mocha.pink, gui = "bold" },
		})

		ins_right({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = " ", modified = "󰝤 ", removed = " " },
			diff_color = {
				added = { fg = mocha.green },
				modified = { fg = mocha.orange },
				removed = { fg = mocha.red },
			},
			cond = conditions.hide_in_width,
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { fg = mocha.blue },
			padding = { left = 1 },
		})

		return config
	end,
}
