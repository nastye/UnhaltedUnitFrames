local _, UUF = ...
local UUF_oUF = UUF.oUF

function UUF:SpawnTargetTargetFrame()
    if not UUF.DB.global.TargetTarget.Frame.Enabled then return end
    local Frame = UUF.DB.global.TargetTarget.Frame
    UUF_oUF:RegisterStyle("UUF_TargetTarget", function(self) UUF.CreateUnitFrame(self, "TargetTarget") end)
    UUF_oUF:SetActiveStyle("UUF_TargetTarget")
    self.TargetTargetFrame = UUF_oUF:Spawn("targettarget", "UUF_TargetTarget")
    self.TargetTargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end