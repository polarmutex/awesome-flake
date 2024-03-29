local awful = require('awful')
require('awful.autofocus')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local bling = require('modules.bling')

client.connect_signal('request::manage', function(c)
    --- Add missing icon to client
    if not c.icon then
        local icon = gears.surface(beautiful.theme_assets.awesome_icon(24, beautiful.xcolor8, beautiful.xbackground))
        c.icon = icon._native
        icon:finish()
    end

    --- Set the windows at the slave,
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        --- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

--- Hide all windows when a splash is shown
awesome.connect_signal('widgets::splash::visibility', function(vis)
    local t = screen.primary.selected_tag
    if vis then
        for idx, c in ipairs(t:clients()) do
            c.hidden = true
        end
    else
        for idx, c in ipairs(t:clients()) do
            c.hidden = false
        end
    end
end)

--- Enable sloppy focus, so that focus follows mouse.
client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end)

--- Wallpapers
--- ~~~~~~~~~-
--screen.connect_signal('request::wallpaper', function(s)
--    awful.wallpaper({
--        screen = s,
--        widget = {
--            {
--                image = gears.filesystem.get_random_file_from_dir(
--                    os.getenv('HOME') .. '/.config/wallpapers',
--                    { '.jpg', '.png', '.svg' },
--                    true
--                ),
--                upscale = true,
--                downscale = true,
--                --resize = true,
--                widget = wibox.widget.imagebox,
--            },
--            valign = 'center',
--            halign = 'center',
--            tiled = false,
--            widget = wibox.container.tile,
--        },
--    })
--end)

--gears.timer({
--    timeout = 1800,
--    autostart = true,
--    callback = function()
--        for s in screen do
--            s:emit_signal('request::wallpaper')
--        end
--    end,
--})

--- Flash focus
--- ~~~~~~~~~~~
bling.module.flash_focus.enable()

--- Tag preview
--- ~~~~~~~~~~~
bling.widget.tag_preview.enable({
    show_client_content = true,
    scale = 0.20,
    honor_workarea = true,
    honor_padding = true,
    placement_fn = function(c)
        awful.placement.bottom(c, {
            margins = {
                bottom = dpi(60),
            },
        })
    end,
    background_widget = wibox.widget({
        image = beautiful.wallpaper,
        horizontal_fit_policy = 'fit',
        vertical_fit_policy = 'fit',
        widget = wibox.widget.imagebox,
    }),
})
