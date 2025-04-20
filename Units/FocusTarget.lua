local _, UUF = ...
local oUF = UUF.oUF

function UUF:SpawnFocusTargetFrame()
    if not UUF.DB.profile.FocusTarget.Frame.Enabled then return end
    local Frame = UUF.DB.profile.FocusTarget.Frame
    oUF:RegisterStyle("UUF_FocusTarget", function(self) UUF.CreateUnitFrame(self, "FocusTarget") end)
    oUF:SetActiveStyle("UUF_FocusTarget")
    self.FocusTargetFrame = oUF:Spawn("focustarget", "UUF_FocusTarget")
    local AnchorParent = Frame.AnchorParent and Frame.AnchorParent ~= nil or UIParent
    self.FocusTargetFrame:SetPoint(Frame.AnchorFrom, AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.FocusTargetFrame, "focustarget")
end