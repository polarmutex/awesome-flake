local awful = require('awful')

local vars = require('configuration.vars')
local bar = require('layouts.bar')

--TODO compare to connect_for_each_screen
screen.connect_signal('request::desktop_decoration', function(s)
    awful.tag(vars.tags, s, awful.layout.layouts[1])
    s.promptbox = bar.create_promptbox()
    s.layoutbox = bar.create_layoutbox(s)
    s.taglist = bar.create_taglist(s)
    s.tasklist = bar.create_tasklist(s)
    s.wibox = bar.create_wibox(s)
end)
