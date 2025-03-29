local _, UUF = ...
local Serialize = LibStub:GetLibrary("AceSerializer-3.0")
local Compress = LibStub:GetLibrary("LibDeflate")

function UUF:ExportSavedVariables()
    local SerializedInfo = Serialize:Serialize(UUFDB.global)
    local CompressedInfo = Compress:CompressDeflate(SerializedInfo)
    local EncodedInfo = Compress:EncodeForPrint(CompressedInfo)
    return EncodedInfo
end

function UUF:ImportSavedVariables(EncodedInfo)
    local DecodedInfo = Compress:DecodeForPrint(EncodedInfo)
    local DecompressedInfo = Compress:DecompressDeflate(DecodedInfo)
    local InformationDecoded, InformationTable = Serialize:Deserialize(DecompressedInfo)
    if InformationDecoded then UUFDB.global = InformationTable end
end