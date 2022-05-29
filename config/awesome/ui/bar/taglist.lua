-- Taglist widget
-- ~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require('awful')
local gears = require('gears')
local helpers = require('helpers')
local wibox = require('wibox')
local beautiful = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

-- default modkey
local modkey = 'Mod4'

local get_taglist = function(s)
    -- Taglist buttons
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

    local the_taglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = { shape = helpers.rrect(5) },
        layout = { spacing = dpi(10), layout = wibox.layout.fixed.vertical },
        widget_template = {
            --id = 'background_role',
            widget = wibox.container.background,
            shape = gears.shape.rounded_rect,
            forced_width = dpi(12),
            forced_height = dpi(12),
            --bg = beautiful.accent,

            create_callback = function(self, c3, _)
                --self:connect_signal('mouse::enter', function()
                --    if #c3:clients() > 0 then
                --        awesome.emit_signal('bling::tag_preview::update', c3)
                --        awesome.emit_signal('bling::tag_preview::visibility', s, true)
                --        awesome.emit_signal('bling::task_preview::visibility', s, true, c3)
                --    end
                --end)
                --self:connect_signal('mouse::leave', function()
                --    awesome.emit_signal('bling::tag_preview::visibility', s, false)
                --    awesome.emit_signal('bling::task_preview::visibility', s, false, c3)
                --end)

                if c3.selected then
                    self.bg = beautiful.accent
                elseif #c3:clients() == 0 then
                    self.bg = beautiful.accent_off
                else
                    self.bg = beautiful.accent_light
                end
            end,

            update_callback = function(self, c3, _)
                if c3.selected then
                    self.bg = beautiful.accent
                elseif #c3:clients() == 0 then
                    self.bg = beautiful.accent_off
                else
                    self.bg = beautiful.accent_light
                end
            end,
        },

        buttons = taglist_buttons,
    })

    return the_taglist
end

return get_taglist
