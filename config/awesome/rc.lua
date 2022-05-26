-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

require('awful.autofocus')

-- Notification library
local naughty = require('naughty')

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal('request::display_error', function(message, startup)
    naughty.notification({
        urgency = 'critical',
        title = 'Oops, an error happened' .. (startup and ' during startup!' or '!'),
        message = message,
    })
end)

-- load theme
local beautiful = require('beautiful')
local gfs = require('gears.filesystem')
beautiful.init(gfs.get_themes_dir() .. 'default/theme.lua')

require('configuration')

-- load key and mouse bindings
require('bindings')

--TODO compare to connect_for_each_screen
local awful = require('awful')
local bar = require('layouts.bar')
local vars = require('configuration.vars')
screen.connect_signal('request::desktop_decoration', function(s)
    awful.tag(vars.tags, s, awful.layout.layouts[1])
    s.promptbox = bar.create_promptbox()
    s.layoutbox = bar.create_layoutbox(s)
    s.taglist = bar.create_taglist(s)
    s.tasklist = bar.create_tasklist(s)
    s.wibox = bar.create_wibox(s)
end)

-- load signals
require('signals')

-- load theme
require('theme')
