local M = {
  "pimalaya/himalaya-vim",
  cmd = { "Himalaya" },
}

function M.config()
  -- Path to himalaya binary (if not in PATH)
  -- vim.g.himalaya_executable = "himalaya"

  -- Folder picker: 'native', 'fzf', 'fzflua', or 'telescope'
  vim.g.himalaya_folder_picker = "telescope"
end

return M
