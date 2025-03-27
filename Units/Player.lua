local _, UUF = ...
local UF = UUF.oUF

function UUF:SpawnPlayerFrame()
    local Frame = UUF.DB.global.Player.Frame
    UF:RegisterStyle("UUF_Player", function(self) UUF.CreateUnitFrame(self, "Player") end)
    UF:SetActiveStyle("UUF_Player")
    self.PlayerFrame = UF:Spawn("player", "UUF_Player")
    self.PlayerFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end