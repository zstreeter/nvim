local M = {
  "rcarriga/nvim-notify",
}

function M.config()
  local banned_messages = { "No information available" }
  require("notify").setup({
    background_colour = "#000000",
    stages = "fade",  -- optional: add animations for fun
    timeout = 3000,   -- optional: duration of notification
  })

  -- Custom highlighting with Catppuccin Lavender palette
  vim.cmd([[
    highlight NotifyERRORBorder guifg=#E64553
    highlight NotifyWARNBorder guifg=#F28FAD
    highlight NotifyINFOBorder guifg=#B4BEFE
    highlight NotifyDEBUGBorder guifg=#A6E3A1
    highlight NotifyTRACEBorder guifg=#DDB6F2
    highlight NotifyERRORIcon guifg=#E64553
    highlight NotifyWARNIcon guifg=#F28FAD
    highlight NotifyINFOIcon guifg=#B4BEFE
    highlight NotifyDEBUGIcon guifg=#A6E3A1
    highlight NotifyTRACEIcon guifg=#DDB6F2
    highlight NotifyERRORTitle guifg=#E64553
    highlight NotifyWARNTitle guifg=#F28FAD
    highlight NotifyINFOTitle guifg=#B4BEFE
    highlight NotifyDEBUGTitle guifg=#A6E3A1
    highlight NotifyTRACETitle guifg=#DDB6F2
    highlight link NotifyERRORBody Normal
    highlight link NotifyWARNBody Normal
    highlight link NotifyINFOBody Normal
    highlight link NotifyDEBUGBody Normal
    highlight link NotifyTRACEBody Normal
  ]])

  vim.notify = function(msg, ...)
    for _, banned in ipairs(banned_messages) do
      if msg == banned then
        return
      end
    end
    return require "notify"(msg, ...)
  end
end

return M
