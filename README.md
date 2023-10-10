![](https://i.imgur.com/eoNe4Ln.jpg)

![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)
![](https://dcbadge.vercel.app/api/server/RTs4VvAw3C?style=flat)

FiveM script library for utilizing game natives and making stancing possible for vehicles


## Instalation

#### Main instalation
1. Clone or download the repository 
2. Unzip the archive contents
3. Add resource to resources startup in the server configuration file

#### Building the UI(optional)

1. Navigate to the ui folder inside resource
2. Open the terminal
3. Run command `npm install` to install dependencies
4. Run command `npm run build` to build the project

## Configuration

All the features can be configured in the resource configuration file(`config.lua`)

| Flag | Description |
|-----------------|-----------------|
| Config.EnableMenu | Enables independant resource stance menu |
| Config.UpdateRate | Defines how frequently scan for vehicles with active stance preset |
| Config.RenderDistance | Determines from what distance stance presets should be applied |
| Config.Features | Enables individual stance features |
| Config.Limits | Configures stance feature offsets and limits |
