local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi
local gears = require('gears')

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()
local helpers = require('helpers')
--local ui_vars = require('theme.ui_vars')

--local colors = require('theme.colors.' .. (ui_vars.color_scheme or 'dark'))
local colors = {
    -- foreground color
    foreground = '#E6E1E5',

    -- base green
    green = '#b9f6ca',
    green_2 = '#b9f6ca99',
    green_3 = '#1e2720',

    -- base red
    red = '#F2B8B5',
    red_2 = '#F85E4D',
    red_3 = '#F9DEDC',

    -- base black
    black = '#000000',
    ext_white_bg = '#EBF0FF',

    -- accents
    accent = '#C6E7FC',
    accent_2 = '#C6E7FC66',
    accent_3 = '#4a5861',
}

-- misc/vars
-- ~~~~~~~~~

-- initial empty array
local theme = {}

-- base background colors
theme.bg_color = '#101012'
theme.bg_2 = '#1B1B1B'
theme.bg_3 = '#303030'

-- foreground colors
theme.fg_color = colors.foreground

-- base red colors
theme.red_color = colors.red
theme.red_2 = colors.red_2
theme.red_3 = colors.red_3

-- base green color
theme.green_color = colors.green
theme.green_2 = colors.green_2
theme.green_3 = colors.green_3

-- black color
theme.black_color = '#000000'

-- extra
theme.ext_white_bg = colors.ext_white_bg

-- light theme colors
theme.ext_light_bg = colors.ext_light_bg or nil
theme.ext_light_bg_2 = colors.ext_light_bg_2 or nil
theme.ext_light_fg = colors.ext_light_fg or nil
theme.ext_light_bg_3 = colors.ext_light_bg_3 or nil

-- accent color
theme.accent = colors.accent
theme.accent_2 = colors.accent_2
theme.accent_3 = colors.accent_3

-- font vars
theme.font_var = 'MonoLisa Nerd Font'
theme.icon_var = 'MonoLisa Nerd Font'

-- props
--theme.title_pos = ui_vars.titlebar_position
--theme.bar_size = dpi(ui_vars.bar_size)

-- rounded corners
--theme.rounded = dpi(ui_vars.round_corners)
--theme.rounded_wids = dpi(ui_vars.round_corners - 2)

-- font
-- ~~~~
theme.font = theme.font_var .. 'size=12'

-- initial colors
-- ~~~~~~~~~~~~~~
theme.bg_normal = theme.bg_color
theme.bg_focus = theme.bg_2
theme.bg_urgent = theme.red_2
theme.bg_minimize = theme.bg_2
theme.bg_systray = theme.bg_c2

theme.fg_normal = theme.fg_color
theme.fg_focus = theme.fg_color
theme.fg_urgent = theme.bg_color
theme.fg_minimize = theme.bg_2

-- gaps/border thing
-- ~~~~~~~~~~~~~~~~~
--theme.useless_gap = dpi(4)
--theme.border_width = dpi(2)
theme.border_color_normal = theme.bg_color
theme.border_color_active = theme.bg_color

-- Layout icons
-- ~~~~~~~~~~~~
--theme.layout_floating = gears.color.recolor_image(themes_path .. 'default/layouts/floating', theme.fg_color)
theme.layout_tile = gears.color.recolor_image(themes_path .. 'default/layouts/tile.png', theme.fg_color)
--theme.layout_fairh = gears.color.recolor_image(theme.images.layouts.flair, theme.fg_color)
--theme.layout_fairv = gears.color.recolor_image(theme.images.layouts.flair, theme.fg_color)
--theme.layout_spiral = gears.color.recolor_image(themes_path .. 'default/layouts/spiralw.png', theme.fg_color)
--theme.layout_machi = gears.color.recolor_image(theme.images.layouts.layoutMachi, theme.fg_color)

-- not in use layouts
theme.layout_fullscreen = themes_path .. 'default/layouts/fullscreenw.png'
theme.layout_dwindle = themes_path .. 'default/layouts/dwindlew.png'
theme.layout_cornernw = themes_path .. 'default/layouts/cornernww.png'
theme.layout_cornerne = themes_path .. 'default/layouts/cornernew.png'
theme.layout_cornersw = themes_path .. 'default/layouts/cornersww.png'
theme.layout_cornerse = themes_path .. 'default/layouts/cornersew.png'
theme.layout_tiletop = themes_path .. 'default/layouts/tiletopw.png'
theme.layout_magnifier = themes_path .. 'default/layouts/magnifierw.png'
theme.layout_max = themes_path .. 'default/layouts/maxw.png'
theme.layout_tilebottom = themes_path .. 'default/layouts/tilebottomw.png'
theme.layout_tileleft = themes_path .. 'default/layouts/tileleftw.png'

-- init
-- ~~~~
require('beautiful').init(theme)
