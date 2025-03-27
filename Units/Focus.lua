local _, UUF = ...
local UUF_oUF = UUF.oUF

function UUF:SpawnFocusFrame()
    if not UUF.DB.global.Focus.Frame.Enabled then return end
    local Frame = UUF.DB.global.Focus.Frame
    UUF_oUF:RegisterStyle("UUF_Focus", function(self) UUF.CreateUnitFrame(self, "Focus") end)
    UUF_oUF:SetActiveStyle("UUF_Focus")
    self.FocusFrame = UUF_oUF:Spawn("focus", "UUF_Focus")
    self.FocusFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.FocusFrame, "focus")
end