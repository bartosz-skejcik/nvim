return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	config = function()
		vim.keymap.set("n", "<leader>mdn", ":MarkdownPreview<CR>", { desc = "[M]ark[D]own Preview [N]ew" })
		vim.keymap.set("n", "<leader>mds", ":MarkdownPreviewStop<CR>", { desc = "[M]ark[D]own Preview [S]top" })

		vim.g.mkdp_markdown_css = "/home/j5on/.config/nvim/md.css"
		vim.g.mkdp_highlight_css = "/home/j5on/.config/nvim/mdhl.css"
	end,
}
