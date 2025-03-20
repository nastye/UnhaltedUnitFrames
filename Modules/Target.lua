local _, UUF = ...
local oUF = UUF.oUF

function UUF:CreateTargetFrame()
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global.Target.Frame
    local Health = UUF.DB.global.Target.Health
    local Absorbs = UUF.DB.global.Target.Health.Absorbs
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

    self.unitHealthBar = CreateFrame("StatusBar", nil, self)
    self.unitHealthBar:SetSize(Frame.Width - 2, Frame.Height - 2)
    self.unitHealthBar:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    self.unitHealthBar:SetStatusBarTexture(General.ForegroundTexture)
    self.unitHealthBar:SetStatusBarColor(unpack(General.ForegroundColour))
    self.unitHealthBar:SetMinMaxValues(0, 100)
    self.unitHealthBar.colorReaction = General.ColourByReaction
    self.unitHealthBar.colorClass = General.ColourByClass
    self.unitHealthBar.colorDisconnected = General.ColourIfDisconnected
    self.unitHealthBar.colorTapping = General.ColourIfTapped
    if Health.Direction == "RL" then
        self.unitHealthBar:SetReverseFill(true)
    elseif Health.Direction == "LR" then
        self.unitHealthBar:SetReverseFill(false)
    end

    if Absorbs.Enabled then
        self.unitAbsorbs = CreateFrame("StatusBar", nil, self)
        self.unitAbsorbs:SetStatusBarTexture(General.ForegroundTexture)
        local UAR, UAG, UAB, UAA = unpack(Absorbs.Colour)
        self.unitAbsorbs:SetStatusBarColor(UAR, UAG, UAB, UAA)
        self.unitAbsorbs:SetMinMaxValues(0, 100)
        if Health.Direction == "RL" then
            self.unitAbsorbs:SetReverseFill(true)
            self.unitAbsorbs:SetPoint("TOPRIGHT", self.unitHealthBar:GetStatusBarTexture(), "TOPLEFT")
            self.unitAbsorbs:SetPoint("BOTTOMRIGHT", self.unitHealthBar:GetStatusBarTexture(), "BOTTOMLEFT")
        elseif Health.Direction == "LR" then
            self.unitAbsorbs:SetReverseFill(false)
            self.unitAbsorbs:SetPoint("TOPLEFT", self.unitHealthBar:GetStatusBarTexture(), "TOPRIGHT")
            self.unitAbsorbs:SetPoint("BOTTOMLEFT", self.unitHealthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        end
        self.unitAbsorbs:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        self.unitAbsorbs:SetFrameLevel(3)
        self.unitAbsorbs:Hide()
        self.Absorbs = self.unitAbsorbs

        self.HealthPrediction = {
            myBar = nil,
            otherBar = nil,
            absorbBar = Absorbs.Enabled and self.Absorbs or nil,
            healAbsorbBar = nil,
            maxOverflow = 1,
        }
    end

    self.unitHealthBar:SetFrameLevel(2)
    self.Health = self.unitHealthBar

    if Buffs.Enabled then
        self.unitBuffs = CreateFrame("Frame", nil, self)
        self.unitBuffs:SetSize(self:GetWidth(), Buffs.Size)
        self.unitBuffs:SetPoint(Buffs.AnchorFrom, self, Buffs.AnchorTo, Buffs.XOffset, Buffs.YOffset)
        self.unitBuffs.size = Buffs.Size
        self.unitBuffs.spacing = Buffs.Spacing
        self.unitBuffs.num = Buffs.Num
        self.unitBuffs.initialAnchor = Buffs.AnchorFrom
        self.unitBuffs["growth-x"] = Buffs.GrowthX
        self.unitBuffs["growth-y"] = Buffs.GrowthY
        self.unitBuffs.filter = "HELPFUL"
        self.unitBuffs.PostCreateButton = function(_, button) UUF:PostCreateButton(_, button) end
        self.Buffs = self.unitBuffs
    end

    if Debuffs.Enabled then
        self.unitDebuffs = CreateFrame("Frame", nil, self)
        self.unitDebuffs:SetSize(self:GetWidth(), Debuffs.Size)
        self.unitDebuffs:SetPoint(Debuffs.AnchorFrom, self, Debuffs.AnchorTo, Debuffs.XOffset, Debuffs.YOffset)
        self.unitDebuffs.size = Debuffs.Size
        self.unitDebuffs.spacing = Debuffs.Spacing
        self.unitDebuffs.num = Debuffs.Num
        self.unitDebuffs.initialAnchor = Debuffs.AnchorFrom
        self.unitDebuffs["growth-x"] = Debuffs.GrowthX
        self.unitDebuffs["growth-y"] = Debuffs.GrowthY
        self.unitDebuffs.filter = "HARMFUL"
        self.unitDebuffs.PostCreateButton = function(_, button) UUF:PostCreateButton(_, button) end
        self.Debuffs = self.unitDebuffs
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
        self.unitTargetMarker = unitHighLevelFrame:CreateTexture(nil, "OVERLAY")
        self.unitTargetMarker:SetSize(TargetMarker.Size, TargetMarker.Size)
        self.unitTargetMarker:SetPoint(TargetMarker.AnchorFrom, unitHighLevelFrame, TargetMarker.AnchorTo, TargetMarker.XOffset, TargetMarker.YOffset)
        self.RaidTargetIndicator = self.unitTargetMarker
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
    local Absorbs = UUF.DB.global.Target.Health.Absorbs
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

    if FrameName.unitHealthBar then
        FrameName.unitHealthBar:SetSize(Frame.Width - 2, Frame.Height - 2)
        FrameName.unitHealthBar:ClearAllPoints()
        FrameName.unitHealthBar:SetPoint("TOPLEFT", FrameName, "TOPLEFT", 1, -1)
        FrameName.unitHealthBar:SetStatusBarTexture(General.ForegroundTexture)
        FrameName.unitHealthBar:SetStatusBarColor(unpack(General.ForegroundColour))
        FrameName.unitHealthBar.colorReaction = General.ColourByReaction
        FrameName.unitHealthBar.colorClass = General.ColourByClass
        FrameName.unitHealthBar.colorDisconnected = General.ColourIfDisconnected
        if Health.Direction == "RL" then
            FrameName.unitHealthBar:SetReverseFill(true)
        elseif Health.Direction == "LR" then
            FrameName.unitHealthBar:SetReverseFill(false)
        end
        FrameName.unitHealthBar:ForceUpdate()
    end

    if FrameName.unitAbsorbs then
        if Health.Direction == "RL" then
            FrameName.unitAbsorbs:SetReverseFill(true)
            FrameName.unitAbsorbs:ClearAllPoints()
            FrameName.unitAbsorbs:SetPoint("TOPRIGHT", FrameName.unitHealthBar:GetStatusBarTexture(), "TOPLEFT")
            FrameName.unitAbsorbs:SetPoint("BOTTOMRIGHT", FrameName.unitHealthBar:GetStatusBarTexture(), "BOTTOMLEFT")
        elseif Health.Direction == "LR" then
            FrameName.unitAbsorbs:SetReverseFill(false)
            FrameName.unitAbsorbs:ClearAllPoints()
            FrameName.unitAbsorbs:SetPoint("TOPLEFT", FrameName.unitHealthBar:GetStatusBarTexture(), "TOPRIGHT")
            FrameName.unitAbsorbs:SetPoint("BOTTOMLEFT", FrameName.unitHealthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        end
        FrameName.unitAbsorbs:SetStatusBarColor(unpack(Absorbs.Colour))
        FrameName.unitAbsorbs:SetStatusBarTexture(General.ForegroundTexture)
        FrameName.unitHealthBar:ForceUpdate()
    end

    if Buffs.Enabled then
        FrameName.unitBuffs:ClearAllPoints()
        FrameName.unitBuffs:SetSize(FrameName:GetWidth(), Buffs.Size)
        FrameName.unitBuffs:SetPoint(Buffs.AnchorFrom, FrameName, Buffs.AnchorTo, Buffs.XOffset, Buffs.YOffset)
        FrameName.unitBuffs.size = Buffs.Size
        FrameName.unitBuffs.spacing = Buffs.Spacing
        FrameName.unitBuffs.num = Buffs.Num
        FrameName.unitBuffs.initialAnchor = Buffs.AnchorFrom
        FrameName.unitBuffs["growth-x"] = Buffs.GrowthX
        FrameName.unitBuffs["growth-y"] = Buffs.GrowthY
        FrameName.unitBuffs.filter = "HELPFUL"
        FrameName.unitBuffs:Show()
        FrameName.unitBuffs:ForceUpdate()
    else
        if FrameName.unitBuffs then
            FrameName.unitBuffs:Hide()
        end
    end

    if Debuffs.Enabled then
        FrameName.unitDebuffs:ClearAllPoints()
        FrameName.unitDebuffs:SetSize(FrameName:GetWidth(), Debuffs.Size)
        FrameName.unitDebuffs:SetPoint(Debuffs.AnchorFrom, FrameName, Debuffs.AnchorTo, Debuffs.XOffset, Debuffs.YOffset)
        FrameName.unitDebuffs.size = Debuffs.Size
        FrameName.unitDebuffs.spacing = Debuffs.Spacing
        FrameName.unitDebuffs.num = Debuffs.Num
        FrameName.unitDebuffs.initialAnchor = Debuffs.AnchorFrom
        FrameName.unitDebuffs["growth-x"] = Debuffs.GrowthX
        FrameName.unitDebuffs["growth-y"] = Debuffs.GrowthY
        FrameName.unitDebuffs.filter = "HELPFUL"
        FrameName.unitDebuffs:Show()
        FrameName.unitDebuffs:ForceUpdate()
    else
        if FrameName.unitDebuffs then
            FrameName.unitDebuffs:Hide()
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

    if FrameName.unitTargetMarker and TargetMarker.Enabled then
        FrameName.unitTargetMarker:ClearAllPoints()
        FrameName.unitTargetMarker:SetSize(TargetMarker.Size, TargetMarker.Size)
        FrameName.unitTargetMarker:SetPoint(TargetMarker.AnchorFrom, FrameName, TargetMarker.AnchorTo, TargetMarker.XOffset, TargetMarker.YOffset)
    end

    FrameName:UpdateTags()
end
