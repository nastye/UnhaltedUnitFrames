local _, UUF = ...
local UF = UUF.oUF

function UUF:SpawnTargetTargetFrame()
    if not UUF.DB.global.TargetTarget.Frame.Enabled then return end
    local Frame = UUF.DB.global.TargetTarget.Frame
    UF:RegisterStyle("UUF_TargetTarget", function(self) UUF.CreateUnitFrame(self, "TargetTarget") end)
    UF:SetActiveStyle("UUF_TargetTarget")
    self.TargetTargetFrame = UF:Spawn("targettarget", "UUF_TargetTarget")
    self.TargetTargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end