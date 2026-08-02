--------------------------
---- ENVIRONMENT VARS ----
--------------------------
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("HYPRCURSOR_THEME", cursorName)
hl.env("HYPRCURSOR_SIZE", cursorSize)
-- See https://github.com/hyprwm/contrib/issues/142
hl.env("GRIMBLAST_NO_CURSOR", "0")

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor " .. cursorName .. " " .. cursorSize)
	hl.exec_cmd("vicinae server &")
	hl.exec_cmd("hyprlock")
	hl.exec_cmd("qs")
end)

--------------------------
---- GENERAL SETTINGS ----
--------------------------
hl.config({
	general = {
		gaps_in = gaps_in,
		gaps_out = gaps_out,
		gaps_workspaces = gaps_workspaces,

		border_size = 1,
		col = {
			active_border = active_border,
			inactive_border = inactive_border,
		},
		resize_on_border = true,

		no_focus_fallback = true,
		allow_tearing = true,
		snap = {
			enabled = true,
			window_gap = 4,
			monitor_gap = 5,
			respect_gaps = true,
		},
	},

	decoration = {
		rounding = rounding,
		rounding_power = rounding_power,

		blur = {
			enabled = true,
			xray = true,
			special = true,
			new_optimizations = true,
			size = 10,
			passes = 3,
			brightness = 1,
			noise = 0.05,
			contrast = 0.89,
			vibrancy = 0.5,
			vibrancy_darkness = 0.5,
			popups = false,
			popups_ignorealpha = 0.6,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},
		shadow = {
			enabled = true,
			range = 20,
			offset = { 0, 2 },
			render_power = 10,
			color = "rgba(00000020)",
		},

		dim_inactive = true,
		dim_strength = 0.05,
		dim_special = 0.2,
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = false
	},

	group = {
		groupbar = {
			font_size = 12,
			font_weight_active = "bold",
			gradients = false,
			height = 20,
			indicator_height = 20,
			indicator_gap = -20,
			rounding = rounding,
			rounding_power = rounding_power,
			text_color = text_color,
			text_color_inactive = text_color_inactive,
			col = {
				active = group_active_color,
				inactive = group_inactive_color,
			},
		},
		col = {
			border_active = active_border,
			border_inactive = inactive_border,
		},
	},

	input = {
		kb_layout = "us",
		numlock_by_default = true,
		repeat_delay = 250,
		repeat_rate = 35,

		follow_mouse = 1,
		off_window_axis_events = 2,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.7
		}
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty)",
		on_focus_under_fullscreen = 2,
		allow_session_lock_restore = true,
		session_lock_xray = true,
		initial_workspace_tracking = false,
		focus_on_activate = true
	},

	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true
	},

	cursor = {
		zoom_factor = 1,
		zoom_rigid = false,
		zoom_disable_aa = true,
		hotspot_padding = 1
	},

	xwayland = {
		force_zero_scaling = true
	},

	gestures = {
		workspace_swipe_distance = 700,
		workspace_swipe_cancel_ratio = 0.2,
		workspace_swipe_min_speed_to_force = 5,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_create_new = true
	},

	debug = {
		disable_logs = false,
	},
})

--------------------
---- GESTURES ------
--------------------
hl.gesture({
	fingers = 3,
	direction = "swipe",
	action = "move"
})
hl.gesture({
	fingers = 3,
	direction = "pinch",
	action = "fullscreen"
})
hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "workspace"
})
hl.gesture({
	fingers = 4,
	direction = "up",
	action = function()
		hl.dispatch(hl.dsp.global("quickshell:overviewWorkspacesToggle"))
	end
})
hl.gesture({
	fingers = 4,
	direction = "down",
	action = function()
		hl.dispatch(hl.dsp.global("quickshell:overviewWorkspacesToggle"))
	end
})

-----------------------
----- PERMISSIONS -----
-----------------------
for k, v in ipairs(screencopy_perms) do
	hl.permission({ binary = v, type = "screencopy", mode = "allow" })
end
