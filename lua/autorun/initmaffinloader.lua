MaffinLoader = MaffinLoader or {}
MaffinLoader.Lang = MaffinLoader.Lang or {}
local files, dirs = file.Find("lang/*", "LUA")
if SERVER then
    AddCSLuaFile("cl/cl_initmaffinloader.lua" )
    AddCSLuaFile("vgui/downloadentry.lua")
    AddCSLuaFile("vgui/downloadsmain.lua")
    AddCSLuaFile("vgui/faqpanel.lua")
    AddCSLuaFile("vgui/settingspanel.lua")
    AddCSLuaFile("settings.lua")
    for _, file in ipairs(files) do
        AddCSLuaFile("lang/" .. file)
    end
    include("sv/sv_initmaffinloader.lua")
elseif CLIENT then
    include("cl/cl_initmaffinloader.lua")
    include("vgui/downloadentry.lua")
    include("vgui/downloadsmain.lua")
    include("vgui/faqpanel.lua")
    include("vgui/settingspanel.lua")
end

include("settings.lua")
for _, file in ipairs(files) do
    include("lang/" .. file)
end