-- lua/plugins/cdb.lua
return {
  "JBITools/cdb.nvim",
  ft = { "cdb", "cql" },
  config = function()
    require("cdb").setup({
      server = {
        host = "localhost",
        port = 9010,
      },
    })
  end,
}
