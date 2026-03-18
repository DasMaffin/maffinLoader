local DATA_FILE = "MaffinLoader/workshop_ids.json"

if not file.IsDir("MaffinLoader", "DATA") then
    file.CreateDir("MaffinLoader")
end

if not file.Exists(DATA_FILE, "DATA") then
    print("[MaffinLoader] Config missing, creating default config.")
    local defaultIDs = {
        "3516091417",
        "3448068894"
    }

    file.Write(DATA_FILE, util.TableToJSON(defaultIDs, true))
end

local raw = file.Read(DATA_FILE, "DATA")
local WORKSHOP_IDS = util.JSONToTable(raw) or {}

util.AddNetworkString("MaffinLoader_SendWorkshopIDs")

hook.Add("PlayerInitialSpawn", "MaffinLoader_SendWorkshopIDs", function(ply)
    timer.Simple(10, function()    
        net.Start("MaffinLoader_SendWorkshopIDs")
            net.WriteTable(WORKSHOP_IDS)
        net.Send(ply)
    end)
end)