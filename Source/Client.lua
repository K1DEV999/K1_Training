--[[

    💬 Export from K1Dev => discord:[ !🧠K1Dev#2935 || ] 
	
    🐌 @Copyright K1Dev
    ☕ Thanks For Coffee Tips 

]]--



local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX = nil
K1Dev = GetCurrentResourceName()
Openshop = false
Checklist = false
numberw = 0
ele = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNUICallback("closeNUI", function ()
    SetNuiFocus(false, false)
    StopAllScreenEffects();
    Openshop = false
    ele = {}

end)


AddEventHandler('esx:onPlayerDeath', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if (GetDistanceBetweenCoords(playerCoords,Config['โซน'].ZoneTrining.x,Config['โซน'].ZoneTrining.y,Config['โซน'].ZoneTrining.z,true) < Config['โซน'].ZoneTrining.Size) then
        ReviveCL()
        DisableControlAction(0, 47, true)
    end

end)

Citizen.CreateThread(function()

	RequestModel(GetHashKey(Config['โซน'].Shopzone.Model))
		while not HasModelLoaded(GetHashKey(Config['โซน'].Shopzone.Model)) do
			Wait(1)
		end
	Npc = CreatePed(4, Config['โซน'].Shopzone.Model, Config['โซน'].Shopzone.x, Config['โซน'].Shopzone.y, Config['โซน'].Shopzone.z-1.0, Config['โซน'].Shopzone.h, false, true)
		FreezeEntityPosition(Npc, true)
		SetEntityInvincible(Npc, true)
		SetBlockingOfNonTemporaryEvents(Npc, true)

end)

Revemovewepon = function()
    if numberw == 1 then
        if Config['ตั้งค่าเบื้องต้น'].Version == "1.1" then
            for k,v in pairs(Config['ร้านค้า']) do

                if v.type == "weapon" then
                    local playerPed = GetPlayerPed(-1)
                    RemoveWeaponFromPed(playerPed, k)
                end
        
            end
            TriggerServerEvent(K1Dev..":RemoveWeapom:item")

            if Config['ตั้งค่าเบื้องต้น'].Removeitem then
                TriggerServerEvent(K1Dev..":Removeitem:item")
            end

            return
        else
            TriggerServerEvent(K1Dev..":RemoveWeapom:item")

            if Config['ตั้งค่าเบื้องต้น'].Removeitem then
                TriggerServerEvent(K1Dev..":Removeitem:item")
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(GetPlayerPed(-1))

            if (GetDistanceBetweenCoords(coords,Config['โซน'].ZoneTrining.x,Config['โซน'].ZoneTrining.y,Config['โซน'].ZoneTrining.z,true) < Config['โซน'].ZoneTrining.Size) then
                mas = 100
                SendNUIMessage({
                    display = "openinzone"
                });
                numberw = 0
                AntiDelWeapon = true
            else
                mas = 1000
                numberw = numberw + 1
                if AntiDelWeapon == true then
                    Revemovewepon()
                end

                SendNUIMessage({
                    display = "closeinzone"
                });
                AntiDelWeapon = false
                
            end

            if (GetDistanceBetweenCoords(coords,Config['โซน'].Shopzone.x,Config['โซน'].Shopzone.y,Config['โซน'].Shopzone.z,true) < 2) then
                if not Openshop then
                    mas = 10
                 --   DisplayHelpText('Press ~INPUT_CONTEXT~ to access the ~y~Shop~s~.')
                    K1ShowFloatingHelp(Config['โซน'].Shopzone.x,Config['โซน'].Shopzone.y,Config['โซน'].Shopzone.z, '~INPUT_CONTEXT~ to access the ~y~Shop~s~.')
                
                    if IsControlJustPressed(0, 38)  then
                        
                        for k,v in pairs(Config['ร้านค้า']) do
                            table.insert(ele,{
                                itemList = k,
                                Type = v.type,
                                Price = v.price,
                                name = v.name
                            })
                            
                        end
                        Openshop = true
                        OpenShopMenu(ele)
                       
                    end
                end
            end

            Citizen.Wait(mas)

    end
end)



OpenShopMenu = function(data)
    StartScreenEffect("MenuMGIn", 1, true)
    SetNuiFocus(true, true)
    SendNUIMessage({
        display = "open",
        action = "itemsent",
        itemall = data
    })
end


RegisterNUICallback("callbackbuy", function (cb)
    local data = {}
    local Antiloop = 0 
    if cb.itemcall.Type == "weapon" then
        if HasPedGotWeapon(PlayerPedId(), GetHashKey(cb.itemcall.itemList), false) == 1 then
            exports.pNotify:SendNotification({
                text = "คุณได้ซื้อ "..cb.itemcall.name.." ไปแล้ว",
                type = "error",
                timeout = 3000,
                layout = "centerLeft",
                queue = "left"
            })
            return
        end
        Antiloop = Antiloop + 1
        if Antiloop == 1 then
            TriggerServerEvent(K1Dev..':add:weponzon',cb.itemcall)  
        end
        
    else
        Antiloop = Antiloop + 1
        if Antiloop == 1 then
            TriggerServerEvent(K1Dev..':add:item:zone',cb.itemcall) 
        end
        
    end

end)



local player = GetPlayerPed(-1)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        local player = GetPlayerPed(-1)
        local playerLoc = GetEntityCoords(player)
        DrawMarker(1, Config['โซน'].Inzone.x, Config['โซน'].Inzone.y, Config['โซน'].Inzone.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 0, 0, 255, 200, 0, 0, 0, 0)
        DrawMarker(1, Config['โซน'].Outzone.x, Config['โซน'].Outzone.y, Config['โซน'].Outzone.z, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 0, 0, 255, 200, 0, 0, 0, 0)
        

        if CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, Config['โซน'].Inzone.x, Config['โซน'].Inzone.y, Config['โซน'].Inzone.z, 2) then


       --     DisplayHelpText('Press ~INPUT_CONTEXT~ to in~y~Espost~s~.')
            K1ShowFloatingHelp(playerLoc.x, playerLoc.y, playerLoc.z, '~INPUT_CONTEXT~ to in ~y~Espost~s~.')
            if IsControlJustReleased(1, 38) then
                CheckWeapon()
                exports['mythic_progbar']:Progress({
                    name = "unique_action_name",
                    duration = 5000,
                    label = 'กำลังพาไป Zone Esport..',
                    useWhileDead = true,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(cancelled)
                    if not cancelled then
                        if Checklist == true then
                            if IsPedInAnyVehicle(player, true) then
                                SetEntityCoords(GetVehiclePedIsUsing(player), Config['โซน'].Outzone.x, Config['โซน'].Outzone.y, Config['โซน'].Outzone.z)
                                AntiCoords()
                            else
                                SetEntityCoords(player, Config['โซน'].Outzone.x, Config['โซน'].Outzone.y, Config['โซน'].Outzone.z)
                                AntiCoords()
                            end 
                        else
                            exports.pNotify:SendNotification({
                                text = "พบเจออาวุธในตัวไม่สามารถเข้า Zone ได้!!!",
                                type = "error",
                                timeout = math.random(1000, 10000),
                                layout = "centerLeft",
                                queue = "left"
                            })
                        end

                    end
                end)
            end

        elseif CheckPos(playerLoc.x, playerLoc.y, playerLoc.z, Config['โซน'].Outzone.x, Config['โซน'].Outzone.y, Config['โซน'].Outzone.z, 2) then

     --       DisplayHelpText('Press ~INPUT_CONTEXT~ to out~y~Espost~s~.')
            K1ShowFloatingHelp(playerLoc.x, playerLoc.y, playerLoc.z, '~INPUT_CONTEXT~ to out ~y~Espost~s~.')
            if IsControlJustReleased(1, 38) then
                exports['mythic_progbar']:Progress({
                    name = "unique_action_name",
                    duration = 5000,
                    label = 'กำลังออกจาก ZoneEsport.',
                    useWhileDead = true,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(cancelled)
                    if not cancelled then
                        if IsPedInAnyVehicle(player, true) then
                            SetEntityCoords(GetVehiclePedIsUsing(player), Config['โซน'].Inzone.x, Config['โซน'].Inzone.y, Config['โซน'].Inzone.z)
                        else
                            SetEntityCoords(player, Config['โซน'].Inzone.x, Config['โซน'].Inzone.y, Config['โซน'].Inzone.z)
                        end
                    end
                end)
            end


        end
    end
end)

ReviveCL = function()
    Revivedie = true
    Timerevive = Config['ตั้งค่าเบื้องต้น'].Timerevive
    Citizen.CreateThread(function()
        while Revivedie do
          
            if Timerevive >= 1 then
                macs = 1000
                Timerevive = Timerevive - 1 
                SendNUIMessage({
                    action = "revivewait",
                    text = "กำลังจะเกิด " .. Timerevive,
                });
                
            end

            if Timerevive == 0 then
                macs = 10
                if IsControlJustPressed(0, Keys[Config['ตั้งค่าเบื้องต้น'].Keys]) then
                    SendNUIMessage({
                        bool = false,
                        action = "pressKey",
                    });
                    Revive()
                    Revivedie = false
                    return
                end
                SendNUIMessage({
                    bool = true,
                    action = "pressKey",
                    text = "กด "..Config['ตั้งค่าเบื้องต้น'].Keys.." เพื่อเกิด..",
                });
            end
            Citizen.Wait(macs)
        end
    end)
end

AntiCoords = function()
    isFreezeLegs = true
    Citizen.CreateThread(function()
        while isFreezeLegs do
            FreezeEntityPosition(PlayerPedId(), true)
      --      DrawText("Press [~g~W, A, S, D, SPACE~s~] to unfreeze your self")
            if IsControlJustPressed(0, Keys['W']) or IsControlJustPressed(0, Keys['A']) or IsControlJustPressed(0, Keys['S']) or IsControlJustPressed(0, Keys['D']) or IsControlJustPressed(0, Keys['SPACE']) then
                FreezeEntityPosition(PlayerPedId(), false)
                isFreezeLegs = false
            end
            Wait(0)
        end
    end)
end



function DrawText(text) 
    SetTextFont(4)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.3)
end

Citizen.CreateThread(function()

	RequestModel(GetHashKey(Config['โซน'].Shopzone.Model))
		while not HasModelLoaded(GetHashKey(Config['โซน'].Shopzone.Model)) do
			Wait(1)
		end
	Npc = CreatePed(4, Config['โซน'].Shopzone.Model, Config['โซน'].Shopzone.x, Config['โซน'].Shopzone.y, Config['โซน'].Shopzone.z-1.0, Config['โซน'].Shopzone.h, false, true)
		FreezeEntityPosition(Npc, true)
		SetEntityInvincible(Npc, true)
		SetBlockingOfNonTemporaryEvents(Npc, true)

        blip = AddBlipForCoord(Config['โซน'].Inzone.x, Config['โซน'].Inzone.y, Config['โซน'].Inzone.z)
    
        SetBlipSprite(blip, Config['โซน'].Inzone.Blip.Sprite)
        SetBlipScale(blip, Config['โซน'].Inzone.Blip.Scale)
        SetBlipColour(blip,Config['โซน'].Inzone.Blip.Colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config['โซน'].Inzone.Blip.Text)
        EndTextCommandSetBlipName(blip)

end)

function CheckPos(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2

    local t2 = y-cy
    local t21 = t2^2

    local t3 = z - cz
    local t31 = t3^2

    return (t12 + t21 + t31) <= radius^2
end

CheckWeapon = function()
    for k,v in pairs(Config['ร้านค้า']) do
        if HasPedGotWeapon(PlayerPedId(), GetHashKey(k), false) == 1 then
            Checklist = false
        else
            Checklist = true
            Citizen.Wait(500)
        end
    end
end



K1ShowFloatingHelp = function(x,y,z, text)
    AddTextEntry('K1'..GetCurrentResourceName(), text)
    SetFloatingHelpTextWorldPosition(1, x,y,z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('K1'..GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)
end


