-- Keybinding overrides.
--
-- HyDE's own binds are in ~/.local/share/hypr/lua/key_binds.lua and load before
-- this file. Only the *differences* from the old keybindings.conf live here --
-- everything that matched a HyDE default was dropped rather than duplicated.
--
-- Replacing a HyDE bind needs matching flags, and `description` is not a flag:
-- miss one and both binds stay live on the same combination. `rebind` below
-- sidesteps that by removing the existing bind first.
--
-- Press SUPER + / to see what is actually loaded.

local MOD = hyde.config.modifiers.main
local HYPER = "SUPER + CTRL + ALT + SHIFT"

local function rebind(combo, action, opts)
	hl.unbind(hyde.binds.normalize(combo))
	hl.bind(combo, action, opts)
end

-- ── Window management ────────────────────────────────────────────────────────

-- HyDE binds this to hl.dsp.exit(), which drops the session with no prompt.
rebind(MOD .. " + Delete", hl.dsp.exec_cmd(hyde.sh.session.logout.launcher()), {
	description = "[Window Management] logout menu"
})

hl.bind(HYPER .. " + Up", function()
	local win = assert(hl.get_active_window(), "No active window to toggle fullscreen")
	local next_state = ((tonumber(win.fullscreen) or 0) + 1) % 3
	hl.dispatch(hl.dsp.window.fullscreen_state({internal = next_state, client = next_state, window = win}))
end, {description = "[Window Management] cycle fullscreen"})

-- MOD + L is taken over by vim focus below, so the lock moves off it.
rebind(MOD .. " + SHIFT + CTRL + L", hl.dsp.exec_cmd(hyde.sh.session.lock()), {
	description = "[Window Management] lock session"
})

hl.bind(HYPER .. " + F", hl.dsp.exec_cmd(
	"hyprctl dispatch resizeactive exact 60% 100% && hyprctl dispatch centerwindow"
), {description = "[Window Management] center active window at 60% width"})

-- Escape hatch for the auto-centering in ultrawide.lua: collapse the gaps on the
-- current workspace until the next window event re-applies the workspace rule.
hl.bind(HYPER .. " + G", hl.dsp.exec_cmd(
	"hyprctl keyword workspace \"$(hyprctl activeworkspace -j | jq -r .id),gapsout:5 5 5 5\""
), {description = "[Window Management] ultrawide: temporarily fill"})

-- ── Vim-style focus and window movement ──────────────────────────────────────
--
-- These claim four combos HyDE already uses: MOD + J is its togglesplit (moved
-- to MOD + Y below), MOD + L its lock (moved above), MOD + K its keyboard-layout
-- switch (moved to MOD + ALT + K below), and MOD + SHIFT + K its calculator.

local focus_vim = {h = "left", j = "down", k = "up", l = "right"}
for key, direction in pairs(focus_vim) do
	rebind(MOD .. " + " .. key:upper(), hl.dsp.focus({direction = direction}), {
		description = "[Window Management|Change focus] focus " .. direction .. " (vim)"
	})
	rebind(MOD .. " + SHIFT + " .. key:upper(), hl.dsp.window.move({direction = direction}), {
		description = "[Window Management|Move active window] move window " .. direction .. " (vim)"
	})
end

hl.bind(MOD .. " + Y", hl.dsp.layout("togglesplit"), {
	description = "[Layout Management|Dwindle] toggle split"
})

hl.bind(MOD .. " + ALT + K", hl.dsp.exec_cmd(hyde.sh.kb.switch()), {
	locked = true,
	description = "[Utilities] toggle keyboard layout"
})

-- ── Launchers ────────────────────────────────────────────────────────────────

-- HyDE moved the app finder to MOD + A; keep it on Space as well.
hl.bind(MOD .. " + SPACE", hl.dsp.exec_cmd(hyde.sh.menu.apps()), {
	description = "[Launcher|Rofi menus] application finder"
})

-- ── Screen recording (wf-recorder via HyDE's screenrecord.sh) ────────────────

hl.bind(MOD .. " + ALT + R", hl.dsp.exec_cmd("hyde-shell screenrecord --start"), {
	description = "[Utilities|Screen Capture] start screen recording (drag to select region; click for whole screen)"
})
hl.bind(MOD .. " + ALT + SHIFT + R", hl.dsp.exec_cmd("hyde-shell screenrecord --quit"), {
	description = "[Utilities|Screen Capture] stop screen recording"
})
