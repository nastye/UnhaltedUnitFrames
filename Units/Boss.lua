local _, UUF = ...
local UF = UUF.oUF

function UUF:SpawnBossFrames()
    local Frame = UUF.DB.global.Boss.Frame
    UF:RegisterStyle("UUF_Boss", function(self) UUF.CreateUnitFrame(self, "Boss") end)
    UF:SetActiveStyle("UUF_Boss")
    UUF.BossFrames = {}
    local BossSpacing = Frame.Spacing
    local BossContainer
    for i = 1, 8 do
        local BossFrame = UF:Spawn("boss" .. i, "UUF_Boss" .. i)
        UUF.BossFrames[i] = BossFrame
        if i == 1 then
            BossContainer = (BossFrame:GetHeight() + BossSpacing) * 8 - BossSpacing
            local offsetY = (BossContainer / 2 - BossFrame:GetHeight() / 2)
            if Frame.GrowthY ~= "DOWN" then
                offsetY = -offsetY
            end
            BossFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, offsetY + Frame.YPosition)
        else
            local anchor = Frame.GrowthY == "DOWN" and "TOPLEFT" or "BOTTOMLEFT"
            local relativeAnchor = Frame.GrowthY == "DOWN" and "BOTTOMLEFT" or "TOPLEFT"
            local offsetY = Frame.GrowthY == "DOWN" and -BossSpacing or BossSpacing
            BossFrame:SetPoint(anchor, _G["UUF_Boss" .. (i - 1)], relativeAnchor, 0, offsetY)
        end
        UUF:RegisterRangeFrame(BossFrame, "boss" .. i)
    end
end