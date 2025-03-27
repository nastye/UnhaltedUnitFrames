local _, UUF = ...
local UF = UUF.oUF

function UUF:CreatePlayerFrame()
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global.Player.Frame
    local Portrait = UUF.DB.global.Player.Portrait
    local Health = UUF.DB.global.Player.Health
    local PowerBar = UUF.DB.global.Player.PowerBar
    local HealthPrediction = Health.HealthPrediction
    local Absorbs = HealthPrediction.Absorbs
    local HealAbsorbs = HealthPrediction.HealAbsorbs
    local Buffs = UUF.DB.global.Player.Buffs
    local Debuffs = UUF.DB.global.Player.Debuffs
    local TargetMarker = UUF.DB.global.Player.TargetMarker
    local LeftText = UUF.DB.global.Player.Texts.Left
    local RightText = UUF.DB.global.Player.Texts.Right
    local CenterText = UUF.DB.global.Player.Texts.Center
    local TopLeftText = UUF.DB.global.Player.Texts.AdditionalTexts.TopLeft
    local TopRightText = UUF.DB.global.Player.Texts.AdditionalTexts.TopRight
    local BottomLeftText = UUF.DB.global.Player.Texts.AdditionalTexts.BottomLeft
    local BottomRightText = UUF.DB.global.Player.Texts.AdditionalTexts.BottomRight
    local MouseoverHighlight = UUF.DB.global.General.MouseoverHighlight
    
    local BackdropTemplate = {
        bgFile = General.BackgroundTexture,
        edgeFile = General.BorderTexture,
        edgeSize = General.BorderSize,
        insets = { left = General.BorderInset, right = General.BorderInset, top = General.BorderInset, bottom = General.BorderInset },
    }
    
    self:SetSize(Frame.Width, Frame.Height)

    self.unitBorder = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.unitBorder:SetAllPoints()
    self.unitBorder:SetBackdrop(BackdropTemplate)
    self.unitBorder:SetBackdropColor(0,0,0,0)
    self.unitBorder:SetBackdropBorderColor(unpack(General.BorderColour))
    self.unitBorder:SetFrameLevel(1)

    if MouseoverHighlight.Enabled then
        self.unitHighlight = CreateFrame("Frame", nil, self, "BackdropTemplate")
        self.unitHighlight:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
        self.unitHighlight:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
        local MHR, MHG, MHB, MHA = unpack(MouseoverHighlight.Colour)
        if MouseoverHighlight.Style == "BORDER" then
            self.unitHighlight:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
            self.unitHighlight:SetBackdropColor(0, 0, 0, 0)
            self.unitHighlight:SetBackdropBorderColor(MHR, MHG, MHB, MHA)
            self.unitHighlight:SetFrameLevel(20)
            self.unitHighlight:Hide()
        elseif MouseoverHighlight.Style == "HIGHLIGHT" then
            self.unitHighlight:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
            self.unitHighlight:SetBackdropColor(MHR, MHG, MHB, MHA)
            self.unitHighlight:SetBackdropBorderColor(0, 0, 0, 0)
            self.unitHighlight:SetFrameLevel(20)
            self.unitHighlight:Hide()
        end
    end

    self.unitHealthBar = CreateFrame("StatusBar", nil, self)
    self.unitHealthBar:SetSize(Frame.Width - 2, Frame.Height - 2)
    self.unitHealthBar:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    self.unitHealthBar:SetStatusBarTexture(General.ForegroundTexture)
    self.unitHealthBar.colorClass = General.ColourByClass
    self.unitHealthBar.colorReaction = General.ColourByClass
    self.unitHealthBar.colorDisconnected = General.ColourIfDisconnected
    self.unitHealthBar.colorTapping = General.ColourIfTapped
    self.unitHealthBar.colorHealth = true
    self.unitHealthBar:SetMinMaxValues(0, 100)
    if Health.Direction == "RL" then
        self.unitHealthBar:SetReverseFill(true)
    elseif Health.Direction == "LR" then
        self.unitHealthBar:SetReverseFill(false)
    end

    self.unitHealthBar.Background = self.unitHealthBar:CreateTexture(nil, "BACKGROUND")
    self.unitHealthBar.Background:SetAllPoints()
    self.unitHealthBar.Background:SetTexture(General.BackgroundTexture)
    if General.ColourBackgroundByHealth then
        self.unitHealthBar.Background.multiplier = General.BackgroundMultiplier
        self.unitHealthBar.bg = self.unitHealthBar.Background
    else
        self.unitHealthBar.Background:SetVertexColor(unpack(General.BackgroundColour))
        self.unitHealthBar.bg = nil
    end

    if Absorbs.Enabled then
        self.unitAbsorbs = CreateFrame("StatusBar", nil, self.unitHealthBar)
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
    end

    if HealAbsorbs.Enabled then
        self.unitHealAbsorbs = CreateFrame("StatusBar", nil, self.unitHealthBar)
        self.unitHealAbsorbs:SetStatusBarTexture(General.ForegroundTexture)
        local UHAR, UHAG, UHAB, UHAA = unpack(HealAbsorbs.Colour)
        self.unitHealAbsorbs:SetStatusBarColor(UHAR, UHAG, UHAB, UHAA)
        self.unitHealAbsorbs:SetMinMaxValues(0, 100)
        local HealthBarTexture = self.unitHealthBar:GetStatusBarTexture()
        if HealthBarTexture then
            self.unitHealAbsorbs:ClearAllPoints()
            if Health.Direction == "RL" then
                self.unitHealAbsorbs:SetReverseFill(false)
                self.unitHealAbsorbs:SetPoint("TOPLEFT", HealthBarTexture, "TOPLEFT")
                self.unitHealAbsorbs:SetPoint("BOTTOMRIGHT", HealthBarTexture, "BOTTOMRIGHT")
            else
                self.unitHealAbsorbs:SetReverseFill(true)
                self.unitHealAbsorbs:SetPoint("TOPRIGHT", HealthBarTexture, "TOPRIGHT")
                self.unitHealAbsorbs:SetPoint("BOTTOMLEFT", HealthBarTexture, "BOTTOMLEFT")
            end
        end
        self.unitHealAbsorbs:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        self.unitHealAbsorbs:SetFrameLevel(4)
        self.unitHealAbsorbs:Hide()
    end

    self.HealthPrediction = {
        myBar = nil,
        otherBar = nil,
        absorbBar = Absorbs.Enabled and self.unitAbsorbs or nil,
        healAbsorbBar = self.unitHealAbsorbs,
        maxOverflow = 1,
        PostUpdate = function(_, unit, _, _, absorb, _, _, _)
            if not unit then return end
            local healthBar = self.unitHealthBar
            local absorbBar = self.unitAbsorbs
            local maxHealth = UnitHealthMax(unit) or 0
            if not absorbBar or maxHealth == 0 or not absorb or absorb == 0 then if absorbBar then absorbBar:SetAlpha(0) end return end
            local overflowLimit = maxHealth * self.HealthPrediction.maxOverflow
            local shownAbsorb = math.min(absorb, overflowLimit)
            absorbBar:SetMinMaxValues(0, maxHealth)
            absorbBar:SetValue(shownAbsorb)
            absorbBar:SetAlpha(1)
        end,
    }

    self.unitHealthBar:SetFrameLevel(2)
    self.Health = self.unitHealthBar

    if Portrait.Enabled then
        self.unitPortraitBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
        self.unitPortraitBackdrop:SetSize(Portrait.Size, Portrait.Size)
        self.unitPortraitBackdrop:SetPoint(Portrait.AnchorFrom, self, Portrait.AnchorTo, Portrait.XOffset, Portrait.YOffset)
        self.unitPortraitBackdrop:SetBackdrop(BackdropTemplate)
        self.unitPortraitBackdrop:SetBackdropColor(unpack(General.BackgroundColour))
        self.unitPortraitBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
        
        self.unitPortrait = self.unitPortraitBackdrop:CreateTexture(nil, "OVERLAY")
        self.unitPortrait:SetSize(self.unitPortraitBackdrop:GetHeight() - 2, self.unitPortraitBackdrop:GetHeight() - 2)
        self.unitPortrait:SetPoint("CENTER", self.unitPortraitBackdrop, "CENTER", 0, 0)
        self.unitPortrait:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.Portrait = self.unitPortrait
    end

    if PowerBar.Enabled then
        self.unitPowerBarBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
        self.unitPowerBarBackdrop:SetSize(Frame.Width, PowerBar.Height)
        self.unitPowerBarBackdrop:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
        self.unitPowerBarBackdrop:SetBackdrop(BackdropTemplate)
        self.unitPowerBarBackdrop:SetBackdropColor(0,0,0,0)
        self.unitPowerBarBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
        self.unitPowerBarBackdrop:SetFrameLevel(4)

        self.unitPowerBar = CreateFrame("StatusBar", nil, self.unitPowerBarBackdrop)
        self.unitPowerBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 1)
        self.unitPowerBar:SetSize(Frame.Width - 2, PowerBar.Height - 2)
        self.unitPowerBar:SetStatusBarTexture(General.ForegroundTexture)
        self.unitPowerBar:SetStatusBarColor(unpack(PowerBar.Colour))
        self.unitPowerBar:SetMinMaxValues(0, 100)
        self.unitPowerBar.colorPower = PowerBar.ColourByType
        self.unitHealthBar:SetHeight(self:GetHeight() - PowerBar.Height - 1)

        self.unitPowerBar.Background = self.unitPowerBar:CreateTexture(nil, "BACKGROUND")
        self.unitPowerBar.Background:SetAllPoints()
        self.unitPowerBar.Background:SetTexture(General.BackgroundTexture)
        if PowerBar.ColourBackgroundByType then 
            self.unitPowerBar.Background.multiplier = PowerBar.BackgroundMultiplier
            self.unitPowerBar.bg = self.unitPowerBar.Background
        else
            self.unitPowerBar.Background:SetVertexColor(unpack(PowerBar.BackgroundColour))
            self.unitPowerBar.bg = nil
        end
        self.Power = self.unitPowerBar
    end

    if Buffs.Enabled then
        self.unitBuffs = CreateFrame("Frame", nil, self)
        self.unitBuffs:SetSize(self:GetWidth(), Buffs.Size)
        self.unitBuffs:SetPoint(Buffs.AnchorFrom, self, Buffs.AnchorTo, Buffs.XOffset, Buffs.YOffset)
        self.unitBuffs.size = Buffs.Size
        self.unitBuffs.spacing = Buffs.Spacing
        self.unitBuffs.num = Buffs.Num
        self.unitBuffs.initialAnchor = Buffs.AnchorFrom
        self.unitBuffs.onlyShowPlayer = Buffs.OnlyShowPlayer
        self.unitBuffs["growth-x"] = Buffs.GrowthX
        self.unitBuffs["growth-y"] = Buffs.GrowthY
        self.unitBuffs.filter = "HELPFUL"
        self.unitBuffs.PostCreateButton = function(_, button) UUF:PostCreateButton(_, button, "Player", "HELPFUL") end
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
        self.unitDebuffs.onlyShowPlayer = Debuffs.OnlyShowPlayer
        self.unitDebuffs["growth-x"] = Debuffs.GrowthX
        self.unitDebuffs["growth-y"] = Debuffs.GrowthY
        self.unitDebuffs.filter = "HARMFUL"
        self.unitDebuffs.PostCreateButton = function(_, button) UUF:PostCreateButton(_, button, "Player", "HARMFUL") end
        self.Debuffs = self.unitDebuffs
    end

    self.unitHighLevelFrame = CreateFrame("Frame", nil, self)
    self.unitHighLevelFrame:SetSize(Frame.Width, Frame.Height)
    self.unitHighLevelFrame:SetPoint("CENTER", 0, 0)
    self.unitHighLevelFrame:SetFrameLevel(999)

    self.unitLeftText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitLeftText:SetFont(General.Font, LeftText.FontSize, General.FontFlag)
    self.unitLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitLeftText:SetPoint("LEFT", self.unitHighLevelFrame, "LEFT", LeftText.XOffset, LeftText.YOffset)
    self.unitLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitLeftText, LeftText.Tag)
    
    self.unitRightText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitRightText:SetFont(General.Font, RightText.FontSize, General.FontFlag)
    self.unitRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitRightText:SetPoint("RIGHT", self.unitHighLevelFrame, "RIGHT", RightText.XOffset, RightText.YOffset)
    self.unitRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitRightText, RightText.Tag)
    
    self.unitCenterText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitCenterText:SetFont(General.Font, CenterText.FontSize, General.FontFlag)
    self.unitCenterText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitCenterText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitCenterText:SetPoint("CENTER", self.unitHighLevelFrame, "CENTER", CenterText.XOffset, CenterText.YOffset)
    self.unitCenterText:SetJustifyH("CENTER")
    self:Tag(self.unitCenterText, CenterText.Tag)

    self.unitTopLeftText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitTopLeftText:SetFont(General.Font, TopLeftText.FontSize, General.FontFlag)
    self.unitTopLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitTopLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitTopLeftText:SetPoint("TOPLEFT", self.unitHighLevelFrame, "TOPLEFT", TopLeftText.XOffset, TopLeftText.YOffset)
    self.unitTopLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitTopLeftText, TopLeftText.Tag)

    self.unitTopRightText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitTopRightText:SetFont(General.Font, TopRightText.FontSize, General.FontFlag)
    self.unitTopRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitTopRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitTopRightText:SetPoint("TOPRIGHT", self.unitHighLevelFrame, "TOPRIGHT", TopRightText.XOffset, TopRightText.YOffset)
    self.unitTopRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitTopRightText, TopRightText.Tag)

    self.unitBottomLeftText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitBottomLeftText:SetFont(General.Font, BottomLeftText.FontSize, General.FontFlag)
    self.unitBottomLeftText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitBottomLeftText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitBottomLeftText:SetPoint("BOTTOMLEFT", self.unitHighLevelFrame, "BOTTOMLEFT", BottomLeftText.XOffset, BottomLeftText.YOffset)
    self.unitBottomLeftText:SetJustifyH("LEFT")
    self:Tag(self.unitBottomLeftText, BottomLeftText.Tag)

    self.unitBottomRightText = self.unitHighLevelFrame:CreateFontString(nil, "OVERLAY")
    self.unitBottomRightText:SetFont(General.Font, BottomRightText.FontSize, General.FontFlag)
    self.unitBottomRightText:SetShadowColor(General.FontShadowColour[1], General.FontShadowColour[2], General.FontShadowColour[3], General.FontShadowColour[4])
    self.unitBottomRightText:SetShadowOffset(General.FontShadowXOffset, General.FontShadowYOffset)
    self.unitBottomRightText:SetPoint("BOTTOMRIGHT", self.unitHighLevelFrame, "BOTTOMRIGHT", BottomRightText.XOffset, BottomRightText.YOffset)
    self.unitBottomRightText:SetJustifyH("RIGHT")
    self:Tag(self.unitBottomRightText, BottomRightText.Tag)

    if TargetMarker.Enabled then
        self.unitTargetMarker = self.unitHighLevelFrame:CreateTexture(nil, "OVERLAY")
        self.unitTargetMarker:SetSize(TargetMarker.Size, TargetMarker.Size)
        self.unitTargetMarker:SetPoint(TargetMarker.AnchorFrom, self.unitHighLevelFrame, TargetMarker.AnchorTo, TargetMarker.XOffset, TargetMarker.YOffset)
        self.RaidTargetIndicator = self.unitTargetMarker
    end

    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type1", "target")
    self:SetAttribute("*type2", "togglemenu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:HookScript("OnEnter", function() if not MouseoverHighlight.Enabled then return end self.unitHighlight:Show() end)
    self:HookScript("OnLeave", function() if not MouseoverHighlight.Enabled then return end self.unitHighlight:Hide() end)
end

function UUF:SpawnPlayerFrame()
    local Frame = UUF.DB.global.Player.Frame
    UF:RegisterStyle("UUF_Player", UUF.CreatePlayerFrame)
    UF:SetActiveStyle("UUF_Player")
    self.PlayerFrame = UF:Spawn("player", "UUF_Player")
    self.PlayerFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end