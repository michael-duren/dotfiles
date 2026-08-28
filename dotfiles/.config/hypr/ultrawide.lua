-- Ultrawide single-window centering
--
-- When the ultrawide has exactly one tiled visible window on a workspace,
-- add large left/right gaps_out so the window is centered at ~60% width.
-- With 2+ tiled windows the rule does not apply, so normal tiling fills the screen.
--
-- Math: 3440 * 0.60 = 2064 usable -> (3440 - 2064) / 2 = 688 px per side.
-- Top/bottom keep a small 5 px gap.
--
-- Monitor matched by description so it survives DP port renumbering.
-- To find your monitor description: hyprctl monitors | grep description

local ultramon = "m[desc:Samsung Electric Company LS34A650U HCNY505479]"

local mx_lg = 688
local mx_md = 400
local mx_sm = 150
local my_xs = 5

-- gaps_out takes an integer or a CSS-style table; the old `gapsout:` short-vec
-- (top right bottom left) maps onto the named fields.
local function gaps(y, x)
	return {top = y, right = x, bottom = y, left = x}
end

hl.workspace_rule({workspace = ultramon .. " w[tv1]", gaps_out = gaps(my_xs, mx_lg)})
hl.workspace_rule({workspace = ultramon .. " w[tv2]", gaps_out = gaps(my_xs, mx_md)})
hl.workspace_rule({workspace = ultramon .. " w[tv3-99]", gaps_out = gaps(my_xs, mx_sm)})
