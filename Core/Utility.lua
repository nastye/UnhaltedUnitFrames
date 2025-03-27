local _, UUF = ...
local UF = UUF.oUF
UUF.Frames = {
    ["player"] = "Player",
    ["target"] = "Target",
    ["focus"] = "Focus",
    ["pet"] = "Pet",
    ["targettarget"] = "TargetTarget",
}

function UUF:PostCreateButton(_, button, Unit, AuraType)
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
    local MouseoverHighlight = UUF.DB.global.General.MouseoverHighlight

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

    if MouseoverHighlight.Enabled and FrameName.unitHighlight then
        local MHR, MHG, MHB, MHA = unpack(MouseoverHighlight.Colour)
        if MouseoverHighlight.Style == "BORDER" then
            FrameName.unitHighlight:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
            FrameName.unitHighlight:SetBackdropColor(0, 0, 0, 0)
            FrameName.unitHighlight:SetBackdropBorderColor(MHR, MHG, MHB, MHA)
            FrameName.unitHighlight:SetFrameLevel(20)
            FrameName.unitHighlight:Hide()
        elseif MouseoverHighlight.Style == "HIGHLIGHT" then
            FrameName.unitHighlight:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
            FrameName.unitHighlight:SetBackdropColor(MHR, MHG, MHB, MHA)
            FrameName.unitHighlight:SetBackdropBorderColor(0, 0, 0, 0)
            FrameName.unitHighlight:SetFrameLevel(20)
            FrameName.unitHighlight:Hide()
        end
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
            BossFrame:SetPoint( Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, offsetY + Frame.YPosition )
        else
            local anchor = growDown and "TOPLEFT" or "BOTTOMLEFT"
            local relativeAnchor = growDown and "BOTTOMLEFT" or "TOPLEFT"
            local offsetY = growDown and -BossSpacing or BossSpacing
            BossFrame:SetPoint( anchor, _G["UUF_Boss" .. (i - 1)], relativeAnchor, 0, offsetY )
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
            UF.colors.power[powerTypeString] = color
        end
    end

    for reaction, color in pairs(General.CustomColours.Reaction) do
        UF.colors.reaction[reaction] = color
    end

    UF.colors.health = { General.ForegroundColour[1], General.ForegroundColour[2], General.ForegroundColour[3] }
end

function UUF:DisplayBossFrames()
    local General = UUF.DB.global.General
    local Frame = UUF.DB.global.Boss.Frame
    local Portrait = UUF.DB.global.Boss.Portrait
    local Health = UUF.DB.global.Boss.Health
    local PowerBar = UUF.DB.global.Boss.PowerBar
    local HealthPrediction = Health.HealthPrediction
    local Absorbs = HealthPrediction.Absorbs
    local HealAbsorbs = HealthPrediction.HealAbsorbs
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
            local PlayerClassColour = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
            BF:SetStatusBarColor(PlayerClassColour.r, PlayerClassColour.g, PlayerClassColour.b)
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
            if BossFrame.unitHealthBar.Background then
                BF.Background:SetAllPoints()
                BF.Background:SetTexture(General.BackgroundTexture)
                if General.ColourBackgroundByHealth then
                    BF.Background:SetVertexColor(PlayerClassColour.r * General.BackgroundMultiplier, PlayerClassColour.g * General.BackgroundMultiplier, PlayerClassColour.b * General.BackgroundMultiplier)
                else
                    BF.Background:SetVertexColor(unpack(General.BackgroundColour))
                end
            end
        end

        if BossFrame.unitAbsorbs then
            local BF = BossFrame.unitAbsorbs
            BF:SetStatusBarColor(unpack(Absorbs.Colour))
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
            BF:Show()
        end

        if BossFrame.unitHealAbsorbs then
            local BF = BossFrame.unitHealAbsorbs
            BF:SetStatusBarColor(unpack(HealAbsorbs.Colour))
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
            BF:Show()
        end

        if BossFrame.unitPowerBar then
            local BF = BossFrame.unitPowerBar
            BF:SetStatusBarColor(unpack(General.CustomColours.Power[0]))
            BF:SetMinMaxValues(0, 100)
            BF:SetValue(math.random(20, 50))
            if BF.Background then
                BF.Background:SetAllPoints()
                BF.Background:SetTexture(General.BackgroundTexture)
                if PowerBar.ColourBackgroundByType then
                    local PBGR, PBGG, PBGB = unpack(General.CustomColours.Power[0])
                    BF.Background:SetVertexColor(PBGR * PowerBar.BackgroundMultiplier, PBGG * PowerBar.BackgroundMultiplier, PBGB * PowerBar.BackgroundMultiplier)
                else
                    BF.Background:SetVertexColor(unpack(PowerBar.BackgroundColour)) 
                end
            end
        end

        if BossFrame.unitPortrait then
            local BF = BossFrame.unitPortrait
            local PortraitOptions = {
                [1] = "achievement_character_human_female",
                [2] = "achievement_character_human_male",
                [3] = "achievement_character_dwarf_male",
                [4] = "achievement_character_dwarf_female"
            }
            BF:SetTexture("Interface\\ICONS\\" .. PortraitOptions[math.random(1, #PortraitOptions)])
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
