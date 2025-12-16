-- Read colorscheme from Omarchy theme (symlinked in plugins/omarchy-theme.lua)
local function get_colorscheme()
  local ok, theme_spec = pcall(require, "plugins.omarchy-theme")
  if ok and theme_spec then
    for _, spec in ipairs(theme_spec) do
      if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
        return spec.opts.colorscheme
      end
    end
  end
  -- Fallback
  return "catppuccin"
end

local colorscheme = get_colorscheme()

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  vim.notify("Colorscheme '" .. colorscheme .. "' not found! Using default.")
  vim.cmd.colorscheme("default")
end
