local PANEL = PANEL or {}
MaffinLoaderSettingsPanelisActive = false
local MaffinLoaderSettingsPanel = MaffinLoaderSettingsPanel or {}
vgui.Register("MaffinLoaderSettingsPanel", PANEL, "EditablePanel")

function PANEL:Init()
    self:SetSize(ScrW() * 0.19, ScrH() * 0.59)
    self:SetPos(ScrW() * 0.8, ScrH() * 0.4)

    self.Paint = function(s, w, h)
        draw.RoundedBox(1, 0, 0, w, h, Color(30, 30, 40, 255))
    end

    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(5, 5, 5, 5)

    self.DisplayWorkshopImagesSettingContainer = self.ScrollPanel:Add("Panel") 
    self.DisplayWorkshopImagesSettingContainer:Dock(TOP)

    self.DisplayWorkshopImagesSettingLabel = vgui.Create("DLabel", self.DisplayWorkshopImagesSettingContainer)
    self.DisplayWorkshopImagesSettingLabel:Dock(LEFT)
    self.DisplayWorkshopImagesSettingLabel:SetText("")
    self.DisplayWorkshopImagesSettingLabel.Paint = function(s, w, h)
        draw.SimpleText(MaffinLoader.Lang[MaffinLoader.Settings.Language].DisplayWorkshopImagesSettingLabel, "DermaDefault", 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.DisplayWorkshopImagesSettingCheckBox = vgui.Create("DCheckBox", self.DisplayWorkshopImagesSettingContainer)
    self.DisplayWorkshopImagesSettingCheckBox:Dock(LEFT)    
    self.DisplayWorkshopImagesSettingCheckBox:SetChecked(MaffinLoader.Settings.DisplayWorkshopImages)
    self.DisplayWorkshopImagesSettingCheckBox.OnChange = function(cb, val)
        MaffinLoader.Settings.DisplayWorkshopImages = val
    end
end

function PANEL:PerformLayout(width, height)
    self.DisplayWorkshopImagesSettingLabel:SetWidth(self.DisplayWorkshopImagesSettingContainer:GetWide() * 0.6)

    self.DisplayWorkshopImagesSettingCheckBox:SetWidth(self.DisplayWorkshopImagesSettingCheckBox:GetTall())
end

local function CreateMaffinLoaderSettingsPanel()
    MaffinLoaderSettingsPanel = vgui.Create("MaffinLoaderSettingsPanel")
    return MaffinLoaderSettingsPanel
end

function ToggleMaffinLoaderSettingsPanel()
    if MaffinLoaderDownloadsMainHUD.FAQPanel then 
        MaffinLoaderFAQPanelisActive = false
        MaffinLoaderDownloadsMainHUD.FAQPanel:SetVisible(MaffinLoaderFAQPanelisActive) 
    end
    MaffinLoaderSettingsPanelisActive = not MaffinLoaderSettingsPanelisActive
    if not IsValid(MaffinLoaderSettingsPanel) then
        MaffinLoaderSettingsPanel = CreateMaffinLoaderSettingsPanel()
    end
    MaffinLoaderSettingsPanel:SetVisible(MaffinLoaderSettingsPanelisActive)
    return MaffinLoaderSettingsPanel
end