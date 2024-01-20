-- ปรับแต่ง Show Help Menu
Config.ClientOnShowHelpMenu = function(vault)

end

-- ปรับแต่งแจ้งเตือน ฝั่ง Client
Config.ClientOnNotify = function(message)
    exports.nc_notify:PushNotification({
        title = message,
        description = '',
        icon = icon,
        type = 'error',
        duration = 3000,
    })
end

-- ปรับแต่งแจ้งเตือน ฝั่ง Server
Config.ServerOnNotify = function(xPlayer, notify)
    exports.nc_notify:PushNotification(xPlayer.source, {
        title = notify.message,
        description = '',
        icon = icon,
        type = 'error',
        duration = 3000,
    })
end

-- ปรับแต่งแจ้ง Discord Log ฝั่ง Server
Config.ServerOnSendDiscord = function(xPlayer, message, webHook)
    --TODO -- ตัวอย่างการใช้งานกับ nc_discordlogs หรือ azael_dc-serverlogs
    --TODO **อย่าลืมไปอื่นรายละเอียดที่ config.general.lua**
    --exports.nc_discordlogs:Discord({
    --    webhook = webHook,
    --    xPlayer = xPlayer,
    --    message = 'แจ้งเตือนตู้เซฟ',
    --    description = message,
    --    color = 'ff4081',
    --})

    CustomDiscordHook(xPlayer, message, webHook)
end

function CustomDiscordHook(xPlayer, message, webHook)
    local headers = {
        ['Content-Type'] = 'application/json'
    }
    local data = {
        ["username"] = 'แจ้งเตือนตู้เซฟ',
        ['avatar_url'] = '',
        ["embeds"] = {
            {
                ['title'] = ('ผู้เล่น **%s** | Identifier: **%s**'):format(xPlayer.getName(), xPlayer.getIdentifier()),
                ['description'] = '```' .. message .. '```',
                ["color"] = 1942002,
                ["footer"] = {
                    ['text'] = ' 🕚เวลา : ' .. os.date('%X') .. ',
                },
            }
        }
    }

    PerformHttpRequest(webHook, function(err, text, headers)
    end, 'POST', json.encode(data), headers)
end