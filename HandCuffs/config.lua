Config = {}

Config.HandCuffItem = 'handcuff'
Config.HandCuffKeyItem = 'handcuffkeys'
Config.LockpickItem = 'lockpick'
Config.TiewrapItem = 'tiewrap'
Config.ScissorItem = 'scissor'
Config.EnableLockpickHandCuffs = true -- If true you can lockpick open a handcuffed player who has been hand cuffed by handcuffs
Config.OnlyPoliceHandcuff = false --If true handcuffs are only usable by police
Config.OnlyPoliceHandcuffKeys = false --If true handcuffs keys are only usable by police
Config.PoliceJob = 'police'
Config.InstaDraggAfterCuff = false --If true you start dragging the player after you have cuffed him
Config.InOutVehicle = true --If true you can put a player in a vehicle while dragging him and you can take cuffed players out the vehicle

--Locals
Config.UncuffPlayer = 'Uncuff'
Config.CuffPlayer = 'Cuff'
Config.DraggPlayer = 'Dragg'
Config.StopDragging = 'Stop dragging'
Config.PutInVehicle = 'Put player in vehicle'
Config.TakePlayerOutVehicle = 'Take player out the vehicle'
Config.RightKeys = 'You need the correct keys or a lockpick to uncuff this player'


--Add to ox_inventory/data/items.lua

--[[
	['handcuff'] = {
		label = 'Handcuff',
		weight = 300,
	},
	
	['handcuffkeys'] = {
		label = 'Handcuff key',
		weight = 250,
		stack = false,
	},

	['tiewrap'] = {
		label = 'Tiewrap',
		weight = 200,
	},

	['scissor'] = {
		label = 'Scissor',
		weight = 450,
	},
]]