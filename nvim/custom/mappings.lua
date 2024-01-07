local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "Format code",
    }

  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

return M
