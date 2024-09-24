return {
  'catppuccin/nvim',
  as = 'catppuccin',
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha', -- Choose your flavor: latte, frappe, macchiato, mocha
    }
    vim.cmd [[colorscheme catppuccin]]
  end,
}
