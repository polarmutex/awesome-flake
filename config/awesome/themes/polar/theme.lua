local gears = require('gears')
local gfs = require('gears.filesystem')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()

local themes_path = gfs.get_themes_dir()
local helpers = require('helpers')

-- Inherit default theme
local theme = dofile(themes_path .. 'default/theme.lua')

-- Load ~/.Xresources colors and set fallback colors
--
theme.darker_bg = '#10171e'
theme.lighter_bg = '#1f272e'
theme.xbackground = xrdb.background or '#131a21'
theme.xforeground = xrdb.foreground or '#ffffff'
theme.xcolor0 = xrdb.color0 or '#15161E'
theme.xcolor1 = xrdb.color1 or '#f7768e'
theme.xcolor2 = xrdb.color2 or '#9ece6a'
theme.xcolor3 = xrdb.color3 or '#e0af68'
theme.xcolor4 = xrdb.color4 or '#7aa2f7'
theme.xcolor5 = xrdb.color5 or '#bb9af7'
theme.xcolor6 = xrdb.color6 or '#7dcfff'
theme.xcolor7 = xrdb.color7 or '#a9b1d6'
theme.xcolor8 = xrdb.color8 or '#414868'
theme.xcolor9 = xrdb.color9 or '#f7768e'
theme.xcolor10 = xrdb.color10 or '#9ece6a'
theme.xcolor11 = xrdb.color11 or '#e0af68'
theme.xcolor12 = xrdb.color12 or '#7aa2f7'
theme.xcolor13 = xrdb.color13 or '#bb9af7'
theme.xcolor14 = xrdb.color14 or '#7dcfff'
theme.xcolor15 = xrdb.color15 or '#c0caf5'

theme.accent = theme.xcolor3
theme.accent_light = '#f2ddbe'
theme.accent_off = '#374f67'

-- Fonts
--
theme.font_name = 'MonoLisa Nerd Font Mono '
theme.font = theme.font_name .. '8'
theme.icon_font_name = 'MonoLisa Nerd Font Mono '
theme.icon_font = theme.icon_font_name .. '18'
theme.font_taglist = theme.icon_font_name .. '8'

-- Borders
--
theme.border_width = dpi(2)
theme.oof_border_width = dpi(0)
theme.border_normal = theme.darker_bg
theme.border_focus = theme.accent
theme.border_radius = dpi(6)
theme.client_radius = dpi(12)
theme.widget_border_width = dpi(2)
theme.widget_border_color = theme.darker_bg

-- Gaps
--
theme.useless_gap = dpi(2)

return theme
