MaffinLoader.WorkshopIDs = MaffinLoader.WorkshopIDs or {}

function MaffinLoader.StartDownloads()
    local downloadCount = 0
    local finishedDownloads = {}

    local function onFinishedDownloads()
        for _, download in ipairs(finishedDownloads) do
            if download.path then
                game.MountGMA( download.path )
            else
                print("[MaffinLoader] Failed to download addon from Workshop ID: " .. download.id)
            end
        end
    end

    for _, id in ipairs(MaffinLoader.WorkshopIDs) do
        if not steamworks.IsSubscribed(id) then
            downloadCount = downloadCount + 1
            steamworks.DownloadUGC( id, function( path, file )
                local downloadData = {
                    id = id,
                    path = path,
                    file = file
                }
                table.insert(finishedDownloads, downloadData)
                if #finishedDownloads == downloadCount then
                    onFinishedDownloads()
                end
            end)
        end
    end    
end

net.Receive("MaffinLoader_SendWorkshopIDs", function()
    MaffinLoader.WorkshopIDs = net.ReadTable()
    MaffinLoader.StartDownloads()
    
    CreateMaffinLoaderDownloadsMainHUD()
    OpenMaffinLoaderDownloadsMainHUD()
end)