local _, UUF = ...
local oUF = UUF.oUF
UUF.Frames = {
    ["player"] = "Player",
    ["target"] = "Target",
    ["focus"] = "Focus",
    ["pet"] = "Pet",
    ["targettarget"] = "TargetTarget",
}

local function PostCreateButton(_, button, Unit, AuraType)
    local General = UUF.DB.global.General
    local BuffCount = UUF.DB.global[Unit].Buffs.Count
    local DebuffCount = UUF.DB.global[Unit].Debuffs.Count
    -- Icon Options
    local auraIcon = button.Icon
    auraIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    -- Border Options
    local buttonBorder = CreateFrame("Frame", nil, button, "BackdropTemplate")
    buttonBorder:SetAllPoints()
    buttonBorder:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
    buttonBorder:SetBackdropBorderColor(0, 0, 0, 1)

    -- Cooldown Options
    local auraCooldown = button.Cooldown
    if auraCooldown then
        auraCooldown:SetDrawEdge(false)
        auraCooldown:SetReverse(true)
    end

    -- Count Options
    local auraCount = button.Count
    if AuraType == "HELPFUL" then
        auraCount:ClearAllPoints()
        auraCount:SetPoint(BuffCount.AnchorFrom, button, BuffCount.AnchorTo, BuffCount.XOffset, BuffCount.YOffset)
        auraCount:SetFont(General.Font, BuffCount.FontSize, "OUTLINE")
        auraCount:SetJustifyH("CENTER")
        auraCount:SetTextColor(1, 1, 1, 1)
    elseif AuraType == "HARMFUL" then
        auraCount:ClearAllPoints()
        auraCount:SetPoint(DebuffCount.AnchorFrom, button, DebuffCount.AnchorTo, DebuffCount.XOffset, DebuffCount.YOffset)
        auraCount:SetFont(General.Font, DebuffCount.FontSize, "OUTLINE")
        auraCount:SetJustifyH("CENTER")
        auraCount:SetTextColor(1, 1, 1, 1)
    end
end

local function PostUpdateButton(_, button, Unit, AuraType)
    local General = UUF.DB.global.General
    local BuffCount = UUF.DB.global[Unit].Buffs.Count
    local DebuffCount = UUF.DB.global[Unit].Debuffs.Count
    -- Icon Options
    local auraIcon = button.Icon
    auraIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    -- Border Options
    local buttonBorder = CreateFrame("Frame", nil, button, "BackdropTemplate")
    buttonBorder:SetAllPoints()
    buttonBorder:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
    buttonBorder:SetBackdropBorderColor(0, 0, 0, 1)

    -- Cooldown Options
    local auraCooldown = button.Cooldown
    if auraCooldown then
        auraCooldown:SetDrawEdge(false)
        auraCooldown:SetReverse(true)
    end

    -- Count Options
    local auraCount = button.Count
    if AuraType == "HELPFUL" then 
        auraCount:ClearAllPoints()
        auraCount:SetPoint(BuffCount.AnchorFrom, button, BuffCount.AnchorTo, BuffCount.XOffset, BuffCount.YOffset)
        auraCount:SetFont(General.Font, BuffCount.FontSize, "OUTLINE")
        auraCount:SetJustifyH("CENTER")
        auraCount:SetTextColor(1, 1, 1, 1)
    elseif AuraType == "HARMFUL" then
        auraCount:ClearAllPoints()
        auraCount:SetPoint(DebuffCount.AnchorFrom, button, DebuffCount.AnchorTo, DebuffCount.XOffset, DebuffCount.YOffset)
        auraCount:SetFont(General.Font, DebuffCount.FontSize, "OUTLINE")
        auraCount:SetJustifyH("CENTER")
        auraCount:SetTextColor(1, 1, 1, 1)
    end
end

function UUF:FormatLargeNumber(value)
    if value < 999 then
        return value
    elseif value < 999999 then
        return string.format("%.1fk", value / 1000)
    elseif value < 99999999 then
        return string.format("%.2fm", value / 1000000)
    elseif value < 999999999 then
        return string.format("%.1fm", value / 1000000)
    elseif value < 99999999999 then
        return string.format("%.2fb", value / 1000000000)
    end
    return string.format("%db", value / 1000000000)
end

function UUF:WrapTextInColor(unitName, unit)
    if not unitName then return "" end
    if not unit then return unitName end
    local unitColor
    if UnitIsPlayer(unit) then
        local unitClass = select(2, UnitClass(unit))
        unitColor = RAID_CLASS_COLORS[unitClass]
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            local r, g, b = unpack(oUF.colors.reaction[reaction])
            unitColor = { r = r, g = g, b = b }
        end
    end
    if unitColor then
        return string.format("|cff%02x%02x%02x%s|r", unitColor.r * 255, unitColor.g * 255, unitColor.b * 255, unitName)
    end
    return unitName
end

UUF.nameBlacklist = {
    ["the"] = true,
    ["of"] = true,
    ["Tentacle"] = true,
    ["Apprentice"] = true,
    ["Denizen"] = true,
    ["Emissary"] = true,
    ["Howlis"] = true,
    ["Terror"] = true,
    ["Totem"] = true,
    ["Waycrest"] = true,
    ["Aspect"] = true
}

function UUF:ShortenName(name, nameBlacklist)
    if not name or name == "" then return nil end
    local words = { strsplit(" ", name) }
    return nameBlacklist[words[2]] and words[1] or words[#words] or name
end


function UUF:ResetDefaultSettings()
    UUF.DB:ResetDB()
    UUF:CreateReloadPrompt()
end

function UUF:CreateUnitFrame(Unit)
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global[Unit].Frame
    local Portrait = UUF.DB.global[Unit].Portrait
    local Health = UUF.DB.global[Unit].Health
    local PowerBar = UUF.DB.global[Unit].PowerBar
    local HealthPrediction = Health.HealthPrediction
    local Absorbs = HealthPrediction.Absorbs
    local HealAbsorbs = HealthPrediction.HealAbsorbs
    local Buffs = UUF.DB.global[Unit].Buffs
    local Debuffs = UUF.DB.global[Unit].Debuffs
    local TargetMarker = UUF.DB.global[Unit].TargetMarker
    local LeftText = UUF.DB.global[Unit].Texts.Left
    local RightText = UUF.DB.global[Unit].Texts.Right
    local CenterText = UUF.DB.global[Unit].Texts.Center
    local TopLeftText = UUF.DB.global[Unit].Texts.AdditionalTexts.TopLeft
    local TopRightText = UUF.DB.global[Unit].Texts.AdditionalTexts.TopRight
    local BottomLeftText = UUF.DB.global[Unit].Texts.AdditionalTexts.BottomLeft
    local BottomRightText = UUF.DB.global[Unit].Texts.AdditionalTexts.BottomRight

    if (Unit == "Focus" or Unit == "TargetTarget" or Unit == "Pet") and not Frame.Enabled then return end
    
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

    self.unitHighlight = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.unitHighlight:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    self.unitHighlight:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
    self.unitHighlight:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
    self.unitHighlight:SetBackdropColor(0, 0, 0, 0)
    self.unitHighlight:SetBackdropBorderColor(1, 1, 1, 1)
    self.unitHighlight:SetFrameLevel(20)
    self.unitHighlight:Hide()

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
        self.unitPortrait:SetTexCoord(0.2, 0.8, 0.2, 0.8)
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
        self.unitBuffs.PostCreateButton = function(_, button) PostCreateButton(_, button, Unit, "HELPFUL") end
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
        self.unitDebuffs.PostCreateButton = function(_, button) PostCreateButton(_, button, Unit, "HARMFUL") end
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
    self:HookScript("OnEnter", function() self.unitHighlight:Show() end)
    self:HookScript("OnLeave", function() self.unitHighlight:Hide() end)
end

function UUF:UpdateUnitFrame(FrameName)
    if not FrameName then return end

    local Unit = UUF.Frames[FrameName.unit] or "Boss"
    local Frame = UUF.DB.global[Unit].Frame
    local Portrait = UUF.DB.global[Unit].Portrait
    local Health = UUF.DB.global[Unit].Health
    local HealthPrediction = Health.HealthPrediction
    local Absorbs = HealthPrediction.Absorbs
    local HealAbsorbs = HealthPrediction.HealAbsorbs
    local PowerBar = UUF.DB.global[Unit].PowerBar
    local General = UUF.DB.global.General
    local Buffs = UUF.DB.global[Unit].Buffs
    local Debuffs = UUF.DB.global[Unit].Debuffs
    local TargetMarker = UUF.DB.global[Unit].TargetMarker
    local LeftText = UUF.DB.global[Unit].Texts.Left
    local RightText = UUF.DB.global[Unit].Texts.Right
    local CenterText = UUF.DB.global[Unit].Texts.Center
    local TopLeftText = UUF.DB.global[Unit].Texts.AdditionalTexts.TopLeft
    local TopRightText = UUF.DB.global[Unit].Texts.AdditionalTexts.TopRight
    local BottomLeftText = UUF.DB.global[Unit].Texts.AdditionalTexts.BottomLeft
    local BottomRightText = UUF.DB.global[Unit].Texts.AdditionalTexts.BottomRight
    local Range = UUF.DB.global[Unit].Range

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

    if FrameName.unitBorder then
        FrameName.unitBorder:SetBackdropBorderColor(unpack(General.BorderColour))
    end

    if FrameName.unitHealthBar then
        FrameName.unitHealthBar:SetSize(Frame.Width - 2, Frame.Height - 2)
        FrameName.unitHealthBar:ClearAllPoints()
        FrameName.unitHealthBar:SetPoint("TOPLEFT", FrameName, "TOPLEFT", 1, -1)
        FrameName.unitHealthBar:SetStatusBarTexture(General.ForegroundTexture)
        FrameName.unitHealthBar.colorClass = General.ColourByClass
        FrameName.unitHealthBar.colorReaction = General.ColourByClass
        FrameName.unitHealthBar.colorDisconnected = General.ColourIfDisconnected
        FrameName.unitHealthBar.colorTapping = General.ColourIfTapped
        FrameName.unitHealthBar.colorHealth = true
        if Health.Direction == "RL" then
            FrameName.unitHealthBar:SetReverseFill(true)
        elseif Health.Direction == "LR" then
            FrameName.unitHealthBar:SetReverseFill(false)
        end
        FrameName.unitHealthBar.Background:SetAllPoints()
        FrameName.unitHealthBar.Background:SetTexture(General.BackgroundTexture)
        if General.ColourBackgroundByHealth then
            FrameName.unitHealthBar.Background.multiplier = General.BackgroundMultiplier
            FrameName.unitHealthBar.bg = FrameName.unitHealthBar.Background
        else
            FrameName.unitHealthBar.Background:SetVertexColor(unpack(General.BackgroundColour))
            FrameName.unitHealthBar.bg = nil
        end
        FrameName.unitHealthBar:ForceUpdate()
    end

    if FrameName.unitAbsorbs then
        local HealthBarTexture = FrameName.unitHealthBar:GetStatusBarTexture()
        if HealthBarTexture then
            FrameName.unitAbsorbs:SetReverseFill(Health.Direction == "RL")
            FrameName.unitAbsorbs:ClearAllPoints()
            if Health.Direction == "RL" then
                FrameName.unitAbsorbs:SetPoint("TOPRIGHT", HealthBarTexture, "TOPLEFT")
                FrameName.unitAbsorbs:SetPoint("BOTTOMRIGHT", HealthBarTexture, "BOTTOMLEFT")
            else
                FrameName.unitAbsorbs:SetPoint("TOPLEFT", HealthBarTexture, "TOPRIGHT")
                FrameName.unitAbsorbs:SetPoint("BOTTOMLEFT", HealthBarTexture, "BOTTOMRIGHT")
            end
        end
        FrameName.unitAbsorbs:SetStatusBarColor(unpack(Absorbs.Colour))
        FrameName.unitAbsorbs:SetStatusBarTexture(General.ForegroundTexture)
    end
    
    if FrameName.unitHealAbsorbs then
        local HealthBarTexture = FrameName.unitHealthBar:GetStatusBarTexture()
        if HealthBarTexture then
            FrameName.unitHealAbsorbs:ClearAllPoints()
            if Health.Direction == "RL" then
                FrameName.unitHealAbsorbs:SetReverseFill(false)
                FrameName.unitHealAbsorbs:SetPoint("TOPLEFT", HealthBarTexture, "TOPLEFT")
                FrameName.unitHealAbsorbs:SetPoint("BOTTOMRIGHT", HealthBarTexture, "BOTTOMRIGHT")
            else
                FrameName.unitHealAbsorbs:SetReverseFill(true)
                FrameName.unitHealAbsorbs:SetPoint("TOPRIGHT", HealthBarTexture, "TOPRIGHT")
                FrameName.unitHealAbsorbs:SetPoint("BOTTOMLEFT", HealthBarTexture, "BOTTOMLEFT")
            end
        end
        FrameName.unitHealAbsorbs:SetStatusBarColor(unpack(HealAbsorbs.Colour))
        FrameName.unitHealAbsorbs:SetStatusBarTexture(General.ForegroundTexture)
    end

    if FrameName.unitPortraitBackdrop and FrameName.unitPortrait then
        FrameName.unitPortraitBackdrop:ClearAllPoints()
        FrameName.unitPortraitBackdrop:SetSize(Portrait.Size, Portrait.Size)
        FrameName.unitPortraitBackdrop:SetPoint(Portrait.AnchorFrom, FrameName, Portrait.AnchorTo, Portrait.XOffset, Portrait.YOffset)
        FrameName.unitPortraitBackdrop:SetBackdrop(BackdropTemplate)
        FrameName.unitPortraitBackdrop:SetBackdropColor(unpack(General.BackgroundColour))
        FrameName.unitPortraitBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
        FrameName.unitPortrait:SetSize(FrameName.unitPortraitBackdrop:GetHeight() - 2, FrameName.unitPortraitBackdrop:GetHeight() - 2)
        FrameName.unitPortrait:SetPoint("CENTER", FrameName.unitPortraitBackdrop, "CENTER", 0, 0)
    end

    if FrameName.unitPowerBar and FrameName.unitPowerBarBackdrop then
        FrameName.unitPowerBarBackdrop:ClearAllPoints()
        FrameName.unitPowerBarBackdrop:SetSize(Frame.Width, PowerBar.Height)
        FrameName.unitPowerBarBackdrop:SetPoint("BOTTOMLEFT", FrameName, "BOTTOMLEFT", 0, 0)
        FrameName.unitPowerBarBackdrop:SetBackdrop(BackdropTemplate)
        FrameName.unitPowerBarBackdrop:SetBackdropBorderColor(unpack(General.BorderColour))
        FrameName.unitPowerBarBackdrop:SetFrameLevel(4)
        FrameName.unitPowerBar:ClearAllPoints()
        FrameName.unitPowerBar:SetPoint("BOTTOMLEFT", FrameName, "BOTTOMLEFT", 1, 1)
        FrameName.unitPowerBar:SetSize(Frame.Width - 2, PowerBar.Height - 2)
        FrameName.unitPowerBar:SetStatusBarTexture(General.ForegroundTexture)
        FrameName.unitPowerBar:SetStatusBarColor(unpack(PowerBar.Colour))
        FrameName.unitPowerBar:SetMinMaxValues(0, 100)
        FrameName.unitPowerBar.colorPower = PowerBar.ColourByType
        FrameName.unitHealthBar:SetHeight(FrameName:GetHeight() - PowerBar.Height - 1)
        FrameName.unitPowerBarBackdrop:SetFrameLevel(5)
        FrameName.unitPowerBar.Background:SetAllPoints()
        FrameName.unitPowerBar.Background:SetTexture(General.BackgroundTexture)
        if PowerBar.ColourBackgroundByType then 
            FrameName.unitPowerBar.Background.multiplier = PowerBar.BackgroundMultiplier
            FrameName.unitPowerBar.bg = FrameName.unitPowerBar.Background
        else
            FrameName.unitPowerBar.Background:SetVertexColor(unpack(PowerBar.BackgroundColour))
            FrameName.unitPowerBar.bg = nil
        end
        FrameName.unitPowerBar:ForceUpdate()
    end

    if Buffs.Enabled then
        FrameName.unitBuffs:ClearAllPoints()
        FrameName.unitBuffs:SetSize(FrameName:GetWidth(), Buffs.Size)
        FrameName.unitBuffs:SetPoint(Buffs.AnchorFrom, FrameName, Buffs.AnchorTo, Buffs.XOffset, Buffs.YOffset)
        FrameName.unitBuffs.size = Buffs.Size
        FrameName.unitBuffs.spacing = Buffs.Spacing
        FrameName.unitBuffs.num = Buffs.Num
        FrameName.unitBuffs.initialAnchor = Buffs.AnchorFrom
        FrameName.unitBuffs.onlyShowPlayer = Buffs.OnlyShowPlayer
        FrameName.unitBuffs["growth-x"] = Buffs.GrowthX
        FrameName.unitBuffs["growth-y"] = Buffs.GrowthY
        FrameName.unitBuffs.filter = "HELPFUL"
        FrameName.unitBuffs:Show()
        FrameName.unitBuffs.PostUpdateButton = function(_, button) PostUpdateButton(_, button, Unit, "HELPFUL") end
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
        FrameName.unitDebuffs.onlyShowPlayer = Debuffs.OnlyShowPlayer
        FrameName.unitDebuffs["growth-x"] = Debuffs.GrowthX
        FrameName.unitDebuffs["growth-y"] = Debuffs.GrowthY
        FrameName.unitDebuffs.filter = "HARMFUL"
        FrameName.unitDebuffs:Show()
        FrameName.unitDebuffs.PostUpdateButton = function(_, button) PostUpdateButton(_, button, Unit, "HARMFUL") end
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

    if Range and Range.Enable then
        FrameName.__RangeAlphaSettings = Range
    else
        FrameName.__RangeAlphaSettings = nil
    end

    FrameName:UpdateTags()
    if UUF.DB.global.TestMode then UUF:DisplayBossFrames() end
end

function UUF:SpawnUnitFrame(Unit)
    if Unit == "Boss" then
        local Frame = UUF.DB.global[Unit].Frame
        local Style = "UUF_" .. Unit
        oUF:RegisterStyle(Style, function(self) UUF.CreateUnitFrame(self, Unit) end)
        oUF:SetActiveStyle(Style)
        UUF.BossFrames = {}
        local BossSpacing = Frame.Spacing
        local BossContainer
        for i = 1, 8 do
            local BossFrame = oUF:Spawn("boss" .. i, "UUF_Boss" .. i)
            UUF.BossFrames[i] = BossFrame
            if i == 1 then
                BossContainer = (BossFrame:GetHeight() + BossSpacing) * 8 - BossSpacing
                local offsetY = (BossContainer / 2 - BossFrame:GetHeight() / 2)
                if Frame.GrowthY ~= "DOWN" then
                    offsetY = -offsetY
                end
                BossFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, offsetY + Frame.YPosition)
            else
                local anchor = Frame.GrowthY == "DOWN" and "TOPLEFT" or "BOTTOMLEFT"
                local relativeAnchor = Frame.GrowthY == "DOWN" and "BOTTOMLEFT" or "TOPLEFT"
                local offsetY = Frame.GrowthY == "DOWN" and -BossSpacing or BossSpacing
                BossFrame:SetPoint(anchor, _G["UUF_Boss" .. (i - 1)], relativeAnchor, 0, offsetY)
            end
            UUF:RegisterRangeFrame(BossFrame, "boss" .. i)
        end
    else
        local Frame = UUF.DB.global[Unit].Frame
        local Style = "UUF_" .. Unit
        oUF:RegisterStyle(Style, function(self) UUF.CreateUnitFrame(self, Unit) end)
        oUF:SetActiveStyle(Style)
        self[Unit .. "Frame"] = oUF:Spawn(Unit, "UUF_" .. Unit)
        self[Unit .. "Frame"]:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
        UUF:RegisterRangeFrame(self[Unit .. "Frame"], Unit:lower())
    end
end

function UUF:UpdateBossFrames()
    if not UUF.BossFrames then return end
    for _, BossFrame in ipairs(UUF.BossFrames) do UUF:UpdateUnitFrame(BossFrame) end
    local Frame = UUF.DB.global.Boss.Frame
    local BossSpacing = Frame.Spacing
    local BossContainer = 0
    local growDown = Frame.GrowthY == "DOWN"

    for i, BossFrame in ipairs(UUF.BossFrames) do
        BossFrame:ClearAllPoints()
        if i == 1 then
            BossContainer = (BossFrame:GetHeight() + BossSpacing) * #UUF.BossFrames - BossSpacing
            local offsetY = (BossContainer / 2 - BossFrame:GetHeight() / 2)
            if not growDown then
                offsetY = -offsetY
            end
            BossFrame:SetPoint(
                Frame.AnchorFrom,
                Frame.AnchorParent,
                Frame.AnchorTo,
                Frame.XPosition,
                offsetY + Frame.YPosition
            )
        else
            local anchor = growDown and "TOPLEFT" or "BOTTOMLEFT"
            local relativeAnchor = growDown and "BOTTOMLEFT" or "TOPLEFT"
            local offsetY = growDown and -BossSpacing or BossSpacing
            BossFrame:SetPoint(
                anchor,
                _G["UUF_Boss" .. (i - 1)],
                relativeAnchor,
                0,
                offsetY
            )
        end
    end
end

function UUF:SetupSlashCommands()
    SLASH_UUF1 = "/uuf"
    SLASH_UUF2 = "/unhalteduf"
    SLASH_UUF3 = "/unhaltedunitframes"
    SlashCmdList["UUF"] = function(msg)
        if msg == "" then
            UUF:CreateGUI()
        end
    end
end

function UUF:LoadCustomColours()
    local General = UUF.DB.global.General
    local PowerTypesToString = {
        [0] = "MANA",
        [1] = "RAGE",
        [2] = "FOCUS",
        [3] = "ENERGY",
        [6] = "RUNIC_POWER",
        [8] = "LUNAR_POWER",
        [11] = "MAELSTROM",
        [13] = "INSANITY",
        [17] = "FURY",
        [18] = "PAIN"
    }

    for powerType, color in pairs(General.CustomColours.Power) do
        local powerTypeString = PowerTypesToString[powerType]
        if powerTypeString then
            oUF.colors.power[powerTypeString] = color
        end
    end

    for reaction, color in pairs(General.CustomColours.Reaction) do
        oUF.colors.reaction[reaction] = color
    end

    oUF.colors.health = { General.ForegroundColour[1], General.ForegroundColour[2], General.ForegroundColour[3] }
end

function UUF:DisplayBossFrames()
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global.Boss.Frame
    local Portrait = UUF.DB.global.Boss.Portrait
    local Health = UUF.DB.global.Boss.Health
    local PowerBar = UUF.DB.global.Boss.PowerBar
    local HealthPrediction = Health.HealthPrediction
    local Absorbs = HealthPrediction.Absorbs
    local Buffs = UUF.DB.global.Boss.Buffs
    local Debuffs = UUF.DB.global.Boss.Debuffs
    local TargetMarker = UUF.DB.global.Boss.TargetMarker
    local LeftText = UUF.DB.global.Boss.Texts.Left
    local RightText = UUF.DB.global.Boss.Texts.Right
    local CenterText = UUF.DB.global.Boss.Texts.Center
    local TopLeftText = UUF.DB.global.Boss.Texts.AdditionalTexts.TopLeft
    local TopRightText = UUF.DB.global.Boss.Texts.AdditionalTexts.TopRight
    local BottomLeftText = UUF.DB.global.Boss.Texts.AdditionalTexts.BottomLeft
    local BottomRightText = UUF.DB.global.Boss.Texts.AdditionalTexts.BottomRight

    local BackdropTemplate = {
        bgFile = General.BackgroundTexture,
        edgeFile = General.BorderTexture,
        edgeSize = General.BorderSize,
        insets = { left = General.BorderInset, right = General.BorderInset, top = General.BorderInset, bottom = General.BorderInset },
    }

    if not UUF.BossFrames then return end
    
    for _, BossFrame in ipairs(UUF.BossFrames) do
        if BossFrame.unitHealthBar then
            local BF = BossFrame.unitHealthBar
            BF:SetStatusBarColor(1, 1, 0.1)
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
        end

        if BossFrame.unitAbsorb then
            local BF = BossFrame.unitAbsorb
            BF:SetStatusBarColor(Absorbs.Colour)
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
            BF:Show()
        end 

        if BossFrame.unitPowerBar then
            local BF = BossFrame.unitPowerBar
            BF:SetStatusBarColor(0.8, 0.1, 0.1)
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
        end

        if BossFrame.unitPortrait then
            local BF = BossFrame.unitPortrait
            BF:SetTexture("Interface\\ICONS\\INV_Misc_Head_Dragon_Blue")
        end
        
        if BossFrame.unitLeftText then
            local BF = BossFrame.unitLeftText
            BF:SetText("Boss " .. _)
        end

        if BossFrame.unitRightText then
            local BF = BossFrame.unitRightText
            BF:SetText(UUF:FormatLargeNumber(math.random(1e3, 1e6)))
        end

        if BossFrame.unitTargetMarker then
            local BF = BossFrame.unitTargetMarker
            BF:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
        end

        if not UUF.DB.global.TestMode then
            BossFrame:SetAttribute("unit", "boss" .. _)
            RegisterUnitWatch(BossFrame)
            BossFrame:Hide()
        else
            BossFrame:SetAttribute("unit", nil)
            UnregisterUnitWatch(BossFrame)
            BossFrame:Show()
        end
    end
end
