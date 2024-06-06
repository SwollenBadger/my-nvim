return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()
        local lspconfig = require("lspconfig")

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        local on_attach = function(client, bufnr)
            local keymap = vim.keymap -- for conciseness
            local opts = { noremap = true, silent = true }
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            opts.buffer = bufnr
            -- set keybinds
            opts.desc = "Show LSP references"
            keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

            opts.desc = "Go to declaration"
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

            opts.desc = "Show LSP implementations"
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

            opts.desc = "Show LSP type definitions"
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

            opts.desc = "Show line diagnostics"
            keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "gh", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping so restart lsp if necessary
        end

        mason_lspconfig.setup({
            ensure_installed = {
                -- Replace these with whatever servers you want to install
                "rust_analyzer",
                "ocamllsp",
                "gopls",
                "clangd",
                "tsserver",
                "lua_ls",
                "intelephense",
                "pylsp",
                "pyright",

                "marksman",
                "sqlls",
                "bashls",
                "yamlls",
                "dockerls",
                "docker_compose_language_service",

                "emmet_ls",
                "svelte",
                "graphql",
                "prismals",
                "tailwindcss",
            },
            automatic_installation = true, -- not the same as ensure_installed
            handlers = {
                function(server_name) -- default handler (optional)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                -- configure svelte server
                ["emmet_ls"] = function()
                    lspconfig.emmet_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = {
                            "php",
                            "astro",
                            "css",
                            "eruby",
                            "html",
                            "htmldjango",
                            "javascriptreact",
                            "less",
                            "pug",
                            "sass",
                            "scss",
                            "svelte",
                            "typescriptreact",
                            "vue",
                        },
                    })
                end,
                ["svelte"] = function()
                    lspconfig.svelte.setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            on_attach(client, bufnr)

                            vim.api.nvim_create_autocmd("BufWritePost", {
                                pattern = { "*.js", "*.ts" },
                                callback = function(ctx)
                                    if client.name == "svelte" then
                                        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                                    end
                                end,
                            })
                        end,
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = { -- custom settings for lua
                            Lua = {
                                -- make the language server recognize "vim" global
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    -- make language server aware of runtime files
                                    library = {
                                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                        [vim.fn.stdpath("config") .. "/lua"] = true,
                                    },
                                },
                            },
                        },
                    })
                end,
                ["graphql"] = function()
                    lspconfig.graphql.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                    })
                end,
            },
        })
    end,
}
