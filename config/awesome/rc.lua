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
beautiful.init(gfs.get_configuration_dir() .. 'themes/polar/theme.lua')

require('configuration')

require('signals')
require('ui')
