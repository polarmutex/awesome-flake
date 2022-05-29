local config_dir = require('gears').filesystem.get_configuration_dir()

return {
    rofiCommand = 'rofi -show run -theme ' .. config_dir .. '/misc/rofi/theme.rasi',
}
