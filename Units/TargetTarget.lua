local _, UUF = ...
local oUF = UUF.oUF

function UUF:SpawnTargetTargetFrame()
    if not UUF.DB.global.TargetTarget.Frame.Enabled then return end
    local Frame = UUF.DB.global.TargetTarget.Frame
    oUF:RegisterStyle("UUF_TargetTarget", function(self) UUF.CreateUnitFrame(self, "TargetTarget") end)
    oUF:SetActiveStyle("UUF_TargetTarget")
    self.TargetTargetFrame = oUF:Spawn("targettarget", "UUF_TargetTarget")
    self.TargetTargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.TargetTargetFrame, "targettarget")
end