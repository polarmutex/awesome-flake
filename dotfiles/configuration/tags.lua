local awful = require('awful')

-- Tags
screen.connect_signal('request::desktop_decoration', function(s)
    screen[s].padding = { left = 0, right = 0, top = 0, bottom = 0 }
    awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8' }, s, awful.layout.layouts[1])
end)
