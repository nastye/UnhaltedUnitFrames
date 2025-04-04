local _, UUF = ...
local oUF = UUF.oUF

function UUF:SpawnPetFrame()
    if not UUF.DB.global.Pet.Frame.Enabled then return end
    local Frame = UUF.DB.global.Pet.Frame
    oUF:RegisterStyle("UUF_Pet", function(self) UUF.CreateUnitFrame(self, "Pet") end)
    oUF:SetActiveStyle("UUF_Pet")
    self.PetFrame = oUF:Spawn("pet", "UUF_Pet")
    self.PetFrame:SetPoint(Frame.AnchorFrom, Frame.AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.PetFrame, "pet")
end