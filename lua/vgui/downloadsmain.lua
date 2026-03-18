local PANEL = PANEL or {}
local MaffinLoaderDownloadsMainHUDisActive = false
local MaffinLoaderDownloadsMainHUD = MaffinLoaderDownloadsMainHUD or {}
local createEntriesCoroutine = createEntriesCoroutine or {}
vgui.Register("MaffinLoaderDownloadsMainHUD", PANEL, "EditablePanel")

local buildQueue = {}
local function EnqueueEntry(fn)
    table.insert(buildQueue, fn)
end

function PANEL:Init()    
    self:SetSize(ScrW() * 0.19, ScrH() * 0.2)
    self:SetPos(ScrW() * 0.8, ScrH() * 0.2)
    self:SetVisible(false)

    self.Paint = function(s, w, h)
        draw.RoundedBox(1, 0, 0, w, h, Color(30, 30, 40, 255))
    end

    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(5, 5, 5, 5)

    createEntriesCoroutine = coroutine.create(function()        
        for _, workshopId in ipairs(MaffinLoader.WorkshopIDs) do
            local scrollPanelEntry =  self.ScrollPanel:Add("Panel")
            scrollPanelEntry:Dock(TOP)
            scrollPanelEntry:SetHeight(64) -- TODO move into PerformLayout or what it was called and make it percentage of parent.
            steamworks.FileInfo(workshopId, function(fileInfo)
                steamworks.Download(fileInfo.previewid, true, function(imagePath)
                    fileInfo.fileid = workshopId
                    EnqueueEntry(function()                    
                        local panel = MaffinLoader.CreateDownloadEntry(imagePath, scrollPanelEntry, fileInfo)                
                        panel:Dock(FILL)
                    end)
                end)
            end)

            coroutine.yield()
        end
    end)
end

function PANEL:Think()
    if coroutine.status(createEntriesCoroutine) ~= "dead" then
        coroutine.resume(createEntriesCoroutine)
    end

    if #buildQueue > 0 then
        local next = table.remove(buildQueue, 1)
        next()
    end
end

function PANEL:PerformLayout(width, height)
end


function CreateMaffinLoaderDownloadsMainHUD()
    MaffinLoaderDownloadsMainHUD = vgui.Create("MaffinLoaderDownloadsMainHUD")
    return MaffinLoaderDownloadsMainHUD
end

function OpenMaffinLoaderDownloadsMainHUD()
    MaffinLoaderDownloadsMainHUDisActive = not MaffinLoaderDownloadsMainHUDisActive
    gui.EnableScreenClicker(MaffinLoaderDownloadsMainHUDisActive)
    if IsValid(MaffinLoaderDownloadsMainHUD) then
        MaffinLoaderDownloadsMainHUD:SetVisible(MaffinLoaderDownloadsMainHUDisActive)
    end
end