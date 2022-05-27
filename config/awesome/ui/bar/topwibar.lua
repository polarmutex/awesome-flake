local M = {}

local awful = require('awful')
local gears = require('gears')
local hotkeys_popup = require('awful.hotkeys_popup')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

local apps = require('configuration.apps')
local helpers = require('helpers')
local mod = {
    alt = 'Mod1',
    super = 'Mod4',
    shift = 'Shift',
    ctrl = 'Control',
}

-- screen width
local screen_width = awful.screen.focused().geometry.width

M.awesomemenu = {
    {
        'hotkeys',
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { 'manual', apps.manual_cmd },
    { 'edit config', apps.editor_cmd .. ' ' .. awesome.conffile },
    { 'restart', awesome.restart },
    { 'quit', awesome.quit },
}

M.mainmenu = awful.menu({
    items = {
        { 'awesome', M.awesomemenu, beautiful.awesome_icon },
        { 'open terminal', apps.terminal },
    },
})

M.launcher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = M.mainmenu,
})

M.keyboardlayout = awful.widget.keyboardlayout()

M.textclock = wibox.widget({
    widget = wibox.widget.textclock(),
    format = '%I:%M   %a %d',
    font = beautiful.font_name,
    valign = 'center',
    align = 'center',
})

function M.create_promptbox()
    return awful.widget.prompt()
end

function M.create_layoutbox(s)
    return awful.widget.layoutbox({
        screen = s,
        buttons = {
            awful.button({
                modifiers = {},
                button = 1,
                on_press = function()
                    awful.layout.inc(1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 3,
                on_press = function()
                    awful.layout.inc(-1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 4,
                on_press = function()
                    awful.layout.inc(-1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 5,
                on_press = function()
                    awful.layout.inc(1)
                end,
            }),
        },
    })
end

function M.create_taglist(s)
    -- Taglist buttons
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t)
            t:view_only()
        end),
        awful.button({ mod.super }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ mod.super }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
    )

    return awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = { shape = helpers.rrect(5) },
        layout = { spacing = dpi(16), layout = wibox.layout.fixed.horizontal },
        widget_template = {
            widget = wibox.container.background,
            shape = gears.shape.rounded_rect,
            forced_width = dpi(13),
            forced_height = dpi(12),

            create_callback = function(self, c3, _)
                if c3.selected then
                    self.bg = beautiful.accent
                    self.forced_width = dpi(20)
                elseif #c3:clients() == 0 then
                    self.bg = beautiful.accent_off
                    self.forced_width = dpi(12)
                else
                    self.bg = beautiful.accent_light
                    self.forced_width = dpi(12)
                end
            end,
            update_callback = function(self, c3, _)
                if c3.selected then
                    self.bg = beautiful.accent
                    self.forced_width = dpi(20)
                elseif #c3:clients() == 0 then
                    self.bg = beautiful.accent_off
                    self.forced_width = dpi(12)
                else
                    self.bg = beautiful.accent_light
                    self.forced_width = dpi(12)
                end
            end,
        },
        buttons = taglist_buttons,
    })
end

function M.create_tasklist(s)
    return awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({
                modifiers = {},
                button = 1,
                on_press = function(c)
                    c:activate({ context = 'tasklist', action = 'toggle_minimization' })
                end,
            }),
            awful.button({
                modifiers = {},
                button = 3,
                on_press = function()
                    awful.menu.client_list({ theme = { width = 250 } })
                end,
            }),
            awful.button({
                modifiers = {},
                button = 4,
                on_press = function()
                    awful.client.focus.byidx(-1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 5,
                on_press = function()
                    awful.client.focus.byidx(1)
                end,
            }),
        },
    })
end

function M.create_wibox(s)
    local wibar = awful.wibar({
        screen = s,
        visible = true,
        ontop = false,
        type = 'dock',
        --height = dpi(44),
        --bg = '#00000000',
        width = screen_width,
    })

    -- wibar placement
    awful.placement.top(wibar)
    wibar:struts({ top = wibar.height })

    -- bar setup
    wibar:setup({
        {
            {
                M.launcher,
                M.textclock,
                s.promptbox,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(16),
            },
            {
                {
                    nil,
                    {
                        s.taglist,
                        layout = wibox.layout.fixed.vertical,
                    },
                    expand = 'none',
                    layout = wibox.layout.align.vertical,
                },
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(20),
            },
            {
                --battery,
                --wifi,
                wibox.widget.systray(),
                s.layoutbox,
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(16),
            },
            layout = wibox.layout.align.horizontal,
            expand = 'none',
        },
        layout = wibox.container.margin,
        margins = { left = dpi(14), right = dpi(14) },
    })

    return wibar
end

--TODO compare to connect_for_each_screen
local vars = require('configuration.vars')
screen.connect_signal('request::desktop_decoration', function(s)
    awful.tag(vars.tags, s, awful.layout.layouts[1])
    s.promptbox = M.create_promptbox()
    s.layoutbox = M.create_layoutbox(s)
    s.taglist = M.create_taglist(s)
    s.tasklist = M.create_tasklist(s)
    s.wibox = M.create_wibox(s)
end)
