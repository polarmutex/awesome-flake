local awful = require('awful')
local gears = require('gears')
local gfs = gears.filesystem
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local helpers = require('helpers')

local get_taglist = function(s)
    -- Taglist buttons
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t)
            t:view_only()
        end),
        --awful.button({ modkey }, 1, function(t)
        --    if client.focus then
        --        client.focus:move_to_tag(t)
        --    end
        --end),
        awful.button({}, 3, awful.tag.viewtoggle),
        --awful.button({ modkey }, 3, function(t)
        --    if client.focus then
        --        client.focus:toggle_tag(t)
        --    end
        --end),
        awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
    )

    local hex_slice = gears.surface.load_uncached(
        gfs.get_configuration_dir() .. 'themes/assets/icons/hexagon-slice-6.svg'
    )
    local hex_slice_icon = gears.color.recolor_image(hex_slice, beautiful.accent)

    local hex_outline = gears.surface.load_uncached(
        gfs.get_configuration_dir() .. 'themes/assets/icons/hexagon-outline.svg'
    )
    local hex_outline_icon = gears.color.recolor_image(hex_outline, beautiful.accent)

    local hex = gears.surface.load_uncached(gfs.get_configuration_dir() .. 'themes/assets/icons/hexagon.svg')
    local hex_icon = gears.color.recolor_image(hex, beautiful.accent)

    -- Function to update the tags
    local update_tags = function(self, c3)
        local imgbox = self:get_children_by_id('icon_role')[1]
        if c3.selected then
            imgbox.image = hex_icon
        elseif #c3:clients() == 0 then
            imgbox.image = hex_outline_icon
        else
            imgbox.image = hex_slice_icon
        end
    end

    local pac_taglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = helpers.rrect(beautiful.border_radius),
        },
        layout = { spacing = 0, layout = wibox.layout.fixed.vertical },
        widget_template = {
            {
                { id = 'icon_role', widget = wibox.widget.imagebox },
                id = 'margin_role',
                margins = dpi(5),
                widget = wibox.container.margin,
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
                update_tags(self, c3)
                --self:connect_signal('mouse::enter', function()
                --    if #c3:clients() > 0 then
                --        awesome.emit_signal('bling::tag_preview::update', c3)
                --        awesome.emit_signal('bling::tag_preview::visibility', s, true)
                --    end
                --end)
                --self:connect_signal('mouse::leave', function()
                --    awesome.emit_signal('bling::tag_preview::visibility', s, false)
                --end)
            end,
            update_callback = function(self, c3, index, objects)
                update_tags(self, c3)
            end,
        },
        buttons = taglist_buttons,
    })

    return pac_taglist
end

return get_taglist
