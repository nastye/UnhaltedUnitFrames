local _, UUF = ...
local UUF_oUF = UUF.oUF

function UUF:SpawnFocusTargetFrame()
    if not UUF.DB.global.FocusTarget.Frame.Enabled then return end
    local Frame = UUF.DB.global.FocusTarget.Frame
    UUF_oUF:RegisterStyle("UUF_FocusTarget", function(self) UUF.CreateUnitFrame(self, "FocusTarget") end)
    UUF_oUF:SetActiveStyle("UUF_FocusTarget")
    self.FocusTargetFrame = UUF_oUF:Spawn("focustarget", "UUF_FocusTarget")
    self.FocusTargetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.FocusTargetFrame, "focustarget")
end