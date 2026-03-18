local PANEL = PANEL or {}
local MaffinLoaderDownloadsMainHUDisActive = false
local MaffinLoaderDownloadsMainHUD = MaffinLoaderDownloadsMainHUD or {}
local createEntriesCoroutine = createEntriesCoroutine or {}
local mainPanelExtended = true
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

    self.CloseButton = vgui.Create("DButton", vgui.GetWorldPanel())
    self.CloseButton:SetSize(24, 24)
    self.CloseButton:SetText("")
    self.CloseButtonText = ">"
    self.CloseButton.DoClick = function()
        if MaffinLoader.LoadingFinished then
            ToggleMaffinLoaderDownloadsMainHUD()
        end
        mainPanelExtended = not mainPanelExtended
        self:InvalidateLayout(true)
        self.CloseButtonText = mainPanelExtended and ">" or "<"
    end

    self.CloseButton.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(200, 50, 50))
        draw.SimpleText(MaffinLoader.LoadingFinished and "x" or self.CloseButtonText, "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.TitleBar = vgui.Create("DPanel", self)
    self.TitleBar:Dock(TOP)
    self.TitleBar.Paint = function() end

    self.Title = vgui.Create("DLabel", self.TitleBar)
    self.Title:Dock(FILL)
    self.Title:SetText("")
    self.Title.Paint = function(s, w, h)
            draw.SimpleText(MaffinLoader.Lang[MaffinLoader.Settings.Language].TitleText, "DermaDefault", 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(5, 5, 5, 5)

    self.footer = vgui.Create("DPanel", self)
    self.footer:Dock(BOTTOM)
    self.footer.Paint = function() end

    self.FAQButton = vgui.Create("DButton", self.footer)
    self.FAQButton:SetText("FAQ")
    self.FAQButton:Dock(LEFT)

    self.SettingsButton = vgui.Create("DButton", self.footer)
    self.SettingsButton:SetText("Settings")
    self.SettingsButton:Dock(RIGHT)

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
    self:SetSize(mainPanelExtended and ScrW() * 0.19 or 0, ScrH() * 0.2)
    self:SetPos(mainPanelExtended and ScrW() * 0.8 or ScrW() * 0.99, ScrH() * 0.2)

    self.TitleBar:SetTall(self:GetTall() * 0.1)

    self.FAQButton:SetWidth(self.footer:GetWide() * 0.48)
    
    self.SettingsButton:SetWidth(self.footer:GetWide() * 0.48)

    if IsValid(self.CloseButton) then
        local x, y = self:GetPos()
        self.CloseButton:SetPos(x + width - 12, y - 12) 
    end
end

function PANEL:OnRemove()
    if IsValid(self.CloseButton) then
        self.CloseButton:Remove()
    end
end


function CreateMaffinLoaderDownloadsMainHUD()
    MaffinLoaderDownloadsMainHUD = vgui.Create("MaffinLoaderDownloadsMainHUD")
    return MaffinLoaderDownloadsMainHUD
end

function ToggleMaffinLoaderDownloadsMainHUD()
    MaffinLoaderDownloadsMainHUDisActive = not MaffinLoaderDownloadsMainHUDisActive
    if IsValid(MaffinLoaderDownloadsMainHUD) then
        MaffinLoaderDownloadsMainHUD:SetVisible(MaffinLoaderDownloadsMainHUDisActive)
        MaffinLoaderDownloadsMainHUD.CloseButton:SetVisible(MaffinLoaderDownloadsMainHUDisActive)
    end
end