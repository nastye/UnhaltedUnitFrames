local _, UUF = ...
local UUF_oUF = UUF.oUF

function UUF:SpawnTargetFrame()
    local Frame = UUF.DB.global.Target.Frame
    UUF_oUF:RegisterStyle("UUF_Target", function(self) UUF.CreateUnitFrame(self, "Target") end)
    UUF_oUF:SetActiveStyle("UUF_Target")
    self.TargetFrame = UUF_oUF:Spawn("target", "UUF_Target")
    self.TargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.TargetFrame, "target")
end