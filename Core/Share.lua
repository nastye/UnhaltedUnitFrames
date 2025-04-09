local _, UUF = ...
local Serialize = LibStub:GetLibrary("AceSerializer-3.0")
local Compress = LibStub:GetLibrary("LibDeflate")

function UUF:ExportSavedVariables()
    local SerializedInfo = Serialize:Serialize(UUF.DB.profile)
    local CompressedInfo = Compress:CompressDeflate(SerializedInfo)
    local EncodedInfo = Compress:EncodeForPrint(CompressedInfo)
    return EncodedInfo
end

function UUF:ImportSavedVariables(EncodedInfo)
    local DecodedInfo = Compress:DecodeForPrint(EncodedInfo)
    local DecompressedInfo = Compress:DecompressDeflate(DecodedInfo)
    local InformationDecoded, InformationTable = Serialize:Deserialize(DecompressedInfo)

    if not InformationDecoded then print("Failed to import: invalid or corrupted string.") return end

    StaticPopupDialogs["UUF_IMPORT_PROFILE_NAME"] = {
        text = "Enter A Profile Name:",
        button1 = "Import",
        button2 = "Cancel",
        hasEditBox = true,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        OnAccept = function(self)
            local newProfileName = self.editBox:GetText()
            if newProfileName and newProfileName ~= "" then
                UUF.DB:SetProfile(newProfileName)
                for k in pairs(UUF.DB.profile) do
                    UUF.DB.profile[k] = nil
                end
                for k, v in pairs(InformationTable) do
                    UUF.DB.profile[k] = v
                end

                UUF:CreateReloadPrompt()
            else
                print("Please enter a valid profile name.")
            end
        end,
    }

    StaticPopup_Show("UUF_IMPORT_PROFILE_NAME")
end

function UUFG:ExportSavedVariables()
    local SerializedInfo = Serialize:Serialize(UUF.DB.profile)
    local CompressedInfo = Compress:CompressDeflate(SerializedInfo)
    local EncodedInfo = Compress:EncodeForPrint(CompressedInfo)
    return EncodedInfo
end

function UUFG:ImportSavedVariables(EncodedInfo)
    local DecodedInfo = Compress:DecodeForPrint(EncodedInfo)
    local DecompressedInfo = Compress:DecompressDeflate(DecodedInfo)
    local InformationDecoded, InformationTable = Serialize:Deserialize(DecompressedInfo)
    if InformationDecoded then
        for k in pairs(UUF.DB.profile) do
            UUF.DB.profile[k] = nil
        end
        for k, v in pairs(InformationTable) do
            UUF.DB.profile[k] = v
        end
    end
end