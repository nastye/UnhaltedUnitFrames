local _, UUF = ...
local oUF = UUF.oUF

function UUF:CreateTargetFrame()
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global.Target.Frame
    local Health = UUF.DB.global.Target.Health
    local Buffs = UUF.DB.global.Target.Buffs
    local Debuffs = UUF.DB.global.Target.Debuffs
    local TargetMarker = UUF.DB.global.Target.TargetMarker
    local LeftText = UUF.DB.global.Target.Texts.Left
    local RightText = UUF.DB.global.Target.Texts.Right
    local CenterText = UUF.DB.global.Target.Texts.Center
    local TopLeftText = UUF.DB.global.Target.Texts.AdditionalTexts.TopLeft
    local TopRightText = UUF.DB.global.Target.Texts.AdditionalTexts.TopRight
    local BottomLeftText = UUF.DB.global.Target.Texts.AdditionalTexts.BottomLeft
    local BottomRightText = UUF.DB.global.Target.Texts.AdditionalTexts.BottomRight

    local BackdropTemplate = {
        bgFile = General.BackgroundTexture,
        edgeFile = General.BorderTexture,
        edgeSize = General.BorderSize,
        insets = { left = General.BorderInset, right = General.BorderInset, top = General.BorderInset, bottom = General.BorderInset },
    }
    
    self:SetSize(Frame.Width, Frame.Height)

    self.unitBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.unitBackdrop:SetAllPoints()
    self.unitBackdrop:SetBackdrop(BackdropTemplate)
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
    if Health.Direction == "RL" then
        unitHealthBar:SetReverseFill(true)
    elseif Health.Direction == "LR" then
        unitHealthBar:SetReverseFill(false)
    end

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
    self.unitLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitLeftText:SetPoint("LEFT", unitHighLevelFrame, "LEFT", LeftText.XOffset, LeftText.YOffset)
    self.unitLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitLeftText, LeftText.Tag)
    
    self.unitRightText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitRightText:SetFont(General.Font, RightText.FontSize, General.FontFlag)
    self.unitRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitRightText:SetPoint("RIGHT", unitHighLevelFrame, "RIGHT", RightText.XOffset, RightText.YOffset)
    self.unitRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitRightText, RightText.Tag)
    
    self.unitCenterText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitCenterText:SetFont(General.Font, CenterText.FontSize, General.FontFlag)
    self.unitCenterText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitCenterText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitCenterText:SetPoint("CENTER", unitHighLevelFrame, "CENTER", CenterText.XOffset, CenterText.YOffset)
    self.unitCenterText:SetJustifyH("CENTER")
    self:Tag(self.unitCenterText, CenterText.Tag)

    self.unitTopLeftText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitTopLeftText:SetFont(General.Font, TopLeftText.FontSize, General.FontFlag)
    self.unitTopLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitTopLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitTopLeftText:SetPoint("TOPLEFT", unitHighLevelFrame, "TOPLEFT", TopLeftText.XOffset, TopLeftText.YOffset)
    self.unitTopLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitTopLeftText, TopLeftText.Tag)

    self.unitTopRightText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitTopRightText:SetFont(General.Font, TopRightText.FontSize, General.FontFlag)
    self.unitTopRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitTopRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitTopRightText:SetPoint("TOPRIGHT", unitHighLevelFrame, "TOPRIGHT", TopRightText.XOffset, TopRightText.YOffset)
    self.unitTopRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitTopRightText, TopRightText.Tag)

    self.unitBottomLeftText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitBottomLeftText:SetFont(General.Font, BottomLeftText.FontSize, General.FontFlag)
    self.unitBottomLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitBottomLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitBottomLeftText:SetPoint("BOTTOMLEFT", unitHighLevelFrame, "BOTTOMLEFT", BottomLeftText.XOffset, BottomLeftText.YOffset)
    self.unitBottomLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitBottomLeftText, BottomLeftText.Tag)

    self.unitBottomRightText = unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitBottomRightText:SetFont(General.Font, BottomRightText.FontSize, General.FontFlag)
    self.unitBottomRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitBottomRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitBottomRightText:SetPoint("BOTTOMRIGHT", unitHighLevelFrame, "BOTTOMRIGHT", BottomRightText.XOffset, BottomRightText.YOffset)
    self.unitBottomRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitBottomRightText, BottomRightText.Tag)

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

function UUF:SpawnTargetFrame()
    local Frame = UUF.DB.global.Target.Frame
    oUF:RegisterStyle("UUF_Target", UUF.CreateTargetFrame)
    oUF:SetActiveStyle("UUF_Target")
    self.TargetFrame = oUF:Spawn("target", "UUF_Target")
    self.TargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end


function UUF:UpdateTargetFrame(FrameName)
    if not FrameName then return end

    local Frame = UUF.DB.global.Target.Frame
    local Health = UUF.DB.global.Target.Health
    local General = UUF.DB.global.General
    local Buffs = UUF.DB.global.Target.Buffs
    local Debuffs = UUF.DB.global.Target.Debuffs
    local TargetMarker = UUF.DB.global.Target.TargetMarker
    local LeftText = UUF.DB.global.Target.Texts.Left
    local RightText = UUF.DB.global.Target.Texts.Right
    local CenterText = UUF.DB.global.Target.Texts.Center
    local TopLeftText = UUF.DB.global.Target.Texts.AdditionalTexts.TopLeft
    local TopRightText = UUF.DB.global.Target.Texts.AdditionalTexts.TopRight
    local BottomLeftText = UUF.DB.global.Target.Texts.AdditionalTexts.BottomLeft
    local BottomRightText = UUF.DB.global.Target.Texts.AdditionalTexts.BottomRight

    local BackdropTemplate = {
        bgFile = General.BackgroundTexture,
        edgeFile = General.BorderTexture,
        edgeSize = General.BorderSize,
        insets = { left = General.BorderInset, right = General.BorderInset, top = General.BorderInset, bottom = General.BorderInset },
    }

    if FrameName then
        FrameName:ClearAllPoints()
        FrameName:SetSize(Frame.Width, Frame.Height)
        FrameName:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    end

    if FrameName.unitBackdrop then
        FrameName.unitBackdrop:SetBackdrop(BackdropTemplate)
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
        if Health.Direction == "RL" then
            FrameName.Health:SetReverseFill(true)
        elseif Health.Direction == "LR" then
            FrameName.Health:SetReverseFill(false)
        end
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
        FrameName.unitLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitLeftText:SetPoint("LEFT", FrameName, "LEFT", LeftText.XOffset, LeftText.YOffset)
        FrameName:Tag(FrameName.unitLeftText, LeftText.Tag)
    end

    if FrameName.unitRightText then
        FrameName.unitRightText:ClearAllPoints()
        FrameName.unitRightText:SetFont(General.Font, RightText.FontSize, General.FontFlag)
        FrameName.unitRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitRightText:SetPoint("RIGHT", FrameName, "RIGHT", RightText.XOffset, RightText.YOffset)
        FrameName:Tag(FrameName.unitRightText, RightText.Tag)
    end

    if FrameName.unitCenterText then
        FrameName.unitCenterText:ClearAllPoints()
        FrameName.unitCenterText:SetFont(General.Font, CenterText.FontSize, General.FontFlag)
        FrameName.unitCenterText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitCenterText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitCenterText:SetPoint("CENTER", FrameName, "CENTER", CenterText.XOffset, CenterText.YOffset)
        FrameName:Tag(FrameName.unitCenterText, CenterText.Tag)
    end

    if FrameName.unitTopLeftText then
        FrameName.unitTopLeftText:ClearAllPoints()
        FrameName.unitTopLeftText:SetFont(General.Font, TopLeftText.FontSize, General.FontFlag)
        FrameName.unitTopLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitTopLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitTopLeftText:SetPoint("TOPLEFT", FrameName, "TOPLEFT", TopLeftText.XOffset, TopLeftText.YOffset)
        FrameName:Tag(FrameName.unitTopLeftText, TopLeftText.Tag)
    end

    if FrameName.unitTopRightText then
        FrameName.unitTopRightText:ClearAllPoints()
        FrameName.unitTopRightText:SetFont(General.Font, TopRightText.FontSize, General.FontFlag)
        FrameName.unitTopRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitTopRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitTopRightText:SetPoint("TOPRIGHT", FrameName, "TOPRIGHT", TopRightText.XOffset, TopRightText.YOffset)
        FrameName:Tag(FrameName.unitTopRightText, TopRightText.Tag)
    end

    if FrameName.unitBottomLeftText then
        FrameName.unitBottomLeftText:ClearAllPoints()
        FrameName.unitBottomLeftText:SetFont(General.Font, BottomLeftText.FontSize, General.FontFlag)
        FrameName.unitBottomLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitBottomLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitBottomLeftText:SetPoint("BOTTOMLEFT", FrameName, "BOTTOMLEFT", BottomLeftText.XOffset, BottomLeftText.YOffset)
        FrameName:Tag(FrameName.unitBottomLeftText, BottomLeftText.Tag)
    end

    if FrameName.unitBottomRightText then
        FrameName.unitBottomRightText:ClearAllPoints()
        FrameName.unitBottomRightText:SetFont(General.Font, BottomRightText.FontSize, General.FontFlag)
        FrameName.unitBottomRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
        FrameName.unitBottomRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
        FrameName.unitBottomRightText:SetPoint("BOTTOMRIGHT", FrameName, "BOTTOMRIGHT", BottomRightText.XOffset, BottomRightText.YOffset)
        FrameName:Tag(FrameName.unitBottomRightText, BottomRightText.Tag)
    end

    if FrameName.RaidTargetIndicator and TargetMarker.Enabled then
        FrameName.RaidTargetIndicator:ClearAllPoints()
        FrameName.RaidTargetIndicator:SetSize(TargetMarker.Size, TargetMarker.Size)
        FrameName.RaidTargetIndicator:SetPoint(TargetMarker.AnchorFrom, FrameName, TargetMarker.AnchorTo, TargetMarker.XOffset, TargetMarker.YOffset)
    end

    FrameName:UpdateTags()
end
