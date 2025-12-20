-- lua/config/colorscheme.lua

local function get_omarchy_colorscheme()
  -- Safely try to load the plugin spec from the Omarchy symlink
  local ok, specs = pcall(require, "plugins.omarchy-theme")
  if not ok or not specs then
    return nil
  end

  -- Parse the specs to find the LazyVim configuration block where the theme name is stored
  for _, spec in ipairs(specs) do
    if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
      return spec.opts.colorscheme
    end
  end
  return nil
end

-- strictly rely on omarchy
local colorscheme = get_omarchy_colorscheme()

if colorscheme then
  local ok = pcall(vim.cmd.colorscheme, colorscheme)
  if not ok then
    vim.notify("Omarchy theme '" .. colorscheme .. "' failed to load. Is the plugin installed?", vim.log.levels.ERROR)
    -- Fallback only if the specific theme fails to load (e.g. plugin missing)
    vim.cmd.colorscheme("default")
  end
else
  -- If we can't read the Omarchy file at all
  vim.notify("Could not detect colorscheme from plugins/omarchy-theme.lua", vim.log.levels.WARN)
  vim.cmd.colorscheme("default")
end
