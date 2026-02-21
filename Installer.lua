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
local Connections = GetModule("Connections")()
local Library = GetModule("Library")(Cascade)
local Parallels = GetModule("Parallels")()
local Others = GetModule("Others")()

local Components = GetModule("Components")(Parallels, Configurations, Cascade, Library, Others)

return {
    Components = Components.Components,
    Configurations = Configurations,
    Settings = Components.Settings,
    Plugins = Components.Plugins,
    Connections = Connections,
    Parallels = Parallels,
	Cascade = Cascade,
}
