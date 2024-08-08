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

-- Systray Widget -------------------------------------------------------------

--local mysystray = wibox.widget.systray()
--mysystray.base_size = beautiful.systray_icon_size

--local sys_button = wibox.widget({
--    forced_width = 10,
--    forced_height = 12,
--    bg = beautiful.xforeground,
--    --shape = helpers.powerline(10, 12),
--    widget = wibox.container.background,
--})

--local sys_popup = awful.popup({
--    widget = wibox.widget({
--        { mysystray, margins = 10, widget = wibox.container.margin },
--        forced_height = 65,
--        bg = beautiful.darker_bg,
--        widget = wibox.container.background,
--    }),
--    ontop = true,
--    visible = false,
--    placement = function(c)
--        awful.placement.bottom_left(c, {
--            margins = { left = beautiful.wibar_width + 10, bottom = 20 },
--        })
--    end,
--    shape = gears.shape.rounded_rect,
--})

--sys_button:buttons(gears.table.join(awful.button({}, 1, function()
--    if sys_popup.visible then
--        sys_popup.visible = false
--    else
--        sys_popup.visible = true
--    end
--end)))

--sys_button:connect_signal('mouse::enter', function()
--    sys_button.bg = beautiful.xcolor8
--end)

--sys_button:connect_signal('mouse::leave', function()
--    sys_button.bg = beautiful.xforeground
--end)

--local wrap_widget = function(w)
--    return {
--        w,
--        top = dpi(5),
--        left = dpi(5),
--        bottom = dpi(5),
--        right = dpi(5),
--        widget = wibox.container.margin,
--    }
--end

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

                    -- Tag preview
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
    --s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    --s.mylayoutbox = awful.widget.layoutbox(s)

    --local layoutbox = wibox.widget({
    --    s.mylayoutbox,
    --    right = dpi(9),
    --    left = dpi(9),
    --    top = dpi(6),
    --    bottom = dpi(6),
    --    widget = wibox.container.margin,
    --})

    local COLORS = {
        purple = '#cdb4db',
        pink = '#ffafcc',
        light_pink = '#ffc8dd',
        blue = '#a2d2ff',
        light_blue = '#bde0fe',
        light_green = '#bde0fe',

        gradient_1 = 'radial:50,50,10:55,55,30:0,#ff0000:0.5,#00ff00:1,#0000ff',

        background = '#171717',
        background_2 = '#282828',
        white = '#ffffff',
        normal = '#959CB7',
        primary = '#1c71a8',
        secondary = '#3EA0C1',
        hidden = '#48616a',
        warning = '#758b0d',
        urgent = '#d43682',
        transparent = '#00000000',
    }
    local function wrap_widget(widget, bg, h_margin)
        return wibox.widget({
            {
                {
                    wibox.widget.base.empty_widget(),
                    widget,
                    expand = 'none',
                    layout = wibox.layout.align.horizontal,
                },
                left = h_margin,
                right = h_margin,
                --top    = 5,
                --bottom = 5,
                widget = wibox.container.margin,
            },
            bg = bg or COLORS.background_2,
            shape_border_color = COLORS.background_2,
            shape_border_width = 1,
            shape = function(cr, width, height)
                return gears.shape.rounded_rect(cr, width, height, dpi(9))
            end,
            widget = wibox.container.background,
        })
    end

    local function create_clock_widget()
        local clock_widget = wibox.widget({
            layout = wibox.layout.fixed.vertical,
            {
                widget = wibox.container.place,
                wibox.widget({
                    format = '%I',
                    font = 'MonoLisa',
                    widget = wibox.widget.textclock,
                }),
            },
            {
                widget = wibox.container.margin,
                left = dpi(5),
                {
                    wibox.widget({
                        markup = ':',
                        font = 'MonoLisa',
                        widget = wibox.widget.textbox,
                    }),
                    direction = 'west',
                    widget = wibox.container.rotate,
                },
            },
            {
                widget = wibox.container.place,
                wibox.widget({
                    format = '%M',
                    font = 'MonoLisa',
                    widget = wibox.widget.textclock,
                }),
            },
        })
        -- Calendar widget
        --local calendar_widget = calendar_widget_f({
        --    theme = 'nord',
        --    placement = 'top_left',
        --    start_sunday = false,
        --    radius = dpi(8),
        --    previous_month_button = 5,
        --    next_month_button = 4,
        --})
        --clock_widget:connect_signal('button::press', function(_, _, _, button)
        --    if button == 1 then
        --        calendar_widget.toggle()
        --    end
        --end)

        return {
            wrap_widget(clock_widget, nil, dpi(6)),
            left = dpi(5),
            right = dpi(5),
            widget = wibox.container.margin,
        }
    end

    local systray = widgets.toggable_systray({
        toggle_side = 'right',
        text_icon_show = ' 󰏝 ',
        text_icon_hide = ' 󰏝 ',
        no_tooltip = true,
        hidden_at_start = false,
        margin_top = dpi(9),
        margin_bottom = dpi(9),
        create_systray_box = function(systray_container)
            local toggable_content = {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(10),
                --{
                --    widgets:load('volume_widget'),
                --    direction = 'east',
                --    widget = wibox.container.rotate,
                --},
                --{
                --    widgets:load('battery_widget'),
                --    direction = 'east',
                --    widget = wibox.container.rotate,
                --},
            }
            if not systray_displayed then
                systray_displayed = true
                table.insert(toggable_content, systray_container)
            end
            return wibox.widget({
                wrap_widget({
                    toggable_content,
                    right = dpi(10),
                    left = dpi(10),
                    widget = wibox.container.margin,
                }, COLORS.background_2),
                top = dpi(5),
                bottom = dpi(5),
                widget = wibox.container.margin,
            })
        end,
    })

    local toggable_systray_container = {
        systray,
        direction = 'west',
        widget = wibox.container.rotate,
    }

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
                widget = wibox.container.place,
                {
                    {
                        layout = wibox.layout.fixed.vertical,
                        spacing = dpi(10),
                        --{
                        --    {
                        --        widgets:load('launcher'),
                        --        width = dpi(25),
                        --        widget = wibox.container.constraint,
                        --    },
                        --    widget = wibox.container.place,
                        --},
                        tag_list(s),
                        --{
                        --wrap_widget({
                        --    {
                        --        {
                        --            --s.mytaglist,
                        --            direction = 'east',
                        --            widget = wibox.container.rotate,
                        --        },
                        --        widget = wibox.container.place,
                        --    },
                        --    top = dpi(1),
                        --    left = dpi(3),
                        --    right = dpi(3),
                        --    widget = wibox.container.margin,
                        --}),
                        --widget = wibox.container.place,
                        --},
                    },
                    top = dpi(10),
                    widget = wibox.container.margin,
                },
            },
            {
                layout = wibox.layout.fixed.vertical,
                -- clock
                {
                    widget = wibox.container.place,
                    create_clock_widget(),
                },
            },
            {
                layout = wibox.layout.fixed.vertical,
                toggable_systray_container,
            },
        },
        widget = wibox.container.background,
        bg = beautiful.wibar_bg,
        shape = function(cr, width, height)
            return gears.shape.rounded_rect(cr, width, height, dpi(15))
        end,
    })
end
