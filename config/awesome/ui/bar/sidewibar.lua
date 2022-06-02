-- a minimal bar
-- ~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local helpers = require('helpers')
local dpi = beautiful.xresources.apply_dpi

local wrap_widget = function(widget)
    return {
        widget,
        margins = dpi(6),
        widget = wibox.container.margin,
    }
end

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- connect to screen
-- ~~~~~~~~~~~~~~~~~
awful.screen.connect_for_each_screen(function(s)
    -- aewseome icon
    local awesome_icon = wibox.widget({
        {
            widget = wibox.widget.imagebox,
            image = beautiful.awesome_icon,
            resize = true,
        },
        margins = dpi(4),
        widget = wibox.container.margin,
    })

    -- clock
    local hour = wibox.widget({
        font = beautiful.font_name .. 'bold 14',
        format = '%H',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textclock,
    })

    local min = wibox.widget({
        font = beautiful.font_name .. 'bold 14',
        format = '%M',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textclock,
    })

    local clock = wibox.widget({
        {
            {
                hour,
                min,
                spacing = dpi(5),
                layout = wibox.layout.fixed.vertical,
            },
            top = dpi(5),
            bottom = dpi(5),
            widget = wibox.container.margin,
        },
        bg = beautiful.wibar_widget_bg,
        shape = helpers.rrect(beautiful.widget_radius),
        widget = wibox.container.background,
    })

    -- Stats
    local stats = wibox.widget({
        {
            --wrap_widget(batt),
            clock,
            spacing = dpi(5),
            layout = wibox.layout.fixed.vertical,
        },
        bg = beautiful.wibar_widget_alt_bg,
        shape = helpers.rrect(beautiful.widget_radius),
        widget = wibox.container.background,
    })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Layoutbox
    local layoutbox_buttons = gears.table.join(
        -- Left click
        awful.button({}, 1, function(c)
            awful.layout.inc(1)
        end),
        -- Right click
        awful.button({}, 3, function(c)
            awful.layout.inc(-1)
        end),
        -- Scrolling
        awful.button({}, 4, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(1)
        end)
    )
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(layoutbox_buttons)

    local layoutbox = wibox.widget({
        s.mylayoutbox,
        margins = { bottom = dpi(7), left = dpi(8), right = dpi(8) },
        widget = wibox.container.margin,
    })

    -- systray
    local systray = wibox.widget.systray()
    systray:set_horizontal(false)

    -- wibar
    s.mywibar = awful.wibar({
        type = 'dock',
        position = 'left',
        screen = s,
        height = awful.screen.focused().geometry.height,
        width = dpi(40),
        bg = beautiful.transparent,
        ontop = false,
        visible = true,
    })

    -- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibar.visible = false
        else
            c.screen.mywibar.visible = true
        end
    end

    -- Remove wibar on full screen
    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibar.visible = true
        end
    end

    client.connect_signal('property::fullscreen', remove_wibar)

    client.connect_signal('request::unmanage', add_wibar)

    -- taglist
    s.mytaglist = require('ui.widgets.taglist-vertical')(s)
    local taglist = wibox.widget({
        s.mytaglist,
        shape = beautiful.taglist_shape_focus,
        bg = beautiful.wibar_widget_alt_bg,
        widget = wibox.container.background,
    })

    -- bar setup
    -- Add widgets to wibar
    s.mywibar:setup({
        {
            {
                layout = wibox.layout.align.vertical,
                expand = 'none',
                { -- top
                    awesome_icon,
                    taglist,
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                },
                -- middle
                nil,
                { -- bottom
                    stats,
                    --notif_center_button,
                    layoutbox,
                    spacing = dpi(8),
                    layout = wibox.layout.fixed.vertical,
                },
            },
            margins = dpi(8),
            widget = wibox.container.margin,
        },
        bg = beautiful.wibar_bg,
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background,
    })

    -- wibar position
    --s.mywibar.x = dpi(25)
end)
