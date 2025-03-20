local _, UUF = ...
local oUF = UUF.oUF
function UUF:PostCreateButton(_, button)
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
