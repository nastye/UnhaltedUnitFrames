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

    self.unitBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.unitBackdrop:SetAllPoints()
    self.unitBackdrop:SetBackdrop({ bgFile = General.BackgroundTexture, edgeFile = General.BorderTexture, edgeSize = General.BorderSize, })
    self.unitBackdrop:SetBackdropColor(unpack(General.BackgroundColour))
    self.unitBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
    self.unitBackdrop:SetFrameLevel(1)

    local unitHealthBar = CreateFrame("StatusBar", nil, self)
    unitHealthBar:SetSize(Frame.Width - 2, Frame.Height - 2)
    unitHealthBar:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    unitHealthBar:SetStatusBarTexture(General.ForegroundTexture)
    unitHealthBar:SetStatusBarColor(unpack(General.ForegroundColour))
    unitHealthBar:SetMinMaxValues(0, 100)
    unitHealthBar.colorReaction = General.ColourByReaction
    unitHealthBar.colorClass = General.ColourByClass
    unitHealthBar.colorDisconnected = General.ColourIfDisconnected
    unitHealthBar.colorTapping = General.ColourIfTapped

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
    UUF.BossFrames = {}
    local BossContainer, BossSpacing = 0, Frame.Spacing
    for i = 1, 8 do
        local BossFrame = oUF:Spawn("boss" .. i, "UUF_Boss" .. i)
        UUF.BossFrames[i] = BossFrame
        if i == 1 then
            BossContainer = (BossFrame:GetHeight() + BossSpacing) * MAX_BOSS_FRAMES - BossSpacing
            BossFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, (BossContainer / 2 - BossFrame:GetHeight() / 2))
        else
            BossFrame:SetPoint("TOPLEFT", _G["UUF_Boss" .. (i - 1)], "BOTTOMLEFT", 0, -BossSpacing)
        end
    end
end

function UUF:UpdateBossFrames()
    if not UUF.BossFrames then return end
    for _, frame in ipairs(UUF.BossFrames) do
        UUF:UpdateBossFrame(frame)
    end
end

function UUF:UpdateBossFrame(FrameName)
    if not FrameName then return end

    local Frame = UUF.DB.global.Boss.Frame
    local General = UUF.DB.global.General
    local Buffs = UUF.DB.global.Boss.Buffs
    local Debuffs = UUF.DB.global.Boss.Debuffs
    local TargetMarker = UUF.DB.global.Boss.TargetMarker
    local LeftText = UUF.DB.global.Boss.Texts.Left
    local RightText = UUF.DB.global.Boss.Texts.Right
    local CenterText = UUF.DB.global.Boss.Texts.Center

    if FrameName then
        FrameName:ClearAllPoints()
        FrameName:SetSize(Frame.Width, Frame.Height)
        FrameName:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    end

    if FrameName.unitBackdrop then
        FrameName.unitBackdrop:SetBackdrop({
            bgFile = General.BackgroundTexture,
            edgeFile = General.BorderTexture,
            edgeSize = General.BorderSize,
        })
        FrameName.unitBackdrop:SetBackdropColor(unpack(General.BackgroundColour))
        FrameName.unitBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
    end

    if FrameName.Health then
        FrameName.Health:SetSize(Frame.Width - 2, Frame.Height - 2)
        FrameName.Health:SetPoint("TOPLEFT", FrameName, "TOPLEFT", 1, -1)
        FrameName.Health:SetStatusBarTexture(General.ForegroundTexture)
        FrameName.Health:SetStatusBarColor(unpack(General.ForegroundColour))
        FrameName.Health.colorReaction = General.ColourByReaction
        FrameName.Health.colorClass = General.ColourByClass
        FrameName.Health.colorDisconnected = General.ColourIfDisconnected
        FrameName.Health:ForceUpdate()
    end

    if Buffs.Enabled then
        FrameName.Buffs:ClearAllPoints()
        FrameName.Buffs:SetSize(FrameName:GetWidth(), Buffs.Size)
        FrameName.Buffs:SetPoint(Buffs.AnchorFrom, FrameName, Buffs.AnchorTo, Buffs.XOffset, Buffs.YOffset)
        FrameName.Buffs.size = Buffs.Size
        FrameName.Buffs.spacing = Buffs.Spacing
        FrameName.Buffs.num = Buffs.Num
        FrameName.Buffs.initialAnchor = Buffs.AnchorFrom
        FrameName.Buffs["growth-x"] = Buffs.GrowthX
        FrameName.Buffs["growth-y"] = Buffs.GrowthY
        FrameName.Buffs.filter = "HELPFUL"
        FrameName.Buffs:Show()
        FrameName.Buffs:ForceUpdate()
    else
        if FrameName.Buffs then
            FrameName.Buffs:Hide()
        end
    end

    if Debuffs.Enabled then
        FrameName.Debuffs:ClearAllPoints()
        FrameName.Debuffs:SetSize(FrameName:GetWidth(), Debuffs.Size)
        FrameName.Debuffs:SetPoint(Debuffs.AnchorFrom, FrameName, Debuffs.AnchorTo, Debuffs.XOffset, Debuffs.YOffset)
        FrameName.Debuffs.size = Debuffs.Size
        FrameName.Debuffs.spacing = Debuffs.Spacing
        FrameName.Debuffs.num = Debuffs.Num
        FrameName.Debuffs.initialAnchor = Debuffs.AnchorFrom
        FrameName.Debuffs["growth-x"] = Debuffs.GrowthX
        FrameName.Debuffs["growth-y"] = Debuffs.GrowthY
        FrameName.Debuffs.filter = "HELPFUL"
        FrameName.Debuffs:Show()
        FrameName.Debuffs:ForceUpdate()
    else
        if FrameName.Debuffs then
            FrameName.Debuffs:Hide()
        end
    end

    if FrameName.unitLeftText then
        FrameName.unitLeftText:ClearAllPoints()
        FrameName.unitLeftText:SetFont(General.Font, LeftText.FontSize, General.FontFlag)
        FrameName.unitLeftText:SetPoint("LEFT", FrameName, "LEFT", LeftText.XOffset, LeftText.YOffset)
        FrameName:Tag(FrameName.unitLeftText, LeftText.Tag)
    end

    if FrameName.unitRightText then
        FrameName.unitRightText:ClearAllPoints()
        FrameName.unitRightText:SetFont(General.Font, RightText.FontSize, General.FontFlag)
        FrameName.unitRightText:SetPoint("RIGHT", FrameName, "RIGHT", RightText.XOffset, RightText.YOffset)
        FrameName:Tag(FrameName.unitRightText, RightText.Tag)
    end

    if FrameName.unitCenterText then
        FrameName.unitCenterText:ClearAllPoints()
        FrameName.unitCenterText:SetFont(General.Font, CenterText.FontSize, General.FontFlag)
        FrameName.unitCenterText:SetPoint("CENTER", FrameName, "CENTER", CenterText.XOffset, CenterText.YOffset)
        FrameName:Tag(FrameName.unitCenterText, CenterText.Tag)
    end

    if FrameName.RaidTargetIndicator and TargetMarker.Enabled then
        FrameName.RaidTargetIndicator:ClearAllPoints()
        FrameName.RaidTargetIndicator:SetSize(TargetMarker.Size, TargetMarker.Size)
        FrameName.RaidTargetIndicator:SetPoint(TargetMarker.AnchorFrom, FrameName, TargetMarker.AnchorTo, TargetMarker.XOffset, TargetMarker.YOffset)
    end

    FrameName:UpdateTags()
end