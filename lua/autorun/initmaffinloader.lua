MaffinLoader = MaffinLoader or {}
if SERVER then
    AddCSLuaFile("cl/cl_initmaffinloader.lua" )
    AddCSLuaFile("vgui/downloadentry.lua")
    AddCSLuaFile("vgui/downloadsmain.lua")
    AddCSLuaFile("settings.lua")
    include("sv/sv_initmaffinloader.lua")
elseif CLIENT then
    include("cl/cl_initmaffinloader.lua")
    include("vgui/downloadentry.lua")
    include("vgui/downloadsmain.lua")
end

include("settings.lua")