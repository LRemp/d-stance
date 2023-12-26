function LoadStanceConfiguration()
    local features = GetStanceFeatures()
    Wait(250)
    SendNUIMessage({
        type = "load-configuration",
        features = features
    })
end

function GetStanceFeatures()
    local features = {}
    for k,v in pairs(Config.Features) do
        table.insert(features, {
            id = k,
            name = Locale.Get(k)
        })
    end
    return features
end

function GetMenuValues(Vehicle)
    local preset = GetWheelsPreset(Vehicle)
    local defaultPreset = GetDefaultWheelPreset(Vehicle)
    local values = {}
    values.frontCamber = (preset.frontCamber - defaultPreset.frontCamber) / Config.Limits.frontCamber
    values.rearCamber = (preset.rearCamber - defaultPreset.rearCamber) / Config.Limits.rearCamber
    values.frontWidth = (preset.frontWidth - defaultPreset.frontWidth) / Config.Limits.frontWidth
    values.rearWidth = (preset.rearWidth - defaultPreset.rearWidth) / Config.Limits.rearWidth
    return values
end

function LoadVehiclePreset(vehicle)
    TriggerServerEvent('d-stance:loadVehiclePreset', vehicle)
end

export(LoadVehiclePreset, "LoadVehiclePreset")