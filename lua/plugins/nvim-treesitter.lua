return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  -- CRASH FIX: Temporarily disable dependencies to allow the main plugin to install first.
  -- Once Neovim starts successfully, you can uncomment these lines.
  -- dependencies = {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  -- },
  config = function()
    -- CRASH FIX: Use pcall so Neovim doesn't die if the plugin is missing
    local status, treesitter = pcall(require, "nvim-treesitter.configs")
    if not status then
      return -- Exit silently if not found, allowing lazy.nvim to install it
    end

    treesitter.setup({
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = false },
      ensure_installed = {
        "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
        "prisma", "markdown", "markdown_inline", "svelte", "graphql",
        "bash", "lua", "vim", "dockerfile", "gitignore", "query",
        "vimdoc", "python", "go", "rust", "c", "cpp",
      },
    })
  end,
}
