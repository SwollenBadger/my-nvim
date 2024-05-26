return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>fr",
			function()
				require("conform").format({
					format_after_save = {
						lsp_fallback = true,
					},
				})
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		quiet = true,
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			ocaml = { "ocamlformat" },
			python = { "black" },
			php = { "easy-coding-standard" },
			lua = { "stylua" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			sh = { "beautysh" },
			zsh = { "beautysh" },
		},
		format_on_save = function(bufnr)
			-- Disable autoformat for files in a certain path
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname:match("/node_modules/") then
				return
			end

			return {
				format_after_save = {
					lsp_fallback = true,
				},
			}
		end,
		format_after_save = { lsp_fallback = true },
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		-- Customize prettier args
		conform.formatters.prettier = {
			args = function(self, ctx)
				local prettier_roots = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.toml",
					".prettierrc.js",
					".prettierrc.mjs",
					".prettierrc.cjs",
					"prettier.config.js",
					"prettier.config.mjs",
					"prettier.config.cjs",
				}
				local args = {
					"--tab-width",
					"4",
					"--no-semi",
					"--no-bracket-spacing",
					"--single-quote",
					"--stdin-filepath",
					"$FILENAME",
				}

				local localPrettierConfig = vim.fs.find(prettier_roots, {
					upward = true,
					type = "file",
				})[1]
				local globalPrettierConfig = vim.fs.find(prettier_roots, {
					path = vim.fn.stdpath("config"),
					type = "file",
				})[1]
				local disableGlobalPrettierConfig = os.getenv("DISABLE_GLOBAL_PRETTIER_CONFIG")

				-- Project config takes precedence over global config
				if localPrettierConfig then
					args = { "--config", localPrettierConfig, "$FILENAME" }
				elseif globalPrettierConfig and not disableGlobalPrettierConfig then
					args = { "--config", globalPrettierConfig, "$FILENAME" }
				end

				local hasTailwindPrettierPlugin = vim.fs.find("node_modules/prettier-plugin-tailwindcss", {
					upward = true,
					path = ctx.dirname,
					type = "directory",
				})[1]

				if hasTailwindPrettierPlugin then
					vim.list_extend(args, { "--plugin", "prettier-plugin-tailwindcss" })
				end

				return args
			end,
		}

		conform.formatters.beautysh = {
			prepend_args = function()
				return { "--indent-size", "4", "--force-function-style", "fnpar" }
			end,
		}
	end,
}
