local _, UUF = ...
local oUF = UUF.oUF
local nameBlacklist = UUF.nameBlacklist
-- Health: Current Value (Shortened)
oUF.Tags.Methods["Health:Current:Short"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return UUF:FormatLargeNumber(unitHealth)
    end
end

-- Absorb: Current Value (Shortened)
oUF.Tags.Methods["Absorb:Current:Short"] = function(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit)
    if unitAbsorb > 0 then 
        return UUF:FormatLargeNumber(unitAbsorb)
    end
end

-- Health: Percentage
oUF.Tags.Methods["Health:Percent"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitHealthPercent = unitHealth / unitMaxHealth * 100
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%.1f%%", unitHealthPercent)
    end
end

-- Health + Absorbs: Percentage
oUF.Tags.Methods["Health:EffectivePercent"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit) or 0
    local unitEffectiveHealth = unitHealth + unitAbsorb
    local unitHealthPercent = unitEffectiveHealth / unitMaxHealth * 100
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%.1f%%", unitHealthPercent)
    end
end

-- Health: Current Value + Percentage (Shortened)
oUF.Tags.Methods["Health:CurrentWithPercent:Short"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitHealthPercent = unitHealth / unitMaxHealth * 100
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%s • %.1f%%", UUF:FormatLargeNumber(unitHealth), unitHealthPercent)
    end
end

-- Health + Absorbs: Current Value + Percentage (Shortened)
oUF.Tags.Methods["Health:EffectiveCurrentWithPercent:Short"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit) or 0
    local unitEffectiveHealth = unitHealth + unitAbsorb
    local unitHealthPercent = unitEffectiveHealth / unitMaxHealth * 100
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%s • %.1f%%", UUF:FormatLargeNumber(unitEffectiveHealth), unitHealthPercent)
    end
end

-- Power: Current Value (Shortened)
oUF.Tags.Methods["Power:Current:Short"] = function(unit)
    local unitPower = UnitPower(unit)
    return UUF:FormatLargeNumber(unitPower)
end

-- Unit Name with Target of Target
oUF.Tags.Methods["Name:TargetofTarget"] = function(unit)
    local unitName = UnitName(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Target of Target - Short
oUF.Tags.Methods["Name:TargetofTarget:Shorten"] = function(unit)
    local unitName = UUF:ShortenName(UnitName(unit), nameBlacklist)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Target of Target with Class Color / Reaction Color
oUF.Tags.Methods["Name:TargetofTarget:Colored"] = function(unit)
    local unitName = UUF:GetColoredName(unit)
    local unitTarget = UUF:GetColoredName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Target of Target with Class Color / Reaction Color - Short
oUF.Tags.Methods["Name:TargetofTarget:Colored:Shorten"] = function(unit)
    local unitName = UUF:ShortenName(UUF:GetColoredName(unit), nameBlacklist)
    local unitTarget = UUF:GetColoredName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

-- Unit Name with Class Color / Reaction Color
oUF.Tags.Methods["Name:Colored"] = function(unit)
    return UUF:GetColoredName(unit)
end

-- Unit Name (Last Name)
oUF.Tags.Methods["Name:LastOnly"] = function(unit)
    return UUF:ShortenName(UnitName(unit), nameBlacklist)
end

-- Unit Name (Last Name) - Colored
oUF.Tags.Methods["Name:LastOnly:Colored"] = function(unit)
    local unitName = UUF:ShortenName(UnitName(unit), nameBlacklist)
    return UUF:WrapTextInColor(unitName, unit)
end

-- Register with oUF
-- Register the relevant tag with the appropriate events. Don't overdo it.
oUF.Tags.Events["Health:Current:Short"] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags.Events["Absorb:Current:Short"] = "UNIT_ABSORB_AMOUNT_CHANGED"
oUF.Tags.Events["Health:Percent"] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags.Events["Health:EffectivePercent"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED"
oUF.Tags.Events["Health:CurrentWithPercent:Short"] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags.Events["Health:EffectiveCurrentWithPercent:Short"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED"
oUF.Tags.Events["Power:Current:Short"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"
oUF.Tags.Events["Name:TargetofTarget"] = "UNIT_NAME_UPDATE UNIT_TARGET"
oUF.Tags.Events["Name:TargetofTarget:Colored"] = "UNIT_NAME_UPDATE UNIT_TARGET"
oUF.Tags.Events["Name:Colored"] = "UNIT_NAME_UPDATE UNIT_TARGET"
oUF.Tags.Events["Name:LastOnly"] = "UNIT_NAME_UPDATE"
oUF.Tags.Events["Name:TargetofTarget:Colored:Shorten"] = "UNIT_NAME_UPDATE UNIT_TARGET"
oUF.Tags.Events["Name:TargetofTarget:Shorten"] = "UNIT_NAME_UPDATE UNIT_TARGET"
oUF.Tags.Events["Name:LastOnly:Colored"] = "UNIT_NAME_UPDATE"
