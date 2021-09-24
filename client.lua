local Saleplaces = {
    {["heading"] = 322.2148 ,["coords"] = vector3(2703.9655,-1101.8981,48.8336)},
    {["heading"] = 338.4930,["coords"] = vector3(-1815.4390,-422.5253,159.9969)},
    {["heading"] = 51.5400,["coords"] = vector3(-3609.3720,-2640.5590,-11.4991)},
}

local packing1 = false
local VORPCore = {}

Citizen.CreateThread(function()
    while not VORPCore do        
        TriggerEvent("getCore", function(core)
            VORPCore = core
        end)
        Citizen.Await(200)
    end
end)
RegisterNetEvent("vorp:SelectedCharacter") -- NPC loads after selecting character
AddEventHandler("vorp:SelectedCharacter", function(charid)
    SpawnNPC()
end)
-- Packing progress
RegisterNetEvent('scf_drugs:progress1')
AddEventHandler('scf_drugs:progress1', function()
    if packing1 == false then
        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
        packing1 = true
        exports['progressBars']:startUI(35000, "Packing...")
        Citizen.Wait(35000)
        ClearPedTasksImmediately(PlayerPedId())
        ClearPedSecondaryTask(PlayerPedId())
        packing1 = false
        TriggerServerEvent("scf_drugs:reward1") 
    end
end)
local packing2 = false
RegisterNetEvent('scf_drugs:progress2')
AddEventHandler('scf_drugs:progress2', function()
    if packing2 == false then
        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
        packing2 = true
        exports['progressBars']:startUI(35000, "Packing...")
        Citizen.Wait(35000)
        ClearPedTasksImmediately(PlayerPedId())
        ClearPedSecondaryTask(PlayerPedId())
        packing2 = false
        TriggerServerEvent("scf_drugs:reward2") 
    end
end)
function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end
keys = {
    -- Letter E
    ["E"] = 0xCEFD9220,
}
-- Packing 1
Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
        local betweencoords = GetDistanceBetweenCoords(coords, -1583.5292,-925.9916,84.7526, true) 
        
        if betweencoords < 2.0 then
			TriggerEvent("vorp:TipBottom", "Press [E] to pack cannabis", 2000) 
			if IsControlJustReleased(0,0xCEFD9220) then	
                TriggerServerEvent("scf_drugs:pack1")
			end
        end
	end
end)

-- Packing 2
Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
        local betweencoords = GetDistanceBetweenCoords(coords, 1410.3643,-1283.9388,81.5902, true) 
        
        if betweencoords < 2.0 then
			TriggerEvent("vorp:TipBottom", "Press [E] to pack cocain", 2000) 
			if IsControlJustReleased(0,0xCEFD9220) then	
                TriggerServerEvent("scf_drugs:pack2")
			end
        end
    end
end)


function SpawnNPC()
    for i,v in ipairs(Saleplaces) do 
       -- Loading Model
       local hashModel = GetHashKey("U_M_M_BHT_BANDITOMINE") 
       if IsModelValid(hashModel) then 
           RequestModel(hashModel)
           while not HasModelLoaded(hashModel) do                
               Citizen.Wait(100)
           end
       else 
           print(v.npcmodel .. " is not valid") -- Concatenations
       end   
        -- Spawn Ped
        local x, y, z = table.unpack(v.coords)
        local npc = CreatePed(hashModel, x, y, z, v.heading, false, true, true, true)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
        SetEntityNoCollisionEntity(PlayerPedId(), npc, false)
        SetEntityCanBeDamaged(npc, false)
        SetEntityInvincible(npc, true)
        Citizen.Wait(1000)
        FreezeEntityPosition(npc, true) -- NPC can't escape
        SetBlockingOfNonTemporaryEvents(npc, true) -- NPC can't be scared
    end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pcoords = GetEntityCoords(PlayerPedId())
        for k,v in ipairs(Saleplaces) do
            if Vdist(pcoords, v.coords) < 2.0 then
                TriggerEvent("vorp:TipBottom", "Press [G] to sale", 2000) 
                if IsControlJustReleased(0,0x760A9C6F) then	
                    TriggerServerEvent("scf_drugs:sale")
                end
            end
        end
    end
end)