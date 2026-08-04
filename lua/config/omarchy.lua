-- Adapter for the omarchy theme switcher — the only place that knows how
-- omarchy hands us a theme. Omarchy manages lua/plugins/omarchy-theme.lua as
-- a symlink into ~/.config/omarchy/current/theme/neovim.lua whose contents
-- are a LazyVim plugin-spec list (the file also stays under lua/plugins/ so
-- lazy.nvim installs the theme plugin it names). That foreign spec shape is
-- this adapter's private implementation; callers get a colorscheme name.
local M = {}

local function is_available(name)
	return name and vim.tbl_contains(vim.fn.getcompletion("", "color"), name)
end

-- Returns the active omarchy colorscheme name, or nil when not on omarchy
-- (or when the theme file stops matching the expected shape).
-- Omarchy theme files sometimes carry a repo-ish name rather than a valid
-- colorscheme ("catppuccin-nvim") — normalizing that is this adapter's job,
-- so callers never silently land on the fallback for a fixable name.
function M.get_colorscheme()
	local ok, specs = pcall(require, "plugins.omarchy-theme")
	if not ok or type(specs) ~= "table" then
		return nil
	end
	local declared, plugin_name
	for _, spec in ipairs(specs) do
		if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
			declared = spec.opts.colorscheme
		elseif spec[1] and spec.name then
			plugin_name = spec.name
		end
	end
	for _, candidate in ipairs({ declared, declared and declared:gsub("%-nvim$", ""), plugin_name }) do
		if is_available(candidate) then
			return candidate
		end
	end
	return nil
end

return M
