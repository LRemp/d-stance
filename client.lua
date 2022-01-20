local vehicles = {}
local wheelsMeta = {}

local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local GetGamePool = GetGamePool
local GetVehicleWheelXOffset = GetVehicleWheelXOffset
local SetVehicleWheelXOffset = SetVehicleWheelXOffset
local GetVehicleWheelYRotation = GetVehicleWheelYRotation
local SetVehicleWheelYRotation = SetVehicleWheelYRotation
local GetVehicleNumberOfWheels = GetVehicleNumberOfWheels
local DoesEntityExist = DoesEntityExist
local Entity = Entity

local playerPed = PlayerPedId()

CreateThread(function()
    while true do
        for i = 1, #vehicles do
            -- it is a must to check if the id is a valid vehicle
            -- otherwise it could crash the game
            if DoesEntityExist(vehicles[i].id) then
                SetWheelsPreset(vehicles[i].id, vehicles[i].stance)
            end
        end
        Wait(20)
    end
end)

-- Scans for vehicles with moddified stance to be applied
CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehiclesPool = GetGamePool("CVehicle")
        local vehiclesList = {}
        -- Scanning whole pool of client vehicles
        for i = 1, #vehiclesPool do
            local stanceActive = Entity(vehiclesPool[i]).state["stance:active"]
            -- we don't need to apply stance modifiers to the stock settings
            if stanceActive then
                local distance = #(GetEntityCoords(vehiclesPool[i]) - coords)
                -- checking if vehicle is in distance 
                if distance < 100.0 then
                    vehiclesList[#vehiclesList + 1] = {
                        id = vehiclesPool[i],
                        stance = GetWheelsPresetFromStateBag(vehiclesPool[i])
                    }
                end
            end
        end
        vehicles = vehiclesList
        Wait(2000)
    end
end)

function PrintWheelsData(vehicle)
    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    for i = 0, wheelsNum - 1 do
        local WheelTrackWidth = GetVehicleWheelXOffset(vehicle, i)
        local WheelCamberAngle = GetVehicleWheelYRotation(vehicle, i)
        
        print(("[WHEEL %s] WheelTrackWidth %s"):format(i, WheelTrackWidth))
        print(("[WHEEL %s] WheelCamberAngle %s"):format(i, WheelCamberAngle))
    end
end

function PrintWheelsPreset(vehicle)
    print(("[DEBUG] frontWheelTrack %s"):format(GetFrontTrackWidth(vehicle)))
    print(("[DEBUG] rearWheelTrack %s"):format(GetRearTrackWidth(vehicle)))
    print(("[DEBUG] frontCamber %s"):format(GetFrontCamber(vehicle)))
    print(("[DEBUG] rearCamber %s"):format(GetRearCamber(vehicle)))
end

function GetFrontTrackWidth(vehicle)
    return GetVehicleWheelXOffset(vehicle, 1)
end

function SetFrontTrackWidth(vehicle, width)
    SetVehicleWheelXOffset(vehicle, 0, -width)
    SetVehicleWheelXOffset(vehicle, 1, width)
    Entity(vehicle).state:set("stance:active", true, true)
    Entity(vehicle).state:set("stance:frontWidth", width, true)
    -- if some external resource changes the value it will only appear in the next iteration of vehicles scan
    -- so we force update it to instantly show
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.frontWidth = width
            break
        end
    end
end

function GetRearTrackWidth(vehicle)
    return GetVehicleWheelXOffset(vehicle, 3)
end

function SetRearTrackWidth(vehicle, width)
    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    for i = 2, wheelsNum - 1 do
        local value = width
        if i % 2 == 0 then
            value = -width
        end
        SetVehicleWheelXOffset(vehicle, i, value)
    end
    Entity(vehicle).state:set("stance:active", true, true)
    Entity(vehicle).state:set("stance:rearWidth", width, true)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.rearWidth = width
            break
        end
    end
end

function GetFrontCamber(vehicle)
    return GetVehicleWheelYRotation(vehicle, 1)
end

function SetFrontCamber(vehicle, value)
    SetVehicleWheelYRotation(vehicle, 0, -value)
    SetVehicleWheelYRotation(vehicle, 1, value)
    Entity(vehicle).state:set("stance:active", true, true)
    Entity(vehicle).state:set("stance:frontCamber", value, true)  
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.frontCamber = value
            break
        end
    end
end

function GetRearCamber(vehicle)
    return GetVehicleWheelYRotation(vehicle, 3)
end

function SetRearCamber(vehicle, angle)
    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    for i = 2, wheelsNum - 1 do
        local value = angle
        if i % 2 == 0 then
            value = -angle
        end
        SetVehicleWheelYRotation(vehicle, i, value)
    end
    Entity(vehicle).state:set("stance:active", true, true)
    Entity(vehicle).state:set("stance:rearCamber", angle, true)  
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.rearCamber = angle
            break
        end
    end
end

function SaveWheelPreset(vehicle, preset)
    SetWheelsPreset(vehicle, preset)
    Entity(vehicle).state:set("stance:active", true, true)
    Entity(vehicle).state:set("stance:frontWidth", preset.frontWidth, true)
    Entity(vehicle).state:set("stance:rearWidth", preset.rearWidth, true)
    Entity(vehicle).state:set("stance:frontCamber", preset.frontCamber, true)
    Entity(vehicle).state:set("stance:rearCamber", preset.rearCamber, true)
end

function GetWheelsPreset(vehicle)
    return {
        frontWidth = GetFrontTrackWidth(vehicle),
        frontCamber = GetFrontCamber(vehicle),
        rearWidth = GetRearTrackWidth(vehicle),
        rearCamber = GetRearCamber(vehicle),
    }
end

function GetWheelsPresetFromStateBag(vehicle)
    local state = Entity(vehicle).state
    return {
        frontWidth = state["stance:frontWidth"],
        frontCamber = state["stance:frontCamber"],
        rearWidth = state["stance:rearWidth"],
        rearCamber = state["stance:rearCamber"],
    }
end

function SetWheelsPreset(vehicle, preset)
    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    if preset.frontWidth then
        SetVehicleWheelXOffset(vehicle, 0, -preset.frontWidth)
        SetVehicleWheelXOffset(vehicle, 1, preset.frontWidth)
    end
    if preset.rearWidth then
        for i = 2, wheelsNum - 1 do
            local value = preset.rearWidth
            if i % 2 == 0 then
                value = -preset.rearWidth
            end
            SetVehicleWheelXOffset(vehicle, i, value)
        end
    end

    if preset.frontCamber then
        SetVehicleWheelYRotation(vehicle, 0, -preset.frontCamber)
        SetVehicleWheelYRotation(vehicle, 1, preset.frontCamber)
    end
    if preset.rearCamber then
        for i = 2, wheelsNum - 1 do
            local value = preset.rearCamber
            if i % 2 == 0 then
                value = -preset.rearCamber
            end
            SetVehicleWheelYRotation(vehicle, i, value)
        end
    end
end

function GetDefaultWheelPreset(vehicle)
    local model = GetEntityModel(vehicle)
    
    if wheelsMeta[model] == nil then
        wheelsMeta[model] = GetBaseWheelsPreset(vehicle)
    end
    return wheelsMeta[model]
end

function ResetWheelsPreset(vehicle)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            table.remove(vehicles, i)
        end
    end
    local wheelType = GetVehicleWheelType(vehicle)
    local wheelsID = GetVehicleMod(vehicle, 23)
    SetVehicleWheelType(vehicle, 0)
    SetVehicleMod(vehicle, 23, -1, false)
    Wait(50)
    SetVehicleWheelType(vehicle, wheelType)
    SetVehicleMod(vehicle, 23, wheelsID, false)
end

function GetBaseWheelsPreset(vehicle)
    -- every vehicle has different wheel offsets, in order to get those we can trick it
    -- by resetting vehicle wheels mod and restoring original values after fetching required ones
    local coords = GetEntityCoords(vehicle)
    
    local wheelType = GetVehicleWheelType(vehicle)
    local wheelsID = GetVehicleMod(vehicle, 23)
    SetVehicleWheelType(vehicle, 0)
    SetVehicleMod(vehicle, 23, -1, false)
    Wait(50)
    local data = {
        frontTrackWidth = GetVehicleWheelXOffset(vehicle, 0),
        frontCamber = GetVehicleWheelYRotation(vehicle, 0),
        rearTrackWidth = GetVehicleWheelXOffset(vehicle, 2),
        rearCamber = GetVehicleWheelYRotation(vehicle, 2),
        --[[colliderSize = GetVehicleWheelRimColliderSize(vehicle, 0),
        wheelSize = GetVehicleWheelSize(vehicle),
        wheelWidth = GetVehicleWheelWidth(vehicle),
        wheelTireColliderSize = GetVehicleWheelTireColliderSize(vehicle, 0),
        wheelTireColliderWidth = GetVehicleWheelTireColliderWidth(vehicle, 0)]]
    }
    SetVehicleWheelType(vehicle, wheelType)
    SetVehicleMod(vehicle, 23, wheelsID, false)
    return data
end

if DEBUG then
    RegisterCommand('stance:data', function()
        local vehicle = GetVehiclePedIsIn(playerPed)
        PrintWheelsPreset(vehicle)
    end)
    
    RegisterCommand('stance:set', function(source, args)
        local vehicle = GetVehiclePedIsIn(playerPed)
        SaveWheelPreset(vehicle, {
            frontWidth = tonumber(args[1]),
            frontCamber = tonumber(args[2]),
            rearWidth = tonumber(args[3]),
            rearCamber = tonumber(args[4]),
        })
    end)

    RegisterCommand('stance:statebag', function(source, args)
        local vehicle = GetVehiclePedIsIn(playerPed)
        local stance = GetWheelsPresetFromStateBag(vehicle)
        print(("[DEBUG] frontWheelTrack %s"):format(stance.frontWidth))
        print(("[DEBUG] rearWheelTrack %s"):format(stance.rearWidth))
        print(("[DEBUG] frontCamber %s"):format(stance.frontCamber))
        print(("[DEBUG] rearCamber %s"):format(stance.rearCamber))
    end)
end

exports('GetFrontTrackWidth', GetFrontTrackWidth)
exports('SetFrontTrackWidth', SetFrontTrackWidth)
exports('GetFrontCamber', GetFrontCamber)
exports('SetFrontCamber', SetFrontCamber)
exports('GetRearTrackWidth', GetRearTrackWidth)
exports('SetRearTrackWidth', SetRearTrackWidth)
exports('GetRearCamber', GetRearCamber)
exports('SetRearCamber', SetRearCamber)
exports('GetWheelsPresetFromStateBag', GetWheelsPresetFromStateBag)
exports('GetWheelsPreset', GetWheelsPreset)
exports('SetWheelsPreset', SetWheelsPreset)
exports('SaveWheelPreset', SaveWheelPreset)
exports('ResetWheelsPreset', ResetWheelsPreset)
exports('PrintWheelsData', PrintWheelsData)
