local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
require('awful.hotkeys_popup.keys')
local menubar = require('menubar')

local apps = require('configuration.apps')
local mod = {
    alt = 'Mod1',
    super = 'Mod4',
    shift = 'Shift',
    ctrl = 'Control',
}
--local bar = require('layouts.bar')

menubar.utils.terminal = apps.terminal

awful.key.keygroup.TAGS = 'tags'
awful.key.keygroups.tags = {
    { 'a', 1 },
    { 'r', 2 },
    { 's', 3 },
    { 't', 4 },
    { 'n', 5 },
    { 'e', 6 },
    { 'i', 7 },
    { 'o', 8 },
}

-- general awesome keys
awful.keyboard.append_global_keybindings({
    --awful.key({
    --    modifiers = { mod.super },
    --    key = 's',
    --    description = 'show help',
    --    group = 'awesome',
    --    on_press = hotkeys_popup.show_help,
    --}),
    --awful.key({
    --    modifiers = { mod.super },
    --    key = 'w',
    --    description = 'show main menu',
    --    group = 'awesome',
    --    on_press = function()
    --        bar.mainmenu:show()
    --    end,
    --}),
    awful.key({
        modifiers = { mod.super, mod.ctrl },
        key = 'r',
        description = 'reload awesome',
        group = 'awesome',
        on_press = awesome.restart,
    }),
    awful.key({
        modifiers = { mod.super, mod.shift },
        key = 'q',
        description = 'quit awesome',
        group = 'awesome',
        on_press = awesome.quit,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'x',
        description = 'lua execute prompt',
        group = 'awesome',
        on_press = function()
            awful.prompt.run({
                prompt = 'Run Lua code: ',
                textbox = awful.screen.focused().promptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. '/history_eval',
            })
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'Return',
        description = 'open a terminal',
        group = 'launcher',
        on_press = function()
            awful.spawn(apps.default.terminal)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'd',
        description = 'run prompt rofi',
        group = 'launcher',
        on_press = function()
            --awful.screen.focused().promptbox:run()
            awful.spawn(apps.default.app_launcher)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'p',
        description = 'show the menubar',
        group = 'launcher',
        on_press = function()
            menubar.show()
        end,
    }),
})

-- tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({
        modifiers = { mod.super },
        key = 'Left',
        description = 'view preivous',
        group = 'tag',
        on_press = awful.tag.viewprev,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'Right',
        description = 'view next',
        group = 'tag',
        on_press = awful.tag.viewnext,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'Escape',
        description = 'go back',
        group = 'tag',
        on_press = awful.tag.history.restore,
    }),
})

-- focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({
        modifiers = { mod.super },
        key = 'j',
        description = 'focus next by index',
        group = 'client',
        on_press = function()
            awful.client.focus.byidx(1)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'k',
        description = 'focus previous by index',
        group = 'client',
        on_press = function()
            awful.client.focus.byidx(-1)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'Tab',
        description = 'go back',
        group = 'client',
        on_press = function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.ctrl },
        key = 'j',
        description = 'focus the next screen',
        group = 'screen',
        on_press = function()
            awful.screen.focus_relative(1)
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.ctrl },
        key = 'n',
        description = 'restore minimized',
        group = 'client',
        on_press = function()
            local c = awful.client.restore()
            if c then
                c:active({ raise = true, context = 'key.unminimize' })
            end
        end,
    }),
})

-- layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({
        modifiers = { mod.super, mod.shift },
        key = 'j',
        description = 'swap with next client by index',
        group = 'client',
        on_press = function()
            awful.client.swap.byidx(1)
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.shift },
        key = 'k',
        description = 'swap with previous client by index',
        group = 'client',
        on_press = function()
            awful.client.swap.byidx(-1)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'u',
        description = 'jump to urgent client',
        group = 'client',
        on_press = awful.client.urgent.jumpto,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'l',
        description = 'increase master width factor',
        group = 'layout',
        on_press = function()
            awful.tag.incmwfact(0.05)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'h',
        description = 'decrease master width factor',
        group = 'layout',
        on_press = function()
            awful.tag.incmwfact(-0.05)
        end,
    }),
    --awful.key({ modkey, "Mod1"    }, "Right",     function () awful.tag.incmwfact( 0.01)    end),
    --awful.key({ modkey, "Mod1"    }, "Left",     function () awful.tag.incmwfact(-0.01)    end),
    --aawful.key({ modkey, "Mod1"    }, "Down",     function () awful.client.incwfact( 0.01)    end),
    --awful.key({ modkey, "Mod1"    }, "Up",     function () awful.client.incwfact(-0.01)    end),
    awful.key({
        modifiers = { mod.super, mod.shift },
        key = 'h',
        description = 'increase the number of master clients',
        group = 'layout',
        on_press = function()
            awful.tag.incnmaster(1, nil, true)
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.shift },
        key = 'l',
        description = 'decrease the number of master clients',
        group = 'layout',
        on_press = function()
            awful.tag.incnmaster(-1, nil, true)
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.ctrl },
        key = 'h',
        description = 'increase the number of columns',
        group = 'layout',
        on_press = function()
            awful.tag.incnmaster(1, nil, true)
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.ctrl },
        key = 'l',
        description = 'decrease the number of columns',
        group = 'layout',
        on_press = function()
            awful.tag.incnmaster(-1, nil, true)
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        key = 'space',
        description = 'select next',
        group = 'layout',
        on_press = function()
            awful.layout.inc(1)
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.shift },
        key = 'space',
        description = 'select previous',
        group = 'layout',
        on_press = function()
            awful.layout.inc(-1)
        end,
    }),
})

awful.keyboard.append_global_keybindings({
    awful.key({
        modifiers = { mod.super },
        keygroup = 'tags',
        description = 'only view tag',
        group = 'tag',
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only(tag)
            end
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.ctrl },
        keygroup = 'tags',
        description = 'toggle tag',
        group = 'tag',
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:viewtoggle(tag)
            end
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.shift },
        keygroup = 'tags',
        description = 'move focused client to tag',
        group = 'tag',
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    }),
    awful.key({
        modifiers = { mod.super, mod.ctrl, mod.shift },
        keygroup = 'tags',
        description = 'toggle focused client on tag',
        group = 'tag',
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    }),
    awful.key({
        modifiers = { mod.super },
        keygroup = 'tags',
        description = 'select layout directrly',
        group = 'layout',
        on_press = function(index)
            local tag = awful.screen.focused().selected_tag
            if tag then
                tag.layout = tag.layouts[index] or tag.layout
            end
        end,
    }),
})

client.connect_signal('request::default_keybindings', function()
    awful.keyboard.append_client_keybindings({
        awful.key({
            modifiers = { mod.super },
            key = 'f',
            description = 'toggle fullscreen',
            group = 'client',
            on_press = function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
        }),
        awful.key({
            modifiers = { mod.super, mod.shift },
            key = 'c',
            description = 'close',
            group = 'client',
            on_press = function(c)
                c:kill()
            end,
        }),
        awful.key({
            modifiers = { mod.super, mod.ctrl },
            key = 'space',
            description = 'toggle floating',
            group = 'client',
            on_press = awful.client.floating.toggle,
        }),
        awful.key({
            modifiers = { mod.super, mod.ctrl },
            key = 'Return',
            description = 'move to master',
            group = 'client',
            on_press = function(c)
                c:swap(awful.client.getmaster())
            end,
        }),
        awful.key({
            modifiers = { mod.super },
            key = 'o',
            description = 'move to screen',
            group = 'client',
            on_press = function(c)
                c:move_to_screen()
            end,
        }),
        awful.key({
            modifiers = { mod.super },
            key = 't',
            description = 'toggle keep on top',
            group = 'client',
            on_press = function(c)
                c.ontop = not c.ontop
            end,
        }),
        awful.key({
            modifiers = { mod.super },
            key = 'n',
            description = 'minimize',
            group = 'client',
            on_press = function(c)
                c.minimized = true
            end,
        }),
        awful.key({
            modifiers = { mod.super },
            key = 'm',
            description = '(un)maximize',
            group = 'client',
            on_press = function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
        }),
        awful.key({
            modifiers = { mod.super, mod.ctrl },
            key = 'm',
            description = '(un)maximize vertically',
            group = 'client',
            on_press = function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
        }),
        awful.key({
            modifiers = { mod.super, mod.shift },
            key = 'm',
            description = '(un)maximize horizontally',
            group = 'client',
            on_press = function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
        }),
    })
end)

awful.mouse.append_global_mousebindings({
    --awful.button({
    --    modifiers = {},
    --    button = 3,
    --    on_press = function()
    --        bar.mainmenu:toggle()
    --    end,
    --}),
    awful.button({
        modifiers = {},
        button = 4,
        on_press = awful.tag.viewprev,
    }),
    awful.button({
        modifiers = {},
        button = 5,
        on_press = awful.tag.viewnext,
    }),
})

client.connect_signal('request::default_mousebindings', function()
    awful.mouse.append_client_mousebindings({
        awful.button({
            modifiers = {},
            button = 1,
            on_press = function(c)
                c:activate({ context = 'mouse_click' })
            end,
        }),
        awful.button({
            modifiers = { mod.super },
            button = 1,
            on_press = function(c)
                c:activate({ context = 'mouse_click', action = 'mouse_move' })
            end,
        }),
        awful.button({
            modifiers = { mod.super },
            button = 3,
            on_press = function(c)
                c:activate({ context = 'mouse_click', action = 'mouse_resize' })
            end,
        }),
    })
end)
