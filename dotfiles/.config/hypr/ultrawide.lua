-- Ultrawide single-window centering
--
-- When the ultrawide has exactly one tiled visible window on a workspace,
-- add large left/right gaps_out so the window is centered at ~60% width.
-- With 2+ tiled windows the rule does not apply, so normal tiling fills the screen.
--
-- Math: 3440 * 0.60 = 2064 usable -> (3440 - 2064) / 2 = 688 px per side.
-- Top/bottom keep a small 5 px gap.
--
-- The rules are enabled only while the ultrawide is actually connected. They
-- are scoped to it by `m[desc:...]` anyway, but leaving them off undocked keeps
-- the laptop from inheriting 688 px gaps if the selector ever goes stale.

-- pcall'd so a broken utils.lua surfaces as one readable message instead of a
-- bare traceback out of the middle of the config parse.
local ok, utils = pcall(require, "utils")
if not ok then
	error("utils.lua failed to load: " .. tostring(utils), 0)
end

local ultramon = "m[" .. utils.ultrawide .. "]"

local mx_lg = 688
local mx_md = 400
local mx_sm = 150
local my_xs = 5

-- gaps_out takes an integer or a CSS-style table; the old `gapsout:` short-vec
-- (top right bottom left) maps onto the named fields.
local function gaps(y, x)
	return {top = y, right = x, bottom = y, left = x}
end

local rules = {
	hl.workspace_rule({workspace = ultramon .. " w[tv1]", gaps_out = gaps(my_xs, mx_lg)}),
	hl.workspace_rule({workspace = ultramon .. " w[tv2]", gaps_out = gaps(my_xs, mx_md)}),
	hl.workspace_rule({workspace = ultramon .. " w[tv3-99]", gaps_out = gaps(my_xs, mx_sm)}),
}

utils.on_ultrawide_change(function(docked)
	for _, rule in ipairs(rules) do
		rule:set_enabled(docked)
	end
end)
