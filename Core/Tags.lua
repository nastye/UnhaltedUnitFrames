local _, UUF = ...
local UUF_oUF = UUF.oUF

UUF_oUF.Tags.Methods["Health:CurHPwithPerHP"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit) or 0
    local effectiveHealth = unitHealth + unitAbsorb
    local unitHealthPercent = (unitMaxHealth > 0) and (effectiveHealth / unitMaxHealth * 100) or 0
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%s - %.1f%%", UUF:FormatLargeNumber(unitHealth), unitHealthPercent)
    end
end

UUF_oUF.Tags.Methods["Health:PerHPwithAbsorbs"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitMaxHealth = UnitHealthMax(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit) or 0
    if unitAbsorb and unitAbsorb > 0 then unitHealth = unitHealth + unitAbsorb end
    local unitHealthPercent = (unitMaxHealth > 0) and (unitHealth / unitMaxHealth * 100) or 0
    return string.format("%.1f%%", unitHealthPercent)
end

UUF_oUF.Tags.Methods["Health:CurHP"] = function(unit)
    local unitHealth = UnitHealth(unit)
    local unitStatus = UnitIsDead(unit) and "Dead" or UnitIsGhost(unit) and "Ghost" or not UnitIsConnected(unit) and "Offline"
    if unitStatus then
        return unitStatus
    else
        return string.format("%s", UUF:FormatLargeNumber(unitHealth))
    end
end

UUF_oUF.Tags.Methods["Health:CurAbsorbs"] = function(unit)
    local unitAbsorb = UnitGetTotalAbsorbs(unit) or 0
    if unitAbsorb > 0 then 
        return UUF:FormatLargeNumber(unitAbsorb)
    end
end

UUF_oUF.Tags.Methods["Name:NamewithTargetTarget"] = function(unit)
    local unitName = UnitName(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitName, unitTarget)
    else
        return unitName
    end
end

UUF_oUF.Tags.Methods["Name:TargetTarget"] = function(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return unitTarget
    end
end

UUF_oUF.Tags.Methods["Name:NamewithTargetTarget:Coloured"] = function(unit)
    local unitName = UnitName(unit)
    local unitTarget = UnitName(unit .. "target")
    local colouredUnitName = UUF:WrapTextInColor(unitName, unit)
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", colouredUnitName, unitTarget)
    else
        return colouredUnitName
    end
end

UUF_oUF.Tags.Methods["Name:TargetTarget:Coloured"] = function(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return UUF:WrapTextInColor(unitTarget, unit .. "target")
    end
end

UUF_oUF.Tags.Methods["Name:NamewithTargetTarget:LastNameOnly"] = function(unit)
    local unitName = UnitName(unit)
    local unitTarget = UnitName(unit .. "target")
    local unitLastName = UUF:ShortenName(unitName, UUF.nameBlacklist)
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", unitLastName, UUF:ShortenName(unitTarget, UUF.nameBlacklist))
    else
        return unitLastName
    end
end

UUF_oUF.Tags.Methods["Name:NamewithTargetTarget:LastNameOnly:Coloured"] = function(unit)
    local unitName = UnitName(unit)
    local unitTarget = UnitName(unit .. "target")
    local colouredUnitName = UUF:WrapTextInColor(UUF:ShortenName(unitName, UUF.nameBlacklist), unit)
    if unitTarget and unitTarget ~= "" then
        return string.format("%s » %s", colouredUnitName, UUF:WrapTextInColor(UUF:ShortenName(unitTarget, UUF.nameBlacklist), unit .. "target"))
    else
        return colouredUnitName
    end
end

UUF_oUF.Tags.Methods["Name:LastNameOnly"] = function(unit)
    local unitName = UnitName(unit)
    return UUF:ShortenName(unitName, UUF.nameBlacklist)
end

UUF_oUF.Tags.Methods["Name:LastNameOnly:Coloured"] = function(unit)
    local unitName = UnitName(unit)
    return UUF:WrapTextInColor(UUF:ShortenName(unitName, UUF.nameBlacklist), unit)
end

UUF_oUF.Tags.Methods["Name:TargetTarget:LastNameOnly"] = function(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return UUF:ShortenName(unitTarget, UUF.nameBlacklist)
    end
end

UUF_oUF.Tags.Methods["Name:TargetTarget:LastNameOnly:Coloured"] = function(unit)
    local unitTarget = UnitName(unit .. "target")
    if unitTarget and unitTarget ~= "" then
        return UUF:WrapTextInColor(UUF:ShortenName(unitTarget, UUF.nameBlacklist), unit .. "target")
    end
end

UUF_oUF.Tags.Methods["Name:VeryShort"] = function(unit)
    local name = UnitName(unit)
    if name then 
        return string.sub(name, 1, 5)
    end
end

UUF_oUF.Tags.Methods["Name:Short"] = function(unit)
    local name = UnitName(unit)
    if name then 
        return string.sub(name, 1, 8)
    end
end

UUF_oUF.Tags.Methods["Name:Medium"] = function(unit)
    local name = UnitName(unit)
    if name then 
        return string.sub(name, 1, 10)
    end
end

UUF_oUF.Tags.Methods["Power:CurPP"] = function(unit)
    local unitPower = UnitPower(unit)
    return UUF:FormatLargeNumber(unitPower)
end

UUF_oUF.Tags.Events["Name:NamewithTargetTarget"] = "UNIT_NAME_UPDATE UNIT_TARGET"
UUF_oUF.Tags.Events["Name:NamewithTargetTarget:Coloured"] = "UNIT_NAME_UPDATE UNIT_TARGET"
UUF_oUF.Tags.Events["Name:TargetTarget"] = "UNIT_TARGET"
UUF_oUF.Tags.Events["Name:TargetTarget:Coloured"] = "UNIT_TARGET"
UUF_oUF.Tags.Events["Name:LastNameOnly"] = "UNIT_NAME_UPDATE"
UUF_oUF.Tags.Events["Name:LastNameOnly:Coloured"] = "UNIT_NAME_UPDATE"
UUF_oUF.Tags.Events["Name:TargetTarget:LastNameOnly"] = "UNIT_TARGET"
UUF_oUF.Tags.Events["Name:TargetTarget:LastNameOnly:Coloured"] = "UNIT_TARGET"
UUF_oUF.Tags.Events["Name:NamewithTargetTarget:LastNameOnly"] = "UNIT_NAME_UPDATE UNIT_TARGET"
UUF_oUF.Tags.Events["Name:NamewithTargetTarget:LastNameOnly:Coloured"] = "UNIT_NAME_UPDATE UNIT_TARGET"

UUF_oUF.Tags.Events["Health:CurHPwithPerHP"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_ABSORB_AMOUNT_CHANGED"
UUF_oUF.Tags.Events["Health:PerHPwithAbsorbs"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED"
UUF_oUF.Tags.Events["Health:CurHP"] = "UNIT_HEALTH UNIT_CONNECTION"
UUF_oUF.Tags.Events["Health:CurAbsorbs"] = "UNIT_ABSORB_AMOUNT_CHANGED"

UUF_oUF.Tags.Events["Power:CurPP"] = "UNIT_POWER_UPDATE UNIT_MAXPOWER"

local HealthTagsDescription = {
    ["Current Health with Percent Health"] = {Tag = "[Health:CurHPwithPerHP]", Desc = "Displays Current Health with Percent Health (Absorbs Included)"},
    ["Percent Health with Absorbs"] = {Tag = "[Health:PerHPwithAbsorbs]", Desc = "Displays Percent Health with Absorbs"},
    ["Current Health"] = {Tag = "[Health:CurHP]", Desc = "Displays Current Health"},
    ["Current Absorbs"] = {Tag = "[Health:CurAbsorbs]", Desc = "Displays Current Absorbs"},
}

function UUF:FetchHealthTagDescriptions()
    return HealthTagsDescription
end

local NameTagsDescription = {
    ["Name with Target's Target"] = {Tag = "[Name:NamewithTargetTarget]", Desc = "Displays Name with Target's Target"},
    ["Target's Target"] = {Tag = "[Name:TargetTarget]", Desc = "Displays Target's Target"},
    ["Name with Target's Target (Coloured)"] = {Tag = "[Name:NamewithTargetTarget:Coloured]", Desc = "Displays Name with Target's Target (Reaction / Class Coloured)"},
    ["Target's Target (Coloured)"] = {Tag = "[Name:TargetTarget:Coloured]", Desc = "Displays Target's Target (Reaction / Class Coloured)"},
    ["Last Name Only"] = {Tag = "[Name:LastNameOnly]", Desc = "Displays Last Name Only"},
    ["Last Name Only (Coloured)"] = {Tag = "[Name:LastNameOnly:Coloured]", Desc = "Displays Last Name Only (Reaction / Class Coloured)"},
    ["Target's Target Last Name Only"] = {Tag = "[Name:TargetTarget:LastNameOnly]", Desc = "Displays Target's Target Last Name Only"},
    ["Target's Target Last Name Only (Coloured)"] = {Tag = "[Name:TargetTarget:LastNameOnly:Coloured]", Desc = "Displays Target's Target Last Name Only (Reaction / Class Coloured)"},
    ["Name with Target's Target Last Name Only"] = {Tag = "[Name:NamewithTargetTarget:LastNameOnly]", Desc = "Displays Name with Target's Target Last Name Only"},
    ["Name with Target's Target Last Name Only (Coloured)"] = {Tag = "[Name:NamewithTargetTarget:LastNameOnly:Coloured]", Desc = "Displays Name with Target's Target Last Name Only (Reaction / Class Coloured)"},
}

function UUF:FetchNameTagDescriptions()
    return NameTagsDescription
end

local PowerTagsDescription = {
    ["Current Power"] = {Tag = "[Power:CurPP]", Desc = "Displays Current Power"},
    ["Colour Power"] = {Tag = "[powercolor]", Desc = "Colour Power. Put infront of Power Tag to colour it."},
}

function UUF:FetchPowerTagDescriptions()
    return PowerTagsDescription
end

local MiscTagsDescription = {
    ["Classification"] = {Tag = "[classification]", Desc = "Returns the current classification (Elite, Rare, Rare Elite) of the unit."},
    ["Short Classification"] = {Tag = "[shortclassification]", Desc = "Returns the current classification (Elite, Rare, Rare Elite) of the unit, shortened."},
    ["Group"] = {Tag = "[group]", Desc = "Returns the current group number of the unit."},
    ["Level"] = {Tag = "[level]", Desc = "Returns the current level of the unit."},
    ["Status"] = {Tag = "[status]", Desc = "Return the current status (Dead, Offline) of the unit."}
}

function UUF:FetchMiscTagDescriptions()
    return MiscTagsDescription
end

