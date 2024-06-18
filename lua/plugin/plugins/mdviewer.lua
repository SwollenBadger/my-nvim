return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	config = function()
		vim.keymap.set("n", "<leader>mdt", ":MarkdownPreviewToggle<CR>")
		vim.keymap.set("n", "<leader>mdp", ":MarkdownPreview<CR>")
		vim.keymap.set("n", "<leader>mdx", ":MarkdownPreviewStop<CR>")
	end,
	ft = { "markdown" },
}
