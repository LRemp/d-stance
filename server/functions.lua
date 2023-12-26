function FetchPreset(numberplate)
    local row = MySQL.single.await('SELECT `preset` FROM `vehicle_stance` WHERE `numberplate` = ? LIMIT 1', {
        numberplate
    })
    return json.decode(row.preset) or nil
end

function SavePreset(numberplate, preset)
    local encodedPreset = json.encode(preset)
    local affectedRows = MySQL.update.await('UPDATE vehicle_stance SET preset = ? WHERE numberplate = ?', {
        encodedPreset, numberplate
    })
    
    if affectedRows == 0 then
        MySQL.insert.await('INSERT INTO `vehicle_stance` (numberplate, preset) VALUES (?, ?)', {
            numberplate, encodedPreset
        })
    end
end