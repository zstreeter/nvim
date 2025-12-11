local M = {
  "zadirion/Unreal.nvim",
  dependencies = { "tpope/vim-dispatch" },
  config = function()
    require "unreal" -- Just require the module if no setup is needed
  end,
}

return M
