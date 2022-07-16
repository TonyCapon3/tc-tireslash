local QBCore = exports['qb-core']:GetCoreObject()

local bones = {
    'wheel_lf', 
    'wheel_rf', 
    'wheel_lm1', 
    'wheel_rm1', 
    'wheel_lm2', 
    'wheel_rm2', 
    'wheel_lm3', 
    'wheel_rm3', 
    'wheel_lr', 
    'wheel_rr'}

CreateThread(function()
    exports['qb-target']:AddTargetBone(bones, {
        options = {
            {
                event = 'tc-tireslash:slash',
                icon = 'fas fa-info',
                label = 'Slash Tire',
                num = 1
            },
        },
        distance = 1
    })
end)

RegisterNetEvent('tc-tireslash:slash', function()
    local vehicle = GetClosestVehicleToPlayer()
    if vehicle ~= 0 then
        if CanUseWeapon(Config.allowedWeapons) then
            local closestTire = GetClosestVehicleTire(vehicle)
            if closestTire ~= nil then
                if IsVehicleTyreBurst(vehicle, closestTire.tireIndex, 0) == false then
                    local animDict = 'melee@knife@streamed_core_fps'
                    local animName = 'ground_attack_on_spot'
                    loadDict('melee@knife@streamed_core_fps')
                    local animDuration = GetAnimDuration(animDict, animName)
                    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, animDuration, 15, 1.0, 0, 0, 0)
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "Stash", 0.5)
                    Wait((animDuration / 2) * 1000)
                    local driverId = GetDriverOfVehicle(vehicle)
                    local driverServId = GetPlayerServerId(driverId)
                    QBCore.Functions.Notify('Tire Slashed', 'success', 7500)
                    if driverServId == 0 then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        SetVehicleTyreBurst(vehicle, closestTire.tireIndex, 0, 100.0)
                        SetEntityAsNoLongerNeeded(vehicle)
                    else
                        TriggerServerEvent('tc-tireslash:sync', driverServId, closestTire.tireIndex)
                    end
                    Wait((animDuration / 2) * 1000)
                    ClearPedTasks(PlayerPedId())
                    RemoveAnimDict(animDict)
                else
                    QBCore.Functions.Notify('Tire Already Slashed', 'error', 7500)
                end
            end
        else
            QBCore.Functions.Notify('Need A Sharp Object', 'error', 7500)
        end
    end
end)

RegisterNetEvent('tc-tireslash:sync')
AddEventHandler('tc-tireslash:sync', function(tireIndex)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleTyreBurst(vehicle, tireIndex, 0, 100.0)
end)


