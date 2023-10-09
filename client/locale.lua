Locale = {}

function Locale.Get(name)
    return Locale.Strings[name] or name
end

function Locale.Load()
    Locale.Strings = {}
    --TODO: check if locale name is valid
    local fileContent = LoadResourceFile(GetCurrentResourceName(), 'locale/' .. Config.Locale .. '.json')
    local parsedJson = json.decode(fileContent)
    for k,v in pairs(parsedJson) do
        Locale.Strings[k] = tostring(v)
    end
end