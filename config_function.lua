--[[

    💬 Export from K1Dev => discord:[ !🧠K1Dev#2935 || ] 
	
    🐌 @Copyright K1Dev
    ☕ Thanks For Coffee Tips 

]]--


Revive = function()
    local playerPed = PlayerPedId()
        if not cancelled then
            TriggerEvent('esx_ambulancejob:revive')
            Citizen.Wait(2000)
            SetEntityHealth(playerPed, 200)
            EnableControlAction(0, 47, true)
        end
end