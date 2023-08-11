local config_dir = require('gears').filesystem.get_configuration_dir()
local M = {
    default = {
        terminal = 'wezterm start --always-new-process', --os.getenv('TERMINAL') or 'st',
        --terminal = 'kitty', --os.getenv('TERMINAL') or 'st',
        --music_player = 'wezterm start --class music ncmpcpp',
        --text_editor = 'wezterm start nvim',
        code_editor = 'codium',
        web_browser = 'firefox',
        file_manager = 'nautilus',
        --network_manager = 'wezterm start nmtui',
        bluetooth_manager = 'blueman-manager',
        power_manager = 'xfce4-power-manager',
        app_launcher = 'rofi -no-lazy-grab -show run -modi drun -theme ' .. config_dir .. 'configuration/rofi.rasi',
    },
}

return M
