hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
  hl.exec_cmd("noctalia")
  hl.exec_cmd('"$HOME/.local/bin/hyprglass-local-load"')
end)

-- ~/.config/hypr/hyprland.lua
-- === Custom Configuration ===

---------------------
-- MONITORS
---------------------
-- Monitor eksternal (atas)
hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

-- Layar laptop (bawah)
hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "0x1080",
    scale = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true, default_name = "web" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true, default_name = "code" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true, default_name = "chat" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1", persistent = true, default_name = "game" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1", persistent = true, default_name = "design" })

---------------------
-- KEYBINDINGS (FIXED)
---------------------
-- Pindah workspace focus
--hl.bind("CTRL+SUPER", "Right", hl.dsp.focus({ workspace = "r+1" }))
--hl.bind("CTRL+SUPER", "Left", hl.dsp.focus({ workspace = "r-1" }))

-- Memindahkan jendela aktif ke workspace lain
--hl.bind("CTRL+SUPER+SHIFT", "Right", hl.dsp.window.move({ workspace = "r+1" }))
--hl.bind("CTRL+SUPER+SHIFT", "Left", hl.dsp.window.move({ workspace = "r-1" }))


---------------------
-- GESTURES & INPUT
---------------------
hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace",
})

hl.config({
    render = {
        -- Keep fullscreen video in SDR so panel brightness remains controllable.
        cm_auto_hdr = 0,
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
    },

    gestures = {
        workspace_swipe_distance = 700,
        workspace_swipe_cancel_ratio = 0.2,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = true,
    },
    input = {
        touchpad = {
            natural_scroll = true,
        },
    },

    decoration = {
        rounding = 20,
        rounding_power = 2,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        blur = {
            enabled = false,
            size = 4,
            passes = 3,
            vibrancy = 0.1696,
            -- variant = "acrylic",
            -- acrylic = {
            --    clarity = 0.82,
            --    refraction = 20.0,
            --    bulb = 48.0,
            --    aberration = 0.025,
            -- },
        },
    },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.1,
  blur = false,
  blur_popups = false,
})

-- ============================================================
-- Hyprland Lua Keybinds
-- Hyprland 0.55+ / Noctalia v5
-- ============================================================

local mainMod = "SUPER"

-- ============================================================
-- Window Management
-- ============================================================

local ipc = "noctalia msg "

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Close active window
hl.bind(
    mainMod .. " + Q",
    hl.dsp.window.close(),
    { description = "Close active window" }
)

-- Fullscreen (mode 1 = maximized, equivalent to old fullscreen, 1)
hl.bind(
    mainMod .. " + F",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "set",
    }),
    { description = "Maximize window" }
)

-- True fullscreen (equivalent to old fullscreen, 0)
hl.bind(
    mainMod .. " + SHIFT + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "set",
    }),
    { description = "Fullscreen window" }
)

-- Toggle floating
hl.bind(
    mainMod .. " + SHIFT + T",
    hl.dsp.window.float({
        action = "toggle",
    }),
    { description = "Toggle floating" }
)

-- Toggle group
hl.bind(
    mainMod .. " + W",
    hl.dsp.group.toggle(),
    { description = "Toggle window group" }
)


-- ============================================================
-- Focus Navigation
-- ============================================================

hl.bind(
    mainMod .. " + left",
    hl.dsp.focus({ direction = "l" }),
    { description = "Focus left" }
)

hl.bind(
    mainMod .. " + down",
    hl.dsp.focus({ direction = "d" }),
    { description = "Focus down" }
)

hl.bind(
    mainMod .. " + up",
    hl.dsp.focus({ direction = "u" }),
    { description = "Focus up" }
)

hl.bind(
    mainMod .. " + right",
    hl.dsp.focus({ direction = "r" }),
    { description = "Focus right" }
)


-- ============================================================
-- Window Movement
-- ============================================================

hl.bind(
    mainMod .. " + SHIFT + left",
    hl.dsp.window.move({ direction = "l" }),
    { description = "Move window left" }
)

hl.bind(
    mainMod .. " + SHIFT + down",
    hl.dsp.window.move({ direction = "d" }),
    { description = "Move window down" }
)

hl.bind(
    mainMod .. " + SHIFT + up",
    hl.dsp.window.move({ direction = "u" }),
    { description = "Move window up" }
)

hl.bind(
    mainMod .. " + SHIFT + right",
    hl.dsp.window.move({ direction = "r" }),
    { description = "Move window right" }
)


-- ============================================================
-- Move Workspaces
-- ============================================================

hl.bind(
    mainMod .. " + SHIFT + Page_Down",
    hl.dsp.window.move({ workspace = "e+1" }),
    { description = "Move window to next workspace" }
)

hl.bind(
    mainMod .. " + SHIFT + Page_Up",
    hl.dsp.window.move({ workspace = "e-1" }),
    { description = "Move window to previous workspace" }
)

-- ============================================================
-- Relative Workspace Navigation
-- ============================================================

-- Ctrl + Super + Right → next workspace
hl.bind(
    "CTRL + SUPER + Right",
    hl.dsp.focus({ workspace = "r+1" }),
    { description = "Next workspace on current monitor" }
)

-- Ctrl + Super + Left → previous workspace
hl.bind(
    "CTRL + SUPER + Left",
    hl.dsp.focus({ workspace = "r-1" }),
    { description = "Previous workspace on current monitor" }
)

-- Ctrl + Super + Shift + Right → move window to next workspace
hl.bind(
    "CTRL + SUPER + SHIFT + Right",
    hl.dsp.window.move({ workspace = "r+1" }),
    { description = "Move window to next workspace" }
)

-- Ctrl + Super + Shift + Left → move window to previous workspace
hl.bind(
    "CTRL + SUPER + SHIFT + Left",
    hl.dsp.window.move({ workspace = "r-1" }),
    { description = "Move window to previous workspace" }
)


-- ============================================================
-- Mouse Wheel Navigation
-- ============================================================

hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" }),
    { description = "Next workspace" }
)

hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" }),
    { description = "Previous workspace" }
)

hl.bind(
    mainMod .. " + CTRL + mouse_down",
    hl.dsp.window.move({ workspace = "e+1" }),
    { description = "Move window to next workspace" }
)

hl.bind(
    mainMod .. " + CTRL + mouse_up",
    hl.dsp.window.move({ workspace = "e-1" }),
    { description = "Move window to previous workspace" }
)


-- ============================================================
-- Numbered Workspaces
-- ============================================================

for i = 1, 9 do
    -- Switch workspace
    hl.bind(
        mainMod .. " + " .. i,
        hl.dsp.focus({ workspace = i }),
        { description = "Workspace " .. i }
    )

    -- Move active window to workspace
    hl.bind(
        mainMod .. " + SHIFT + " .. i,
        hl.dsp.window.move({ workspace = i }),
        { description = "Move window to workspace " .. i }
    )
end


-- ============================================================
-- Manual Sizing
-- ============================================================

-- Old:
-- binde = SUPER, minus, resizeactive, -10% 0
-- binde = SUPER, equal, resizeactive, 10% 0
--
-- Lua resize uses pixel values with relative = true.
-- Adjust resizeAmount if you want larger/smaller steps.

local resizeAmount = 50

hl.bind(
    mainMod .. " + Minus",
    hl.dsp.window.resize({
        x = -resizeAmount,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "Shrink window width",
    }
)

hl.bind(
    mainMod .. " + Equal",
    hl.dsp.window.resize({
        x = resizeAmount,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "Expand window width",
    }
)


hl.bind(
    mainMod .. " + SHIFT + Minus",
    hl.dsp.window.resize({
        x = 0,
        y = -resizeAmount,
        relative = true,
    }),
    {
        repeating = true,
        description = "Shrink window height",
    }
)

hl.bind(
    mainMod .. " + SHIFT + Equal",
    hl.dsp.window.resize({
        x = 0,
        y = resizeAmount,
        relative = true,
    }),
    {
        repeating = true,
        description = "Expand window height",
    }
)


-- ============================================================
-- Move / Resize Windows with SUPER + Mouse
-- ============================================================

-- SUPER + LMB = Move window
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
        description = "Move window",
    }
)

-- SUPER + RMB = Resize window
hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true,
        description = "Resize window",
    }
)


-- ============================================================
-- Resize with SUPER + Keycode
-- ============================================================

-- Old:
-- bindd = SUPER, code:20, Expand window left, resizeactive, -100 0
-- bindd = SUPER, code:21, Shrink window left, resizeactive, 100 0

hl.bind(
    mainMod .. " + code:20",
    hl.dsp.window.resize({
        x = -100,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "Expand window left",
    }
)

hl.bind(
    mainMod .. " + code:21",
    hl.dsp.window.resize({
        x = 100,
        y = 0,
        relative = true,
    }),
    {
        repeating = true,
        description = "Shrink window left",
    }
)


-- ============================================================
-- Noctalia v5
-- ============================================================

-- SUPER + SPACE = Launcher
hl.bind(
    mainMod .. " + Space",
    hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"),
    { description = "Toggle launcher" }
)

-- SUPER + S = Control Center
hl.bind(
    mainMod .. " + S",
    hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"),
    { description = "Toggle control center" }
)

-- SUPER + COMMA = Settings
hl.bind(
    mainMod .. " + comma",
    hl.dsp.exec_cmd("noctalia msg settings-toggle"),
    { description = "Toggle settings" }
)

-- Clipboard
hl.bind(
    "SUPER + V",
    hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"),
    { description = "Toggle clipboard" }
)

-- Terminal
hl.bind(
    "SUPER + T",
    hl.dsp.exec_cmd("kitty"),
    { description = "Open terminal" }
)

-- Screenshot / region selection
hl.bind(
    "SUPER + SHIFT + S",
    hl.dsp.exec_cmd("noctalia msg screenshot-region"),
    { description = "Screenshot region" }
)

-- Open new application windows floating by default.
hl.window_rule({
    name = "default-floating",
    match = { class = ".*" },
    float = true,
})

-- Noctalia Settings
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

-- For Noctalia Color templates
require("noctalia").apply_theme()

-- Use the outside glass rim only while this local build is loaded.
local optical_windows = false
for _, plugin in ipairs(hl.get_loaded_plugins()) do
    if plugin.name == "hyprglass" and plugin.version == "1.1.1-optical-rim" then
        optical_windows = true
    end
end

-- Keep the application rim after Noctalia's generated border colors.
hl.config({
    general = {
        border_size = 1,
        col = {
            active_border = optical_windows and "rgba(00000000)" or { colors = { "rgba(dce7ee55)", "rgba(9aacba22)", "rgba(20273355)" }, angle = 135 },
            inactive_border = optical_windows and "rgba(00000000)" or { colors = { "rgba(dce7ee22)", "rgba(9aacba11)", "rgba(20273333)" }, angle = 135 },
        },
    },
})


-- ============================================================
-- HYPRGLASS
-- Noctalia v5
-- macOS Tahoe / Liquid Glass
-- Neutral for Light & Dark
-- ============================================================

if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    -- ========================================================
    -- GLOBAL
    -- ========================================================

    hg.config({
        default_theme = "light",
        default_preset = "tahoe-window",
        skip_opaque_windows = not optical_windows,

        -- Cool-white tint yang sangat tipis.
        -- Format: RRGGBBAA
        tint_color = 0xeef3ff16,

        -- Netral supaya tetap enak di light maupun dark.
        brightness = 0.97,
        contrast = 1.05,
        saturation = 1.00,

        vibrancy = 0.20,
        vibrancy_darkness = 0.08,

        -- Menjaga detail tetap terlihat di wallpaper
        -- sangat terang maupun sangat gelap.
        adaptive_dim = 0.10,
        adaptive_boost = 0.10,

        layers = {
            enabled = true,
        },
    })


    -- ========================================================
    -- TAHOE
    --
    -- Full Liquid Glass.
    -- Dipakai untuk:
    -- - Dock
    -- - Floating panel
    -- - Notification
    -- - OSD
    -- - Window switcher
    --
    -- Efek dibuat sengaja cukup agresif.
    -- ========================================================

    hg.preset("tahoe", {
        -- ----------------------------------------------------
        -- GLASS BODY
        -- ----------------------------------------------------

        glass_opacity = 0.82,

        -- Jangan terlalu blur.
        -- Kita ingin masih melihat detail yang ter-refract.
        blur_strength = 0.80,
        blur_iterations = 2,

        -- ----------------------------------------------------
        -- GLASS BEZEL / DEPTH
        -- ----------------------------------------------------

        edge_thickness = 0.085,

        -- ----------------------------------------------------
        -- OPTICAL DISTORTION
        -- ----------------------------------------------------

        refraction_strength = 0.95,
        lens_distortion = 0.62,

        -- ----------------------------------------------------
        -- LIGHT RESPONSE
        -- ----------------------------------------------------

        fresnel_strength = 0.92,
        specular_strength = 1.00,

        -- ----------------------------------------------------
        -- DISPERSION
        -- ----------------------------------------------------

        chromatic_aberration = 0.16,

        -- ----------------------------------------------------
        -- COLOR
        -- ----------------------------------------------------

        contrast = 1.10,
        saturation = 1.02,
        vibrancy = 0.24,
    })


    -- Separate window bevels from Noctalia's layer presets.
    hg.preset("tahoe-window", {
        inherits = "liquid-shell",
        blur_strength = 0.60,
        edge_thickness = 0.028,
        refraction_strength = 1.25,
        refraction_flow = 1.0,
        refraction_spread = 0.25,
        lens_distortion = 0.24,
        fresnel_strength = 0.45,
        specular_strength = 0.60,
        bevel_strength = 0.40,
        bevel_size = 1.5,
        bevel_shadow = 0.0,
        bevel_tint = 1.0,
    })

    -- Shell glass is independent of application-window glass.
    hg.preset("liquid-shell", {
        glass_opacity = 1.0,
        blur_strength = 0.85,
        blur_iterations = 1,
        tint_color = 0xffffff00,
        brightness = 1.0,
        contrast = 1.0,
        saturation = 1.0,
        vibrancy = 0.0,
        adaptive_dim = 0.0,
        adaptive_boost = 0.0,
        edge_thickness = 0.055,
        refraction_strength = 1.35,
        lens_distortion = 0.24,
        chromatic_aberration = 0.06,
        fresnel_strength = 0.45,
        fresnel_tint = 0.75,
        specular_strength = 0.60,
        specular_angle = 315.0,
        bevel_strength = 0.40,
        bevel_size = 3.5,
        bevel_angle = 315.0,
        bevel_shadow = 0.0,
        bevel_tint = 1.0,
    })

    -- Reduce the rim at the bar/panel join, without turning it off.
    hg.preset("liquid-dock", {
        inherits = "liquid-shell",
        bevel_size = 2.5,
        bevel_strength = 0.40,
        refraction_strength = 1.2,
        fresnel_strength = 0.45,
        specular_strength = 0.60,
    })

    hg.preset("liquid-attached", {
        inherits = "liquid-shell",
        -- The bar and dropdown share one rim, with the live windows behind them.
        xray = false,
    })


    -- ========================================================
    -- NOCTALIA BAR
    -- ========================================================

    hg.layer("noctalia-bar-default", {
        preset = "liquid-attached",

        mask_mode = "auto",
        mask_threshold = 0.08,
    })


    -- ========================================================
    -- NOCTALIA ATTACHED PANEL
    --
    -- Launcher / Control Center yang attached ke bar.
    -- ========================================================

    hg.layer("noctalia-attached-panel", {
        preset = "liquid-attached",

        mask_mode = "auto",
        mask_threshold = 0.08,
    })


    -- ========================================================
    -- NOCTALIA FLOATING PANEL
    --
    -- Kalau panel dibuka sebagai floating, kita bisa memakai
    -- full Tahoe karena tidak perlu menyatu dengan bar.
    -- ========================================================

    hg.layer("noctalia-panel", {
        preset = "liquid-shell",

        mask_mode = "auto",
        mask_threshold = 0.08,
    })


    -- ========================================================
    -- NOCTALIA DOCK
    --
    -- Ini yang seharusnya paling kelihatan "Liquid Glass".
    -- ========================================================

    hg.layer("noctalia-dock", {
        preset = "liquid-dock",

        mask_mode = "auto",
        mask_threshold = 0.08,
    })


    -- ========================================================
    -- NOCTALIA NOTIFICATION
    -- ========================================================

    hg.layer("noctalia-notification", {
        preset = "liquid-shell",

        mask_mode = "auto",
        mask_threshold = 0.10,
    })


    -- ========================================================
    -- NOCTALIA OSD
    -- Volume / Brightness / etc.
    -- ========================================================

    hg.layer("noctalia-osd", {
        preset = "liquid-shell",

        mask_mode = "auto",
        mask_threshold = 0.10,
    })


    -- ========================================================
    -- NOCTALIA WINDOW SWITCHER
    -- ========================================================

    hg.layer("noctalia-window-switcher", {
        preset = "liquid-shell",

        mask_mode = "auto",
        mask_threshold = 0.10,
    })
end

-- HyprMod managed settings
require("hyprland-gui")
