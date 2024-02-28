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
            })

            require("mason-null-ls").setup({
                ensure_installed = {
                    "prettier",
                    "black",
                    "stylua",
                    "ocamlformat",
                },
                automatic_installation = true, -- You can still set this to `true`
            })
        end,
    },
}
