local _, UUF = ...
local UF = UUF.oUF

function UUF:SpawnTargetFrame()
    local Frame = UUF.DB.global.Target.Frame
    UF:RegisterStyle("UUF_Target", function(self) UUF.CreateUnitFrame(self, "Target") end)
    UF:SetActiveStyle("UUF_Target")
    self.TargetFrame = UF:Spawn("target", "UUF_Target")
    self.TargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end