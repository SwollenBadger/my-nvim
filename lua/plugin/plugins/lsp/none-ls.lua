return {
	{ "j-hui/fidget.nvim" },
	-- Nvim lsp config is here
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"jay-babu/mason-null-ls.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"neovim/nvim-lspconfig",
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			local null_ls = require("null-ls")
			local lsp_formatting = function(bufnr)
				vim.lsp.buf.format({
					filter = function(client)
						-- apply whatever logic you want (in this example, we'll only use null-ls)
						return client.name == "null-ls"
					end,
					bufnr = bufnr,
				})
			end

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								lsp_formatting(bufnr)
							end,
						})
					end
				end,
				sources = {
					-- Replace these with the tools you have installed
					null_ls.builtins.formatting.prettier.with({
						extra_args = {
							"--no-semi",
							"--single-quote",
							"--jsx-single-quote",
						},
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"css",
							"scss",
							"less",
							"html",
							"json",
							"jsonc",
							"yaml",
							"markdown",
							"markdown.mdx",
							"graphql",
							"handlebars",
						},
					}),
					null_ls.builtins.formatting.stylua,
				},
			})

			require("mason-null-ls").setup({
				ensure_installed = {
					"prettier",
					"stylua",
				},
				automatic_installation = true, -- You can still set this to `true`
			})
		end,
	},
}
