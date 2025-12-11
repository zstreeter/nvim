-- Set the desired colorscheme name
local colorscheme = "catppuccin"

-- Function to safely set the colorscheme
local function set_colorscheme(name)
	-- The "flavour" is set in the plugin configuration, not here.
	-- We just need to call the main colorscheme name.
	local status_ok, _ = pcall(vim.cmd.colorscheme, name)
	if not status_ok then
		vim.notify("Colorscheme '" .. name .. "' not found! Using default.")
		vim.cmd.colorscheme("default")
	end
end

-- Set the colorscheme
set_colorscheme(colorscheme)
