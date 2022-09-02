-- wibar.lua
-- Wibar (top bar)
local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi
local helpers = require('helpers')
local widgets = require('ui.widgets')
local animation = require('modules.animation')

local screen_height = awful.screen.focused().geometry.height

-- Awesome Icon
local awesome_icon = wibox.widget({
    {
        {
            widget = wibox.widget.imagebox,
            image = beautiful.awesome_logo,
            resize = true,
        },
        margins = dpi(4),
        widget = wibox.container.margin,
    },
    --shape = helpers.ui.rrect(beautiful.border_radius),
    bg = beautiful.wibar_bg,
    widget = wibox.container.background,
})

-- Battery
local charge_icon = wibox.widget({
    bg = beautiful.xcolor8,
    widget = wibox.container.background,
    visible = false,
})

local batt = wibox.widget({
    charge_icon,
    color = { beautiful.xcolor2 },
    bg = beautiful.xcolor8 .. '88',
    value = 50,
    min_value = 0,
    max_value = 100,
    thickness = dpi(4),
    padding = dpi(2),
    -- rounded_edge = true,
    start_angle = math.pi * 3 / 2,
    widget = wibox.container.arcchart,
})

awesome.connect_signal('signal::battery', function(value)
    local fill_color = beautiful.xcolor2

    if value >= 11 and value <= 30 then
        fill_color = beautiful.xcolor3
    elseif value <= 10 then
        fill_color = beautiful.xcolor1
    end

    batt.colors = { fill_color }
    batt.value = value
end)

awesome.connect_signal('signal::charger', function(state)
    if state then
        charge_icon.visible = true
    else
        charge_icon.visible = false
    end
end)

-- Clock

-- Clock Widget ----------------------------------------------------------------
-- Stolen from No37

local hourtextbox = wibox.widget.textclock('%I')
hourtextbox.markup = helpers.ui.colorize_text(hourtextbox.text, beautiful.xcolor5)
hourtextbox.align = 'center'
hourtextbox.valign = 'center'

local minutetextbox = wibox.widget.textclock('%M')
minutetextbox.align = 'center'
minutetextbox.valign = 'center'

hourtextbox:connect_signal('widget::redraw_needed', function()
    hourtextbox.markup = helpers.ui.colorize_text(hourtextbox.text, beautiful.xcolor5)
end)

minutetextbox:connect_signal('widget::redraw_needed', function()
    minutetextbox.markup = helpers.ui.colorize_text(minutetextbox.text, beautiful.xforeground)
end)

local clock = wibox.widget({
    { hourtextbox, minutetextbox, layout = wibox.layout.fixed.vertical },
    bg = beautiful.xcolor0 .. '00',
    widget = wibox.container.background,
})

local datetooltip = awful.tooltip({})
datetooltip.shape = helpers.ui.prrect(beautiful.border_radius, false, true, true, false)
datetooltip.preferred_alignments = { 'middle', 'front', 'back' }
datetooltip.mode = 'outside'
datetooltip:add_to_object(clock)
datetooltip.text = os.date('%d.%m.%y') -- just don't stay up long enough for that to change

-- Tasklist
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal('request::activate', 'tasklist', { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

-- Notification center
local notifs = wibox.widget({
    markup = '',
    font = beautiful.font_name .. '16',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
})
--notifs.markup = helpers.colorize_text(notifs.text, beautiful.xcolor3)

notifs:buttons(gears.table.join(awful.button({}, 1, function()
    notifs_toggle()
end)))

-- Systray Widget -------------------------------------------------------------

local mysystray = wibox.widget.systray()
mysystray.base_size = beautiful.systray_icon_size

local sys_button = wibox.widget({
    forced_width = 10,
    forced_height = 12,
    bg = beautiful.xforeground,
    --shape = helpers.powerline(10, 12),
    widget = wibox.container.background,
})

local sys_popup = awful.popup({
    widget = wibox.widget({
        { mysystray, margins = 10, widget = wibox.container.margin },
        forced_height = 65,
        bg = beautiful.darker_bg,
        widget = wibox.container.background,
    }),
    ontop = true,
    visible = false,
    placement = function(c)
        awful.placement.bottom_left(c, {
            margins = { left = beautiful.wibar_width + 10, bottom = 20 },
        })
    end,
    shape = gears.shape.rounded_rect,
})

sys_button:buttons(gears.table.join(awful.button({}, 1, function()
    if sys_popup.visible then
        sys_popup.visible = false
    else
        sys_popup.visible = true
    end
end)))

sys_button:connect_signal('mouse::enter', function()
    sys_button.bg = beautiful.xcolor8
end)

sys_button:connect_signal('mouse::leave', function()
    sys_button.bg = beautiful.xforeground
end)

-- Create the Wibar -----------------------------------------------------------
--
local wrap_widget = function(w)
    return {
        w,
        top = dpi(5),
        left = dpi(5),
        bottom = dpi(5),
        right = dpi(5),
        widget = wibox.container.margin,
    }
end

local wrap_widget2 = function(w)
    return {
        w,
        left = dpi(20),
        right = dpi(20),
        widget = wibox.container.margin,
    }
end

return function(s)
    --- Taglist buttons
    local modkey = 'Mod4'
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
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

    local function tag_list(s)
        local taglist = awful.widget.taglist({
            screen = s,
            filter = awful.widget.taglist.filter.all,
            layout = { layout = wibox.layout.fixed.vertical },
            widget_template = {
                widget = wibox.container.margin,
                forced_width = dpi(40),
                forced_height = dpi(40),
                create_callback = function(self, c3, _)
                    local indicator = wibox.widget({
                        widget = wibox.container.place,
                        valign = 'center',
                        {
                            widget = wibox.container.background,
                            forced_width = dpi(8),
                            shape = gears.shape.rounded_bar,
                        },
                    })

                    self.indicator_animation = animation:new({
                        duration = 0.125,
                        easing = animation.easing.linear,
                        update = function(self, pos)
                            indicator.children[1].forced_height = pos
                        end,
                    })

                    self:set_widget(indicator)

                    if c3.selected then
                        self.widget.children[1].bg = beautiful.accent
                        self.indicator_animation:set(dpi(32))
                    elseif #c3:clients() == 0 then
                        self.widget.children[1].bg = beautiful.xcolor8
                        self.indicator_animation:set(dpi(8))
                    else
                        self.widget.children[1].bg = beautiful.xcolor4
                        self.indicator_animation:set(dpi(16))
                    end

                    --- Tag preview
                    self:connect_signal('mouse::enter', function()
                        if #c3:clients() > 0 then
                            awesome.emit_signal('bling::tag_preview::update', c3)
                            awesome.emit_signal('bling::tag_preview::visibility', s, true)
                        end
                    end)

                    self:connect_signal('mouse::leave', function()
                        awesome.emit_signal('bling::tag_preview::visibility', s, false)
                    end)
                end,
                update_callback = function(self, c3, _)
                    if c3.selected then
                        self.widget.children[1].bg = beautiful.accent
                        self.indicator_animation:set(dpi(32))
                    elseif #c3:clients() == 0 then
                        self.widget.children[1].bg = beautiful.xcolor8
                        self.indicator_animation:set(dpi(8))
                    else
                        self.widget.children[1].bg = beautiful.xcolor4
                        self.indicator_animation:set(dpi(16))
                    end
                end,
            },
            buttons = taglist_buttons,
        })
        local widget = widgets.button.elevated.state({
            normal_bg = beautiful.widget_bg,
            normal_shape = gears.shape.rounded_bar,
            child = {
                taglist,
                --margins = { left = dpi(10), right = dpi(10) },
                widget = wibox.container.margin,
            },
            --on_release = function()
            --    awesome.emit_signal('central_panel::toggle', s)
            --end,
        })

        return wibox.widget({
            widget,
            margins = dpi(5),
            widget = wibox.container.margin,
        })
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)

    local layoutbox = wibox.widget({
        s.mylayoutbox,
        right = dpi(9),
        left = dpi(9),
        top = dpi(6),
        bottom = dpi(6),
        widget = wibox.container.margin,
    })

    -- Create the wibox
    s.mywibox = wibox({
        -- position = beautiful.wibar_position,
        screen = s,
        type = 'dock',
        ontop = true,
        x = 0,
        y = 0,
        width = beautiful.wibar_width,
        height = screen_height,
        visible = true,
    })

    s.mywibox:struts({ left = beautiful.wibar_width })

    -- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = false
        else
            c.screen.mywibox.visible = true
        end
    end

    -- Remove wibar on full screen
    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = true
        end
    end

    client.connect_signal('property::fullscreen', remove_wibar)

    client.connect_signal('request::unmanage', add_wibar)

    -- Create the taglist widget
    --s.mytaglist = require('ui.widgets.pacman_taglist')(s)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        bg = beautiful.wibar_bg,
        style = {
            bg = beautiful.xcolor0,
            --shape = helpers.rrect(beautiful.border_radius),
        },
        layout = { spacing = dpi(10), layout = wibox.layout.fixed.vertical },
        widget_template = {
            {
                awful.widget.clienticon,
                margins = dpi(6),
                layout = wibox.container.margin,
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c, index, clients)
                self:connect_signal('mouse::enter', function()
                    self.bg_temp = self.bg
                    self.bg = beautiful.xcolor0
                    awesome.emit_signal('bling::task_preview::visibility', s, true, c)
                end)
                self:connect_signal('mouse::leave', function()
                    self.bg = self.bg_temp
                    awesome.emit_signal('bling::task_preview::visibility', s, false, c)
                end)
            end,
        },
    })

    -- Add widgets to the wibox
    s.mywibox.widget = wibox.widget({
        {
            layout = wibox.layout.align.vertical,
            expand = 'none',
            {
                layout = wibox.layout.fixed.vertical,
                {
                    awesome_icon,
                    top = dpi(10),
                    right = dpi(6),
                    left = dpi(6),
                    bottom = dpi(6),
                    widget = wibox.container.margin,
                },
                wrap_widget({
                    s.mytasklist,
                    left = dpi(5),
                    right = dpi(5),
                    widget = wibox.container.margin,
                }),
            },
            tag_list(s),
            {
                wrap_widget(clock),
                --volume
                --brightness
                --battery
                wrap_widget(awful.widget.only_on_screen({
                    sys_button,
                    halign = 'center',
                    valign = 'center',
                    widget = wibox.container.place,
                }, s)),
                wrap_widget({
                    s.mylayoutbox,
                    top = dpi(5),
                    bottom = dpi(10),
                    right = dpi(8),
                    left = dpi(8),
                    widget = wibox.container.margin,
                }),
                layout = wibox.layout.fixed.vertical,
            },
        },
        widget = wibox.container.background,
        bg = beautiful.wibar_bg,
    })
end
