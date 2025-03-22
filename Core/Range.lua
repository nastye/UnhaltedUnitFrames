local _, UUF = ...
local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
UUF.RangeEvtFrames = {}

local rangeEventFrame = CreateFrame("Frame")
rangeEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
rangeEventFrame:RegisterEvent("UNIT_TARGET")
rangeEventFrame:RegisterEvent("UNIT_AURA")
rangeEventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
rangeEventFrame:RegisterEvent("SPELL_UPDATE_USABLE")
rangeEventFrame:SetScript("OnEvent", function()
    for _, frameData in ipairs(UUF.RangeEvtFrames) do
        local frame, unit = frameData.frame, frameData.unit
        UUF:UpdateRangeAlpha(frame, unit)
    end
end)

function UUF:RegisterRangeFrame(frame, unit)
    table.insert(UUF.RangeEvtFrames, { frame = frame, unit = unit })
end

-- Range Check
local LRC = LibStub("LibRangeCheck-3.0")

function GetGroupUnit(unit)
	if UnitIsUnit(unit, 'player') then return end
	if strfind(unit, 'party') or strfind(unit, 'raid') then
		return unit
	end
	if UnitInParty(unit) or UnitInRaid(unit) then
		local isInRaid = IsInRaid()
		for i = 1, GetNumGroupMembers() do
			local groupUnit = (isInRaid and 'raid' or 'party')..i
			if UnitIsUnit(unit, groupUnit) then
				return groupUnit
			end
		end
	end
end

local function IsUnitInRange(unit)
    local minRange, maxRange = LRC:GetRange(unit, true, true)
    return (not minRange) or maxRange
end

local function FriendlyIsInRange(realUnit)
    local unit = GetGroupUnit(realUnit) or realUnit
    if UnitIsPlayer(unit) and (isRetail and UnitPhaseReason(unit) or not isRetail --[[and not UnitInPhase(unit)]]) then
        return false
    end
    local inRange, checkedRange = UnitInRange(unit)
    if checkedRange and not inRange then
        return false
    end
    return IsUnitInRange(unit)
end

function UUF:UpdateRangeAlpha(frame, unit)
    local frameAlpha
    if UnitCanAttack('player', unit) or UnitIsUnit(unit, 'pet') then
        frameAlpha = (IsUnitInRange(unit) and 1) or 0.5
    else
        frameAlpha = (UnitIsConnected(unit) and FriendlyIsInRange(unit) and 1) or 0.5
    end
    frame:SetAlpha(frameAlpha)
end