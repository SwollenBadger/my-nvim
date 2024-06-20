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
            require("mason-null-ls").setup({
                ensure_installed = {
                    "prettier",
                    "black",
                    "stylua",
                    "ocamlformat",
                    "shfmt",
                    "php-cs-fixer",
                    "clang-format",
                },
                automatic_installation = true, -- You can still set this to `true`
            })
        end,
    },
}
