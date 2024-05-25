-- Telescope
return {
    "nvim-telescope/telescope.nvim",
    branch = false,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = function()
        return {
            {
                "<leader>fe",
                function()
                    require("telescope.builtin").find_files({})
                end,
                silent = true,
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep({})
                end,
                silent = true,
            },
            {
                "<leader>fG",
                function()
                    require("telescope.builtin").git_files({})
                end,
                silent = true,
            },
            {
                "<leader>ft",
                function()
                    require("telescope.builtin").buffers({})
                end,
                silent = true,
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").git_branches({})
                end,
                silent = true,
            },
        }
    end,
    opts = function()
        local actions = require("telescope.actions")
        local telescopeConfig = require("telescope.config")
        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--hidden")
        -- I don't want to search in the `.git` directory.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*")

        return {
            defaults = {
                file_ignore_patterns = { "%.git/*" },
                selection_caret = "  ",
                path_display = { "smart" },
                mappings = {
                    i = {

                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,

                        ["<C-c>"] = actions.close,

                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,

                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = "nop",

                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,

                        ["<PageUp>"] = actions.results_scrolling_up,
                        ["<PageDown>"] = actions.results_scrolling_down,

                        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-n>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<C-p>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-l>"] = actions.complete_tag,
                        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                    },

                    n = {
                        ["q"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = "nop",

                        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-n>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<C-p>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                        ["j"] = actions.move_selection_next,
                        ["k"] = actions.move_selection_previous,
                        ["H"] = actions.move_to_top,
                        ["M"] = actions.move_to_middle,
                        ["L"] = actions.move_to_bottom,

                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["gg"] = actions.move_to_top,
                        ["G"] = actions.move_to_bottom,

                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,

                        ["<PageUp>"] = actions.results_scrolling_up,
                        ["<PageDown>"] = actions.results_scrolling_down,

                        ["?"] = actions.which_key,
                    },
                },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    hidden = true,
                },
                live_grep = {
                    theme = "dropdown",
                    hidden = true,
                },
                buffers = {
                    theme = "dropdown",
                },
                git_branches = {
                    theme = "dropdown",
                },
            },
        }
    end,
}
