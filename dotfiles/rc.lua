-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')
local gears = require('gears')
local beautiful = require('beautiful')

-- Theme
local theme_dir = gears.filesystem.get_configuration_dir() .. 'theme/'
beautiful.init(theme_dir .. 'theme.lua')

-- Configuration
require('configuration')

-- Modules
require('modules')

-- UI
require('ui')

-- Garbage
--- Enable for lower memory consumption
collectgarbage('setpause', 110)
collectgarbage('setstepmul', 1000)
gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function()
        collectgarbage('collect')
    end,
})

-- Notification library
--local naughty = require('naughty')
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
--naughty.connect_signal('request::display_error', function(message, startup)
--    naughty.notification({
--        urgency = 'critical',
--        title = 'Oops, an error happened' .. (startup and ' during startup!' or '!'),
--        message = message,
--    })
--end)
