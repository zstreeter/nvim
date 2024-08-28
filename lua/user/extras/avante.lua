local M = {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make", -- Optional: only if you want to use tiktoken_core to calculate tokens count
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "Avante" }, -- Lazy-load for specified file types
      opts = {
        file_types = { "markdown", "Avante" },
      },
    },
  },
}

function M.config()
  require("avante").setup {
    provider = "openai",
    claude = {
      endpoint = "https://chatgpt.com",
      model = "chatGPT 4o",
      temperature = 0,
      max_tokens = 4096,
    },
    panel = {
      keymap = {
        open = "<M-CR>",
        refresh = "r",
        accept = "<c-l>",
        jump_next = "<c-j>",
        jump_prev = "<c-k>",
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<c-l>",
        next = "<c-j>",
        prev = "<c-k>",
        dismiss = "<c-h>",
      },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = false,
      gitrebase = false,
      cvs = false,
      ["."] = false, -- Disable for all other file types
    },
    copilot_node_command = "node", -- Node.js command if specific version is required
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      diff = {
        ours = "co",
        theirs = "ct",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      toggle = {
        debug = "<leader>ad",
        hint = "<leader>ah",
      },
    },
    hints = { enabled = true },
    windows = {
      wrap = true, -- similar to vim.o.wrap
      width = 30, -- default % based on available width
      sidebar_header = {
        align = "center", -- left, center, right for title
        rounded = true,
      },
    },
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    diff = {
      debug = false,
      autojump = true,
      list_opener = "copen",
    },
  }

  -- Define key mappings
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>a", "<cmd>AvanteCommand<CR>", opts) -- Example keymap
end

return M
