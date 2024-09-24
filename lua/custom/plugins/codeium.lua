return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-h>', function()
      return vim.fn['codeium#AcceptNextLine']()
    end, { expr = true, silent = true })
  end,
}
