local _, UUF = ...
local UF = UUF.oUF

function UUF:SpawnPetFrame()
    if not UUF.DB.global.Pet.Frame.Enabled then return end
    local Frame = UUF.DB.global.Pet.Frame
    UF:RegisterStyle("UUF_Pet", function(self) UUF.CreateUnitFrame(self, "Pet") end)
    UF:SetActiveStyle("UUF_Pet")
    self.PetFrame = UF:Spawn("pet", "UUF_Pet")
    self.PetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
end