local PANEL = PANEL or {}

function PANEL:Init()
end

function PANEL:PerformLayout(width, height)
    if self.image then 
        self.image:SetWidth(height-5)
    end
end

function MaffinLoader.CreateDownloadEntry(imagePath, parent, fileInfo) -- fileInfo: https://gmodwiki.com/steamworks.FileInfo
    local panel = parent:Add("MaffinLoaderDownloadEntryHUD")
    local isSubscribed = steamworks.IsSubscribed(fileInfo.fileid)
    local text = "Subscribe"
    if isSubscribed then        
        text = "Already Subscribed"
        panel:SetVisible(not MaffinLoader.Settings.HideSubscribedItems)
        local size = MaffinLoader.Settings.HideSubscribedItems and 0 or 64
        panel:SetTall(size)
        panel:GetParent():SetTall(size)
    else
        panel:SetTall(64)
    end
    panel:GetParent():InvalidateLayout(true)
    if MaffinLoader.Settings.DisplayWorkshopImages then
        local mat = AddonMaterial(imagePath)

        panel.image = vgui.Create("DImage", panel)
        panel.image:SetMaterial(mat)
        panel.image:Dock(LEFT)
        panel.image:DockMargin(0,0,0,5)
    end
    panel.middleSection = vgui.Create("Panel", panel)
    panel.middleSection:Dock(FILL)

    panel.label = vgui.Create("DLabel", panel.middleSection)
    panel.label:SetText(fileInfo.title)
    panel.label:Dock(TOP)

    panel.subscribeButton = vgui.Create("DButton", panel.middleSection)
    panel.subscribeButton:Dock(BOTTOM)
    panel.subscribeButton:SetText(text)
    panel.subscribeButton.DoClick = function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. tostring(fileInfo.fileid))
    end
    return panel
end

vgui.Register("MaffinLoaderDownloadEntryHUD", PANEL, "Panel")