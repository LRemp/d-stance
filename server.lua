RegisterNetEvent('d-stance:server:setStateBag', function(vehicle, name, value)
    local veh = Entity(NetworkGetEntityFromNetworkId(vehicle))
    veh.state[name] = value
end)