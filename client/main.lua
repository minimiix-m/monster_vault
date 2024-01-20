ESX = nil
local objPropSpawnList = {}
local vaultType = {}
local time = 0
local activeVault = false
local open = false
local tempData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.EventRoute['getSharedObject'], function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX == nil or ESX.GetPlayerData().job == nil do
        Citizen.Wait(1000)
    end

    for k, v in pairs(Config.VaultInventory) do
        for i, j in pairs(v.Coords) do
            ESX.Game.SpawnLocalObject(v.Model, j, function(obj)
                table.insert(objPropSpawnList, obj)
                SetEntityHeading(obj, j.w)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
            end)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(objPropSpawnList) do
            log('delete object : ' .. tostring(v))
            if v ~= nil then
                ESX.Game.DeleteObject(v)
            end
        end
    end
end)

function OpenVaultInventoryMenu(_data)
    if _data.job == ESX.GetPlayerData().job.name then
        vaultType = _data
        ESX.TriggerServerCallback("monster_vault:getVaultInventory", function(inventory)
            TriggerEvent(Config.EventRoute['openVaultInventory'], inventory)
        end, _data, false)
    elseif _data.job == "vault" then
        local isVault = checkItemUse(_data.needItemLicense)
        if isVault == "money" then
            if not activeVault then
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'monster_vault',
                {
                    title    =  '',
                    align    = 'top-left',
                    elements = {
                        {
                            label = 'จ่ายเงิน '..Config.CostOpen..' เพื่อเปิดตู้ '..Config.TimeVault..' นาที',	
                            value = 'yes'
                        },
                    }
                }, function(data, menu)
                    if data.current.value == 'yes' then
                        menu.close()
                        if checkMoney() then
                            vaultType = _data
                            ESX.TriggerServerCallback("monster_vault:getVaultInventory", function(inventory)
                                if not activeVault then
                                    time = Config.TimeVault * 60 * 1000
                                    TriggerServerEvent('monster_vault:removemoney')
                                    activeVault = true
                                end
            
                                TriggerEvent(Config.EventRoute['openVaultInventory'], inventory)
                            end, _data, false)
                        else
                            Config.ClientOnNotify('คุณต้องมีเงิน '..Config.CostOpen..' บาทเพื่อใช้เปิดตู้เซฟ')
                        end
                    end
                end, function(data, menu)
                    menu.close()
                end)
            else
                ESX.TriggerServerCallback("monster_vault:getVaultInventory", function(inventory)
                    TriggerEvent(Config.EventRoute['openVaultInventory'], inventory)
                end, _data, false)
            end
        elseif isVault == "item" then
            vaultType = _data
            ESX.TriggerServerCallback("monster_vault:getVaultInventory", function(inventory)
                TriggerEvent(Config.EventRoute['openVaultInventory'], inventory)
            end, _data, false)
        else
            Config.ClientOnNotify('คุณไม่มี กุญแจ ในการเปิดตู้เซฟ')
        end
    else
        Config.ClientOnNotify('คุณไม่ได้รับอนุญาต เพราะไม่ใช่หน่วยงานที่กำหนด')
        Citizen.Wait(8000)
    end
end

function checkItemUse(itemList)
    local inventory = ESX.GetPlayerData().inventory

    for i = 1, #inventory do
        for _, v in pairs(itemList) do
            if v == inventory[i].name then
                if inventory[i].count > 0 then
                    return "item"
                else
                    return "money"
                end
            end
        end
    end

    return "none"
end

function checkMoney()
    for _,v in pairs(ESX.GetPlayerData().accounts) do
        if v.name == 'money' then
            if (ESX and v.money >= Config.CostOpen) then
                return true
            else
                return false
            end
        end
    end      
end

Citizen.CreateThread(function()
    while true do
        local sleepTime = 10000

        if time > 0 and activeVault then
            time = time - 10000
        end

        if time <= 0 and activeVault then
            time = 0
            activeVault = false
            exports.nc_inventory:CloseInventory()
        end

        Citizen.Wait(sleepTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleepTime = 1000
        local coords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(Config.VaultInventory) do
            for i, j in pairs(v.Coords) do
                local dist = GetDistanceBetweenCoords(coords, j, true)

                if dist < 5 and not open then
                    tempData = j
                    sleepTime = 0
                    exports["Chanom_textui"]:TextUI("PRESS ~INPUT_CONTEXT~ OPEN VAULT")
                    if IsControlJustReleased(0, Keys['E']) then
                        OpenVaultInventoryMenu({ job = k, needItemLicense = v.NeedItemLicense, coords = j })
                    end
                end
            end
        end

        Citizen.Wait(sleepTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        if tempData ~= nil then
            local coords = GetEntityCoords(PlayerPedId())
            local dist = GetDistanceBetweenCoords(coords, tempData, true)

            if dist > 5 then
                tempData = nil
                ESX.UI.Menu.CloseAll()
                exports.nc_inventory:CloseInventory()
            end
        end

        Citizen.Wait(1000)
    end
end)

function getMonsterVaultLicense()
    return vaultType
end
