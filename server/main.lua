ESX = nil

TriggerEvent(Config.EventRoute['getSharedObject'], function(obj)
    ESX = obj
end)

function SendToDiscordLog(xPlayer, vaultJob, type, item, count, message)
    local vault = Config.VaultInventory[vaultJob]
    local finalMessage = message or (Config.VaultMessage[type]):format(item, vault.Name, count)

    local discord_webhook = vault.DiscordHook[type]

    if discord_webhook == '' then
        return
    end

    Config.ServerOnSendDiscord(xPlayer, finalMessage, discord_webhook)
end

RegisterServerEvent('monster_vault:removemoney')
AddEventHandler('monster_vault:removemoney', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(Config.CostOpen)
end)

RegisterServerEvent('monster_vault:getItem')
AddEventHandler('monster_vault:getItem', function(job, type, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == 'item_standard' then

        local sourceItem = xPlayer.getInventoryItem(item)

        if xPlayer.job.name == job then
            TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
                local inventoryItem = inventory.getItem(item)
                if count > 0 and inventoryItem.count >= count then
                    if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                        local status, err = pcall(function()
                            Config.ServerOnNotify(xPlayer, {
                                message = 'พื้นที่ในกระเป๋าไม่เพียงพอ',
                                type = 'error',
                                duration = 4000
                            })
                        end)
                        logError('Config.ServerOnNotify', err)
                    else
                        inventory.removeItem(item, count)
                        xPlayer.addInventoryItem(item, count)

                        SendToDiscordLog(xPlayer, job, 'GetItem', item, count)
                    end
                else
                    local status, err = pcall(function()
                        Config.ServerOnNotify(xPlayer, {
                            message = 'จำนวนไอเทมในตู้มีไม่เพียงพอ',
                            type = 'error',
                            duration = 4000
                        })
                    end)
                    logError('Config.ServerOnNotify', err)
                end
            end)
        elseif job == 'vault' then
            TriggerEvent('esx_addoninventory:getInventory', 'vault', xPlayer.identifier, function(inventory)
                local inventoryItem = inventory.getItem(item)

                if count > 0 and inventoryItem.count >= count then
                    if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                        local status, err = pcall(function()
                            Config.ServerOnNotify(xPlayer, {
                                message = 'พื้นที่ในกระเป๋าไม่เพียงพอ',
                                type = 'error',
                                duration = 4000
                            })
                        end)
                        logError('Config.ServerOnNotify', err)
                    else
                        inventory.removeItem(item, count)
                        xPlayer.addInventoryItem(item, count)
                        SendToDiscordLog(xPlayer, job, 'GetItem', item, count)
                    end
                else
                    local status, err = pcall(function()
                        Config.ServerOnNotify(xPlayer, {
                            message = 'จำนวนไอเทมในตู้มีไม่เพียงพอ',
                            type = 'error',
                            duration = 4000
                        })
                    end)
                    logError('Config.ServerOnNotify', err)
                end
            end)
        else
            local status, err = pcall(function()
                Config.ServerOnNotify(xPlayer, {
                    message = 'อาชีพของคุณไม่สามารถใช้งานตู้เซฟนี้ได้',
                    type = 'error',
                    duration = 4000
                })
            end)
            logError('Config.ServerOnNotify', err)
        end
    elseif type == 'item_account' then
        if xPlayer.job.name == job then
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job .. '_' .. item, function(account)
                local policeAccountMoney = account.money

                if policeAccountMoney >= count then
                    account.removeMoney(count)
                    xPlayer.addAccountMoney(item, count)
                    SendToDiscordLog(xPlayer, job, 'GetMoney', item, count)
                else
                    local status, err = pcall(function()
                        Config.ServerOnNotify(xPlayer, {
                            message = 'จำนวนเงินไม่ถูกต้อง',
                            type = 'error',
                            duration = 4000
                        })
                    end)
                    logError('Config.ServerOnNotify', err)
                end
            end)
        elseif job == 'vault' then
           TriggerEvent('esx_addonaccount:getAccount', 'vault_' .. item, xPlayer.identifier, function(account)
                local roomAccountMoney = account.money

                if roomAccountMoney >= count then
                    account.removeMoney(count)
                    xPlayer.addAccountMoney(item, count)

                    SendToDiscordLog(xPlayer, job, 'GetMoney', item, count)
                else
                    local status, err = pcall(function()
                        Config.ServerOnNotify(xPlayer, {
                            message = 'จำนวนเงินไม่ถูกต้อง',
                            type = 'error',
                            duration = 4000
                        })
                    end)
                    logError('Config.ServerOnNotify', err)
                end
            end)
        else
            local status, err = pcall(function()
                Config.ServerOnNotify(xPlayer, {
                    message = 'อาชีพของคุณไม่สามารถใช้งานตู้เซฟนี้ได้',
                    type = 'error',
                    duration = 4000
                })
            end)
            logError('Config.ServerOnNotify', err)
        end
    elseif type == 'item_weapon' then
        if xPlayer.job.name == job then
            TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. job, function(store)
                local storeWeapons = store.get('weapons') or {}
                local weaponName = nil
                local ammo = nil

                for i = 1, #storeWeapons, 1 do
                    if storeWeapons[i].name == item then
                        weaponName = storeWeapons[i].name
                        ammo = storeWeapons[i].ammo

                        table.remove(storeWeapons, i)
                        break
                    end
                end

                store.set('weapons', storeWeapons)
                xPlayer.addWeapon(weaponName, ammo)

                local msg = '' .. xPlayer.name .. ' นำ ' .. ESX.GetWeaponLabel(weaponName) .. ' ออกจากตู้นิรภัย'
                if ammo ~= nil and ammo > 0 then
                    msg = '' .. xPlayer.name .. ' นำ ' .. ESX.GetWeaponLabel(weaponName) .. ' และ กระสุน จำนวน ' .. ESX.Math.GroupDigits(ammo) .. ' ออกจากตู้นิรภัย'
                end
                SendToDiscordLog(xPlayer, job, 'GetWeapon', item, count, msg)
            end)
        elseif job == 'vault' then
            TriggerEvent('esx_datastore:getDataStore', 'vault', xPlayer.identifier, function(store)
                local storeWeapons = store.get('weapons') or {}
                local weaponName = nil
                local ammo = nil

                for i = 1, #storeWeapons, 1 do
                    if storeWeapons[i].name == item then
                        weaponName = storeWeapons[i].name
                        ammo = storeWeapons[i].ammo

                        table.remove(storeWeapons, i)
                        break
                    end
                end

                store.set('weapons', storeWeapons)
                xPlayer.addWeapon(weaponName, ammo)

                local msg = '' .. xPlayer.name .. ' นำ ' .. ESX.GetWeaponLabel(weaponName) .. ' ออกจากตู้นิรภัย'
                if ammo ~= nil and ammo > 0 then
                    msg = '' .. xPlayer.name .. ' นำ ' .. ESX.GetWeaponLabel(weaponName) .. ' และ กระสุน จำนวน ' .. ESX.Math.GroupDigits(ammo) .. ' ออกจากตู้นิรภัย'
                end

                SendToDiscordLog(xPlayer, job, 'GetWeapon', item, count, msg)
            end)
        else
            local status, err = pcall(function()
                Config.ServerOnNotify(xPlayer, {
                    message = 'อาชีพของคุณไม่สามารถใช้งานตู้เซฟนี้ได้',
                    type = 'error',
                    duration = 4000
                })
            end)
            logError('Config.ServerOnNotify', err)
        end
    end

end)

RegisterServerEvent('monster_vault:putItem')
AddEventHandler('monster_vault:putItem', function(job, type, item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if ArrayIsOne(Config.ItemBlackList, item) then
        local status, err = pcall(function()
            Config.ServerOnNotify(xPlayer, {
                message = 'คุณไม่สามารถเก็บไอเทม "' .. item .. '" เข้าตู้เซฟนี้ได้',
                type = 'warning',
                duration = 4000
            })
        end)
        logError('Config.ServerOnNotify', err)
        return
    end

    if ArrayIsOne(Config.VaultInventory[job].ItemBlackList, item) then
        local status, err = pcall(function()
            Config.ServerOnNotify(xPlayer, {
                message = 'คุณไม่สามารถเก็บไอเทม "' .. item .. '" เข้าตู้เซฟนี้ได้',
                type = 'warning',
                duration = 4000
            })
        end)
        logError('Config.ServerOnNotify', err)
        return
    end

    if type == 'item_standard' then
        local playerItemCount = xPlayer.getInventoryItem(item).count
        if playerItemCount >= count and count > 0 then
            if xPlayer.job.name == job then
                TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
                    xPlayer.removeInventoryItem(item, count)
                    inventory.addItem(item, count)

                    SendToDiscordLog(xPlayer, job, 'PutItem', item, count)
                end)
            elseif job == 'vault' then
                TriggerEvent('esx_addoninventory:getInventory', 'vault', xPlayer.identifier, function(inventory)
                    xPlayer.removeInventoryItem(item, count)
                    inventory.addItem(item, count)
                    SendToDiscordLog(xPlayer, job, 'PutItem', item, count)
                end)
            else
                local status, err = pcall(function()
                    Config.ServerOnNotify(xPlayer, {
                        message = 'อาชีพของคุณไม่สามารถเก็บไอเทมเข้าตู้เซฟนี้ได้',
                        type = 'error',
                        duration = 4000
                    })
                end)
                logError('Config.ServerOnNotify', err)
            end
        else
            local status, err = pcall(function()
                Config.ServerOnNotify(xPlayer, {
                    message = 'จำนวนไม่ถูกต้อง',
                    type = 'error',
                    duration = 4000
                })
            end)
            logError('Config.ServerOnNotify', err)
        end

    elseif type == 'item_account' then

        local playerAccountMoney = xPlayer.getAccount(item).money

        if playerAccountMoney >= count and count > 0 then
            if xPlayer.job.name == job and Config.VaultInventory[job].AllowBlackMoney then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job .. '_' .. item, function(account)
                    xPlayer.removeAccountMoney(item, count)
                    account.addMoney(count)
                end)

                SendToDiscordLog(xPlayer, job, 'PutMoney', item, count)
            elseif job == 'vault' and Config.VaultInventory[job].AllowBlackMoney then
                TriggerEvent('esx_addonaccount:getAccount', 'vault_' .. item, xPlayer.identifier, function(account)
                    xPlayer.removeAccountMoney(item, count)
                    account.addMoney(count)
                end)
                SendToDiscordLog(xPlayer, job, 'PutMoney', item, count)
            else
                local status, err = pcall(function()
                    Config.ServerOnNotify(xPlayer, {
                        message = 'ตู้นี้ไม่สามารถเก็บเงินแดงได้',
                        type = 'error',
                        duration = 4000
                    })
                end)
                logError('Config.ServerOnNotify', err)
            end
        else
            local status, err = pcall(function()
                Config.ServerOnNotify(xPlayer, {
                    message = 'จำนวนเงินไม่ถูกต้อง',
                    type = 'error',
                    duration = 4000
                })
            end)
            logError('Config.ServerOnNotify', err)
        end
    elseif type == 'item_weapon' then
        if xPlayer.job.name == job then
            TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. job, function(store)
                local storeWeapons = store.get('weapons') or {}

                table.insert(storeWeapons, {
                    name = item,
                    count = count
                })

                xPlayer.removeWeapon(item)
                store.set('weapons', storeWeapons)

                local msg = '' .. xPlayer.name .. ' ฝาก ' .. ESX.GetWeaponLabel(item) .. ' เข้าตู้นิรภัย'
                if count ~= nil and count > 0 then
                    msg = '' .. xPlayer.name .. ' ฝาก ' .. ESX.GetWeaponLabel(item) .. ' และ กระสุน จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตู้นิรภัย'
                end

                SendToDiscordLog(xPlayer, job, 'PutWeapon', item, count, msg)
            end)
        elseif job == 'vault' then
            TriggerEvent('esx_datastore:getDataStore', 'vault', xPlayer.identifier, function(store)
                local storeWeapons = store.get('weapons') or {}

                table.insert(storeWeapons, {
                    name = item,
                    ammo = count
                })

                xPlayer.removeWeapon(item)
                store.set('weapons', storeWeapons)

                local msg = '' .. xPlayer.name .. ' ฝาก ' .. ESX.GetWeaponLabel(item) .. ' เข้าตู้นิรภัย'
                if count ~= nil and count > 0 then
                    msg = '' .. xPlayer.name .. ' ฝาก ' .. ESX.GetWeaponLabel(item) .. ' และ กระสุน จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตู้นิรภัย'
                end
                SendToDiscordLog(xPlayer, job, 'PutWeapon', item, count, msg)
            end)
        else
            local status, err = pcall(function()
                Config.ServerOnNotify(xPlayer, {
                    message = 'อาชีพของคุณไม่สามารถเก็บอาวุธเข้าตู้เซฟนี้ได้',
                    type = 'error',
                    duration = 4000
                })
            end)
            logError('Config.ServerOnNotify', err)
        end
    end

end)

ESX.RegisterServerCallback('monster_vault:getVaultInventory', function(source, cb, item, refresh)
    local xPlayer = ESX.GetPlayerFromId(source)
    local refresh = refresh or false

    local blackMoney = 0
    local items = {}
    local weapons = {}

    local typeVault = ''
    local society = false
    if string.find(item.job, "vault") then
        typeVault = item.job
    else
        typeVault = "society_" .. item.job
        society = true
    end

    if society then
        if Config.VaultInventory[item.job].AllowBlackMoney then
            TriggerEvent('esx_addonaccount:getSharedAccount', typeVault .. '_black_money', function(account)
                blackMoney = account.money
            end)
        else
            blackMoney = 0
        end

        TriggerEvent('esx_addoninventory:getSharedInventory', typeVault, function(inventory)
            items = inventory.items
        end)
        TriggerEvent('esx_datastore:getSharedDataStore', typeVault, function(store)
            weapons = store.get('weapons') or {}
        end)
        cb({
            blackMoney = blackMoney,
            items = items,
            weapons = weapons,
            job = item.job
        })
    else
        if Config.VaultInventory[item.job].AllowBlackMoney then
            TriggerEvent('esx_addonaccount:getAccount', typeVault .. '_black_money', xPlayer.identifier, function(account)
                blackMoney = account.money
            end)
        else
            blackMoney = 0
        end

        TriggerEvent('esx_addoninventory:getInventory', typeVault, xPlayer.identifier, function(inventory)
            items = inventory.items
        end)

        TriggerEvent('esx_datastore:getDataStore', typeVault, xPlayer.identifier, function(store)
            weapons = store.get('weapons') or {}
        end)

        cb({
            blackMoney = blackMoney,
            items = items,
            weapons = weapons,
            job = item.job
        })
    end
end)