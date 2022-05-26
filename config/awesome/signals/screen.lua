local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')

local vars = require('configuration.vars')
local bar = require('layouts.bar')
local gears = require('gears')

screen.connect_signal('request::wallpaper', function(s)
    awful.wallpaper({
        screen = s,
        widget = {
            {
                image = gears.filesystem.get_random_file_from_dir(
                    os.getenv('HOME') .. '/.config/wallpapers',
                    { '.jpg', '.png', '.svg' },
                    true
                ),
                upscale = true,
                downscale = true,
                --resize = true,
                widget = wibox.widget.imagebox,
            },
            valign = 'center',
            halign = 'center',
            tiled = false,
            widget = wibox.container.tile,
        },
    })
end)

gears.timer({
    timeout = 1800,
    autostart = true,
    callback = function()
        for s in screen do
            s:emit_signal('request::wallpaper')
        end
    end,
})

--TODO compare to connect_for_each_screen
screen.connect_signal('request::desktop_decoration', function(s)
    awful.tag(vars.tags, s, awful.layout.layouts[1])
    s.promptbox = bar.create_promptbox()
    s.layoutbox = bar.create_layoutbox(s)
    s.taglist = bar.create_taglist(s)
    s.tasklist = bar.create_tasklist(s)
    s.wibox = bar.create_wibox(s)
end)
