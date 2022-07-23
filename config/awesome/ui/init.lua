require(... .. '.notifications')
require(... .. '.popups')

local decorations = require(... .. '.decorations')
decorations.init()

local bottom_panel = require(... .. '.panels.bottom-panel')
local side_panel = require(... .. '.panels.side-panel')

local awful = require('awful')
awful.screen.connect_for_each_screen(function(s)
    --bottom_panel(s)
    side_panel(s)
end)
