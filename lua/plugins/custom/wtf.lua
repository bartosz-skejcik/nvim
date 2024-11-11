return {
  "bartosz-skejcik/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    provider = "groq"
  },
  keys = {
    {
      "<leader>wa",
      mode = { "n", "x" },
      function()
        require("wtf").ai()
      end,
      desc = "Debug diagnostic [W]ith [A]I",
    },
    {
      mode = { "n" },
      "<leader>ws",
      function()
        require("wtf").search()
      end,
      desc = "[W]tf [S]earch diagnostic with Google",
    },
    {
      mode = { "n" },
      "<leader>wh",
      function()
        require("wtf").history()
      end,
      desc = "Populate the quickfix list with previous chat history",
    },
    {
      mode = { "n" },
      "<leader>wg",
      function()
        require("wtf").grep_history()
      end,
      desc = "Grep previous chat history with Telescope",
    },
    {
      mode = { "n", "x" },
      "<leader>we",
      function()
        require("wtf").explain_code()
      end,
      desc = "[W]tf [E]xplain code with AI",
    },
  },
}
