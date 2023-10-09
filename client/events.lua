RegisterNuiCallback('set-value', function(data, cb)
    local defaultValues = GetDefaultWheelPreset(Vehicle)
    print(json.encode(defaultValues))
    if data.id == "frontCamber" then
        SetFrontCamber(Vehicle, defaultValues.frontCamber + Config.Limits.frontCamber * data.value)
    elseif data.id == "rearCamber" then
        SetRearCamber(Vehicle, defaultValues.rearCamber + Config.Limits.rearCamber * data.value)
    elseif data.id == "frontWidth" then
        SetFrontTrackWidth(Vehicle, defaultValues.frontWidth + Config.Limits.frontWidth * data.value)
    elseif data.id == "rearWidth" then
        SetRearTrackWidth(Vehicle, defaultValues.rearWidth + Config.Limits.rearWidth * data.value)
    elseif data.id == "suspensionHeight" then
        local value = math.abs(Config.Limits.suspensionHeight.min) + math.abs(Config.Limits.suspensionHeight.max)
        SetSuspensionHeight(Vehicle, Config.Limits.suspensionHeight.min + value * data.value)
    elseif data.id == "wheelSize" then
        SetWheelsSize(Vehicle, defaultValues.wheelSize + Config.Limits.wheelSize * data.value)
    end
    cb('ok')
end)

RegisterNuiCallback("close-ui", function(data, cb)
    SetNuiFocus(false, false)
    Vehicle = nil
    cb('ok')
end)

RegisterNuiCallback("reset", function(data, cb)
    ResetWheelsPreset(Vehicle)
    local defaultPreset = GetMenuValues(Vehicle)
    SendNUIMessage({
        type = "update-values",
        values = defaultPreset
    })
    cb('ok')
end)