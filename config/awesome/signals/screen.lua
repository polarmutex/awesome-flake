local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')

local vars = require('config.vars')
local widgets = require('widgets')
local gears = require('gears')

screen.connect_signal('request::wallpaper', function(s)
    awful.wallpaper({
        screen = s,
        widget = {
            {
                image = gears.filesystem.get_random_file_from_dir(
                    os.getenv("HOME") .. '/.config/wallpapers',
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

screen.connect_signal('request::desktop_decoration', function(s)
    awful.tag(vars.tags, s, awful.layout.layouts[1])
    s.promptbox = widgets.create_promptbox()
    s.layoutbox = widgets.create_layoutbox(s)
    s.taglist = widgets.create_taglist(s)
    s.tasklist = widgets.create_tasklist(s)
    s.wibox = widgets.create_wibox(s)
end)
