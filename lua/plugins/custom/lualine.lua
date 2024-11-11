return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" },
	event = "VeryLazy",
	opts = function()
		local catppuccin_palette = {
			rosewater = "#f5e0dc",
			flamingo = "#f2cdcd",
			pink = "#f5c2e7",
			mauve = "#cba6f7",
			red = "#f38ba8",
			maroon = "#eba0ac",
			dark_orange = "#f88e78",
			orange = "#f9a875",
			peach = "#fab387",
			yellow = "#f9e2af",
			green = "#a6e3a1",
			teal = "#94e2d5",
			sky = "#89dceb",
			sapphire = "#74c7ec",
			blue = "#89b4fa",
			lavender = "#b4befe",
			white = "#f8f8f2",
			text = "#cdd6f4",
			subtext1 = "#bac2de",
			subtext0 = "#a6adc8",
			overlay2 = "#9399b2",
			overlay1 = "#7f849c",
			overlay0 = "#6c7086",
			surface2 = "#585b70",
			surface1 = "#45475a",
			surface0 = "#313244",
			base = "#1e1e2e",
			mantle = "#181825",
			crust = "#11111b",
		}

		-- local gruvbox_palette = {
		-- 	red = "#cc241d",
		-- 	green = "#98971a",
		-- 	yellow = "#d79921",
		-- 	blue = "#458588",
		-- 	purple = "#b16286",
		-- 	aqua = "#689d6a",
		-- 	orange = "#d65d0e",
		-- 	gray = "#928374",
		-- 	dark_red = "#9d0006",
		-- 	dark_green = "#79740e",
		-- 	dark_yellow = "#b57614",
		-- 	dark_blue = "#076678",
		-- 	dark_purple = "#8f3f71",
		-- 	dark_aqua = "#427b58",
		-- 	dark_orange = "#af3a03",
		-- 	dark_gray = "#7c6f64",
		-- 	light_red = "#fb4934",
		-- 	light_green = "#b8bb26",
		-- 	light_yellow = "#fabd2f",
		-- 	light_blue = "#83a598",
		-- 	light_purple = "#d3869b",
		-- 	light_aqua = "#8ec07c",
		-- 	light_orange = "#fe8019",
		-- 	light_gray = "#ebdbb2",
		-- }

		local webdevicons = require("nvim-web-devicons")

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local opts = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = "auto",
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			extensions = { "neo-tree" },
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(opts.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(opts.sections.lualine_x, component)
		end

		-- ins_left {
		--   function()
		--     return ''
		--   end,
		--   color = { fg = catppuccin_palette.red }, -- Sets highlighting of component,
		--   padding = { left = 0, right = 1 },       -- We don't need space before this
		-- }

		-- ##################################################################################
		-- #                                   Left side                                    #
		-- ##################################################################################

		ins_left({
			function()
				-- Get the current mode and return the corresponding symbol
				local mode = vim.fn.mode()
				local mode_symbols = {
					n = "NORMAL",
					i = "INSERT",
					v = "VISUAL",
					[""] = "V-LINE",
					V = "V-LINE",
					c = "COMMAND",
					no = "N-PENDING",
					s = "SELECT",
					S = "S-LINE",
					[""] = "S-BLOCK",
					ic = "INSERT-COMP",
					R = "REPLACE",
					Rv = "V-REPLACE",
					cv = "V-CMD",
					ce = "EX",
					r = "PROMPT",
					rm = "MORE",
					["r?"] = "CONFIRM",
					["!"] = "SHELL",
					t = "TERMINAL",
				}

				return mode_symbols[mode] or mode
			end,
			color = function()
				-- Auto change color according to Neovim's mode
				local mode_color = {
					n = catppuccin_palette.red,
					i = catppuccin_palette.green,
					v = catppuccin_palette.blue,
					[""] = catppuccin_palette.blue,
					V = catppuccin_palette.blue,
					c = catppuccin_palette.maroon,
					no = catppuccin_palette.red,
					s = catppuccin_palette.yellow,
					S = catppuccin_palette.yellow,
					[""] = catppuccin_palette.yellow,
					ic = catppuccin_palette.peach,
					R = catppuccin_palette.mauve,
					Rv = catppuccin_palette.mauve,
					cv = catppuccin_palette.red,
					ce = catppuccin_palette.red,
					r = catppuccin_palette.teal,
					rm = catppuccin_palette.teal,
					["r?"] = catppuccin_palette.teal,
					["!"] = catppuccin_palette.red,
					t = catppuccin_palette.red,
				}

				return { bg = mode_color[vim.fn.mode()], fg = catppuccin_palette.base, gui = "bold" }
			end,
			separator = { right = "", left = "" },
			padding = { left = 0, right = 0 },
		})

		ins_left({
			function()
				return "▊"
			end,
			color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
			padding = { left = 0, right = 0 },
		})

		ins_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = catppuccin_palette.base, bg = catppuccin_palette.sky },
			separator = { right = "", left = "" },
			padding = { left = 0, right = 0 },
		})

		ins_left({
			function()
				return "▊"
			end,
			color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
			padding = { left = 0, right = 0 },
		})

		ins_left({ "progress", color = { gui = "bold" } })

		ins_left({
			function()
				return "▊"
			end,
			color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
			padding = { left = 0, right = 0 },
		})

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				error = { fg = catppuccin_palette.red },
				warn = { fg = catppuccin_palette.yellow },
				info = { fg = catppuccin_palette.rosewater },
			},
			padding = 0,
		})

		-- ##################################################################################
		-- #                                  Right side                                    #
		-- ##################################################################################

		ins_right({
			"location",
			color = { fg = catppuccin_palette.orange },
			padding = 0,
		})

		-- No Separator here cause there are not rounded corners for components

		ins_right({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = " ", modified = "󰝤 ", removed = " " },
			cond = conditions.hide_in_width,
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
			padding = { left = 0, right = 0 },
		})

		ins_right({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				-- filetype is of type string
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				local clients = vim.lsp.get_clients()

				if next(clients) == nil then
					return msg
				end

				local found_client = nil

				for _, client in ipairs(clients) do
					if client.name ~= "copilot" then
						-- Check if the client supports the current filetype
						local language_id = client.get_language_id(0, buf_ft)
						if language_id == buf_ft then
							found_client = client.name
							break
						end
					end
				end

				return found_client or msg
			end,
			icon = " LSP:",
			color = { fg = catppuccin_palette.base, bg = catppuccin_palette.green, gui = "bold" },
			padding = 0,
			separator = { right = "", left = "" },
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
			padding = { left = 0, right = 0 },
			cond = conditions.hide_in_width,
		})

		-- -- New Treesitter component
		-- ins_right({
		-- 	function()
		-- 		local ts_status = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] and "TS Active"
		-- 			or "TS Inactive"
		-- 		return ts_status
		-- 	end,
		-- 	icon = "綠",
		-- 	color = { fg = catppuccin_palette.base, bg = catppuccin_palette.sapphire, gui = "bold" },
		-- 	padding = 0,
		-- 	separator = { right = "", left = "" },
		-- })
		--
		-- ins_right({
		-- 	function()
		-- 		return "▊"
		-- 	end,
		-- 	color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
		-- 	padding = { left = 0, right = 0 },
		-- 	cond = conditions.hide_in_width,
		-- })

		ins_right({
			-- Language icon and name.
			function()
				-- Get the filetype of the current buffer
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })

				-- Use nvim-web-devicons to get the icon for the current filetype
				local icon, _ = webdevicons.get_icon_by_filetype(buf_ft)

				-- Fallback in case no icon is found
				icon = icon or "" -- Fallback icon:  (unknown)

				-- Return icon and the filetype name (or 'Unknown' if filetype is empty)
				local filetype_display_name = buf_ft ~= "" and buf_ft or "Unknown"
				return string.format("%s %s", icon, filetype_display_name)
			end,
			color = { fg = catppuccin_palette.base, bg = catppuccin_palette.blue, gui = "bold" },
			padding = 0,
			separator = { right = "", left = "" },
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { bg = catppuccin_palette.mantle, fg = catppuccin_palette.mantle },
			padding = { left = 0, right = 0 },
			cond = conditions.hide_in_width,
		})

		ins_right({
			"branch",
			icon = "",
			-- cond = function()
			--   -- Check if we are in a Git repository
			--   return require('neogit')
			-- end,
			color = { bg = catppuccin_palette.mauve, fg = catppuccin_palette.base, gui = "bold" },
			-- color = function()
			--   -- -- based on the branch name, change the background color
			--   -- local neogit = require("neogit") -- for example 'dev' or 'develop' or 'development' will be purple
			--   -- -- print if its a repository
			--   -- local isRepo = neogit.lib.git.repo()
			--   -- print(isRepo)
			--   -- local branch = neogit.branch()

			--   -- local branch_colors = {
			--   --   ['dev'] = catppuccin_palette.mauve,
			--   --   ['master'] = catppuccin_palette.red,
			--   --   ['main'] = catppuccin_palette.red,
			--   --   ['feat'] = catppuccin_palette.green,
			--   --   ['bug'] = catppuccin_palette.yellow,
			--   --   ['fix'] = catppuccin_palette.yellow,
			--   -- }

			--   -- do a .has() for the branch and determine the color that way
			--   -- if not found, return the default color
			--   for key, color in pairs(branch_colors) do
			--     if string.find(branch, key) then
			--       return { bg = color, gui = 'bold' }
			--     end
			--   end

			--   return { bg = catppuccin_palette.white, gui = 'bold' }
			-- end,
			separator = { right = "", left = "" },
			padding = 0,
		})

		-- ins_right {
		--   function()
		--     return ''
		--   end,
		--   color = { fg = catppuccin_palette.red },
		--   padding = { left = 1 },
		-- }

		return opts
	end,
}
