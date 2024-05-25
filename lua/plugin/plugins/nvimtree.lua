return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	keys = function()
		local root = require("core.util").get_root()
		local function open_tree()
			require("nvim-tree.api").tree.toggle({ path = root, update_root = true, focus = true })
		end

		return {
			{ "<leader>e", open_tree, silent = true },
		}
	end,

	config = function()
		-- disable netrw at the very start of your init.lua
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- set termguicolors to enable highlight groups
		vim.opt.termguicolors = true

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")
			local openfile = require("nvim-tree.actions.node.open-file")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local root = require("core.util").get_root()

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			local view_selection = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local filename = selection.filename
					if filename == nil then
						filename = selection[1]
					end
					openfile.fn("open", filename)
				end)
				return true
			end

			local function launch_telescope(func_name, opts)
				local telescope_status_ok, _ = pcall(require, "telescope")
				if not telescope_status_ok then
					return
				end
				opts = opts or {}
				opts.cwd = root
				opts.search_dirs = { root }
				opts.attach_mappings = view_selection
				return require("telescope.builtin")[func_name](opts)
			end

			local function launch_live_grep(opts)
				return launch_telescope("live_grep", opts)
			end

			local function launch_find_files(opts)
				return launch_telescope("find_files", opts)
			end

			function NvimTreeTrash()
				local lib = require("nvim-tree.lib")
				local node = lib.get_node_at_cursor()
				local trash_cmd = "trash "

				local function get_user_input_char()
					local c = vim.fn.getchar()
					return vim.fn.nr2char(c)
				end

				print("Trash " .. node.name .. " ? y/n")

				if get_user_input_char():match("^y") and node then
					vim.fn.jobstart(trash_cmd .. node.absolute_path, {
						detach = true,
						on_exit = function(job_id, data, event)
							lib.refresh_tree()
						end,
					})
				end

				vim.api.nvim_command("normal :esc<CR>")
			end

			-- custom mappings
			vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts("Help"))
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			vim.keymap.set("n", ".", api.tree.change_root_to_node, opts("Change directory"))
			vim.keymap.set("n", "v", api.node.open.vertical, opts("Open vertical"))
			vim.keymap.set("n", "h", api.node.open.horizontal, opts("Open horizontal"))
			vim.keymap.set("n", "f", launch_find_files, opts("Launch Find Files"))
			vim.keymap.set("n", "g", launch_live_grep, opts("Launch Live Grep"))
			vim.keymap.set("n", "<C-CR>", api.node.run.system, opts("Run System"))
			vim.keymap.set("n", "d", api.fs.trash, opts("Trash file"))
			vim.keymap.set("n", "D", api.fs.remove, opts("Remove file"))
		end

		require("nvim-tree").setup({ -- BEGIN_DEFAULT_OPTS
			on_attach = my_on_attach,
			view = {
				side = "left",
			},
			renderer = {
				add_trailing = false,
				group_empty = false,
				full_name = false,
				root_folder_label = ":~:s?$?/..?",
				indent_width = 2,
				special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "Dockerfile" },
				symlink_destination = true,
				highlight_git = true,
				highlight_diagnostics = true,
				highlight_opened_files = "none",
				highlight_modified = "none",
				highlight_bookmarks = "none",
				highlight_clipboard = "name",
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = "│",
					},
				},
				icons = {
					web_devicons = {
						file = {
							enable = true,
							color = true,
						},
					},
					git_placement = "after",
					modified_placement = "after",
					diagnostics_placement = "signcolumn",
					bookmarks_placement = "signcolumn",
					padding = " ",
					symlink_arrow = " 󱡀 ",
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
						modified = true,
						diagnostics = true,
						bookmarks = true,
					},
					glyphs = {
						default = "",
						symlink = "",
						bookmark = "󰆤",
						modified = "●",
						folder = {
							arrow_closed = "",
							arrow_open = "",
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
							symlink_open = "",
						},
						git = {
							unstaged = "N",
							staged = "S",
							unmerged = "m",
							renamed = "R",
							untracked = "U",
							deleted = "D",
							ignored = "I",
						},
					},
				},
			},
			hijack_directories = {
				enable = true,
				auto_open = true,
			},
			update_focused_file = {
				enable = true,
				update_root = true,
				ignore_list = {},
			},
			git = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
				disable_for_dirs = {},
				timeout = 400,
				cygwin_support = false,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
				debounce_delay = 50,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
				icons = {
					hint = "󰛨",
					info = "󰌵",
					warning = "",
					error = "",
				},
			},
			modified = {
				enable = true,
				show_on_dirs = false,
				show_on_open_dirs = true,
			},
			filters = {
				custom = { "^.git$" },
				git_ignored = false,
				dotfiles = true,
				git_clean = false,
				no_buffer = false,
			},
			live_filter = {
				prefix = "Filter: ",
				always_show_folders = true,
			},
			actions = {
				use_system_clipboard = true,
				expand_all = {
					max_folder_discovery = 300,
					exclude = {},
				},
				file_popup = {
					open_win_config = {
						col = 1,
						row = 1,
						relative = "cursor",
						border = "shadow",
						style = "minimal",
					},
				},
				open_file = {
					quit_on_open = true,
					eject = true,
					resize_window = true,
					window_picker = {
						enable = true,
						picker = "default",
						chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
						exclude = {
							filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
							buftype = { "nofile", "terminal", "help" },
						},
					},
				},
				remove_file = {
					close_window = true,
				},
			},
			trash = {
				cmd = "trash-put",
			},
			tab = {
				sync = {
					open = true,
					close = true,
					ignore = {},
				},
			},
			ui = {
				confirm = {
					remove = true,
					trash = true,
					default_yes = false,
				},
			},
		}) -- END_DEFAULT_OPTS
	end,
}
