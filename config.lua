Config = {}

Config.Locale = "en"

Config.Debug = true
Config.EnableMenu = true
Config.RenderDistance = 100.0 -- meters
Config.UpdateRate = 2000 -- miliseconds

Config.Limits = {
    frontWidth = 0.1,
    rearWidth = 0.1,
    frontCamber = 0.19,
    rearCamber = 0.19,
    suspensionHeight = {
        min = -0.08,
        max = 0.08
    },
    wheelSize = 0.2
}

Config.Features = {
    frontCamber = true,
    rearCamber = true,
    frontWidth = true,
    rearWidth = true,
    suspensionHeight = true,
    wheelSize = true
}