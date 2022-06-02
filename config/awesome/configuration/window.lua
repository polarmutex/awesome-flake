local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')

client.connect_signal('request::manage', function(c, context)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Fallback icon for clients
    if c.icon == nil then
        local i = gears.surface(beautiful.theme_assets.awesome_icon(256, beautiful.xcolor8, beautiful.darker_bg))
        c.icon = i._native
    end
end)

-- OLD
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end)
-- NEW
-- Enable sloppy focus, so that focus follows mouse.
-- from https://github.com/awesomeWM/awesome/issues/3349#issuecomment-846611872
--Mutex = false
--client.connect_signal('mouse::move', function(c)
--print('client mouse::move envent triggered')

--    if client.focus ~= c then
--print('we can change focus')

--        if not Mutex then
--print('we request focus change')
--            Mutex = true

--            gears.timer.delayed_call(function()
--print('we are in delayed_call to change focus')
--                c:activate({ context = 'mouse_enter', raise = false })
--                Mutex = false
--            end)
--        end
--    end
--end)

client.connect_signal('focus', function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal('unfocus', function(c)
    c.border_color = beautiful.border_normal
end)

-- Layouts
local vars = require('configuration.vars')
tag.connect_signal('request::default_layouts', function()
    awful.layout.append_default_layouts(vars.layouts)
end)
