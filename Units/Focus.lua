local _, UUF = ...
local oUF = UUF.oUF

function UUF:SpawnFocusFrame()
    if not UUF.DB.global.Focus.Frame.Enabled then return end
    local Frame = UUF.DB.global.Focus.Frame
    oUF:RegisterStyle("UUF_Focus", function(self) UUF.CreateUnitFrame(self, "Focus") end)
    oUF:SetActiveStyle("UUF_Focus")
    self.FocusFrame = oUF:Spawn("focus", "UUF_Focus")
    self.FocusFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.FocusFrame, "focus")
end