RegisterCommand('stance', function(source, args)
    if not Config.EnableMenu then return end
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