local _, UUF = ...
local oUF = UUF.oUF
local rangeEventFrames = {}
local uiScaleFrame = CreateFrame("Frame")
uiScaleFrame:RegisterEvent("PLAYER_LOGIN")
uiScaleFrame:SetScript("OnEvent", function(_, event) UIParent:SetScale(0.53333333333333) end)
-- Colour Overrides
oUF.colors.reaction[2] = {255/255, 64/255, 64/255}      -- Hostile
oUF.colors.reaction[3] = {255/255, 128/255, 64/255}     -- Unfriendly
oUF.colors.reaction[4] = {255/255, 255/255, 64/255}     -- Neutral
oUF.colors.reaction[5] = {64/255, 255/255, 64/255}      -- Friendly
oUF.colors.disconnected = {77/255, 77/255, 77/255}      -- Disconnected
oUF.colors.power.MANA = {64/255, 128/255, 255/255}

-- Range Check Frame
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

-- Aura Styling
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
    auraCount:SetPoint("BOTTOMRIGHT", 0, 3)
    auraCount:SetJustifyH("RIGHT")
    auraCount:SetTextColor(1, 1, 1, 1)
end

-- Power Bar Creation / Options

local function CreatePowerBar(self, unitHealth)
    -- Unit Power Bar
    local unitPower = CreateFrame("StatusBar", nil, self)
    unitPower:SetHeight(3)
    -- Don't touch below this, it does some magic to always keep stuff aligned.
    unitPower:SetWidth(self:GetWidth() - 2)
    unitHealth:SetHeight(self:GetHeight() - unitPower:GetHeight() - 3)
    -- You can change stuff again :)
    unitPower:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    unitPower:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 1)
    unitPower:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
    unitPower.colorPower = true
    self.Power = unitPower
end

-- Create Unit Frame
function CreateUnitFrame(self, unitW, unitH, shouldReverse, showPowerBar, showPowerText, showBuffs, showName, showTargetofTarget, healthTag, showIncomingHeals, showAbsorbs, showHealAbsorbs)
    -- Local Variables
    local isPlayer = self.unit == "player"
    self:SetSize(unitW, unitH)

    -- Unit Backdrop
    local unitBackdrop = CreateFrame("Frame", nil, self, "BackdropTemplate")
    unitBackdrop:SetAllPoints()
    unitBackdrop:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} })
    unitBackdrop:SetBackdropColor(8/255, 8/255, 8/255, 0.75)
    unitBackdrop:SetBackdropBorderColor(0, 0, 0, 1)

    -- Unit Health Bar
    local unitHealth = CreateFrame("StatusBar", nil, self)
    unitHealth:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
    unitHealth:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
    unitHealth:SetMinMaxValues(0, 100)
    unitHealth:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    unitHealth:SetStatusBarColor(26/255, 26/255, 26/255, 1)
    if shouldReverse then unitHealth:SetReverseFill(true) end
    unitHealth.colorDisconnected = true
    unitHealth.colorClass = true
    unitHealth.colorReaction = true

    -- Incoming Heals
    if showIncomingHeals then
        -- Player
        local unitIncomingHealsSelf = CreateFrame("StatusBar", nil, self)
        unitIncomingHealsSelf:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitIncomingHealsSelf:SetStatusBarColor(64/255, 255/255, 64/255, 1)
        unitIncomingHealsSelf:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitIncomingHealsSelf:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitIncomingHealsSelf:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitIncomingHealsSelf:Hide()
        self.IncomingHealsSelf = unitIncomingHealsSelf
        -- Others
        local unitIncomingHealsOthers = CreateFrame("StatusBar", nil, self)
        unitIncomingHealsOthers:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitIncomingHealsOthers:SetStatusBarColor(64/255, 255/255, 64/255, 1)
        unitIncomingHealsOthers:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitIncomingHealsOthers:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitIncomingHealsOthers:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitIncomingHealsOthers:Hide()
        self.IncomingHealsOthers = unitIncomingHealsOthers
    end
    
    -- Absorbs
    if showAbsorbs then
        local unitAbsorbs = CreateFrame("StatusBar", nil, self)
        unitAbsorbs:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitAbsorbs:SetStatusBarColor(255/255, 205/255, 0/255, 1)
        unitAbsorbs:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitAbsorbs:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitAbsorbs:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitAbsorbs:Hide()
        self.Absorbs = unitAbsorbs
    end

    -- Heal Absorbs
    if showHealAbsorbs then
        local unitHealAbsorbs = CreateFrame("StatusBar", nil, self)
        unitHealAbsorbs:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
        unitHealAbsorbs:SetStatusBarColor(128/255, 64/255, 255/255, 1)
        unitHealAbsorbs:SetPoint("TOPLEFT", unitHealth:GetStatusBarTexture(), "TOPRIGHT")
        unitHealAbsorbs:SetPoint("BOTTOMLEFT", unitHealth:GetStatusBarTexture(), "BOTTOMRIGHT")
        unitHealAbsorbs:SetSize(self:GetWidth() - 2, self:GetHeight() - 2)
        unitHealAbsorbs:Hide()
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
    unitMouseoverHighlight:SetVertexColor(1, 1, 1, 0.15) -- Color
    unitMouseoverHighlight:Hide()

    -- Text Frame
    local unitTextFrame = CreateFrame("Frame", nil, self)
    unitTextFrame:SetSize(self:GetWidth(), self:GetHeight())
    unitTextFrame:SetPoint("CENTER", 0, 0)
    unitTextFrame:SetFrameLevel(5)

    -- Name Text
    if showName then
        local unitNameText = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitNameText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        if self.unit == "pet" or self.unit == "focus" then
            unitNameText:SetPoint("CENTER", 0, 0)
            unitNameText:SetJustifyH("CENTER")
            self:Tag(unitNameText, "[Name:Last]")
        else
            unitNameText:SetPoint("LEFT", 3, 0)
            unitNameText:SetJustifyH("LEFT")
            if showTargetofTarget then
                self:Tag(unitNameText, "[ToT]")
            else
                self:Tag(unitNameText, "[Name:Last]")
            end
        end
        unitNameText:SetTextColor(1, 1, 1, 1)
        self.Name = unitNameText
    end


    -- Health Text
    local unitHealthText = unitTextFrame:CreateFontString(nil, "OVERLAY")
    local healthTag = healthTag or "[CurHP-PerHP:Short]"
    unitHealthText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    unitHealthText:SetPoint("RIGHT", -3, 0)
    unitHealthText:SetJustifyH("RIGHT")
    unitHealthText:SetTextColor(1, 1, 1, 1)
    self:Tag(unitHealthText, healthTag)

    -- Additional Text
    if showPowerText then
        local unitPowerText = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitPowerText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        unitPowerText:SetPoint("RIGHT", unitTextFrame, "BOTTOMRIGHT", -3, 1)
        unitPowerText:SetJustifyH("RIGHT")
        unitPowerText:SetTextColor(1, 1, 1, 1)
        self:Tag(unitPowerText, "[powercolor][CurPP:Short]")
    end

    -- Unit Absorb Text
    if isPlayer then
        local unitAbsorbText = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitAbsorbText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        unitAbsorbText:SetPoint("RIGHT", unitTextFrame, "TOPRIGHT", -3, -1)
        unitAbsorbText:SetJustifyH("RIGHT")
        unitAbsorbText:SetTextColor(255/255 , 205/255, 0/255, 1)
        self:Tag(unitAbsorbText, "[CurAbsorb:Short]")
    end

    -- Buffs
    if showBuffs then
        local unitBuffs = CreateFrame("Frame", nil, self)
        if self.unit == "target" then 
            unitBuffs:SetSize(self:GetWidth(), 38)
            unitBuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 1)
            unitBuffs.size = 38
            unitBuffs.spacing = 1
            unitBuffs.initialAnchor = "BOTTOMLEFT"
            unitBuffs["growth-x"] = "RIGHT"
            unitBuffs["growth-y"] = "UP"
            unitBuffs.num = 4
            unitBuffs.filter = "HELPFUL"
        end

        if self.unit == "boss1"
        or self.unit == "boss2"
        or self.unit == "boss3"
        or self.unit == "boss4"
        or self.unit == "boss5"
        then
            unitBuffs:SetSize(self:GetWidth(), 52)
            unitBuffs:SetPoint("LEFT", self, "RIGHT", 1, 0)
            unitBuffs.size = 52
            unitBuffs.spacing = 1
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
    if showPowerBar then CreatePowerBar(self, unitHealth) end

    -- Raid Target Marker
    local unitRaidTarget = unitTextFrame:CreateTexture(nil, "OVERLAY")
    unitRaidTarget:SetSize(24, 24)
    unitRaidTarget:SetPoint("CENTER", unitTextFrame, "CENTER", 0, 0)
    self.RaidTargetIndicator = unitRaidTarget

    -- Summon Indicator
    local unitSummonIndicator = unitTextFrame:CreateTexture(nil, "OVERLAY")
    unitSummonIndicator:SetSize(24, 24)
    unitSummonIndicator:SetPoint("CENTER", unitTextFrame, "CENTER", 0, 0)
    self.SummonIndicator = unitSummonIndicator

    -- Ready Check Indicator
    local unitReadyCheckIndicator = unitTextFrame:CreateTexture(nil, "OVERLAY")
    unitReadyCheckIndicator:SetSize(24, 24)
    unitReadyCheckIndicator:SetPoint("CENTER", unitTextFrame, "CENTER", 0, 0)
    self.ReadyCheckIndicator = unitReadyCheckIndicator

    -- Combat Indicator
    if isPlayer then 
        local unitCombatEventFrame = CreateFrame("Frame", nil, self)
        local unitCombatIndicator = unitTextFrame:CreateFontString(nil, "OVERLAY")
        unitCombatIndicator:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        unitCombatIndicator:SetPoint("LEFT", unitTextFrame, "TOPLEFT", 3, 0)
        unitCombatIndicator:SetJustifyH("LEFT")
        unitCombatIndicator:SetTextColor(1, 0, 0, 1)
        unitCombatEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        unitCombatEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        unitCombatEventFrame:SetScript("OnEvent", function(_, event)
            if UnitAffectingCombat("player") then
                unitCombatIndicator:SetText("X")
            else
                unitCombatIndicator:SetText("")
            end
        end)
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

--[[
    arg1 = self (Leave this as is / just refers to the frame in question)
    arg2 = Unit Width (number)
    arg3 = Unit Height (number)
    arg4 = Reverse Health Bar (boolean)
    arg5 = Show Power Bar (boolean)
    arg6 = Show Power Text (boolean)
    arg7 = Show Buffs (boolean) 
    arg8 = Show Name (boolean)
    arg9 = Show Target of Target (boolean)
    arg10 = Health Tag (Tag / String)
    arg11 = Show Incoming Heals (boolean)
    arg12 = Show Absorbs (boolean)
    arg13 = Show Heal Absorbs (boolean)
]]

-- Spawn Player
oUF:RegisterStyle("UUF_Player", function(self) CreateUnitFrame(self, 272, 42, false, false, false, false, false, false, "[CurHP-PerHP:Short]", true, true, true) end)
oUF:SetActiveStyle("UUF_Player")
oUF:Spawn("player", "UUF_Player"):SetPoint("CENTER", -350.1, -271.1)

-- Spawn Target
oUF:RegisterStyle("UUF_Target", function(self) CreateUnitFrame(self, 272, 42, false, false, true, true, true, true, "[CurHP-PerHP:Short]", true, true, true) end)
oUF:SetActiveStyle("UUF_Target")
local targetFrame = oUF:Spawn("target", "UUF_Target")
targetFrame:SetPoint("CENTER", 350.1, -271.1)
UUF:RegisterRangeFrame(targetFrame, "target") -- Range Checking

-- Spawn Boss Frames
oUF:RegisterStyle("UUF_Boss", function(self) CreateUnitFrame(self, 272, 52, false, false, true, true, true, false, "[CurHP-PerHP:Short]", false, true, false) end)
oUF:SetActiveStyle("UUF_Boss")
local totalBossContainerHeight, spaceBetweenFrames = 0, 32
for i = 1, 8 or MAX_BOSS_FRAMES do
    local bossFrame = oUF:Spawn("boss" .. i, "UUF_Boss" .. i)
    if i == 1 then
        totalBossContainerHeight = (bossFrame:GetHeight() + spaceBetweenFrames) * MAX_BOSS_FRAMES - spaceBetweenFrames
        bossFrame:SetPoint("CENTER", UIParent, "CENTER", 750.1, totalBossContainerHeight / 2 - bossFrame:GetHeight() / 2)
    else
        bossFrame:SetPoint("TOPLEFT", _G["UUF_Boss" .. (i - 1)], "BOTTOMLEFT", 0, -spaceBetweenFrames)
    end
    UUF:RegisterRangeFrame(bossFrame, "boss" .. i) -- Range Checking
end

-- Spawn Pet Frame
oUF:RegisterStyle("UUF_Pet", function(self) CreateUnitFrame(self, 116, 38, false, false, false, false, true, false, "", false, false, false) end)
oUF:SetActiveStyle("UUF_Pet")
oUF:Spawn("pet", "UUF_Pet"):SetPoint("BOTTOMLEFT", UUF_Player, "TOPLEFT", 0, 1.1)

-- Spawn Focus Frame
oUF:RegisterStyle("UUF_Focus", function(self) CreateUnitFrame(self, 116, 38, false, false, false, false, true, false, "", false, false, false) end)
oUF:SetActiveStyle("UUF_Focus")
oUF:Spawn("focus", "UUF_Focus"):SetPoint("BOTTOMRIGHT", UUF_Target, "TOPRIGHT", 0, 1.1)