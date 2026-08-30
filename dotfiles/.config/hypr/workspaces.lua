-- Workspaces are pinned by monitor description so they always live on the
-- correct physical display regardless of DP port renumbering.
--
-- Layout when docked:
--   1-9  -> Samsung ultrawide  (primary work area)
--   10   -> Framework laptop   (music player / aux content)
--
-- Undocked, EVERY rule here is disabled -- including the laptop's own -- so a
-- laptop-only session runs on stock Hyprland workspace behaviour. Pinning 10 as
-- default+persistent only makes sense as the counterpart to the ultrawide
-- holding 1-9; alone it just strands focus on a workspace numbered 10.
--
-- Rules are built up front and toggled rather than created on dock: Hyprland
-- has no API to delete a workspace rule, so creating them inside the callback
-- would stack duplicates on every reconnect. A disabled rule has no effect.

-- pcall'd so a broken utils.lua surfaces as one readable message instead of a
-- bare traceback out of the middle of the config parse.
local ok, utils = pcall(require, "utils")
if not ok then
	error("utils.lua failed to load: " .. tostring(utils), 0)
end

local rules = {
	hl.workspace_rule({ workspace = "1", monitor = utils.ultrawide, default = true, persistent = true }),
	hl.workspace_rule({ workspace = "2", monitor = utils.ultrawide, persistent = true }),
}

for i = 3, 9 do
	rules[#rules + 1] = hl.workspace_rule({ workspace = tostring(i), monitor = utils.ultrawide })
end

-- Laptop's dedicated workspace -- focus jumps here on first window spawn.
rules[#rules + 1] =
	hl.workspace_rule({ workspace = "10", monitor = utils.laptop, default = true, persistent = true })

utils.on_ultrawide_change(function(docked)
	for _, rule in ipairs(rules) do
		rule:set_enabled(docked)
	end
end)
