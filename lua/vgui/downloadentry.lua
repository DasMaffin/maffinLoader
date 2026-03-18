local PANEL = PANEL or {}

function PANEL:Init()
end

function PANEL:PerformLayout(width, height)
    self.image:SetWidth(height-5)
end

function MaffinLoader.CreateDownloadEntry(imagePath, parent, fileInfo) -- fileInfo: https://gmodwiki.com/steamworks.FileInfo
    local panel = vgui.Create("MaffinLoaderDownloadEntryHUD", parent)
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
    local text = steamworks.IsSubscribed(fileInfo.fileid) and "Already Subscribed" or "Subscribe" 
    panel.subscribeButton:SetText(text)
    panel.subscribeButton.DoClick = function()
        gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. tostring(fileInfo.fileid))
    end
    return panel
end

vgui.Register("MaffinLoaderDownloadEntryHUD", PANEL, "Panel")