-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- User configuration, ported from the pre-Lua .conf files (2026-08-28).
-- HyDE's defaults live in ~/.local/share/hypr/lua/ and are overwritten on every
-- update; everything below loads after them, so these win.
--
-- Files resolve against ~/.config/hypr/ (hyde.lua puts it on package.path).
require("displays")
require("workspaces")
require("ultrawide")
require("userprefs")
require("keybindings")
