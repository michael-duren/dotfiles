-- Shared monitor helpers.
--
-- Monitors are matched by `desc:` (EDID description) so configs survive
-- DP-port renumbering across reboots and dock reconnects.
-- Find descriptions with: hyprctl monitors | grep description

local M = {}

-- Bare EDID descriptions, as reported by `hyprctl monitors`.
M.ultrawide_desc = "Samsung Electric Company LS34A650U HCNY505479"
M.laptop_desc = "BOE NE160QDM-NZ6"

-- `desc:` selectors -- the form hl.monitor{output=...},
-- hl.get_monitor() and workspace_rule{monitor=...} all take.
M.ultrawide = "desc:" .. M.ultrawide_desc
M.laptop = "desc:" .. M.laptop_desc

--- Is the Samsung ultrawide connected right now?
---
--- NOTE: this is always false while the config is being parsed. Hyprland
--- creates the ConfigManager and runs this file before the aquamarine backend
--- enumerates outputs, so at that point no monitor exists yet -- even one that
--- is physically plugged in. Only meaningful from an event callback or after
--- a `hyprctl reload`. Use M.on_ultrawide_change() instead of calling this at
--- the top level.
---@return boolean
function M.has_ultrawide()
	return hl.get_monitor(M.ultrawide) ~= nil
end

--- Call `fn(docked)` once now, and again whenever the ultrawide is plugged in
--- or unplugged.
---
--- The monitor.added/removed callbacks are handed the monitor that changed, so
--- the description is read off the event rather than re-queried: on removal the
--- monitor is already gone from hl.get_monitors().
---
--- hyprland.start is also subscribed as a backstop, so a session that boots
--- already docked converges even if the initial outputs appear without firing
--- monitor.added. `fn` must therefore be idempotent -- it can run twice for the
--- same state.
---@param fn fun(docked: boolean)
function M.on_ultrawide_change(fn)
	local function is_ultrawide(mon)
		return mon ~= nil
			and mon.description ~= nil
			and mon.description:find(M.ultrawide_desc, 1, true) ~= nil
	end

	hl.on("monitor.added", function(mon)
		if is_ultrawide(mon) then
			fn(true)
		end
	end)

	hl.on("monitor.removed", function(mon)
		if is_ultrawide(mon) then
			fn(false)
		end
	end)

	hl.on("hyprland.start", function()
		fn(M.has_ultrawide())
	end)

	fn(M.has_ultrawide())
end

return M
