CreateThread(function()
    if Config.EnableMenu then
        RegisterCommand('stance', function(source, args)
            Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local preset = GetMenuValues(Vehicle)
            SendNUIMessage({
                type = "update-values",
                preset = preset
            })
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "toggle-ui"
            })
        end, false)
    end
end)