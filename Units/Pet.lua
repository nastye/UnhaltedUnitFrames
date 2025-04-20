local _, UUF = ...
local oUF = UUF.oUF

function UUF:SpawnPetFrame()
    if not UUF.DB.profile.Pet.Frame.Enabled then return end
    local Frame = UUF.DB.profile.Pet.Frame
    oUF:RegisterStyle("UUF_Pet", function(self) UUF.CreateUnitFrame(self, "Pet") end)
    oUF:SetActiveStyle("UUF_Pet")
    self.PetFrame = oUF:Spawn("pet", "UUF_Pet")
    local AnchorParent = Frame.AnchorParent and Frame.AnchorParent ~= nil or UIParent
    self.PetFrame:SetPoint(Frame.AnchorFrom, AnchorParent, Frame.AnchorTo, Frame.XPosition, Frame.YPosition)
    UUF:RegisterRangeFrame(self.PetFrame, "pet")
end