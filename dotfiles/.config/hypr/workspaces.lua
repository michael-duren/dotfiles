-- Workspaces are pinned by monitor description so they always live on the
-- correct physical display regardless of DP port renumbering.
--
-- Layout:
--   1-9  -> Samsung ultrawide  (primary work area when docked)
--   10   -> Framework laptop   (music player / aux content)
--
-- When the ultrawide is unplugged, Hyprland automatically reassigns its
-- workspaces to whatever monitor remains, so the laptop alone "just works".

local ultrawide = "desc:Samsung Electric Company LS34A650U HCNY505479"
local laptop = "desc:BOE NE160QDM-NZ6"

hl.workspace_rule({workspace = "1", monitor = ultrawide, default = true, persistent = true})
hl.workspace_rule({workspace = "2", monitor = ultrawide, persistent = true})

for i = 3, 9 do
	hl.workspace_rule({workspace = tostring(i), monitor = ultrawide})
end

-- Laptop's dedicated workspace -- focus jumps here on first window spawn.
hl.workspace_rule({workspace = "10", monitor = laptop, default = true, persistent = true})
