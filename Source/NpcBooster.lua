--[[

    💬 Export from K1Dev => discord:[ !🧠K1Dev#2935 || ] 
	
    🐌 @Copyright K1Dev
    ☕ Thanks For Coffee Tips 

]]--


local ESX = nil

local Peds = {}
local NPCPeds = {}
local notpick = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
end)

function spawnPed(location)
	local npc = Config["เช็ตNpc"][location.npc]
	npc.spawnPoint = location.coords
	local choosenPed = string.upper(npc.model)
	RequestModel(GetHashKey(choosenPed))
	while not HasModelLoaded(GetHashKey(choosenPed)) or not HasCollisionForModelLoaded(GetHashKey(choosenPed)) do
		Wait(1)
	end
	local x, y, z = table.unpack(location.coords)
	local NPC = Config["เช็ตNpc"][location.npc]
	local choosenPed = string.upper(NPC.model)
	RequestModel(GetHashKey(choosenPed))

	while not HasModelLoaded(GetHashKey(choosenPed)) or not HasCollisionForModelLoaded(GetHashKey(choosenPed)) do
		Citizen.Wait(1)
	end
	local distance = location.distance
	local newX = x + math.random(-distance, distance)
	local newY = y + math.random(-distance, distance)
	local _, newZ = GetGroundZFor_3dCoord(newX+.0, newY+.0, z+999.0, 1)
	local ped = CreatePed(4, GetHashKey(choosenPed), newX, newY, newZ, 0.0, false, false)
	SetEntityHealth(ped, npc.health)
	SetPedArmour(ped, npc.armour)

	FreezeEntityPosition(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	
	TaskStartScenarioInPlace(ped, "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01", 0, false)
	RequestAnimDict("anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01")
	TaskPlayAnim(ped, "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01", 20.0, -20.0, -1, 1, 0, false, false, false)				

	table.insert(Peds, ped)
	table.insert(NPCPeds, {
		entity = ped,
		npc = npc,
		die = 0
	})
end

function GetPedNPC(ped)
	for i, npc in pairs(NPCPeds) do
		if npc.entity == ped then
			return NPCPeds[i]
		end
	end
end

function RemovePedNPC(ped)

	for i, npc in pairs(NPCPeds) do
		if npc.entity == ped then
			table.remove(NPCPeds, i)
		end
	end

	for k, v in pairs(Peds) do
		if v == ped then
			table.remove(Peds, k)
		end
	end

	if DoesEntityExist(ped) then
		DeleteEntity(ped)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local canSleep = true
		for k, v in pairs(Config["เช็ตจุด"]) do
			local currentcoords = v.coords
			local distance = v.distance
			local currentkcoords = k
			local playerCoords = GetEntityCoords(GetPlayerPed(-1), true)
			
			if (Vdist(v.coords, playerCoords) < v.distance) then
				if  #Peds < v.max then
					spawnPed(v)
					Citizen.Wait(v.spawntime)
				end
				canSleep = false
			end
		end
		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local canSleep = true
		for i, ped in pairs(Peds) do
			local npc = GetPedNPC(ped)
			local pedCoord = GetEntityCoords(ped, true)
			local playerCoords = GetEntityCoords(GetPlayerPed(-1), true)

			if not DoesEntityExist(ped) then
				RemovePedNPC(ped)
			elseif IsPedDeadOrDying(ped, 1) then
				if npc.die == 0 then
					npc.die = GetGameTimer()
				end

				if GetGameTimer() - npc.die >= Config["ลบNpcหลังตาย"] and not notpick then
					local model = GetEntityModel(ped)
					SetEntityAsNoLongerNeeded(ped)
					SetModelAsNoLongerNeeded(model)
					RemovePedNPC(ped)
				end
			else
				if (Vdist(pedCoord, npc.npc.spawnPoint.x, npc.npc.spawnPoint.y, npc.npc.spawnPoint.z) > npc.npc.remove_range) and (Vdist(pedCoord, playerCoords) > 10) then
					TaskGoStraightToCoord(ped, npc.npc.spawnPoint.x, npc.npc.spawnPoint.y, npc.npc.spawnPoint.z, 1.0, -1, 0.0, 0.0)
					Citizen.Wait(2000)
					TaskWanderStandard(ped, 1.0, 10)
				end

				if (Vdist(pedCoord, playerCoords) > npc.npc.remove_range) then
					local model = GetEntityModel(ped)
					SetEntityAsNoLongerNeeded(ped)
					SetModelAsNoLongerNeeded(model)
					RemovePedNPC(ped)
					ResetAiMeleeWeaponDamageModifier()
				else
				end
				canSleep = false
			end
			if canSleep then
				Citizen.Wait(500)
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for i, ped in pairs(Peds) do
			SetEntityAsNoLongerNeeded(ped)
			DeleteEntity(ped)
		end
	end
end)