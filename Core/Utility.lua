local _, UUF = ...

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