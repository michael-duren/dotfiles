-- wezterm use on windows since ghostty isn't available
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
config.color_scheme = "Black Metal (Dark Funeral) (base16)"
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Shell configuration
config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }

-- Launch menu
config.launch_menu = {
	{
		label = "PowerShell 7",
		args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe" },
	},
	{
		label = "Windows PowerShell",
		args = { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" },
	},
	{
		label = "Command Prompt",
		args = { "cmd.exe" },
	},
	{
		label = "Ubuntu WSL",
		args = { "wsl.exe", "-d", "Ubuntu" },
	},
}

-- Key bindings
config.keys = {
	{
		key = "t",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Left" }),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Down" }),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Up" }),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Right" }),
	},
	{
		key = "f",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Vim-like pane navigation with Ctrl+h/l
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},

	-- Close current pane
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},

	-- Zoom/unzoom pane
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
}

-- Font configuration using WezTerm's built-in fonts
-- WezTerm bundles: JetBrains Mono, Noto Color Emoji, and various symbol fonts
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 10.0

-- Alternative built-in options:
-- config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
-- Or if you have Nerd Fonts installed separately:
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("JetBrainsMono Nerd Font")

-- Performance optimizations for Windows
config.front_end = "WebGpu" -- or "OpenGL" if you have issues
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Disable ligatures if not needed (improves performance)
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Scrollback performance
config.scrollback_lines = 10000

-- Windows-specific optimizations
config.window_close_confirmation = "NeverPrompt"
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
}

-- Reduce visual effects for better performance
config.enable_scroll_bar = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

return config
