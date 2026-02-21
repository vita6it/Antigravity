local _ENV = (getgenv or getrenv or getfenv)()

local Owner = "vita6it"
local Repository = "Antigravity"

local Utils = _ENV.Utils or (function(owner, repo, file)
	local URL = string.format(
		"https://raw.githubusercontent.com/%s/%s/main/%s",
		owner, repo, file
    )
    
    warn("Fetch : ", file)

	return loadstring(game:HttpGet(URL))()
end)

local function GetModule(module)
    return Utils(Owner, Repository, "Utils/" .. module)
end

local Cascade = GetModule("Cascade")

local Configurations = GetModule("Configurations")("Antigravity")
local Parallels = GetModule("Parallels")()
local Library = GetModule("Library")(Cascade)
local Others = GetModule("Others")()

local SaveManager = Configurations.Configurations
local Settings = Configurations.Settings

local Connections = GetModule("Connections")()
local Components = GetModule("Components")
local Plugins = GetModule("Plugins")(Components, Configurations, Others, Cascade)

return {
    Components = Components(Parallels, Configurations, Cascade, Library, Others),
    Plugins = Plugins,
    Connections = Connections,
    Parallels = Parallels,
    Configurations = Configurations,
	SaveManager = SaveManager,
	Settings = Settings,
	Cascade = Cascade,
}
