-- lua/config/colorscheme.lua

local function get_colorscheme()
  -- 1. Try to read from Omarchy config
  local ok, specs = pcall(require, "plugins.omarchy-theme")
  if ok and specs then
    for _, spec in ipairs(specs) do
      if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
        return spec.opts.colorscheme
      end
    end
  end

  -- 2. Fallback for non-Omarchy systems
  return "kanagawa"
end

local colorscheme = get_colorscheme()

-- Try to load the scheme, if it fails (e.g. plugin missing), stick to default
local ok = pcall(vim.cmd.colorscheme, colorscheme)
if not ok then
  vim.notify("Colorscheme '" .. colorscheme .. "' not found! Using default.")
  vim.cmd.colorscheme("default")
end
