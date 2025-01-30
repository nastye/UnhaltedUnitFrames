local _, UUF = ...
local oUF = UUF.oUF
UUF.isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

UUF.AltManaSpecID = {
    [1467] = "true", -- Devastation
    [1473] = "true", -- Augmentation
    [258] = "true", -- Shadow
    [262] = "true", -- Elemental
    [263] = "true", -- Enhancement
    [102] = "true", -- Balance
    [103] = "true", -- Feral
    [104] = "true", -- Guardian
}

UUF.ClassName = {
	DEATHKNIGHT	= "Death Knight",
	DEMONHUNTER	= "Demon Hunter",
	DRUID		= "Druid",
	EVOKER		= "Evoker",
	HUNTER		= "Hunter",
	MAGE		= "Mage",
	MONK		= "Monk",
	PALADIN		= "Paladin",
	PRIEST		= "Priest",
	ROGUE		= "Rogue",
	SHAMAN		= "Shaman",
	WARLOCK		= "Warlock",
	WARRIOR		= "Warrior",
}

UUF.SpecName = {
	-- Death Knight
	[250]	= "Blood",
	[251]	= "Frost",
	[252]	= "Unholy",
	-- Demon Hunter
	[577]	= "Havoc",
	[581]	= "Vengeance",
	-- Druids
	[102]	= "Balance",
	[103]	= "Feral",
	[104]	= "Guardian",
	[105]	= "Restoration",
	-- Evoker
	[1467]	= "Devastation",
	[1468]	= "Preservation",
	[1473]	= "Augmentation",
	-- Hunter
	[253]	= "Beast Mastery",
	[254]	= "Marksmanship",
	[255]	= "Survival",
	-- Mage
	[62]	= "Arcane",
	[63]	= "Fire",
	[64]	= "Frost",
	-- Monk
	[268]	= "Brewmaster",
	[270]	= "Mistweaver",
	[269]	= "Windwalker",
	-- Paladin
	[65]	= "Holy",
	[66]	= "Protection",
	[70]	= "Retribution",
	-- Priest
	[256]	= "Discipline",
	[257]	= "Holy",
	[258]	= "Shadow",
	-- Rogue
	[259]	= "Assassination",
	[260]	= "Combat",
	[261]	= "Subtlety",
	-- Shaman
	[262]	= "Elemental",
	[263]	= "Enhancement",
	[264]	= "Restoration",
	-- Walock
	[265]	= "Affliction",
	[266]	= "Demonology",
	[267]	= "Destruction",
	-- Warrior
	[71]	= "Arms",
	[72]	= "Fury",
	[73]	= "Protection",
}

-- Last Name Blacklist
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

-- Hide Blizzard Cast Bar
PlayerCastingBarFrame:UnregisterAllEvents()

-- Get Unit Reaction
function UUF:GetUnitReaction(unit)
    if UnitIsPlayer(unit) then
        return UnitReaction(unit, "player")
    else
        return UnitReaction(unit, "player")
    end
end

-- Format Large Number
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

-- Get Coloured Name: For Kwepp / Dark Frames.
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

-- Shorten Name
function UUF:ShortenName(name, nameBlacklist)
    if not name or name == "" then return nil end
    local unitName
    local a, b, c, d, e, f = strsplit(' ', name, 5)
    if nameBlacklist[b] then
        unitName = a or b or c or d or e or f
    else
        unitName = f or e or d or c or b or a
    end
    return unitName or name
end