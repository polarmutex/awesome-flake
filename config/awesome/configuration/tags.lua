local awful = require('awful')
local l = awful.layout.suit
local vars = require('configuration.vars')

-- default tags
tag.connect_signal('request::default_layouts', function()
    awful.layout.append_default_layouts({
        l.tile,
    })
end)

-- set tags
screen.connect_signal('request::desktop_decoration', function(s)
    screen[s].padding = { left = 0, right = 0, top = 0, bottom = 0 }
    awful.tag(vars.tags, s, awful.layout.layouts[1])
end)
