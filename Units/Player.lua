local _, UUF = ...
local UUF_oUF = UUF.oUF

function UUF:SpawnPlayerFrame()
    local Frame = UUF.DB.global.Player.Frame
    UUF_oUF:RegisterStyle("UUF_Player", function(self) UUF.CreateUnitFrame(self, "Player") end)
    UUF_oUF:SetActiveStyle("UUF_Player")
    self.PlayerFrame = UUF_oUF:Spawn("player", "UUF_Player")
    self.PlayerFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end