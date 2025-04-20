local _, UUF = ...
local oUF = UUF.oUF

local unitIsTargetEvtFrame = CreateFrame("Frame")
unitIsTargetEvtFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
unitIsTargetEvtFrame:RegisterEvent("UNIT_TARGET")
unitIsTargetEvtFrame:SetScript("OnEvent", function()
    if not UUF.DB.profile.Boss.TargetIndicator.Enabled then return end
    for _, frameData in ipairs(UUF.TargetHighlightEvtFrames) do
        local frame, unit = frameData.frame, frameData.unit
        UUF:UpdateTargetHighlight(frame, unit)
    end
end)

function UUF:SpawnBossFrames()
    if not UUF.DB.profile.Boss.Frame.Enabled then return end
    local Frame = UUF.DB.profile.Boss.Frame
    oUF:RegisterStyle("UUF_Boss", function(self) UUF.CreateUnitFrame(self, "Boss") end)
    oUF:SetActiveStyle("UUF_Boss")
    UUF.BossFrames = {}
    local BossSpacing = Frame.Spacing
    for i = 1, 8 do
        local BossFrame = oUF:Spawn("boss" .. i, "UUF_Boss" .. i)
        UUF.BossFrames[i] = BossFrame
        if i == 1 then
            BossFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
        else
            local anchor = Frame.GrowthY == "DOWN" and "TOPLEFT" or "BOTTOMLEFT"
            local relativeAnchor = Frame.GrowthY == "DOWN" and "BOTTOMLEFT" or "TOPLEFT"
            local offsetY = Frame.GrowthY == "DOWN" and -BossSpacing or BossSpacing
            BossFrame:SetPoint(anchor, _G["UUF_Boss" .. (i - 1)], relativeAnchor, 0, offsetY)
        end
        UUF:RegisterRangeFrame(BossFrame, "boss" .. i)
        UUF:RegisterTargetHighlightFrame(BossFrame, "boss" .. i)
    end
end
