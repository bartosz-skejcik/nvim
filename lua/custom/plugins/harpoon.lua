return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end)

    vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end)

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")

    local function toggle_telescope(harpoon_files)
      -- Check if Telescope is already open, and if so, close it
      local bufnr = vim.api.nvim_get_current_buf()
      local existing_picker = require("telescope.actions.state").get_current_picker(bufnr)
      if existing_picker then
        actions.close(existing_picker)
        return
      end

      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      -- Open a new Telescope picker
      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        initial_mode = "normal",
        attach_mappings = function(_, map)
          -- Mapping for Ctrl + e to close the window
          map("i", "<leader>e", actions.close)
          map("n", "<leader>e", actions.close)

          map('n', "l", actions.select_default)
          return true
        end,
      }):find()
    end

    -- Set keymap for toggling the Telescope window with Ctrl + e
    vim.keymap.set("n", "<leader>e", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open or close Harpoon window" })
  end
}
