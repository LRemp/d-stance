local vehicles = {}
local wheelsMeta = {}

Vehicle = nil

Locale.Load()
LoadStanceConfiguration()

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
        Wait(3)
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
                if distance < Config.RenderDistance then
                    vehiclesList[#vehiclesList + 1] = {
                        id = vehiclesPool[i],
                        stance = GetWheelsPresetFromStateBag(vehiclesPool[i])
                    }
                end
            end
        end
        vehicles = vehiclesList
        Wait(Config.UpdateRate)
    end
end)

---@param vehicle number
function PrintWheelsData(vehicle)
    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    for i = 0, wheelsNum - 1 do
        local WheelTrackWidth = GetVehicleWheelXOffset(vehicle, i)
        local WheelCamberAngle = GetVehicleWheelYRotation(vehicle, i)
        
        print(("[WHEEL %s] WheelTrackWidth %s"):format(i, WheelTrackWidth))
        print(("[WHEEL %s] WheelCamberAngle %s"):format(i, WheelCamberAngle))
    end
end

---@param vehicle number
function PrintWheelsPreset(vehicle)
    print(("[DEBUG] frontWheelTrack %s"):format(GetFrontTrackWidth(vehicle)))
    print(("[DEBUG] rearWheelTrack %s"):format(GetRearTrackWidth(vehicle)))
    print(("[DEBUG] frontCamber %s"):format(GetFrontCamber(vehicle)))
    print(("[DEBUG] rearCamber %s"):format(GetRearCamber(vehicle)))
    print(("[DEBUG] suspensionHeight %s"):format(GetVehicleSuspensionHeight(vehicle)))
end

---@param vehicle number
---@return offset number
function GetFrontTrackWidth(vehicle)
    return GetVehicleWheelXOffset(vehicle, 1)
end

---@param vehicle number
---@param width number
function SetFrontTrackWidth(vehicle, width)
    EnsureStanceStateBag(vehicle)

    SetVehicleWheelXOffset(vehicle, 0, -width)
    SetVehicleWheelXOffset(vehicle, 1, width)

    SetStateBag(vehicle, "stance:frontWidth", width)
    -- if some external resource changes the value it will only appear in the next iteration of vehicles scan
    -- so we force update it to instantly show
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.frontWidth = width
            break
        end
    end
end

---@param vehicle number
---@return offset number
function GetRearTrackWidth(vehicle)
    return GetVehicleWheelXOffset(vehicle, 3)
end

---@param vehicle number
---@param width number
function SetRearTrackWidth(vehicle, width)
    EnsureStanceStateBag(vehicle)

    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    for i = 2, wheelsNum - 1 do
        local value = width
        if i % 2 == 0 then
            value = -width
        end
        SetVehicleWheelXOffset(vehicle, i, value)
    end

    SetStateBag(vehicle, "stance:rearWidth", width)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.rearWidth = width
            break
        end
    end
end

---@param vehicle number
---@return rotation number
function GetFrontCamber(vehicle)
    return GetVehicleWheelYRotation(vehicle, 1)
end

---@param vehicle number
---@param angle number
function SetFrontCamber(vehicle, value)
    EnsureStanceStateBag(vehicle)

    SetVehicleWheelYRotation(vehicle, 0, -value)
    SetVehicleWheelYRotation(vehicle, 1, value)

    SetStateBag(vehicle, "stance:frontCamber", value)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.frontCamber = value
            break
        end
    end
end

---@param vehicle number
---@return height number
function GetSuspensionHeight(vehicle)
    return GetVehicleSuspensionHeight(vehicle)
end

---@param vehicle number
---@param height number
function SetSuspensionHeight(vehicle, value)
    EnsureStanceStateBag(vehicle)

    SetStateBag(vehicle, "stance:suspensionHeight", value)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.suspensionHeight = value
            break
        end
    end
end

---@param vehicle number
---@return rotation number
function GetRearCamber(vehicle)
    return GetVehicleWheelYRotation(vehicle, 3)
end

---@param vehicle number
---@param angle number
function SetRearCamber(vehicle, angle)
    EnsureStanceStateBag(vehicle)

    local wheelsNum = GetVehicleNumberOfWheels(vehicle)
    for i = 2, wheelsNum - 1 do
        local value = angle
        if i % 2 == 0 then
            value = -angle
        end
        SetVehicleWheelYRotation(vehicle, i, value)
    end

    SetStateBag(vehicle, "stance:rearCamber", angle)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.rearCamber = angle
            break
        end
    end
end

function SetWheelsSize(vehicle, size)
    EnsureStanceStateBag(vehicle)

    SetStateBag(vehicle, "stance:wheelSize", size)
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            vehicles[i].stance.wheelSize = size
            break
        end
    end
    
    SetVehicleWheelSize(vehicle, size)
    for i = 0, 4 do
        SetVehicleWheelTireColliderSize(vehicle, i, size)
        SetVehicleWheelRimColliderSize(vehicle, i, size)
    end
end

---@param vehicle number
---@param preset table
function SaveWheelPreset(vehicle, preset)
    SetWheelsPreset(vehicle, preset)
    SetStateBag(vehicle, "stance:active", true)
    SetStateBag(vehicle, "stance:frontWidth", preset.frontWidth)
    SetStateBag(vehicle, "stance:rearWidth", preset.rearWidth)
    SetStateBag(vehicle, "stance:frontCamber", preset.frontCamber)
    SetStateBag(vehicle, "stance:rearCamber", preset.rearCamber)
    SetStateBag(vehicle, "stance:suspensionHeight", preset.suspensionHeight)
    SetStateBag(vehicle, "stance:wheelSize", preset.wheelSize)
    SetVehicleSuspensionHeight(vehicle, preset.suspensionHeight)
end

---@param vehicle number
function SaveDefaultWheelPreset(vehicle)
    if DEBUG then PrintWheelsPreset(vehicle) end
    SetStateBag(vehicle, "stance:active", true)
    SetStateBag(vehicle, "stance:frontWidth_def", GetFrontTrackWidth(vehicle))
    SetStateBag(vehicle, "stance:rearWidth_def", GetRearTrackWidth(vehicle))
    SetStateBag(vehicle, "stance:frontCamber_def", GetFrontCamber(vehicle))
    SetStateBag(vehicle, "stance:rearCamber_def", GetRearCamber(vehicle))
    SetStateBag(vehicle, "stance:suspensionHeight_def", GetVehicleSuspensionHeight(vehicle))
    SetStateBag(vehicle, "stance:wheelSize_def", GetVehicleWheelSize(vehicle))
end

---@param vehicle number
---@return data table
function GetWheelsPreset(vehicle)
    return {
        frontWidth = GetFrontTrackWidth(vehicle),
        frontCamber = GetFrontCamber(vehicle),
        rearWidth = GetRearTrackWidth(vehicle),
        rearCamber = GetRearCamber(vehicle),
        suspensionHeight = GetVehicleSuspensionHeight(vehicle),
        wheelSize = GetVehicleWheelSize(vehicle)
    }
end

---@param vehicle number
---@return data table
function GetWheelsPresetFromStateBag(vehicle)
    local state = Entity(vehicle).state
    return {
        frontWidth = state["stance:frontWidth"],
        frontCamber = state["stance:frontCamber"],
        rearWidth = state["stance:rearWidth"],
        rearCamber = state["stance:rearCamber"],
        suspensionHeight = state["stance:suspensionHeight"],
        wheelSize = state["stance:wheelSize"]
    }
end

---@param vehicle number
---@param preset table
function SetWheelsPreset(vehicle, preset)
    if Entity(vehicle).state["stance:active"] == nil then
        SaveDefaultWheelPreset(vehicle)
    end
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
    if preset.suspensionHeight then
        SetVehicleSuspensionHeight(vehicle, preset.suspensionHeight)
    end
    if preset.wheelSize then
        SetVehicleWheelSize(vehicle, preset.wheelSize)
        for i = 0, 4 do
            SetVehicleWheelTireColliderSize(vehicle, i, preset.wheelSize / 2)
            SetVehicleWheelRimColliderSize(vehicle, i, preset.wheelSize)
            --SetVehicleWheelTireColliderWidth(vehicle, i, preset.wheelSize / 2)
        end
    end
end

---@param vehicle number
---@return data table
function GetDefaultWheelPreset(vehicle)
    if not Entity(vehicle).state["stance:active"] then
        return GetWheelsPreset(vehicle)
    end
    local state = Entity(vehicle).state
    
    return {
        frontWidth = state["stance:frontWidth_def"],
        frontCamber = state["stance:frontCamber_def"],
        rearWidth = state["stance:rearWidth_def"],
        rearCamber = state["stance:rearCamber_def"],
        suspensionHeight = 0.0,
        wheelSize = state["stance:wheelSize_def"]
    }
end

---@param vehicle number
function ResetWheelsPreset(vehicle)
    if not Entity(vehicle).state["stance:active"] then
        return
    end

    SetStateBag(vehicle, "stance:active", false)
    SetStateBag(vehicle, "stance:frontWidth", nil)
    SetStateBag(vehicle, "stance:rearWidth", nil)
    SetStateBag(vehicle, "stance:frontCamber", nil)
    SetStateBag(vehicle, "stance:rearCamber", nil)
    SetStateBag(vehicle, "stance:suspensionHeight", nil)
    SetStateBag(vehicle, "stance:wheelSize", nil)
    
    for i = 1, #vehicles do
        if vehicles[i].id == vehicle then
            table.remove(vehicles, i)
        end
    end

    SetFrontTrackWidth(vehicle, Entity(vehicle).state["stance:frontWidth_def"])
    SetFrontCamber(vehicle, Entity(vehicle).state["stance:frontCamber_def"])
    SetRearTrackWidth(vehicle, Entity(vehicle).state["stance:rearWidth_def"])
    SetRearCamber(vehicle, Entity(vehicle).state["stance:rearCamber_def"])
    SetWheelsSize(vehicle, Entity(vehicle).state["stance:wheelSize_def"])
    SetVehicleSuspensionHeight(vehicle, 0.0)
end

function SetStateBag(vehicle, name, value)
    TriggerServerEvent('d-stance:server:setStateBag', NetworkGetNetworkIdFromEntity(vehicle), name, value)
end

function EnsureStanceStateBag(vehicle)
    if not Entity(vehicle).state["stance:active"] then
        SaveDefaultWheelPreset(vehicle)
        SetStateBag(vehicle, "stance:active", true)
    end
end

if DEBUG then
    RegisterCommand('stance:data', function()
        local vehicle = GetVehiclePedIsIn(playerPed)
        PrintWheelsPreset(vehicle)
    end, false)
    
    RegisterCommand('stance:default', function()
        local vehicle = GetVehiclePedIsIn(playerPed)
        ResetWheelsPreset(vehicle)
        PrintWheelsPreset(vehicle)
    end, false)
    
    RegisterCommand('stance:set', function(source, args)
        local vehicle = GetVehiclePedIsIn(playerPed)
        SaveWheelPreset(vehicle, {
            frontWidth = tonumber(args[1]),
            frontCamber = tonumber(args[2]),
            rearWidth = tonumber(args[3]),
            rearCamber = tonumber(args[4]),
        })
    end, false)

    RegisterCommand('stance:statebag', function(source, args)
        local vehicle = GetVehiclePedIsIn(playerPed)
        local stance = GetWheelsPresetFromStateBag(vehicle)
        print(("[DEBUG] frontWheelTrack %s"):format(stance.frontWidth))
        print(("[DEBUG] rearWheelTrack %s"):format(stance.rearWidth))
        print(("[DEBUG] frontCamber %s"):format(stance.frontCamber))
        print(("[DEBUG] rearCamber %s"):format(stance.rearCamber))
        print(("[DEBUG] suspensionHeight %s"):format(stance.suspensionHeight))
    end, false)
end

exports('GetFrontTrackWidth', GetFrontTrackWidth)
exports('SetFrontTrackWidth', SetFrontTrackWidth)
exports('GetFrontCamber', GetFrontCamber)
exports('SetFrontCamber', SetFrontCamber)
exports('GetSuspensionHeight', GetSuspensionHeight)
exports('SetSuspensionHeight', SetSuspensionHeight)
exports('GetRearTrackWidth', GetRearTrackWidth)
exports('SetRearTrackWidth', SetRearTrackWidth)
exports('GetRearCamber', GetRearCamber)
exports('SetRearCamber', SetRearCamber)
--exports('GetWheelsSize', GetWheelsSize)
exports('SetWheelsSize', SetWheelsSize)
exports('GetWheelsPresetFromStateBag', GetWheelsPresetFromStateBag)
exports('GetDefaultWheelPreset', GetDefaultWheelPreset)
exports('GetWheelsPreset', GetWheelsPreset)
exports('SetWheelsPreset', SetWheelsPreset)
exports('SaveWheelPreset', SaveWheelPreset)
exports('ResetWheelsPreset', ResetWheelsPreset)
exports('PrintWheelsData', PrintWheelsData)