CreateThread(function()
    if Config.EnableMenu then
        RegisterNetEvent('d-stance:loadVehiclePreset', function(netId)
            local source = source
            local vehicle = NetworkGetEntityFromNetworkId(netId)
            if vehicle == 0 then
                return -- TODO: cancel operation(vehicle not existing in onesync entity pool)
            end
            local numberplate = GetVehicleNumberPlateText(vehicle)
            local preset = FetchPreset(numberplate)
            TriggerClientEvent('d-stance:loadVehicePreset', source, netId, preset)
        end)
    end
end)