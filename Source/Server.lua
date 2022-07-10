--[[

    💬 Export from K1Dev => discord:[ !🧠K1Dev#2935 || ] 
	
    🐌 @Copyright K1Dev
    ☕ Thanks For Coffee Tips 

]]--


ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
K1Dev = GetCurrentResourceName()

-- Modify
local ItemsSaver = {}
local WeaponsSaver = {}

RegisterServerEvent(K1Dev..':add:weponzon')
AddEventHandler(K1Dev..':add:weponzon',function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if WeaponsSaver[data.itemList] then
        TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "คุณได้เช่าไปแล้ว!!",
            type = "error",
            queue = "lmao",
            timeout = 10000,
            layout = "bottomCenter"
        })
        return
    end

    if xPlayer.getWeapon(data.itemList) then
        TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "คุณมีอาวุธนี้อยู่แล้ว!!",
            type = "error",
            queue = "lmao",
            timeout = 10000,
            layout = "bottomCenter"
        })
        return
    end

    if xPlayer.getMoney() >= data.Price then
        WeaponsSaver[data.itemList] = 100
        xPlayer.addWeapon(data.itemList, 100)
        xPlayer.removeMoney(data.Price)
    else
        TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "เงินของคุณไม่พอ!!",
            type = "error",
            queue = "lmao",
            timeout = 10000,
            layout = "bottomCenter"
        })
    end
end)

RegisterServerEvent(K1Dev..':add:item:zone')
AddEventHandler(K1Dev..':add:item:zone',function(data)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local prices = data[1].Price * data[2].countitemsel
    if xPlayer.getMoney() >= data[1].Price then
        if ItemsSaver[data[1].itemList] then
            ItemsSaver[data[1].itemList] = ItemsSaver[data[1].itemList] + data[2].countitemsel
        else
            ItemsSaver[data[1].itemList] = data[2].countitemsel
        end
        xPlayer.addInventoryItem(data[1].itemList, data[2].countitemsel)
        xPlayer.removeMoney(prices)
        return
    else
        TriggerClientEvent("pNotify:SendNotification", _source, {
            text = "เงินของคุณไม่พอ !!",
            type = "error",
            queue = "lmao",
            timeout = 10000,
            layout = "bottomCenter"
        })
    end

end)




RegisterServerEvent(K1Dev..":RemoveWeapom:item")
AddEventHandler(K1Dev..":RemoveWeapom:item",function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent("pNotify:SendNotification", _source, {
        text = "ลบอาวุธแล้ว !!",
        type = "error",
        queue = "lmao",
        timeout = 5000,
        layout = "bottomCenter"
    })
    
    for weaponName,_ in pairs(WeaponsSaver) do
        xPlayer.removeWeapon(weaponName)
        table.remove(WeaponsSaver, weaponName)
    end
end)


RegisterServerEvent(K1Dev..":Removeitem:item")
AddEventHandler(K1Dev..":Removeitem:item",function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    for name,count in pairs(ItemsSaver) do
        xPlayer.setInventoryItem(name, 0)
        table.remove(ItemsSaver, name)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then    
        for name,count in pairs(ItemsSaver) do
            xPlayer.setInventoryItem(name, 0)
            table.remove(ItemsSaver, name)
        end
        for weaponName,_ in pairs(WeaponsSaver) do
            xPlayer.removeWeapon(weaponName)
            table.remove(WeaponsSaver, weaponName)
        end
        print('^2RemoveItem ...^0')
    end
end)