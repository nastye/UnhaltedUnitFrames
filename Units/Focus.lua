local _, UUF = ...
local UF = UUF.oUF

function UUF:SpawnFocusFrame()
    if not UUF.DB.global.Focus.Frame.Enabled then return end
    local Frame = UUF.DB.global.Focus.Frame
    UF:RegisterStyle("UUF_Focus", function(self) UUF.CreateUnitFrame(self, "Focus") end)
    UF:SetActiveStyle("UUF_Focus")
    self.FocusFrame = UF:Spawn("focus", "UUF_Focus")
    self.FocusFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end