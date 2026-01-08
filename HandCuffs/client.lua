if not lib then return end
ESX = exports["es_extended"]:getSharedObject()
local IsCuffed = false
local CuffObject = nil
local DragAnimDict = "switch@trevor@escorted_out"
local DragAnim = "001215_02_trvs_12_escorted_out_idle_guard2"
local Running = false
local Dragging = false
local WalkAnimDict = "anim@move_m@grooving@"
local DraggingId = nil
local WalkAnim = "walk"
local Dragged = false
local Detached = true
local Dragger = nil


exports.ox_target:addGlobalPlayer({
	{
		name = 'cuff',
		distance = 1.5,
		label = Config.CuffPlayer,
		icon = 'fa-solid fa-handcuffs',
		canInteract = function(entity)
			SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(entity)))
			local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
			if not IsCuffed then
				local HasHandCuffs = lib.callback.await('HandCuffs:HasItem', false, Config.HandCuffItem)
				local HasTiewrap = lib.callback.await('HandCuffs:HasItem', false, Config.TiewrapItem)
				if HasHandCuffs then
					if Config.OnlyPoliceHandcuff then
						if ESX.GetPlayerData().job.name == Config.PoliceJob then
							return true
						end
					else
						return true
					end
				end
				if HasTiewrap then
					return true
				end
			end
			return false
		end,
		onSelect = function(data)
			local HandCuff = false
			local HasHandCuffs = lib.callback.await('HandCuffs:HasItem', false, Config.HandCuffItem)
			local HasTiewrap = lib.callback.await('HandCuffs:HasItem', false, Config.TiewrapItem)
			if HasHandCuffs then
				if Config.OnlyPoliceHandcuff then
					if ESX.GetPlayerData().job.name == Config.PoliceJob then
						HandCuff = true
					end
				else
					HandCuff = true
				end
			end
            SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(data.coords))
            TriggerServerEvent('HandCuffs:CuffPlayer', SelectedPlayer, HandCuff)
		end
	},
    {
        name = 'uncuff',
        distance = 1.5,
        label = Config.UncuffPlayer,
        icon = 'fa-solid fa-key',
        canInteract = function(entity) 
			SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(entity)))
			local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
			local HasItem = false
			local HasItem2 = false
			if IsCuffed == 'Tiewraps' then
				HasItem = lib.callback.await('HandCuffs:HasItem', false, Config.ScissorItem)
			elseif IsCuffed then
				if Config.EnableLockpickHandCuffs then
					HasItem = lib.callback.await('HandCuffs:HasItem', false, Config.LockpickItem)
				end
				if Config.OnlyPoliceHandcuffKeys then
					if ESX.GetPlayerData().job.name == Config.PoliceJob then

					end
				else
					HasItem2 = lib.callback.await('HandCuffs:HasItem', false, Config.HandCuffKeyItem)
				end
			end

			if (HasItem or HasItem2) and IsStandingBehindPed(SelectedPlayer) then
				return true
			else
				return false
			end 
        end,
        onSelect = function(data) 
            SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(data.coords))
            TriggerServerEvent('HandCuffs:UnCuffPlayer', SelectedPlayer)
        end,
    },
	{
		name = 'dragg_player',
		distance = 1.5,
		label = Config.DraggPlayer,
		icon = 'fa-solid fa-hand',
		canInteract = function(entity)
			SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(entity)))
			local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
			return IsCuffed
		end,
		onSelect = function(data)
            SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(data.coords))
            TriggerServerEvent('HandCuffs:DraggPlayer', SelectedPlayer)
		end
	}
})

exports.ox_target:addGlobalVehicle({
	{
		name = 'take_player_out',
		distance = 2.5,
		label = Config.TakePlayerOutVehicle,
		icon = 'fa-solid fa-hand',
		canInteract = function(entity)
			local PlayerSeat0 = GetPedInVehicleSeat(entity, 0)
			local PlayerSeat1 = GetPedInVehicleSeat(entity, 1)
			local PlayerSeat2 = GetPedInVehicleSeat(entity, 2)
			if PlayerSeat0 then
				local SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerSeat0)))
				local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
				if IsCuffed then
					return true
				end
			end
			if PlayerSeat1 then
				local SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerSeat1)))
				local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
				if IsCuffed then
					return true
				end
			end
			if PlayerSeat2 then
				local SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerSeat2)))
				local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
				if IsCuffed then
					return true
				end
			end
			return false
		end,
		onSelect = function()
			local PlayerSeat0 = GetPedInVehicleSeat(entity, 0)
			local PlayerSeat1 = GetPedInVehicleSeat(entity, 1)
			local PlayerSeat2 = GetPedInVehicleSeat(entity, 2)
			if PlayerSeat0 then
				local SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerSeat0)))
				local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
				if IsCuffed then
					TaskLeaveAnyVehicle(PlayerSeat0, 0)
				end
			end
			if PlayerSeat1 then
				local SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerSeat1)))
				local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
				if IsCuffed then
					TriggerServerEvent('HandCuffs:LeaveVehicle', SelectedPlayer)
				end
			end
			if PlayerSeat2 then
				local SelectedPlayer = GetPlayerServerId(ESX.Game.GetClosestPlayer(GetEntityCoords(PlayerSeat2)))
				local IsCuffed = lib.callback.await('HandCuffs:IsCuffed', false, SelectedPlayer)
				if IsCuffed then
					TaskLeaveAnyVehicle(PlayerSeat2, 0)
				end
			end
		end
	}
})

function IsStandingBehindPlayer(ped)
	if IsPedRagdoll(ped) then
		return true
	end
	local offset = GetOffsetFromEntityGivenWorldCoords(ped, GetEntityCoords(PlayerPedId()))
	if offset.y < 0 then
		return true
	end

	return false
end

function IsStandingBehindPed(player)
	return IsStandingBehindPlayer(GetPlayerPed(GetPlayerFromServerId(player)))
end




Citizen.CreateThread(function()
	while true do
		Sleep = 700
		local playerPed = PlayerPedId()
		if IsCuffed then
            sleep = 1
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)

			SetEntityMaxSpeed(playerPed, 4.0)

			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 21, true) -- Left shift
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(0, 73, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 or IsPedFalling(playerPed) or IsPedRagdoll(playerPed) then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			SetEntityMaxSpeed(playerPed, 10.0)
			while Dragged == true do
				Wait(0)
				Detached = false
		
				local ped = GetPlayerPed(GetPlayerFromServerId(Dragger))
				local myped = GetPlayerPed(-1)
		
				if not IsPedSittingInAnyVehicle(ped) then
					  AttachEntityToEntity(myped, ped, 11816, 0.0, 0.64, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					  Dragged = false
				end
			
				if IsPedDeadOrDying(ped, true) then
					  Dragged = false
				end
			
				local isPlayingAnim = IsEntityPlayingAnim(myped, WalkAnimDict, WalkAnim, 3)
				local isCopWalking = IsPedWalking(ped)
			
				if not HasAnimDictLoaded(WalkAnimDict) then
					LoadDict(WalkAnimDict)
				end
			
				if isCopWalking ~= false and isPlayingAnim == false then
					  TaskPlayAnim(myped, WalkAnimDict, WalkAnim, 2.0, 2.0, -1, 1, 0, false, false, false)
				elseif isCopWalking == false and isPlayingAnim ~= false then
					  StopAnimTask(myped, WalkAnimDict, WalkAnim, -4.0)
				end
			end
			Citizen.Wait(500)
		end
        Wait(sleep)
	end
end)


RegisterNetEvent('HandCuffs:GetCuffed')
AddEventHandler('HandCuffs:GetCuffed', function(target, Cuff, Handcuffs)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

    if Cuff then

        RequestAnimDict('mp_arrest_paired')

        while not HasAnimDictLoaded('mp_arrest_paired') do
            Citizen.Wait(10)
        end

        AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_left', 8.0, -8.0, 5500, 33, 0, false, false, false)

        Citizen.Wait(950)
        DetachEntity(GetPlayerPed(-1), true, false)

        Citizen.Wait(3000)

        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
            RequestAnimDict('mp_arresting')
        end

        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        IsCuffed = true
		
		if Handcuffs then
			HandcuffProp = 'p_cs_cuffs_02_s'
			RequestSpawnObject(HandcuffProp)
			CuffObject = CreateObject(GetHashKey(HandcuffProp), 0.0, true, true, true)
			AttachEntityToEntity(CuffObject, playerPed, GetPedBoneIndex(playerPed, 57005), 0.04, 0.065, 0.0, 110.0, 180.0, 80.0, true, true, false, false, false, true)
		else
			HandcuffProp = 'hei_prop_zip_tie_positioned'
			RequestSpawnObject(HandcuffProp)
			CuffObject = CreateObject(GetHashKey(HandcuffProp), 0.0, true, true, true)
			AttachEntityToEntity(CuffObject, playerPed, GetPedBoneIndex(playerPed, 60309), -0.020, 0.035, 0.06, 0.04, 155.0, 80.0, true, false, false, false, 0, true)
		end
    else
        IsCuffed = false
        RequestAnimDict('mp_arresting')

        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(10)
        end
    
        AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8.0, 5500, 33, 0, false, false, false)
    
        Citizen.Wait(5500)
        Dragged = false
        DetachEntity(GetPlayerPed(-1), true, false)
    
        ClearPedTasks(GetPlayerPed(-1))
        DeleteEntity(CuffObject)
    end
end)


RegisterNetEvent('HandCuffs:CuffPlayer')
AddEventHandler('HandCuffs:CuffPlayer', function(Cuff, target)
	local playerPed = GetPlayerPed(-1)

    if Cuff then
        RequestAnimDict('mp_arrest_paired')

        while not HasAnimDictLoaded('mp_arrest_paired') do
            Citizen.Wait(10)
        end

        TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_left', 8.0, -8.0, 5500, 33, 0, false, false, false)

        Citizen.Wait(3000)

        ClearPedSecondaryTask(playerPed)
		Wait(1000)
		if Config.InstaDraggAfterCuff then
			TriggerServerEvent('HandCuffs:DraggPlayer', target)
		end
    else
        RequestAnimDict('mp_arresting')

        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(10)
        end
        TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8.0, 5500, 33, 0, false, false, false)
    
        Citizen.Wait(5500)
        Dragging = false
        ClearPedTasks(GetPlayerPed(-1))
    end
end)


function LoadDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end
end



RegisterNetEvent('HandCuffs:DraggPlayer')
AddEventHandler('HandCuffs:DraggPlayer', function(target, StopDragg)

    if StopDragg then
        if not Dragging then
            return
        end
    end

	Dragging = not Dragging

	if Running then
        return
    end

	Running = true

	local VehicleTextUi = false
	Citizen.CreateThread(function()
		if Dragging then
			lib.showTextUI('[X] - '..Config.StopDragging)
		end
        while Dragging == true do
            Citizen.Wait(0)
            DisableControlAction(2, 21, true)
            local playerPed = PlayerPedId()
            local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
            if IsEntityAttachedToEntity(targetPed, playerPed) == false then
                Citizen.Wait(1000)
                if IsEntityAttachedToEntity(targetPed, playerPed) == false then
                  Dragging = false
                end
            end
            local isWalking = IsPedWalking(playerPed)
            local isPlayingAnim = IsEntityPlayingAnim(playerPed, DragAnimDict, DragAnim, 3)
            if isWalking and not isPlayingAnim then
                LoadDict(DragAnimDict)
                TaskPlayAnim(playerPed, DragAnimDict, DragAnim, 2.0, 2.0, -1, 51, 0, false, false, false)
            elseif not isWalking and isPlayingAnim then
                StopAnimTask(playerPed, DragAnimDict, DragAnim, -4.0)
            end
			if IsControlJustReleased(0, 73) then
				TriggerServerEvent('HandCuffs:StopDragg', target, true)
				ClearPedTasks(playerPed)
				lib.hideTextUI()
				break
			end
			if Config.InOutVehicle then
				local Vehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(targetPed)) 
				if Vehicle then
					local VehicleCoords = GetEntityCoords(Vehicle)
					if #(VehicleCoords - GetEntityCoords(targetPed)) <= 2.5 and (IsVehicleSeatFree(Vehicle, 1) or IsVehicleSeatFree(Vehicle, 2) or IsVehicleSeatFree(Vehicle, 0)) then
						if not VehicleTextUi then
							VehicleTextUi = true
							lib.showTextUI('[X] - '..Config.StopDragging..' || [E] - '..Config.PutInVehicle)
						end
						if IsControlJustReleased(0, 51) then
							TriggerServerEvent('HandCuffs:StopDragg', target, true, GetEntityCoords(Vehicle))
							ClearPedTasks(playerPed)
							lib.hideTextUI()
							break
						end
					else
						if VehicleTextUi then
							VehicleTextUi = false
							lib.showTextUI('[X] - '..Config.StopDragging)
						end
					end
				end
			end
        end
        Running = false
    end)
end)



RegisterNetEvent('HandCuffs:Dragged')
AddEventHandler('HandCuffs:Dragged', function(Dragger, cleartask, StopDragg, VehicleCoords)
    if StopDragg then
        if not Dragged then
            return
        end
    end
	Dragged = not Dragged

    if not Dragged and cleartask then
        Wait(50)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end

	while Dragged == true do   
		Wait(0)

		Detached = false

		local ped = GetPlayerPed(GetPlayerFromServerId(Dragger))
		local myped = GetPlayerPed(-1)

		if not IsPedSittingInAnyVehicle(ped) then
		  	AttachEntityToEntity(myped, ped, 11816, 0.0, 0.64, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
		  	Dragged = false
		end
	
		if IsPedDeadOrDying(ped, true) then
		  	Dragged = false
		end
	
		local isPlayingAnim = IsEntityPlayingAnim(myped, WalkAnimDict, WalkAnim, 3)
		local isCopWalking = IsPedWalking(ped)
	
		if not HasAnimDictLoaded(WalkAnimDict) then
			LoadDict(WalkAnimDict)
		end
	
		if isCopWalking ~= false and isPlayingAnim == false then
		  	TaskPlayAnim(myped, WalkAnimDict, WalkAnim, 2.0, 2.0, -1, 1, 0, false, false, false)
		elseif isCopWalking == false and isPlayingAnim ~= false then
		  	StopAnimTask(myped, WalkAnimDict, WalkAnim, -4.0)
		end
	end
	if Detached == false then
		Detached = true
		DetachEntity(GetPlayerPed(-1), true, false)
	end
	
	if not Dragged and VehicleCoords then
		local Vehicle = ESX.Game.GetClosestVehicle(VehicleCoords)
		local Seat = GetClosestFreeSeat(PlayerPedId(), Vehicle)
		if Seat then
		TaskEnterVehicle(PlayerPedId(), Vehicle, 5000, Seat, 1.0, 1, 0)
		end
	end
end)


local seatPriority = { 1, 2, 0 }

function GetClosestFreeSeat(vehicle)
    for _, seat in ipairs(seatPriority) do
        if GetPedInVehicleSeat(vehicle, seat) == 0 then
            return seat
        end
    end
    return nil
end



RegisterNetEvent('HandCuffs:LeaveVehicle')
AddEventHandler('HandCuffs:LeaveVehicle', function()
	TaskLeaveAnyVehicle(PlayerPedId())
end)



AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    IsCuffed = false
	Dragged = false
    if CuffObject then
        DeleteEntity(CuffObject)
    end
  end)
  

AddEventHandler('esx:onPlayerDeath', function(data)
    IsCuffed = false
	Dragged = false
    if CuffObject then
        DeleteEntity(CuffObject)
    end
end)

function RequestSpawnObject(object)
    local hash = GetHashKey(object)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
        Wait(1)
    end
end