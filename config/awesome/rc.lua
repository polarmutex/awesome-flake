-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gfs = require('gears.filesystem')
local awful = require('awful')
require('awful.autofocus')

-- load theme
local beautiful = require('beautiful')
local gears = require('gears')
beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')

-- load key and mouse bindings
require('bindings')

-- load rules
require('rules')

-- load signals
require('signals')

-- load theme
require('theme')
