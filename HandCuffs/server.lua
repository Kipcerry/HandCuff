if not lib then return end
ESX = exports["es_extended"]:getSharedObject()
local Cuffed = {}
local Charset = {}


for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

lib.callback.register('HandCuffs:HasItem', function(source, item, meta)
    local xPlayer = ESX.GetPlayerFromId(source)
    if meta then
        local xTarget = ESX.GetPlayerFromId(item)
        local sleutels = exports.ox_inventory:Search(xPlayer.source, 1, 'handboeisleutels', Cuffed[tostring(xTarget.source)])
        local sleutelId = nil
        for k, v in pairs(sleutels) do
            sleutelId = v.metadata.type
        end  
        if sleutelId == Cuffed[tostring(xTarget.source)] then
            return true
        else
            return false
        end
    else
        if xPlayer.getInventoryItem(item).count > 0 then
            return true
        else
            return false
        end
    end

end)

lib.callback.register('HandCuffs:IsCuffed', function(source, spelerId, Self)
    if Self then
        if Cuffed[tostring(source)] then
            return Cuffed[tostring(source)]
        else
            return false
        end
    else   
        if Cuffed[tostring(spelerId)] then
            return Cuffed[tostring(spelerId)]
        else
            return false
        end
    end
end)

function GetRandomLetter(length)
	Wait(0)
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end


RegisterServerEvent('HandCuffs:CuffPlayer')
AddEventHandler('HandCuffs:CuffPlayer', function(target, HandCuffs)
    if target ~= -1 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(target)
        if not Cuffed[tostring(xTarget.source)] then
            if HandCuffs then
                if xPlayer.getInventoryItem(Config.HandCuffItem).count > 0 then
 
                    local success = exports.ox_inventory:CanCarryItem(xPlayer.source, Config.HandCuffKeyItem, 1)
                    if success then
                        xPlayer.removeInventoryItem(Config.HandCuffItem, 1)
                        TriggerClientEvent('HandCuffs:CuffPlayer', xPlayer.source, true, xTarget.source)
                        TriggerClientEvent('HandCuffs:GetCuffed', xTarget.source, xPlayer.source, true, HandCuffs)
                        local handboeiId = string.upper(GetRandomLetter(15))
                        local handBoeiMetaData = 'Sleutel id: '..tostring(handboeiId)
                        Cuffed[tostring(xTarget.source)] = handBoeiMetaData
                        exports.ox_inventory:AddItem(xPlayer.source, Config.HandCuffKeyItem, 1, handBoeiMetaData)
                    end
                else
                    xPlayer.showNotification('Je hebt wel handboeien nodig.', 'Politie')
                end
            else
                if xPlayer.getInventoryItem(Config.TiewrapItem).count > 0 then
                    xPlayer.removeInventoryItem(Config.TiewrapItem, 1)
                    TriggerClientEvent('HandCuffs:CuffPlayer', xPlayer.source, true, xTarget.source)
                    TriggerClientEvent('HandCuffs:GetCuffed', xTarget.source, xPlayer.source, true)
                    Cuffed[tostring(xTarget.source)] = 'Tiewraps'
                else
                    
                    xPlayer.showNotification('Je hebt wel tiewraps nodig.', 'Afboeien')
                end
            end
        end
    end
end)


RegisterServerEvent('HandCuffs:UnCuffPlayer')
AddEventHandler('HandCuffs:UnCuffPlayer', function(target)
    if target ~= -1 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(target)
        if Cuffed[tostring(xTarget.source)] then
            if Cuffed[tostring(xTarget.source)] == 'Tiewraps' then
                if xPlayer.getInventoryItem(Config.ScissorItem).count > 0 then
                    TriggerClientEvent('HandCuffs:CuffPlayer', xPlayer.source, false, xTarget.source)
                    TriggerClientEvent('HandCuffs:GetCuffed', xTarget.source, xPlayer.source, false)
                    Cuffed[tostring(xTarget.source)] = nil
                end
            else
                local sleutels = exports.ox_inventory:Search(xPlayer.source, 1, Config.HandCuffKeyItem, Cuffed[tostring(xTarget.source)])
                local sleutelId = nil
                for k, v in pairs(sleutels) do
                    sleutelId = v.metadata.type
                end  
                if sleutelId == Cuffed[tostring(xTarget.source)] then
                    local success = exports.ox_inventory:RemoveItem(xPlayer.source, Config.HandCuffKeyItem, 1, Cuffed[tostring(xTarget.source)])
                    if success then
                        xPlayer.addInventoryItem(Config.HandCuffItem, 1)
                        TriggerClientEvent('HandCuffs:CuffPlayer', xPlayer.source, false, xTarget.source)
                        TriggerClientEvent('HandCuffs:GetCuffed', xTarget.source, xPlayer.source, false)
                        Cuffed[tostring(xTarget.source)] = nil
                    end
                elseif xPlayer.getInventoryItem(Config.LockpickItem).count > 0 then
                    xPlayer.removeInventoryItem(Config.LockpickItem, 1)
                    TriggerClientEvent('HandCuffs:CuffPlayer', xPlayer.source, false, xTarget.source)
                    TriggerClientEvent('HandCuffs:GetCuffed', xTarget.source, xPlayer.source, false)
                    Cuffed[tostring(xTarget.source)] = nil
                else
                    xPlayer.showNotification(Config.RightKeys)
                end
            end
        end 
    end
end)

RegisterServerEvent('HandCuffs:LeaveVehicle')
AddEventHandler('HandCuffs:LeaveVehicle', function(Target)
    if Target ~= -1 then
        TriggerClientEvent('HandCuffs:LeaveVehicle', Target)
    end
end)

RegisterServerEvent('HandCuffs:DraggPlayer')
AddEventHandler('HandCuffs:DraggPlayer', function(target, cleartask)
    if target ~= -1 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(target)

        if Cuffed[tostring(xTarget.source)] ~= nil then
            TriggerClientEvent('HandCuffs:DraggPlayer', xPlayer.source, xTarget.source, false)
            TriggerClientEvent('HandCuffs:Dragged', xTarget.source, xPlayer.source, cleartask, false)            
        end
    end
end)



RegisterServerEvent('HandCuffs:StopDragg')
AddEventHandler('HandCuffs:StopDragg', function(target, cleartask, Vehicle)
    if target ~= -1 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(target)

        TriggerClientEvent('HandCuffs:DraggPlayer', xPlayer.source, xTarget.source, true)
        TriggerClientEvent('HandCuffs:Dragged', xTarget.source, xPlayer.source, cleartask, true, Vehicle)            
    end
end)
