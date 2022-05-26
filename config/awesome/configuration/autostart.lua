local awful = require('awful')

-- Add apps to autostart here
local autostart_apps = {}

for app = 1, #autostart_apps do
    awful.spawn.single_instance(autostart_apps[app], awful.rules.rules)
end
