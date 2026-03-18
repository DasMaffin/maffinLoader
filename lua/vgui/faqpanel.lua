local PANEL = PANEL or {}
MaffinLoaderFAQPanelisActive = false
local MaffinLoaderFAQPanel = MaffinLoaderFAQPanel or {}
vgui.Register("MaffinLoaderFAQPanel", PANEL, "EditablePanel")

local function WrapText(text, font, maxWidth)
    surface.SetFont(font)
    local lines = {}
    local words = string.Explode(" ", text)
    local currentLine = ""

    for _, word in ipairs(words) do
        local testLine = currentLine == "" and word or (currentLine .. " " .. word)
        local w = surface.GetTextSize(testLine)

        if w > maxWidth and currentLine ~= "" then
            table.insert(lines, currentLine)
            currentLine = word
        else
            currentLine = testLine
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return lines
end

function PANEL:Init()
    self:SetSize(ScrW() * 0.49, ScrH() * 0.59)
    self:SetPos(ScrW() * 0.5, ScrH() * 0.4)

    self.Paint = function(s, w, h)
        draw.RoundedBox(1, 0, 0, w, h, Color(30, 30, 40, 255))
    end

    self.ScrollPanel = vgui.Create("DScrollPanel", self)
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel:DockMargin(5, 5, 5, 5)

    self.FAQOneTitle = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQOneTitle:SetText("")
    self.FAQOneTitle:Dock(TOP)
    self.FAQOneTitle.Paint = function(s, w, h)
        draw.SimpleText(MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleOneText, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.FAQOneAnswer = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQOneAnswer:SetText("")
    self.FAQOneAnswer:Dock(TOP)
    self.FAQOneAnswer:DockMargin(0,0,0,5)
    self.FAQOneAnswer._lines = {}
    self.FAQOneAnswer._lineH = 0
    self.FAQOneAnswer.Paint = function(s, w, h)
        for i, line in ipairs(s._lines) do
            draw.SimpleText(line, "DermaDefault", 0, (i - 1) * s._lineH, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end
    
    self.FAQTwoTitle = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQTwoTitle:SetText("")
    self.FAQTwoTitle:Dock(TOP)
    self.FAQTwoTitle.Paint = function(s, w, h)
        draw.SimpleText(MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleTwoText, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.FAQTwoAnswer = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQTwoAnswer:SetText("")
    self.FAQTwoAnswer:Dock(TOP)
    self.FAQTwoAnswer:DockMargin(0,0,0,5)
    self.FAQTwoAnswer._lines = {}
    self.FAQTwoAnswer._lineH = 0
    self.FAQTwoAnswer.Paint = function(s, w, h)
        for i, line in ipairs(s._lines) do
            draw.SimpleText(line, "DermaDefault", 0, (i - 1) * s._lineH, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    self.FAQThreeTitle = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQThreeTitle:SetText("")
    self.FAQThreeTitle:Dock(TOP)
    self.FAQThreeTitle.Paint = function(s, w, h)
        draw.SimpleText(MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleThreeText, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.FAQThreeAnswer = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQThreeAnswer:SetText("")
    self.FAQThreeAnswer:Dock(TOP)
    self.FAQThreeAnswer:DockMargin(0,0,0,5)
    self.FAQThreeAnswer._lines = {}
    self.FAQThreeAnswer._lineH = 0
    self.FAQThreeAnswer.Paint = function(s, w, h)
        for i, line in ipairs(s._lines) do
            draw.SimpleText(line, "DermaDefault", 0, (i - 1) * s._lineH, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    self.FAQFourTitle = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQFourTitle:SetText("")
    self.FAQFourTitle:Dock(TOP)
    self.FAQFourTitle.Paint = function(s, w, h)
        draw.SimpleText(MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleFourText, "DermaLarge", 0, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    self.FAQFourAnswer = vgui.Create("DLabel", self.ScrollPanel)
    self.FAQFourAnswer:SetText("")
    self.FAQFourAnswer:Dock(TOP)
    self.FAQFourAnswer:DockMargin(0,0,0,5)
    self.FAQFourAnswer._lines = {}
    self.FAQFourAnswer._lineH = 0
    self.FAQFourAnswer.Paint = function(s, w, h)
        for i, line in ipairs(s._lines) do
            draw.SimpleText(line, "DermaDefault", 0, (i - 1) * s._lineH, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end
end

function AutoSetLabelHeight(derma, text)
    local _, titleH = surface.GetTextSize(text)
    derma:SetHeight(titleH)
end

function SetAnswerText(derma, answerText)
    local lines = WrapText(answerText, "DermaDefault", derma:GetWide())
    surface.SetFont("DermaDefault")
    local _, lineH = surface.GetTextSize("A")
    derma._lines = lines
    derma._lineH = lineH
    derma:SetHeight(#lines * lineH)
end

function PANEL:PerformLayout(width, height)
    surface.SetFont("DermaLarge")
    AutoSetLabelHeight(self.FAQOneTitle, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleOneText)
    AutoSetLabelHeight(self.FAQTwoTitle, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleTwoText)
    AutoSetLabelHeight(self.FAQThreeTitle, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleThreeText)
    AutoSetLabelHeight(self.FAQFourTitle, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.TitleFourText)

    SetAnswerText(self.FAQOneAnswer, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.AnswerOneText)
    SetAnswerText(self.FAQTwoAnswer, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.AnswerTwoText)
    SetAnswerText(self.FAQThreeAnswer, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.AnswerThreeText)
    SetAnswerText(self.FAQFourAnswer, MaffinLoader.Lang[MaffinLoader.Settings.Language].FAQ.AnswerFourText)
end

local function CreateMaffinLoaderFAQPanel()
    MaffinLoaderFAQPanel = vgui.Create("MaffinLoaderFAQPanel")
    return MaffinLoaderFAQPanel
end

function ToggleMaffinLoaderFAQPanel()
    if MaffinLoaderDownloadsMainHUD.SettingsPanel then 
        MaffinLoaderSettingsPanelisActive = false
        MaffinLoaderDownloadsMainHUD.SettingsPanel:SetVisible(MaffinLoaderSettingsPanelisActive) 
    end
    MaffinLoaderFAQPanelisActive = not MaffinLoaderFAQPanelisActive
    if not IsValid(MaffinLoaderFAQPanel) then
        MaffinLoaderFAQPanel = CreateMaffinLoaderFAQPanel()
    end
    MaffinLoaderFAQPanel:SetVisible(MaffinLoaderFAQPanelisActive)
    return MaffinLoaderFAQPanel
end