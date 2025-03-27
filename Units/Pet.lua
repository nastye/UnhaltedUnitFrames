local _, UUF = ...
local UUF_oUF = UUF.oUF

function UUF:SpawnPetFrame()
    if not UUF.DB.global.Pet.Frame.Enabled then return end
    local Frame = UUF.DB.global.Pet.Frame
    UUF_oUF:RegisterStyle("UUF_Pet", function(self) UUF.CreateUnitFrame(self, "Pet") end)
    UUF_oUF:SetActiveStyle("UUF_Pet")
    self.PetFrame = UUF_oUF:Spawn("pet", "UUF_Pet")
    self.PetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.PetFrame, "pet")
end