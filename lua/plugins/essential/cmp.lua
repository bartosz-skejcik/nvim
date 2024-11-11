return {
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",

			"hrsh7th/cmp-git",
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local types = require("cmp.types")
			local str = require("cmp.utils.str")

			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			luasnip.config.setup({
				region_check_events = "CursorMoved",
				delete_check_events = "TextChanged",
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					scrollbar = "║",
					-- completeopt = "menu,menuone,noinsert",
				},
				window = {
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-j>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-k>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					-- ['<C-y>'] = cmp.mapping.confirm { select = true },

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- ["<Tab>"] = cmp.mapping.select_next_item(),
					-- ["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "cmp_git" },
					{ name = "path" },
					{
						name = "lazydev",
						-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
						group_index = 0,
					},
					{ name = "luasnip" },
					{ name = "buffer", keyword_length = 5, max_item_count = 5 },
				},
				formatting = {
					expandable_indicator = false,
					fields = {
						"kind",
						"abbr",
						"menu",
					},
					format = lspkind.cmp_format({
						-- mode = "symbol", -- show only symbol annotations
						-- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						-- -- can also be a function to dynamically calculate max width such as
						-- -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
						-- ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
						--
						-- -- The function below will be called before any actual modifications from lspkind
						-- -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						with_text = false,
						before = function(entry, vim_item)
							-- Get the full snippet (and only keep first line)
							local word = entry:get_insert_text()
							if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
								word = entry.completion_item.label
							end
							word = str.oneline(word)

							-- concatenates the string
							-- local max = 50
							-- if string.len(word) >= max then
							-- 	local before = string.sub(word, 1, math.floor((max - 3) / 2))
							-- 	word = before .. "..."
							-- end

							if
								entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
								and string.sub(vim_item.abbr, -1, -1) == "~"
							then
								word = word .. "~"
							end
							vim_item.abbr = word

							return vim_item
						end,
					}),
				},
				experimental = {
					ghost_text = false,
				},
			})
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et