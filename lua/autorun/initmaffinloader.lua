if SERVER then
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
        net.Start("MaffinLoader_SendWorkshopIDs")
            net.WriteTable(WORKSHOP_IDS)
        net.Send(ply)
    end)
end

if CLIENT then
    MyAddon_WorkshopIDs = MyAddon_WorkshopIDs or {}

    net.Receive("MaffinLoader_SendWorkshopIDs", function()
        MyAddon_WorkshopIDs = net.ReadTable()
        for _, id in ipairs(MyAddon_WorkshopIDs) do
            if not steamworks.IsSubscribed(id) then
                steamworks.DownloadUGC( id, function( path, file )
                    game.MountGMA( path )
                end)
            end
        end
    end)
end

