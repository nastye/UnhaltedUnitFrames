local _, UUF = ...
local oUF = UUF.oUF
local rangeEventFrames = {}
-- -- -- -- -- -- -- --
-- CONFIG
-- -- -- -- -- -- -- --
-- Player
local pFrameX = -350.1
local pFrameY = -245.1
local pFrameW = 240
local pFrameH = 43
local pHealthTag = "[Health:EffectiveCurrentWithPercent:Short]"
local pReverseHealth = false
local pPowerBar = false
local pPowerText = false
local pBuffs = false
local pName = false
local pToT = false
local pIncHeals = false
local pAbsorbs = false
local pHealAbsorbs = false
local pRaidMarker = false
local pSummonIndicator = false
local pReadyCheckIndicator = false
-- Target
local tFrameX = 350.1
local tFrameY = -245.1
local tFrameW = 240
local tFrameH = 43
local tBuffSize = 26
local tHealthTag = "[Health:EffectiveCurrentWithPercent:Short]"
local tReverseHealth = false
local tPowerBar = false
local tPowerText = true
local tBuffs = true
local tName = true
local tToT = false
local tIncHeals = false
local tAbsorbs = false
local tHealAbsorbs = false
local tRaidMarker = false
local tSummonIndicator = false
local tReadyCheckIndicator = false
-- Boss
local bossFrameX = 750.1
local bossVerticalSpacing = 10
local bossFrameW = 235
local bossFrameH = 44
local bossHealthTag = "[Health:EffectiveCurrentWithPercent:Short]"
-- Pet
local petFrameX = 0
local petFrameY = 0
local petFrameW = 210
local petFrameH = 24
local petHealthTag = ""
-- Focus
local focusFrameX = 0
local focusFrameY = 70
local focusFrameW = 155
local focusFrameH = 30
local focusHealthTag = "[Health:EffectivePercent]"

-- -- -- -- -- -- -- --
-- END CONFIG
-- -- -- -- -- -- -- --

-- Better Colours
oUF.colors.reaction[2] = {149/255, 0/255, 8/255}        -- Hostile
oUF.colors.reaction[3] = {255/255, 128/255, 64/255}     -- Unfriendly
oUF.colors.reaction[4] = {255/255, 211/255, 0/255}      -- Neutral
oUF.colors.reaction[5] = {0/255, 189/255, 0/255}        -- Friendly
oUF.colors.disconnected = {77/255, 77/255, 77/255}      -- Disconnected

-- Better Mana Colour
oUF.colors.power.MANA = {64/255, 128/255, 255/255}

-- Set UI Scale
local uiScaleFrame = CreateFrame("Frame")
uiScaleFrame:RegisterEvent("PLAYER_LOGIN")
uiScaleFrame:SetScript("OnEvent", function(_, event) UIParent:SetScale(0.53333333333333) end)

-- Range Check Frame
-- Range Checking is toxic.
-- `OnUpdate` is bad for performance. `OnEvent` isn't perfect but it's better.
local rangeEventFrame = CreateFrame("Frame")
rangeEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
rangeEventFrame:RegisterEvent("UNIT_TARGET")
rangeEventFrame:RegisterEvent("UNIT_AURA")
rangeEventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
rangeEventFrame:RegisterEvent("SPELL_UPDATE_USABLE")

rangeEventFrame:SetScript("OnEvent", function()
    for _, frameData in ipairs(rangeEventFrames) do
        local frame, unit = frameData.frame, frameData.unit
        UUF:UpdateRangeAlpha(frame, unit)
    end
end)

function UUF:RegisterRangeFrame(frame, unit)
    table.insert(rangeEventFrames, { frame = frame, unit = unit })
end

local function PostCreateButton(_, button)
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
    auraCooldown:SetDrawEdge(false)
    auraCooldown:SetReverse(true)

    -- Count Options
    local auraCount = button.Count
    auraCount:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    auraCount:SetPoint("BOTTOMRIGHT", 2, 1)
    auraCount:SetJustifyH("RIGHT")
    auraCount:SetTextColor(1, 1, 1, 1)
end

local function CreatePowerBar(self, unitHealth)
    -- Unit Power Bar
    local unitPower = CreateFrame("StatusBar", nil, self)
    unitPower:SetHeight(4)
    unitPower:SetWidth(self:GetWidth() - 2)
    unitHealth:SetHeight(self:GetHeight() - unitPower:GetHeight() - 3)
    unitPower:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    unitPower:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 1)
    unitPower:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
    unitPower.colorPower = true
    self.Power = unitPower
end

function CreateUnitFrame(self, unitW, unitH, shouldReverse, showPowerBar, showPowerText, showBuffs, showName, showTargetofTarget, healthTag, showIncomingHeals, showAbsorbs, showHealAbsorbs, showRaidMarker, showSummonIndicator, showReadyCheckIndicator)
    -- Local Variables
    local isPlayer = UnitIsUnit(self.unit, "player")
    self:SetSize(unitW, unitH)

    -- Unit Backdrop
    local unitBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
    unitBackdrop:SetAllPoints()
    unitBackdrop:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
    unitBackdrop:SetBackdropColor(173/255, 171/255, 173/255, 1)
    unitBackdrop:SetBackdropBorderColor(0, 0, 0, 1)

    -- Unit Health Bar
    local unitHealth = CreateFrame("StatusBar", nil, self)
    unitHealth:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
    unitHealth:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    unitHealth:SetMinMaxValues(0, 100)
    unitHealth:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    unitHealth:SetStatusBarColor(30/255, 30/255, 30/255, 1)
    if shouldReverse then unitHealth:SetReverseFill(true) end
    unitHealth.colorDisconnected = true
    unitHealth.colorClass = false
    unitHealth.colorReaction = false

    -- Unit Incoming Heals
    if showIncomingHeals then
        -- Player
        local unitIncomingHealsSelf = CreateFrame("StatusBar", nil, self)
        unitIncomingHealsSelf:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitIncomingHealsSelf:SetStatusBarColor(64/255, 255/255, 64/255, 1)
        unitIncomingHealsSelf:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitIncomingHealsSelf:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitIncomingHealsSelf:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitIncomingHealsSelf:Hide()
        if shouldReverse then
            unitIncomingHealsSelf:SetReverseFill(true)
            unitIncomingHealsSelf:ClearAllPoints()
            unitIncomingHealsSelf:SetPoint("TOPRIGHT", unitHealth:GetStatusBarTexture(), "TOPLEFT")
            unitIncomingHealsSelf:SetPoint("BOTTOMRIGHT", unitHealth:GetStatusBarTexture(), "BOTTOMLEFT")
        end
        self.IncomingHealsSelf = unitIncomingHealsSelf
        -- Others
        local unitIncomingHealsOthers = CreateFrame("StatusBar", nil, self)
        unitIncomingHealsOthers:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitIncomingHealsOthers:SetStatusBarColor(64/255, 255/255, 64/255, 1)
        unitIncomingHealsOthers:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitIncomingHealsOthers:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitIncomingHealsOthers:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitIncomingHealsOthers:Hide()
        if shouldReverse then
            unitIncomingHealsOthers:SetReverseFill(true)
            unitIncomingHealsOthers:ClearAllPoints()
            unitIncomingHealsOthers:SetPoint("TOPRIGHT", unitHealth:GetStatusBarTexture(), "TOPLEFT")
            unitIncomingHealsOthers:SetPoint("BOTTOMRIGHT", unitHealth:GetStatusBarTexture(), "BOTTOMLEFT")
        end
        self.IncomingHealsOthers = unitIncomingHealsOthers
    end

    -- Unit Absorbs
    if showAbsorbs then
        local unitAbsorbs = CreateFrame("StatusBar", nil, self)
        unitAbsorbs:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitAbsorbs:SetStatusBarColor(138/255, 252/255, 255/255, 0.5)
        unitAbsorbs:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitAbsorbs:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitAbsorbs:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitAbsorbs:Hide()
        if shouldReverse then
            unitAbsorbs:SetReverseFill(true)
            unitAbsorbs:ClearAllPoints()
            unitAbsorbs:SetPoint("TOPRIGHT", unitHealth:GetStatusBarTexture(), "TOPLEFT")
            unitAbsorbs:SetPoint("BOTTOMRIGHT", unitHealth:GetStatusBarTexture(), "BOTTOMLEFT")
        end
        self.Absorbs = unitAbsorbs
    end

    -- Unit Heal Absorbs
    if showHealAbsorbs then
        local unitHealAbsorbs = CreateFrame("StatusBar", nil, self)
        unitHealAbsorbs:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitHealAbsorbs:SetStatusBarColor(92/255, 0/255, 255/255, 0.5)
        unitHealAbsorbs:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitHealAbsorbs:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitHealAbsorbs:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitHealAbsorbs:Hide()
        if shouldReverse then
            unitHealAbsorbs:SetReverseFill(true)
            unitHealAbsorbs:ClearAllPoints()
            unitHealAbsorbs:SetPoint("TOPRIGHT", unitHealth:GetStatusBarTexture(), "TOPLEFT")
            unitHealAbsorbs:SetPoint("BOTTOMRIGHT", unitHealth:GetStatusBarTexture(), "BOTTOMLEFT")
        end
        self.HealAbsorbs = unitHealAbsorbs
    end

    -- Register with oUF
    self.HealthPrediction = {
        myBar = showIncomingHeals and self.IncomingHealsSelf or nil,
        otherBar = showIncomingHeals and self.IncomingHealsOthers or nil,
        absorbBar = showAbsorbs and self.Absorbs or nil,
        healAbsorbBar = showHealAbsorbs and self.HealAbsorbs or nil,
        maxOverflow = 1,
    }

    -- Unit Highlight
    local unitMouseoverHighlight = unitHealth:CreateTexture(nil, "OVERLAY")
    unitMouseoverHighlight:SetAllPoints()
    unitMouseoverHighlight:SetTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    unitMouseoverHighlight:SetBlendMode("ADD")
    unitMouseoverHighlight:SetVertexColor(1, 1, 1, 0.15)
    unitMouseoverHighlight:Hide()

    -- Text Frame
    local unitTextFrame = CreateFrame("Frame", nil, self)
    unitTextFrame:SetSize(self:GetWidth(), self:GetHeight())
    unitTextFrame:SetPoint("CENTER", 0, 0)

    -- Name Text
    if showName then
        local unitNameText = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitNameText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        if self.unit == "pet" then 
            unitNameText:SetPoint("CENTER", 0, 0)
            unitNameText:SetJustifyH("CENTER")
        else
            unitNameText:SetPoint("LEFT", 4, 0)
            unitNameText:SetJustifyH("LEFT")
        end
        unitNameText:SetTextColor(1, 1, 1, 1)
        if showTargetofTarget then
            self:Tag(unitNameText, "[Name:TargetofTarget:Colored]")
        else
            self:Tag(unitNameText, "[Name:LastOnly:Colored]")
        end
        self.Name = unitNameText
    end

    -- Health Text
    local unitHealthText = unitTextFrame:CreateFontString(nil, "OVERLAY")
    local healthTag = healthTag or "[Health:EffectiveCurrentWithPercent:Short]"
    unitHealthText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    unitHealthText:SetPoint("RIGHT", -1, 0)
    unitHealthText:SetJustifyH("RIGHT")
    unitHealthText:SetTextColor(1, 1, 1, 1)
    self:Tag(unitHealthText, healthTag)

    -- Additional Text
    if showPowerText then
        local unitPowerText = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitPowerText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        unitPowerText:SetPoint("RIGHT", unitTextFrame, "BOTTOMRIGHT", -1, 2)
        unitPowerText:SetJustifyH("RIGHT")
        unitPowerText:SetTextColor(1, 1, 1, 1)
        self:Tag(unitPowerText, "[powercolor][Power:Current:Short]")
    end

    -- Unit Absorb Text
    if isPlayer then
        local unitAbsorbText = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitAbsorbText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        unitAbsorbText:SetPoint("RIGHT", unitTextFrame, "TOPRIGHT", -2, -2)
        unitAbsorbText:SetJustifyH("RIGHT")
        unitAbsorbText:SetTextColor(0/255 , 255/255, 64/255, 1)
        self:Tag(unitAbsorbText, "[Absorb:Current:Short]")
    end

    -- Buffs
    if showBuffs then
        local unitBuffs = CreateFrame("Frame", nil, self)
        if self.unit == "target" then 
            unitBuffs:SetSize(self:GetWidth(), tBuffSize)
            unitBuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, -1)
            unitBuffs.size = tBuffSize
            unitBuffs.spacing = -1
            unitBuffs.initialAnchor = "BOTTOMRIGHT"
            unitBuffs["growth-x"] = "LEFT"
            unitBuffs["growth-y"] = "UP"
            unitBuffs.num = 7
            unitBuffs.filter = "HELPFUL"
        end

        if self.unit == "boss1" 
        or self.unit == "boss2"
        or self.unit == "boss3"
        or self.unit == "boss4"
        or self.unit == "boss5"
        then
            unitBuffs:SetSize(self:GetWidth(), bossFrameH)
            unitBuffs:SetPoint("LEFT", self, "RIGHT", -1, 0)
            unitBuffs.size = bossFrameH
            unitBuffs.spacing = -1
            unitBuffs.initialAnchor = "LEFT"
            unitBuffs["growth-x"] = "RIGHT"
            unitBuffs["growth-y"] = "UP"
            unitBuffs.num = 3
            unitBuffs.filter = "HELPFUL"
        end        
        -- Apply Button Styling: Icon Zoom, Border, Count, Cooldown
        unitBuffs.PostCreateButton = PostCreateButton
        -- Register with oUF
        self.Buffs = unitBuffs
    end

    -- Power Bar
    if showPowerBar then
        CreatePowerBar(self, unitHealth)
    end

    -- TODO: Alternate Power Bar (Mana)

    -- Raid Target Marker
    if showRaidMarker then
        local unitRaidTarget = unitTextFrame:CreateTexture(nil, "OVERLAY")
        unitRaidTarget:SetSize(18, 18)
        unitRaidTarget:SetPoint("TOPLEFT", unitTextFrame, "TOPLEFT", 4, 7)
        self.RaidTargetIndicator = unitRaidTarget
    end

    -- Summon Indicator
    if showSummonIndicator then
        local unitSummonIndicator = unitTextFrame:CreateTexture(nil, "OVERLAY")
        unitSummonIndicator:SetSize(24, 24)
        unitSummonIndicator:SetPoint("CENTER", unitTextFrame, "CENTER", 0, 0)
        self.SummonIndicator = unitSummonIndicator
    end

    -- Ready Check Indicator
    if showReadyCheckIndicator then
        local unitReadyCheckIndicator = unitTextFrame:CreateTexture(nil, "OVERLAY")
        unitReadyCheckIndicator:SetSize(24, 24)
        unitReadyCheckIndicator:SetPoint("CENTER", unitTextFrame, "CENTER", 0, 0)
        self.ReadyCheckIndicator = unitReadyCheckIndicator
    end

    -- Scripts
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type1", "target")
    self:SetAttribute("*type2", "togglemenu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:HookScript("OnEnter", function() unitMouseoverHighlight:Show() end)
    self:HookScript("OnLeave", function() unitMouseoverHighlight:Hide() end)

    -- Register with oUF
    self.Health = unitHealth
    self.Health.Value = unitHealthText
end

-- Spawn Player
oUF:RegisterStyle("UUF_Player", function(self) CreateUnitFrame(self, pFrameW, pFrameH, pReverseHealth, pPowerBar, pPowerText, pBuffs, pName, pToT, pHealthTag, pIncHeals, pAbsorbs, pHealAbsorbs, pRaidMarker, pSummonIndicator, pReadyCheckIndicator) end)
oUF:SetActiveStyle("UUF_Player")
oUF:Spawn("player", "UUF_Player"):SetPoint("CENTER", pFrameX, pFrameY)
-- Spawn Target
oUF:RegisterStyle("UUF_Target", function(self) CreateUnitFrame(self, tFrameW, tFrameH, tReverseHealth, tPowerBar, tPowerText, tBuffs, tName, tToT, tHealthTag, tIncHeals, tAbsorbs, tHealAbsorbs, tRaidMarker, tSummonIndicator, tReadyCheckIndicator) end)
oUF:SetActiveStyle("UUF_Target")
local targetFrame = oUF:Spawn("target", "UUF_Target")
targetFrame:SetPoint("CENTER", tFrameX, tFrameY)
UUF:RegisterRangeFrame(targetFrame, "target")
-- Spawn Boss Frames
oUF:RegisterStyle("UUF_Boss", function(self) CreateUnitFrame(self, bossFrameW, bossFrameH, false, false, true, true, true, false, bossHealthTag, false, true, false, true, false, false) end)
oUF:SetActiveStyle("UUF_Boss")
local totalBossContainerHeight = 0
for i = 1, MAX_BOSS_FRAMES do
    local bossFrame = oUF:Spawn("boss" .. i, "UUF_Boss" .. i)
    if i == 1 then
        totalBossContainerHeight = (bossFrame:GetHeight() + bossVerticalSpacing) * MAX_BOSS_FRAMES - bossVerticalSpacing
        bossFrame:SetPoint("CENTER", UIParent, "CENTER", bossFrameX, totalBossContainerHeight / 2 - bossFrame:GetHeight() / 2)
    else
        bossFrame:SetPoint("TOPLEFT", _G["UUF_Boss" .. (i - 1)], "BOTTOMLEFT", 0, -bossVerticalSpacing)
    end
    UUF:RegisterRangeFrame(bossFrame, "boss" .. i)
end
-- Spawn Pet
oUF:RegisterStyle("UUF_Pet", function(self) CreateUnitFrame(self, petFrameW, petFrameH, false, false, false, false, true, false, petHealthTag, false, false, false, false, false, false) end)
oUF:SetActiveStyle("UUF_Pet")
local petFrame = oUF:Spawn("pet", "UUF_Pet")
petFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", petFrameX, petFrameY)

-- Spawn Focus
oUF:RegisterStyle("UUF_Focus", function(self) CreateUnitFrame(self, focusFrameW, focusFrameH, false, false, false, false, true, false, focusHealthTag, false, false, false, false, false, false) end)
oUF:SetActiveStyle("UUF_Focus")
local focusFrame = oUF:Spawn("focus", "UUF_Focus")
focusFrame:SetPoint("BOTTOMRIGHT", UUF_Target, "TOPRIGHT", focusFrameX, focusFrameY)
