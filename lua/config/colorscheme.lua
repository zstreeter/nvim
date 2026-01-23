-- lua/config/colorscheme.lua
-- Dynamically loads Omarchy theme, falls back to catppuccin on non-Omarchy systems

local function get_colorscheme()
  -- Try to read from Omarchy theme (symlinked to plugins/omarchy-theme.lua)
  local ok, specs = pcall(require, "plugins.omarchy-theme")
  if ok and type(specs) == "table" then
    for _, spec in ipairs(specs) do
      if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
        return spec.opts.colorscheme
      end
    end
  end

  -- Fallback for non-Omarchy systems
  return "catppuccin"
end

local colorscheme = get_colorscheme()

local ok = pcall(vim.cmd.colorscheme, colorscheme)
if not ok then
  vim.notify("Colorscheme '" .. colorscheme .. "' not found, using catppuccin", vim.log.levels.WARN)
  pcall(vim.cmd.colorscheme, "catppuccin")
end
