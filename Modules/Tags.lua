local _, UUF = ...
local oUF = UUF.oUF
local nameBlacklist = UUF.nameBlacklist

oUF.Tags.Methods["CurHP-PerHP:Short"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit) or 0
    if unitAbsorb and unitAbsorb > 0 then unitHealth = unitHealth + unitAbsorb end
    local unitHealthPercent = (unitMaxHealth > 0) and (unitHealth / unitMaxHealth * 100) or 0
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%s • %.1f%%", UUF:FormatLargeNumber(unitHealth), unitHealthPercent)
    end
end

-- Absorb: Current Value (Shortened)
oUF.Tags.Methods["CurAbsorb:Short"] = function(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit)
    if unitAbsorb and unitAbsorb > 0 then return UUF:FormatLargeNumber(unitAbsorb) end
end

-- Power: Current Value (Shortened)
oUF.Tags.Methods["CurPP:Short"] = function(unit)
    local unitPower = UnitPower(unit)
    local unitPowerType = UnitPowerType(unit)
    if unitPowerType == 0 then
        local unitPowerPercent = UnitPower(unit) / UnitPowerMax(unit) * 100
        return string.format("%.1f%%", unitPowerPercent)
    else
        return UUF:FormatLargeNumber(unitPower)
    end
end

-- Unit Name with Target of Target
oUF.Tags.Methods["ToT"] = function(unit)
    local unitName = UnitName(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Target of Target - Short
oUF.Tags.Methods["ToT:Shorten"] = function(unit)
    local unitName = UUF:ShortenName(UnitName(unit), nameBlacklist)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Target of Target with Class Color / Reaction Color
oUF.Tags.Methods["ToT:Colored"] = function(unit)
    local unitName = UUF:WrapTextInColor(UnitName(unit), unit)
    local unitTarget = UUF:WrapTextInColor(UnitName(unit .. "target"), unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Target of Target with Class Color / Reaction Color - Short
oUF.Tags.Methods["ToT:Colored:Shorten"] = function(unit)
    local shortenUnitName = UUF:ShortenName(UnitName(unit), nameBlacklist)
    local unitName = UUF:WrapTextInColor(shortenUnitName, unit)
    local unitTarget = UUF:WrapTextInColor(UnitName(unit .. "target"), unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Class Color / Reaction Color
oUF.Tags.Methods["Name:Colored"] = function(unit)
    return UUF:WrapTextInColor(UnitName(unit), unit)
end

-- Unit Name (Last Name)
oUF.Tags.Methods["Name:Shorten"] = function(unit)
    local shortenUnitName = UUF:ShortenName(UnitName(unit), nameBlacklist)
    return shortenUnitName
end

-- Unit Name (Last Name) - Colored
oUF.Tags.Methods["Name:Last:Colored"] = function(unit)
    local shortenUnitName = UUF:ShortenName(UnitName(unit), nameBlacklist)
    return UUF:WrapTextInColor(shortenUnitName, unit)
end

-- Register with oUF
-- Register the relevant tag with the appropriate events. Don't overdo it.
oUF.Tags.Events["CurHP-PerHP:Short"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_ABSORB_AMOUNT_CHANGED"
oUF.Tags.Events["CurAbsorb:Short"] = "UNIT_ABSORB_AMOUNT_CHANGED"
oUF.Tags.Events["CurPP:Short"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"
oUF.Tags.Events["ToT"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["ToT:Shorten"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["ToT:Colored"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["ToT:Colored:Shorten"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["Name:Colored"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["Name:Shorten"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["Name:Shorten:Colored"] = "UNIT_NAME_UPDATE"
