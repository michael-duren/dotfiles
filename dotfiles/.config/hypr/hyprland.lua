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
--
-- Loaded under pcall and in order: a typo in one module then costs that
-- module's config instead of aborting the whole parse and leaving a session
-- with HyDE's defaults (or nothing) and no hint as to why. `hl` is unusable
-- for reporting this early -- the backend has not started -- so failures are
-- collected and shown once hyprland.start fires.
local failures = {}

for _, mod in ipairs({ "displays", "workspaces", "ultrawide", "userprefs", "keybindings" }) do
	local ok, err = pcall(require, mod)
	if not ok then
		failures[#failures + 1] = mod .. ".lua: " .. tostring(err)
	end
end

if #failures > 0 then
	hl.on("hyprland.start", function()
		hl.notification.create({
			text = "Hyprland config errors\n" .. table.concat(failures, "\n"),
			timeout = 15000,
			color = "rgb(ff6666)",
		})
	end)
end
