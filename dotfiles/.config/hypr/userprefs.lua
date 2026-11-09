-- Personal Hyprland preferences.
-- See https://wiki.hypr.land/Configuring for more information.

hl.config({
	input = {
		repeat_delay = 300,
		repeat_rate = 50,
		follow_mouse = 1,
		sensitivity = -1,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = false
		}
	}
})

-- Per-device overrides. See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
	name = "pixa3854:00-093a:0274-touchpad",
	sensitivity = 0.5
})

hl.device({
	name = "logitech-mx-master-3s",
	-- sensitivity range: -1 (slowest) to 1 (fastest), 0 = default. Tune to taste.
	sensitivity = -0.3,
	scroll_factor = 1.0
})

-- Ignore maximize requests from apps. Kitty asks to open maximized, which covers
-- every other tiled window on the workspace. Lost in the .conf -> Lua port.
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Autostart. Replaces `exec-once` from the old conf.
hl.on(
	"hyprland.start",
	function()
		hl.exec_cmd("nwg-dock-hyprland -mb 5 -ml 50 -mr 50 -x -d -hd 20")
	end
)

-- Automount removable drives (iPod, USB sticks). HyDE starts udiskie with
-- --no-automount (~/.local/share/hypr/lua/variables.lua); its start_up.lua reads
-- this table when hyprland.start fires, so overriding the entry here wins.
hyde.config.start.applet_removable_media = "hyde-shell app -u hyde-"
	.. (os.getenv("XDG_SESSION_DESKTOP") or "")
	.. "-removable-media-applet.service -t service -- udiskie --smart-tray"
