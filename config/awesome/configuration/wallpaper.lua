local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

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
