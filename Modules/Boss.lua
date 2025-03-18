local _, UUF = ...
local oUF = UUF.oUF

function UUF:CreateBossFrame()
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global.Boss.Frame
    local Buffs = UUF.DB.global.Boss.Buffs
    local Debuffs = UUF.DB.global.Boss.Debuffs
    local TargetMarker = UUF.DB.global.Boss.TargetMarker
    local LeftText = UUF.DB.global.Boss.Texts.Left
    local RightText = UUF.DB.global.Boss.Texts.Right
    local CenterText = UUF.DB.global.Boss.Texts.Center
    
    self:SetSize(Frame.Width, Frame.Height)

    local unitBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
    unitBackdrop:SetAllPoints()
    unitBackdrop:SetBackdrop({ bgFile = General.BackgroundTexture, edgeFile = General.BorderTexture, edgeSize = General.BorderSize, })
    unitBackdrop:SetBackdropColor(unpack(General.BackgroundColour))
    unitBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
    unitBackdrop:SetFrameLevel(1)

    local unitHealthBar = CreateFrame("StatusBar", nil, self)
    unitHealthBar:SetSize(Frame.Width - 2, Frame.Height - 2)
    unitHealthBar:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    unitHealthBar:SetStatusBarTexture(General.ForegroundTexture)
    unitHealthBar:SetStatusBarColor(unpack(General.ForegroundColour))
    unitHealthBar.colorReaction = General.ColourByReaction
    unitHealthBar.colorClass = General.ColourByClass
    unitHealthBar.colorDisconnected = General.ColourIfDisconnected
    unitHealthBar:SetFrameLevel(2)
    self.Health = unitHealthBar

    if Buffs.Enabled then
        local unitBuffs = CreateFrame("Frame", nil, self)
        unitBuffs:SetSize(self:GetWidth(), Buffs.Size)
        unitBuffs:SetPoint(Buffs.AnchorFrom, self, Buffs.AnchorTo, Buffs.XOffset, Buffs.YOffset)
        unitBuffs.size = Buffs.Size
        unitBuffs.spacing = Buffs.Spacing
        unitBuffs.num = Buffs.Num
        unitBuffs.initialAnchor = Buffs.AnchorFrom
        unitBuffs["growth-x"] = Buffs.GrowthX
        unitBuffs["growth-y"] = Buffs.GrowthY
        unitBuffs.filter = "HELPFUL"
        unitBuffs.PostCreateButton = function(_, button) UUF:PostCreateButton(_, button) end
        self.Buffs = unitBuffs
    end

    if Debuffs.Enabled then
        local unitDebuffs = CreateFrame("Frame", nil, self)
        unitDebuffs:SetSize(self:GetWidth(), Debuffs.Size)
        unitDebuffs:SetPoint(Debuffs.AnchorFrom, self, Debuffs.AnchorTo, Debuffs.XOffset, Debuffs.YOffset)
        unitDebuffs.size = Debuffs.Size
        unitDebuffs.spacing = Debuffs.Spacing
        unitDebuffs.num = Debuffs.Num
        unitDebuffs.initialAnchor = Debuffs.AnchorFrom
        unitDebuffs["growth-x"] = Debuffs.GrowthX
        unitDebuffs["growth-y"] = Debuffs.GrowthY
        unitDebuffs.filter = "HARMFUL"
        unitDebuffs.PostCreateButton = function(_, button) UUF:PostCreateButton(_, button) end
        self.Debuffs = unitDebuffs
    end

    local unitHighLevelFrame = CreateFrame("Frame", nil, self)
    unitHighLevelFrame:SetSize(Frame.Width, Frame.Height)
    unitHighLevelFrame:SetPoint("CENTER", 0, 0)
    unitHighLevelFrame:SetFrameLevel(999)

    self.unitLeftText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitLeftText:SetFont(General.Font, LeftText.FontSize, General.FontFlag)
    self.unitLeftText:SetPoint("LEFT", unitHighLevelFrame, "LEFT", LeftText.XOffset, LeftText.YOffset)
    self.unitLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitLeftText, LeftText.Tag)
    
    self.unitRightText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitRightText:SetFont(General.Font, RightText.FontSize, General.FontFlag)
    self.unitRightText:SetPoint("RIGHT", unitHighLevelFrame, "RIGHT", RightText.XOffset, RightText.YOffset)
    self.unitRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitRightText, RightText.Tag)
    
    self.unitCenterText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitCenterText:SetFont(General.Font, CenterText.FontSize, General.FontFlag)
    self.unitCenterText:SetPoint("CENTER", unitHighLevelFrame, "CENTER", CenterText.XOffset, CenterText.YOffset)
    self.unitCenterText:SetJustifyH("CENTER")
    self:Tag(self.unitCenterText, CenterText.Tag)

    if TargetMarker.Enabled then
        local unitTargetMarker = unitHighLevelFrame:CreateTexture(nil, "OVERLAY")
        unitTargetMarker:SetSize(TargetMarker.Size, TargetMarker.Size)
        unitTargetMarker:SetPoint(TargetMarker.AnchorFrom, unitHighLevelFrame, TargetMarker.AnchorTo, TargetMarker.XOffset, TargetMarker.YOffset)
        self.RaidTargetIndicator = unitTargetMarker
    end

    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type1", "target")
    self:SetAttribute("*type2", "togglemenu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
end

function UUF:SpawnBossFrame()
    local Frame = UUF.DB.global.Boss.Frame
    oUF:RegisterStyle("UUF_Boss", UUF.CreateBossFrame)
    oUF:SetActiveStyle("UUF_Boss")
    local BossContainer, BossSpacing = 0, Frame.Spacing
    for i = 1, 8 do
        self.BossFrame = oUF:Spawn("boss" .. i, "UUF_Boss" .. i)
        if i == 1 then
            BossContainer = (self.BossFrame:GetHeight() + BossSpacing) * MAX_BOSS_FRAMES - BossSpacing
            self.BossFrame:SetPoint("CENTER", UIParent, "CENTER", Frame.XPosition, (BossContainer / 2 - self.BossFrame:GetHeight() / 2))
        else
            self.BossFrame:SetPoint("TOPLEFT", _G["UUF_Boss" .. (i - 1)], "BOTTOMLEFT", 0, -BossSpacing)
        end
    end
end