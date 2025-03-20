local _, UUF = ...
local UUFGUI = LibStub:GetLibrary("AceGUI-3.0")
local GUI_WIDTH = 1200
local GUI_HEIGHT = 900
local GUI_TITLE = C_AddOns.GetAddOnMetadata("UnhaltedUF", "Title")
local GUI_VERSION = C_AddOns.GetAddOnMetadata("UnhaltedUF", "Version")
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("border", "WHITE8X8", [[Interface\Buttons\WHITE8X8]])
local LSMFonts = {}
local LSMTextures = {}
local LSMBorders = {}

local PowerNames = {
    [0] = "Mana",
    [1] = "Rage",
    [2] = "Focus",
    [3] = "Energy",
    [4] = "Combo Points",
    [5] = "Runes",
    [6] = "Runic Power",
    [7] = "Soul Shards",
    [8] = "Lunar Power",
    [9] = "Holy Power",
    [11] = "Maelstrom",
    [13] = "Insanity",
    [17] = "Fury",
    [18] = "Pain"
}

local ReactionNames = {
    [1] = "Hated",
    [2] = "Hostile",
    [3] = "Unfriendly",
    [4] = "Neutral",
    [5] = "Friendly",
    [6] = "Honored",
    [7] = "Revered",
    [8] = "Exalted",
}

function UUF:GenerateLSMFonts()
    local Fonts = LSM:HashTable("font")
    for Path, Font in pairs(Fonts) do
        LSMFonts[Font] = Path
    end
    return LSMFonts
end

function UUF:GenerateLSMBorders()
    local Borders = LSM:HashTable("border")
    for Path, Border in pairs(Borders) do
        LSMBorders[Border] = Path
    end
    return LSMBorders
end

function UUF:GenerateLSMTextures()
    local Textures = LSM:HashTable("statusbar")
    for Path, Texture in pairs(Textures) do
        LSMTextures[Texture] = Path
    end
    return LSMTextures
end

function UUF:UpdateFrames()
    UUF:LoadCustomColours()
    UUF:UpdateUnitFrame(self.PlayerFrame)
    UUF:UpdateUnitFrame(self.TargetFrame)
    UUF:UpdateUnitFrame(self.FocusFrame)
    UUF:UpdateUnitFrame(self.PetFrame)
    UUF:UpdateUnitFrame(self.TargetTargetFrame)
    UUF:UpdateBossFrames()
end

function UUF:CreateReloadPrompt()
    StaticPopupDialogs["UUF_RELOAD_PROMPT"] = {
        text = "Reload is necessary for changes to take effect. Reload Now?",
        button1 = "Reload",
        button2 = "Later",
        OnAccept = function() ReloadUI() end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("UUF_RELOAD_PROMPT")
end

function UUF:UpdateUIScale()
    UIParent:SetScale(UUF.DB.global.General.UIScale)
end

local AnchorPoints = {
    ["TOPLEFT"] = "Top Left",
    ["TOP"] = "Top",
    ["TOPRIGHT"] = "Top Right",
    ["LEFT"] = "Left",
    ["CENTER"] = "Center",
    ["RIGHT"] = "Right",
    ["BOTTOMLEFT"] = "Bottom Left",
    ["BOTTOM"] = "Bottom",
    ["BOTTOMRIGHT"] = "Bottom Right",
}

local GrowthX = {
    ["LEFT"] = "Left",
    ["RIGHT"] = "Right",
}

local GrowthY = {
    ["UP"] = "Up",
    ["DOWN"] = "Down",
}

function UUF:CreateGUI()
    UUF:GenerateLSMFonts()
    UUF:GenerateLSMTextures()
    -- UUF:GenerateLSMBorders()
    local UUFGUI_Container = UUFGUI:Create("Frame")
    UUFGUI_Container:SetTitle(GUI_TITLE)
    UUFGUI_Container:SetStatusText("Version: " .. GUI_VERSION)
    UUFGUI_Container:SetLayout("Fill")
    UUFGUI_Container:SetWidth(GUI_WIDTH)
    UUFGUI_Container:SetHeight(GUI_HEIGHT)
    UUFGUI_Container:EnableResize(false)
    UUFGUI_Container:SetCallback("OnClose", function(widget) UUFGUI:Release(widget) end)

    local function DrawGeneralContainer(UUFGUI_Container)
        local General = UUF.DB.global.General
        local UIScaleContainer = UUFGUI:Create("InlineGroup")
        UIScaleContainer:SetTitle("UI Scale")
        UIScaleContainer:SetLayout("Flow")
        UIScaleContainer:SetFullWidth(true)

        local UIScale = UUFGUI:Create("Slider")
        UIScale:SetLabel("UI Scale")
        UIScale:SetSliderValues(0.5, 2, 0.01)
        UIScale:SetValue(General.UIScale)
        UIScale:SetCallback("OnValueChanged", function(widget, event, value) General.UIScale = value end)
        UIScale:SetRelativeWidth(0.25)
        UIScaleContainer:AddChild(UIScale)

        local TenEightyP = UUFGUI:Create("Button")
        TenEightyP:SetText("1080p")
        TenEightyP:SetCallback("OnClick", function(widget, event, value) General.UIScale = 0.7111111111111 UIScale:SetValue(0.7111111111111) UUF:UpdateUIScale() end)
        TenEightyP:SetRelativeWidth(0.25)
        UIScaleContainer:AddChild(TenEightyP)

        local FourteenFortyP = UUFGUI:Create("Button")
        FourteenFortyP:SetText("1440p")
        FourteenFortyP:SetCallback("OnClick", function(widget, event, value) General.UIScale = 0.5333333333333 UIScale:SetValue(0.5333333333333) UUF:UpdateUIScale() end)
        FourteenFortyP:SetRelativeWidth(0.25)
        UIScaleContainer:AddChild(FourteenFortyP)

        local ApplyUIScale = UUFGUI:Create("Button")
        ApplyUIScale:SetText("Apply")
        ApplyUIScale:SetCallback("OnClick", function(widget, event, value) UUF:UpdateUIScale() end)
        ApplyUIScale:SetRelativeWidth(0.25)
        UIScaleContainer:AddChild(ApplyUIScale)
        
        UUFGUI_Container:AddChild(UIScaleContainer)

        -- Font Options
        local FontOptionsContainer = UUFGUI:Create("InlineGroup")
        FontOptionsContainer:SetTitle("Font Options")
        FontOptionsContainer:SetLayout("Flow")
        FontOptionsContainer:SetFullWidth(true)

        local Font = UUFGUI:Create("Dropdown")
        Font:SetLabel("Font")
        Font:SetList(LSMFonts)
        Font:SetValue(General.Font)
        Font:SetCallback("OnValueChanged", function(widget, event, value) General.Font = value UUF:CreateReloadPrompt() end)
        Font:SetRelativeWidth(0.5)
        FontOptionsContainer:AddChild(Font)
        
        local FontFlag = UUFGUI:Create("Dropdown")
        FontFlag:SetLabel("Font Flag")
        FontFlag:SetList({
            ["NONE"] = "None",
            ["OUTLINE"] = "Outline",
            ["THICKOUTLINE"] = "Thick Outline",
            ["MONOCHROME"] = "Monochrome",
            ["OUTLINE, MONOCHROME"] = "Outline, Monochrome",
            ["THICKOUTLINE, MONOCHROME"] = "Thick Outline, Monochrome",
        })
        FontFlag:SetValue(General.FontFlag)
        FontFlag:SetCallback("OnValueChanged", function(widget, event, value) General.FontFlag = value UUF:UpdateFrames() end)
        FontFlag:SetRelativeWidth(0.5)
        FontOptionsContainer:AddChild(FontFlag)

        local FontShadowContainer = UUFGUI:Create("InlineGroup")
        FontShadowContainer:SetTitle("Font Shadow Options")
        FontShadowContainer:SetLayout("Flow")
        FontShadowContainer:SetFullWidth(true)
        FontOptionsContainer:AddChild(FontShadowContainer)

        local FontShadowColourPicker = UUFGUI:Create("ColorPicker")
        FontShadowColourPicker:SetLabel("Colour")
        local FSR, FSG, FSB, FSA = unpack(General.FontShadowColour)
        FontShadowColourPicker:SetColor(FSR, FSG, FSB, FSA)
        FontShadowColourPicker:SetCallback("OnValueChanged", function(widget, _, r, g, b, a) General.FontShadowColour = {r, g, b, a} UUF:UpdateFrames() end)
        FontShadowColourPicker:SetHasAlpha(true)
        FontShadowColourPicker:SetRelativeWidth(0.33)
        FontShadowContainer:AddChild(FontShadowColourPicker)

        local FontShadowOffsetX = UUFGUI:Create("Slider")
        FontShadowOffsetX:SetLabel("Shadow Offset X")
        FontShadowOffsetX:SetValue(General.FontShadowXOffset)
        FontShadowOffsetX:SetSliderValues(-10, 10, 1)
        FontShadowOffsetX:SetCallback("OnValueChanged", function(_, _, value) General.FontShadowXOffset = value UUF:UpdateFrames() end)
        FontShadowOffsetX:SetRelativeWidth(0.33)
        FontShadowContainer:AddChild(FontShadowOffsetX)
        
        local FontShadowOffsetY = UUFGUI:Create("Slider")
        FontShadowOffsetY:SetLabel("Shadow Offset Y")
        FontShadowOffsetY:SetValue(General.FontShadowYOffset)
        FontShadowOffsetY:SetSliderValues(-10, 10, 1)
        FontShadowOffsetY:SetCallback("OnValueChanged", function(_, _, value) General.FontShadowYOffset = value UUF:UpdateFrames() end)
        FontShadowOffsetY:SetRelativeWidth(0.33)
        FontShadowContainer:AddChild(FontShadowOffsetY)

        UUFGUI_Container:AddChild(FontOptionsContainer)

        -- Texture Options
        local TextureOptionsContainer = UUFGUI:Create("InlineGroup")
        TextureOptionsContainer:SetTitle("Texture Options")
        TextureOptionsContainer:SetLayout("Flow")
        TextureOptionsContainer:SetFullWidth(true)

        local ForegroundTexture = UUFGUI:Create("Dropdown")
        ForegroundTexture:SetLabel("Foreground Texture")
        ForegroundTexture:SetList(LSMTextures)
        ForegroundTexture:SetValue(General.ForegroundTexture)
        ForegroundTexture:SetCallback("OnValueChanged", function(widget, event, value) General.ForegroundTexture = value UUF:UpdateFrames() end)
        ForegroundTexture:SetRelativeWidth(0.5)
        TextureOptionsContainer:AddChild(ForegroundTexture)

        local BackgroundTexture = UUFGUI:Create("Dropdown")
        BackgroundTexture:SetLabel("Background Texture")
        BackgroundTexture:SetList(LSMTextures)
        BackgroundTexture:SetValue(General.BackgroundTexture)
        BackgroundTexture:SetCallback("OnValueChanged", function(widget, event, value) General.BackgroundTexture = value UUF:UpdateFrames() end)
        BackgroundTexture:SetRelativeWidth(0.5)
        TextureOptionsContainer:AddChild(BackgroundTexture)

        -- local BorderTexture = UUFGUI:Create("Dropdown")
        -- BorderTexture:SetLabel("Border Texture")
        -- BorderTexture:SetList(LSMBorders)
        -- BorderTexture:SetValue(General.BorderTexture)
        -- BorderTexture:SetCallback("OnValueChanged", function(widget, event, value) General.BorderTexture = value UUF:UpdateFrames() end)
        -- BorderTexture:SetRelativeWidth(0.33)
        -- TextureOptionsContainer:AddChild(BorderTexture)

        -- local BorderSize = UUFGUI:Create("Slider")
        -- BorderSize:SetLabel("Border Size")
        -- BorderSize:SetSliderValues(0, 64, 1)
        -- BorderSize:SetValue(General.BorderSize)
        -- BorderSize:SetCallback("OnValueChanged", function(widget, event, value) General.BorderSize = value UUF:UpdateFrames() end)
        -- BorderSize:SetRelativeWidth(0.5)
        -- TextureOptionsContainer:AddChild(BorderSize)

        -- local BorderInset = UUFGUI:Create("Slider")
        -- BorderInset:SetLabel("Border Inset")
        -- BorderInset:SetSliderValues(-64, 64, 1)
        -- BorderInset:SetValue(General.BorderInset)
        -- BorderInset:SetCallback("OnValueChanged", function(widget, event, value) General.BorderInset = value UUF:UpdateFrames() end)
        -- BorderInset:SetRelativeWidth(0.5)
        -- TextureOptionsContainer:AddChild(BorderInset)
        
        UUFGUI_Container:AddChild(TextureOptionsContainer)

        -- Colouring Options
        local ColouringOptionsContainer = UUFGUI:Create("InlineGroup")
        ColouringOptionsContainer:SetTitle("Colour Options")
        ColouringOptionsContainer:SetLayout("Flow")
        ColouringOptionsContainer:SetFullWidth(true)

        local ForegroundColour = UUFGUI:Create("ColorPicker")
        ForegroundColour:SetLabel("Foreground Colour")
        local FGR, FGG, FGB, FGA = unpack(General.ForegroundColour)
        ForegroundColour:SetColor(FGR, FGG, FGB, FGA)
        ForegroundColour:SetCallback("OnValueChanged", function(widget, _, r, g, b, a) General.ForegroundColour = {r, g, b, a} UUF:UpdateFrames() end)
        ForegroundColour:SetHasAlpha(true)
        ForegroundColour:SetRelativeWidth(0.33)
        ColouringOptionsContainer:AddChild(ForegroundColour)

        local BackgroundColour = UUFGUI:Create("ColorPicker")
        BackgroundColour:SetLabel("Background Colour")
        local BGR, BGG, BGB, BGA = unpack(General.BackgroundColour)
        BackgroundColour:SetColor(BGR, BGG, BGB, BGA)
        BackgroundColour:SetCallback("OnValueChanged", function(widget, _, r, g, b, a) General.BackgroundColour = {r, g, b, a} UUF:UpdateFrames() end)
        BackgroundColour:SetHasAlpha(true)
        BackgroundColour:SetRelativeWidth(0.33)
        ColouringOptionsContainer:AddChild(BackgroundColour)

        local BorderColour = UUFGUI:Create("ColorPicker")
        BorderColour:SetLabel("Border Colour")
        local BR, BG, BB, BA = unpack(General.BorderColour)
        BorderColour:SetColor(BR, BG, BB, BA)
        BorderColour:SetCallback("OnValueChanged", function(widget, _, r, g, b, a) General.BorderColour = {r, g, b, a} UUF:UpdateFrames() end)
        BorderColour:SetHasAlpha(true)
        BorderColour:SetRelativeWidth(0.33)
        ColouringOptionsContainer:AddChild(BorderColour)

        local ClassColour = UUFGUI:Create("CheckBox")
        ClassColour:SetLabel("Use Class Colour")
        ClassColour:SetValue(General.ColourByClass)
        ClassColour:SetCallback("OnValueChanged", function(widget, event, value) General.ColourByClass = value UUF:UpdateFrames() end)
        ClassColour:SetRelativeWidth(0.25)
        ColouringOptionsContainer:AddChild(ClassColour)

        local ReactionColour = UUFGUI:Create("CheckBox")
        ReactionColour:SetLabel("Use Reaction Colour")
        ReactionColour:SetValue(General.ColourByReaction)
        ReactionColour:SetCallback("OnValueChanged", function(widget, event, value) General.ColourByReaction = value UUF:UpdateFrames() end)
        ReactionColour:SetRelativeWidth(0.25)
        ColouringOptionsContainer:AddChild(ReactionColour)

        local DisconnectedColour = UUFGUI:Create("CheckBox")
        DisconnectedColour:SetLabel("Use Disconnected Colour")
        DisconnectedColour:SetValue(General.ColourIfDisconnected)
        DisconnectedColour:SetCallback("OnValueChanged", function(widget, event, value) General.ColourIfDisconnected = value UUF:UpdateFrames() end)
        DisconnectedColour:SetRelativeWidth(0.25)
        ColouringOptionsContainer:AddChild(DisconnectedColour)

        local TappedColour = UUFGUI:Create("CheckBox")
        TappedColour:SetLabel("Use Tapped Colour")
        TappedColour:SetValue(General.ColourIfTapped)
        TappedColour:SetCallback("OnValueChanged", function(widget, event, value) General.ColourIfTapped = value UUF:UpdateFrames() end)
        TappedColour:SetRelativeWidth(0.25)
        ColouringOptionsContainer:AddChild(TappedColour)

        local CustomColours = UUFGUI:Create("InlineGroup")
        CustomColours:SetTitle("Custom Colours")
        CustomColours:SetLayout("Flow")
        CustomColours:SetFullWidth(true)
        ColouringOptionsContainer:AddChild(CustomColours)

        local PowerColours = UUFGUI:Create("InlineGroup")
        PowerColours:SetTitle("Power Colours")
        PowerColours:SetLayout("Flow")
        PowerColours:SetFullWidth(true)
        CustomColours:AddChild(PowerColours)

        for powerType, powerColour in pairs(General.CustomColours.Power) do
            local PowerColour = UUFGUI:Create("ColorPicker")
            PowerColour:SetLabel(PowerNames[powerType])
            local R, G, B = unpack(powerColour)
            PowerColour:SetColor(R, G, B)
            PowerColour:SetCallback("OnValueChanged", function(widget, _, r, g, b) General.CustomColours.Power[powerType] = {r, g, b} UUF:UpdateFrames() end)
            PowerColour:SetHasAlpha(false)
            PowerColour:SetRelativeWidth(0.25)
            PowerColours:AddChild(PowerColour)
        end

        local ReactionColours = UUFGUI:Create("InlineGroup")
        ReactionColours:SetTitle("Reaction Colours")
        ReactionColours:SetLayout("Flow")
        ReactionColours:SetFullWidth(true)
        CustomColours:AddChild(ReactionColours)

        for reactionType, reactionColour in pairs(General.CustomColours.Reaction) do
            local ReactionColour = UUFGUI:Create("ColorPicker")
            ReactionColour:SetLabel(ReactionNames[reactionType])
            local R, G, B = unpack(reactionColour)
            ReactionColour:SetColor(R, G, B)
            ReactionColour:SetCallback("OnValueChanged", function(widget, _, r, g, b) General.CustomColours.Reaction[reactionType] = {r, g, b} UUF:UpdateFrames() end)
            ReactionColour:SetHasAlpha(false)
            ReactionColour:SetRelativeWidth(0.25)
            ReactionColours:AddChild(ReactionColour)
        end

        local ResetToDefault = UUFGUI:Create("Button")
        ResetToDefault:SetText("Reset Settings")
        ResetToDefault:SetCallback("OnClick", function(widget, event, value) UUF:ResetDefaultSettings() end)
        ResetToDefault:SetRelativeWidth(1)
        
        UUFGUI_Container:AddChild(ColouringOptionsContainer)
        UUFGUI_Container:AddChild(ResetToDefault)
    end

    local function DrawUnitContainer(UUFGUI_Container, Unit)
        local Frame = UUF.DB.global[Unit].Frame
        local Portrait = UUF.DB.global[Unit].Portrait
        local Health = UUF.DB.global[Unit].Health
        local Absorbs = Health.Absorbs
        local PowerBar = UUF.DB.global[Unit].PowerBar
        local Buffs = UUF.DB.global[Unit].Buffs
        local Debuffs = UUF.DB.global[Unit].Debuffs
        local TargetMarker = UUF.DB.global[Unit].TargetMarker
        local LeftText = UUF.DB.global[Unit].Texts.Left
        local RightText = UUF.DB.global[Unit].Texts.Right
        local CenterText = UUF.DB.global[Unit].Texts.Center
        local TopLeftText = UUF.DB.global[Unit].Texts.AdditionalTexts.TopLeft
        local TopRightText = UUF.DB.global[Unit].Texts.AdditionalTexts.TopRight
        local BottomLeftText = UUF.DB.global[Unit].Texts.AdditionalTexts.BottomLeft
        local BottomRightText = UUF.DB.global[Unit].Texts.AdditionalTexts.BottomRight

        local function DrawFrameContainer(UUFGUI_Container)
            if Unit == "Focus" or Unit == "Pet" or Unit == "TargetTarget" then 
                local Enabled = UUFGUI:Create("CheckBox")
                Enabled:SetLabel("Enable Frame")
                Enabled:SetValue(Frame.Enabled)
                Enabled:SetCallback("OnValueChanged", function(widget, event, value) Frame.Enabled = value UUF:CreateReloadPrompt() end)
                Enabled:SetFullWidth(true)
                UUFGUI_Container:AddChild(Enabled)
            end

            -- Frame Options
            local FrameOptions = UUFGUI:Create("InlineGroup")
            FrameOptions:SetTitle("Frame Options")
            FrameOptions:SetLayout("Flow")
            FrameOptions:SetFullWidth(true)

            local FrameAnchorFrom = UUFGUI:Create("Dropdown")
            FrameAnchorFrom:SetLabel("Anchor From")
            FrameAnchorFrom:SetList(AnchorPoints)
            FrameAnchorFrom:SetValue(Frame.AnchorFrom)
            FrameAnchorFrom:SetCallback("OnValueChanged", function(widget, event, value) Frame.AnchorFrom = value UUF:UpdateFrames() end)
            FrameAnchorFrom:SetRelativeWidth(0.33)
            FrameOptions:AddChild(FrameAnchorFrom)

            local FrameAnchorTo = UUFGUI:Create("Dropdown")
            FrameAnchorTo:SetLabel("Anchor To")
            FrameAnchorTo:SetList(AnchorPoints)
            FrameAnchorTo:SetValue(Frame.AnchorTo)
            FrameAnchorTo:SetCallback("OnValueChanged", function(widget, event, value) Frame.AnchorTo = value UUF:UpdateFrames() end)
            FrameAnchorTo:SetRelativeWidth(0.33)
            FrameOptions:AddChild(FrameAnchorTo)

            local FrameAnchorParent = UUFGUI:Create("EditBox")
            FrameAnchorParent:SetLabel("Anchor Parent")
            FrameAnchorParent:SetText(Frame.AnchorParent)
            FrameAnchorParent:SetCallback("OnEnterPressed", function(widget, event, value) Frame.AnchorParent = value UUF:UpdateFrames() end)
            FrameAnchorParent:SetRelativeWidth(0.33)
            FrameOptions:AddChild(FrameAnchorParent)

            local FrameWidth = UUFGUI:Create("Slider")
            FrameWidth:SetLabel("Frame Width")
            FrameWidth:SetSliderValues(1, 999, 0.1)
            FrameWidth:SetValue(Frame.Width)
            FrameWidth:SetCallback("OnValueChanged", function(widget, event, value) Frame.Width = value UUF:UpdateFrames() end)
            FrameWidth:SetRelativeWidth(0.5)
            FrameOptions:AddChild(FrameWidth)

            local FrameHeight = UUFGUI:Create("Slider")
            FrameHeight:SetLabel("Frame Height")
            FrameHeight:SetSliderValues(1, 999, 0.1)
            FrameHeight:SetValue(Frame.Height)
            FrameHeight:SetCallback("OnValueChanged", function(widget, event, value) Frame.Height = value UUF:UpdateFrames() end)
            FrameHeight:SetRelativeWidth(0.5)
            FrameOptions:AddChild(FrameHeight)

            local FrameXPosition = UUFGUI:Create("Slider")
            FrameXPosition:SetLabel("Frame X Position")
            FrameXPosition:SetSliderValues(-999, 999, 1)
            FrameXPosition:SetValue(Frame.XPosition)
            FrameXPosition:SetCallback("OnValueChanged", function(widget, event, value) Frame.XPosition = value UUF:UpdateFrames() end)
            FrameXPosition:SetRelativeWidth(0.5)
            FrameOptions:AddChild(FrameXPosition)

            local FrameYPosition = UUFGUI:Create("Slider")
            FrameYPosition:SetLabel("Frame Y Position")
            FrameYPosition:SetSliderValues(-999, 999, 1)
            FrameYPosition:SetValue(Frame.YPosition)
            FrameYPosition:SetCallback("OnValueChanged", function(widget, event, value) Frame.YPosition = value UUF:UpdateFrames() end)
            FrameYPosition:SetRelativeWidth(0.5)
            FrameOptions:AddChild(FrameYPosition)

            UUFGUI_Container:AddChild(FrameOptions)

            local PortraitOptions = UUFGUI:Create("InlineGroup")
            PortraitOptions:SetTitle("Portrait Options")
            PortraitOptions:SetLayout("Flow")
            PortraitOptions:SetFullWidth(true)

            local PortraitEnabled = UUFGUI:Create("CheckBox")
            PortraitEnabled:SetLabel("Enable Portrait")
            PortraitEnabled:SetValue(Portrait.Enabled)
            PortraitEnabled:SetCallback("OnValueChanged", function(widget, event, value) Portrait.Enabled = value UUF:CreateReloadPrompt() end)
            PortraitEnabled:SetRelativeWidth(1)
            PortraitOptions:AddChild(PortraitEnabled)

            local PortraitAnchorFrom = UUFGUI:Create("Dropdown")
            PortraitAnchorFrom:SetLabel("Anchor From")
            PortraitAnchorFrom:SetList(AnchorPoints)
            PortraitAnchorFrom:SetValue(Portrait.AnchorFrom)
            PortraitAnchorFrom:SetCallback("OnValueChanged", function(widget, event, value) Portrait.AnchorFrom = value UUF:UpdateFrames() end)
            PortraitAnchorFrom:SetRelativeWidth(0.5)
            PortraitOptions:AddChild(PortraitAnchorFrom)

            local PortraitAnchorTo = UUFGUI:Create("Dropdown")
            PortraitAnchorTo:SetLabel("Anchor To")
            PortraitAnchorTo:SetList(AnchorPoints)
            PortraitAnchorTo:SetValue(Portrait.AnchorTo)
            PortraitAnchorTo:SetCallback("OnValueChanged", function(widget, event, value) Portrait.AnchorTo = value UUF:UpdateFrames() end)
            PortraitAnchorTo:SetRelativeWidth(0.5)
            PortraitOptions:AddChild(PortraitAnchorTo)

            local PortraitSize = UUFGUI:Create("Slider")
            PortraitSize:SetLabel("Portrait Size")
            PortraitSize:SetSliderValues(1, 999, 0.1)
            PortraitSize:SetValue(Portrait.Size)
            PortraitSize:SetCallback("OnValueChanged", function(widget, event, value) Portrait.Size = value UUF:UpdateFrames() end)
            PortraitSize:SetRelativeWidth(0.33)
            PortraitOptions:AddChild(PortraitSize)

            local PortraitXOffset = UUFGUI:Create("Slider")
            PortraitXOffset:SetLabel("Portrait X Offset")
            PortraitXOffset:SetSliderValues(-999, 999, 1)
            PortraitXOffset:SetValue(Portrait.XOffset)
            PortraitXOffset:SetCallback("OnValueChanged", function(widget, event, value) Portrait.XOffset = value UUF:UpdateFrames() end)
            PortraitXOffset:SetRelativeWidth(0.33)
            PortraitOptions:AddChild(PortraitXOffset)

            local PortraitYOffset = UUFGUI:Create("Slider")
            PortraitYOffset:SetLabel("Portrait Y Offset")
            PortraitYOffset:SetSliderValues(-999, 999, 1)
            PortraitYOffset:SetValue(Portrait.YOffset)
            PortraitYOffset:SetCallback("OnValueChanged", function(widget, event, value) Portrait.YOffset = value UUF:UpdateFrames() end)
            PortraitYOffset:SetRelativeWidth(0.33)
            PortraitOptions:AddChild(PortraitYOffset)

            UUFGUI_Container:AddChild(PortraitOptions)

            local HealthOptionsContainer = UUFGUI:Create("InlineGroup")
            HealthOptionsContainer:SetTitle("Health Options")
            HealthOptionsContainer:SetLayout("Flow")
            HealthOptionsContainer:SetFullWidth(true)

            local HealthGrowDirection = UUFGUI:Create("Dropdown")
            HealthGrowDirection:SetLabel("Health Grow Direction")
            HealthGrowDirection:SetList({
                ["LR"] = "Left To Right",
                ["RL"] = "Right To Left",
            })
            HealthGrowDirection:SetValue(Health.Direction)
            HealthGrowDirection:SetCallback("OnValueChanged", function(widget, event, value) Health.Direction = value UUF:UpdateFrames() end)
            HealthGrowDirection:SetFullWidth(true)
            HealthOptionsContainer:AddChild(HealthGrowDirection)

            local AbsorbsContainer = UUFGUI:Create("InlineGroup")
            AbsorbsContainer:SetTitle("Absorbs Options")
            AbsorbsContainer:SetLayout("Flow")
            AbsorbsContainer:SetFullWidth(true)
            HealthOptionsContainer:AddChild(AbsorbsContainer)

            local AbsorbsEnabled = UUFGUI:Create("CheckBox")
            AbsorbsEnabled:SetLabel("Enable Absorbs")
            AbsorbsEnabled:SetValue(Absorbs.Enabled)
            AbsorbsEnabled:SetCallback("OnValueChanged", function(widget, event, value) Absorbs.Enabled = value UUF:CreateReloadPrompt() end)
            AbsorbsEnabled:SetRelativeWidth(0.5)
            AbsorbsContainer:AddChild(AbsorbsEnabled)

            local AbsorbsColourPicker = UUFGUI:Create("ColorPicker")
            AbsorbsColourPicker:SetLabel("Colour")
            local AR, AG, AB, AA = unpack(Absorbs.Colour)
            AbsorbsColourPicker:SetColor(AR, AG, AB, AA)
            AbsorbsColourPicker:SetCallback("OnValueChanged", function(widget, _, r, g, b, a) Absorbs.Colour = {r, g, b, a} UUF:UpdateFrames() end)
            AbsorbsColourPicker:SetHasAlpha(true)
            AbsorbsColourPicker:SetRelativeWidth(0.5)
            AbsorbsContainer:AddChild(AbsorbsColourPicker)

            UUFGUI_Container:AddChild(HealthOptionsContainer)

            local PowerBarOptionsContainer = UUFGUI:Create("InlineGroup")
            PowerBarOptionsContainer:SetTitle("Power Bar Options")
            PowerBarOptionsContainer:SetLayout("Flow")
            PowerBarOptionsContainer:SetFullWidth(true)
            UUFGUI_Container:AddChild(PowerBarOptionsContainer)

            local PowerBarEnabled = UUFGUI:Create("CheckBox")
            PowerBarEnabled:SetLabel("Enable Power Bar")
            PowerBarEnabled:SetValue(PowerBar.Enabled)
            PowerBarEnabled:SetCallback("OnValueChanged", function(widget, event, value) PowerBar.Enabled = value UUF:CreateReloadPrompt() end)
            PowerBarEnabled:SetRelativeWidth(0.5)
            PowerBarOptionsContainer:AddChild(PowerBarEnabled)

            local PowerBarBackdropColour = UUFGUI:Create("ColorPicker")
            PowerBarBackdropColour:SetLabel("Colour")
            local PBBR, PBBG, PBBB, PBBA = unpack(PowerBar.BackgroundColour)
            PowerBarBackdropColour:SetColor(PBBR, PBBG, PBBB, PBBA)
            PowerBarBackdropColour:SetCallback("OnValueChanged", function(widget, event, r, g, b, a) PowerBar.BackgroundColour = {r, g, b, a} UUF:UpdateFrames() end)
            PowerBarBackdropColour:SetHasAlpha(true)
            PowerBarBackdropColour:SetRelativeWidth(0.5)
            PowerBarOptionsContainer:AddChild(PowerBarBackdropColour)

            local PowerBarColour = UUFGUI:Create("ColorPicker")
            PowerBarColour:SetLabel("Bar Colour")
            local PBR, PBG, PBB, PBA = unpack(PowerBar.Colour)
            PowerBarColour:SetColor(PBR, PBG, PBB, PBA)
            PowerBarColour:SetCallback("OnValueChanged", function(widget, event, r, g, b, a) PowerBar.Colour = {r, g, b, a} UUF:UpdateFrames() end)
            PowerBarColour:SetHasAlpha(true)
            PowerBarColour:SetRelativeWidth(0.5)

            local PowerBarColourByType = UUFGUI:Create("CheckBox")
            PowerBarColourByType:SetLabel("Colour By Type")
            PowerBarColourByType:SetValue(PowerBar.ColourByType)
            PowerBarColourByType:SetCallback("OnValueChanged", function(widget, event, value) 
                PowerBar.ColourByType = value
                UUF:UpdateFrames()
                PowerBarColour:SetDisabled(value)
                end)
            PowerBarColourByType:SetRelativeWidth(0.5)

            local PowerBarHeight = UUFGUI:Create("Slider")
            PowerBarHeight:SetLabel("Height")
            PowerBarHeight:SetSliderValues(1, 64, 1)
            PowerBarHeight:SetValue(PowerBar.Height)
            PowerBarHeight:SetCallback("OnValueChanged", function(widget, event, value) PowerBar.Height = value UUF:UpdateFrames() end)
            PowerBarHeight:SetRelativeWidth(1)
            PowerBarOptionsContainer:AddChild(PowerBarColourByType)
            PowerBarOptionsContainer:AddChild(PowerBarColour)
            PowerBarOptionsContainer:AddChild(PowerBarHeight)
        end

        local function DrawBuffsContainer(UUFGUI_Container)
            local BuffOptions = UUFGUI:Create("InlineGroup")
            BuffOptions:SetTitle("Buff Options")
            BuffOptions:SetLayout("Flow")
            BuffOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(BuffOptions)
    
            local BuffsEnabled = UUFGUI:Create("CheckBox")
            BuffsEnabled:SetLabel("Enable Buffs")
            BuffsEnabled:SetValue(Buffs.Enabled)
            BuffsEnabled:SetCallback("OnValueChanged", function(widget, event, value) Buffs.Enabled = value UUF:CreateReloadPrompt() end)
            BuffsEnabled:SetFullWidth(true)
            BuffOptions:AddChild(BuffsEnabled)

            local BuffAnchorFrom = UUFGUI:Create("Dropdown")
            BuffAnchorFrom:SetLabel("Anchor From")
            BuffAnchorFrom:SetList(AnchorPoints)
            BuffAnchorFrom:SetValue(Buffs.AnchorFrom)
            BuffAnchorFrom:SetCallback("OnValueChanged", function(widget, event, value) Buffs.AnchorFrom = value UUF:UpdateFrames() end)
            BuffAnchorFrom:SetRelativeWidth(0.5)
            BuffOptions:AddChild(BuffAnchorFrom)
    
            local BuffAnchorTo = UUFGUI:Create("Dropdown")
            BuffAnchorTo:SetLabel("Anchor To")
            BuffAnchorTo:SetList(AnchorPoints)
            BuffAnchorTo:SetValue(Buffs.AnchorTo)
            BuffAnchorTo:SetCallback("OnValueChanged", function(widget, event, value) Buffs.AnchorTo = value UUF:UpdateFrames() end)
            BuffAnchorTo:SetRelativeWidth(0.5)
            BuffOptions:AddChild(BuffAnchorTo)
    
            local BuffGrowthX = UUFGUI:Create("Dropdown")
            BuffGrowthX:SetLabel("Growth Direction X")
            BuffGrowthX:SetList(GrowthX)
            BuffGrowthX:SetValue(Buffs.GrowthX)
            BuffGrowthX:SetCallback("OnValueChanged", function(widget, event, value) Buffs.GrowthX = value UUF:UpdateFrames() end)
            BuffGrowthX:SetRelativeWidth(0.5)
            BuffOptions:AddChild(BuffGrowthX)
    
            local BuffGrowthY = UUFGUI:Create("Dropdown")
            BuffGrowthY:SetLabel("Growth Direction Y")
            BuffGrowthY:SetList(GrowthY)
            BuffGrowthY:SetValue(Buffs.GrowthY)
            BuffGrowthY:SetCallback("OnValueChanged", function(widget, event, value) Buffs.GrowthY = value UUF:UpdateFrames() end)
            BuffGrowthY:SetRelativeWidth(0.5)
            BuffOptions:AddChild(BuffGrowthY)

            local BuffSize = UUFGUI:Create("Slider")
            BuffSize:SetLabel("Size")
            BuffSize:SetSliderValues(-1, 64, 1)
            BuffSize:SetValue(Buffs.Size)
            BuffSize:SetCallback("OnValueChanged", function(widget, event, value) Buffs.Size = value UUF:UpdateFrames() end)
            BuffSize:SetRelativeWidth(0.33)
            BuffOptions:AddChild(BuffSize)

            local BuffSpacing = UUFGUI:Create("Slider")
            BuffSpacing:SetLabel("Spacing")
            BuffSpacing:SetSliderValues(-1, 64, 1)
            BuffSpacing:SetValue(Buffs.Spacing)
            BuffSpacing:SetCallback("OnValueChanged", function(widget, event, value) Buffs.Spacing = value UUF:UpdateFrames() end)
            BuffSpacing:SetRelativeWidth(0.33)
            BuffOptions:AddChild(BuffSpacing)

            local BuffNum = UUFGUI:Create("Slider")
            BuffNum:SetLabel("Amount To Show")
            BuffNum:SetSliderValues(1, 64, 1)
            BuffNum:SetValue(Buffs.Num)
            BuffNum:SetCallback("OnValueChanged", function(widget, event, value) Buffs.Num = value UUF:UpdateFrames() end)
            BuffNum:SetRelativeWidth(0.33)
            BuffOptions:AddChild(BuffNum)
    
            local BuffXOffset = UUFGUI:Create("Slider")
            BuffXOffset:SetLabel("Buff X Offset")
            BuffXOffset:SetSliderValues(-64, 64, 1)
            BuffXOffset:SetValue(Buffs.XOffset)
            BuffXOffset:SetCallback("OnValueChanged", function(widget, event, value) Buffs.XOffset = value UUF:UpdateFrames() end)
            BuffXOffset:SetRelativeWidth(0.5)
            BuffOptions:AddChild(BuffXOffset)
    
            local BuffYOffset = UUFGUI:Create("Slider")
            BuffYOffset:SetLabel("Buff Y Offset")
            BuffYOffset:SetSliderValues(-64, 64, 1)
            BuffYOffset:SetValue(Buffs.YOffset)
            BuffYOffset:SetCallback("OnValueChanged", function(widget, event, value) Buffs.YOffset = value UUF:UpdateFrames() end)
            BuffYOffset:SetRelativeWidth(0.5)
            BuffOptions:AddChild(BuffYOffset)
        end

        local function DrawDebuffsContainer(UUFGUI_Container)
            local DebuffOptions = UUFGUI:Create("InlineGroup")
            DebuffOptions:SetTitle("Debuff Options")
            DebuffOptions:SetLayout("Flow")
            DebuffOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(DebuffOptions)
    
            local DebuffsEnabled = UUFGUI:Create("CheckBox")
            DebuffsEnabled:SetLabel("Enable Debuffs")
            DebuffsEnabled:SetValue(Debuffs.Enabled)
            DebuffsEnabled:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.Enabled = value UUF:CreateReloadPrompt() end)
            DebuffsEnabled:SetFullWidth(true)
            DebuffOptions:AddChild(DebuffsEnabled)

            local DebuffAnchorFrom = UUFGUI:Create("Dropdown")
            DebuffAnchorFrom:SetLabel("Anchor From")
            DebuffAnchorFrom:SetList(AnchorPoints)
            DebuffAnchorFrom:SetValue(Debuffs.AnchorFrom)
            DebuffAnchorFrom:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.AnchorFrom = value UUF:UpdateFrames() end)
            DebuffAnchorFrom:SetRelativeWidth(0.5)
            DebuffOptions:AddChild(DebuffAnchorFrom)
    
            local DebuffAnchorTo = UUFGUI:Create("Dropdown")
            DebuffAnchorTo:SetLabel("Anchor To")
            DebuffAnchorTo:SetList(AnchorPoints)
            DebuffAnchorTo:SetValue(Debuffs.AnchorTo)
            DebuffAnchorTo:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.AnchorTo = value UUF:UpdateFrames() end)
            DebuffAnchorTo:SetRelativeWidth(0.5)
            DebuffOptions:AddChild(DebuffAnchorTo)
    
            local DebuffGrowthX = UUFGUI:Create("Dropdown")
            DebuffGrowthX:SetLabel("Growth Direction X")
            DebuffGrowthX:SetList(GrowthX)
            DebuffGrowthX:SetValue(Debuffs.GrowthX)
            DebuffGrowthX:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.GrowthX = value UUF:UpdateFrames() end)
            DebuffGrowthX:SetRelativeWidth(0.5)
            DebuffOptions:AddChild(DebuffGrowthX)
    
            local DebuffGrowthY = UUFGUI:Create("Dropdown")
            DebuffGrowthY:SetLabel("Growth Direction Y")
            DebuffGrowthY:SetList(GrowthY)
            DebuffGrowthY:SetValue(Debuffs.GrowthY)
            DebuffGrowthY:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.GrowthY = value UUF:UpdateFrames() end)
            DebuffGrowthY:SetRelativeWidth(0.5)
            DebuffOptions:AddChild(DebuffGrowthY)

            local DebuffSize = UUFGUI:Create("Slider")
            DebuffSize:SetLabel("Size")
            DebuffSize:SetSliderValues(-1, 64, 1)
            DebuffSize:SetValue(Debuffs.Size)
            DebuffSize:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.Size = value UUF:UpdateFrames() end)
            DebuffSize:SetRelativeWidth(0.33)
            DebuffOptions:AddChild(DebuffSize)

            local DebuffSpacing = UUFGUI:Create("Slider")
            DebuffSpacing:SetLabel("Spacing")
            DebuffSpacing:SetSliderValues(-1, 64, 1)
            DebuffSpacing:SetValue(Debuffs.Spacing)
            DebuffSpacing:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.Spacing = value UUF:UpdateFrames() end)
            DebuffSpacing:SetRelativeWidth(0.33)
            DebuffOptions:AddChild(DebuffSpacing)

            local DebuffNum = UUFGUI:Create("Slider")
            DebuffNum:SetLabel("Amount To Show")
            DebuffNum:SetSliderValues(1, 64, 1)
            DebuffNum:SetValue(Debuffs.Num)
            DebuffNum:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.Num = value UUF:UpdateFrames() end)
            DebuffNum:SetRelativeWidth(0.33)
            DebuffOptions:AddChild(DebuffNum)
    
            local DebuffXOffset = UUFGUI:Create("Slider")
            DebuffXOffset:SetLabel("Debuff X Offset")
            DebuffXOffset:SetSliderValues(-64, 64, 1)
            DebuffXOffset:SetValue(Debuffs.XOffset)
            DebuffXOffset:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.XOffset = value UUF:UpdateFrames() end)
            DebuffXOffset:SetRelativeWidth(0.5)
            DebuffOptions:AddChild(DebuffXOffset)
    
            local DebuffYOffset = UUFGUI:Create("Slider")
            DebuffYOffset:SetLabel("Debuff Y Offset")
            DebuffYOffset:SetSliderValues(-64, 64, 1)
            DebuffYOffset:SetValue(Debuffs.YOffset)
            DebuffYOffset:SetCallback("OnValueChanged", function(widget, event, value) Debuffs.YOffset = value UUF:UpdateFrames() end)
            DebuffYOffset:SetRelativeWidth(0.5)
            DebuffOptions:AddChild(DebuffYOffset)
        end

        local function DrawTargetMarkerContainer(UUFGUI_Container)
            local TargetMarkerOptions = UUFGUI:Create("InlineGroup")
            TargetMarkerOptions:SetTitle("Target Marker Options")
            TargetMarkerOptions:SetLayout("Flow")
            TargetMarkerOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(TargetMarkerOptions)

            local TargetMarkerEnabled = UUFGUI:Create("CheckBox")
            TargetMarkerEnabled:SetLabel("Enable Target Marker")
            TargetMarkerEnabled:SetValue(TargetMarker.Enabled)
            TargetMarkerEnabled:SetCallback("OnValueChanged", function(widget, event, value) TargetMarker.Enabled = value UUF:CreateReloadPrompt() end)
            TargetMarkerEnabled:SetFullWidth(true)
            TargetMarkerOptions:AddChild(TargetMarkerEnabled)

            local TargetMarkerAnchorFrom = UUFGUI:Create("Dropdown")
            TargetMarkerAnchorFrom:SetLabel("Anchor From")
            TargetMarkerAnchorFrom:SetList(AnchorPoints)
            TargetMarkerAnchorFrom:SetValue(TargetMarker.AnchorFrom)
            TargetMarkerAnchorFrom:SetCallback("OnValueChanged", function(widget, event, value) TargetMarker.AnchorFrom = value UUF:UpdateFrames() end)
            TargetMarkerAnchorFrom:SetRelativeWidth(0.5)
            TargetMarkerOptions:AddChild(TargetMarkerAnchorFrom)

            local TargetMarkerAnchorTo = UUFGUI:Create("Dropdown")
            TargetMarkerAnchorTo:SetLabel("Anchor To")
            TargetMarkerAnchorTo:SetList(AnchorPoints)
            TargetMarkerAnchorTo:SetValue(TargetMarker.AnchorTo)
            TargetMarkerAnchorTo:SetCallback("OnValueChanged", function(widget, event, value) TargetMarker.AnchorTo = value UUF:UpdateFrames() end)
            TargetMarkerAnchorTo:SetRelativeWidth(0.5)
            TargetMarkerOptions:AddChild(TargetMarkerAnchorTo)

            local TargetMarkerSize = UUFGUI:Create("Slider")
            TargetMarkerSize:SetLabel("Size")
            TargetMarkerSize:SetSliderValues(-1, 64, 1)
            TargetMarkerSize:SetValue(TargetMarker.Size)
            TargetMarkerSize:SetCallback("OnValueChanged", function(widget, event, value) TargetMarker.Size = value UUF:UpdateFrames() end)
            TargetMarkerSize:SetRelativeWidth(0.33)
            TargetMarkerOptions:AddChild(TargetMarkerSize)

            local TargetMarkerXOffset = UUFGUI:Create("Slider")
            TargetMarkerXOffset:SetLabel("X Offset")
            TargetMarkerXOffset:SetSliderValues(-64, 64, 1)
            TargetMarkerXOffset:SetValue(TargetMarker.XOffset)
            TargetMarkerXOffset:SetCallback("OnValueChanged", function(widget, event, value) TargetMarker.XOffset = value UUF:UpdateFrames() end)
            TargetMarkerXOffset:SetRelativeWidth(0.33)
            TargetMarkerOptions:AddChild(TargetMarkerXOffset)

            local TargetMarkerYOffset = UUFGUI:Create("Slider")
            TargetMarkerYOffset:SetLabel("Y Offset")
            TargetMarkerYOffset:SetSliderValues(-64, 64, 1)
            TargetMarkerYOffset:SetValue(TargetMarker.YOffset)
            TargetMarkerYOffset:SetCallback("OnValueChanged", function(widget, event, value) TargetMarker.YOffset = value UUF:UpdateFrames() end)
            TargetMarkerYOffset:SetRelativeWidth(0.33)
            TargetMarkerOptions:AddChild(TargetMarkerYOffset)
        end

        local function DrawTextsContainer(UUFGUI_Container)
            local TextOptions = UUFGUI:Create("InlineGroup")
            TextOptions:SetTitle("Text Options")
            TextOptions:SetLayout("Flow")
            TextOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(TextOptions)

            local LeftTextOptions = UUFGUI:Create("InlineGroup")
            LeftTextOptions:SetTitle("Left Text Options")
            LeftTextOptions:SetLayout("Flow")
            LeftTextOptions:SetFullWidth(true)
            TextOptions:AddChild(LeftTextOptions)

            local LeftTextFontSize = UUFGUI:Create("Slider")
            LeftTextFontSize:SetLabel("Font Size")
            LeftTextFontSize:SetSliderValues(1, 64, 1)
            LeftTextFontSize:SetValue(LeftText.FontSize)
            LeftTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) LeftText.FontSize = value UUF:UpdateFrames() end)
            LeftTextFontSize:SetRelativeWidth(0.33)
            LeftTextOptions:AddChild(LeftTextFontSize)

            local LeftTextXOffset = UUFGUI:Create("Slider")
            LeftTextXOffset:SetLabel("X Offset")
            LeftTextXOffset:SetSliderValues(-64, 64, 1)
            LeftTextXOffset:SetValue(LeftText.XOffset)
            LeftTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) LeftText.XOffset = value UUF:UpdateFrames() end)
            LeftTextXOffset:SetRelativeWidth(0.33)
            LeftTextOptions:AddChild(LeftTextXOffset)

            local LeftTextYOffset = UUFGUI:Create("Slider")
            LeftTextYOffset:SetLabel("Y Offset")
            LeftTextYOffset:SetSliderValues(-64, 64, 1)
            LeftTextYOffset:SetValue(LeftText.YOffset)
            LeftTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) LeftText.YOffset = value UUF:UpdateFrames() end)
            LeftTextYOffset:SetRelativeWidth(0.33)
            LeftTextOptions:AddChild(LeftTextYOffset)

            local LeftTextTag = UUFGUI:Create("EditBox")
            LeftTextTag:SetLabel("Tag")
            LeftTextTag:SetText(LeftText.Tag)
            LeftTextTag:SetCallback("OnEnterPressed", function(widget, event, value) LeftText.Tag = value UUF:UpdateFrames() end)
            LeftTextTag:SetFullWidth(true)
            LeftTextOptions:AddChild(LeftTextTag)
            
            local RightTextOptions = UUFGUI:Create("InlineGroup")
            RightTextOptions:SetTitle("Right Text Options")
            RightTextOptions:SetLayout("Flow")
            RightTextOptions:SetFullWidth(true)
            TextOptions:AddChild(RightTextOptions)

            local RightTextFontSize = UUFGUI:Create("Slider")
            RightTextFontSize:SetLabel("Font Size")
            RightTextFontSize:SetSliderValues(1, 64, 1)
            RightTextFontSize:SetValue(RightText.FontSize)
            RightTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) RightText.FontSize = value UUF:UpdateFrames() end)
            RightTextFontSize:SetRelativeWidth(0.33)
            RightTextOptions:AddChild(RightTextFontSize)

            local RightTextXOffset = UUFGUI:Create("Slider")
            RightTextXOffset:SetLabel("X Offset")
            RightTextXOffset:SetSliderValues(-64, 64, 1)
            RightTextXOffset:SetValue(RightText.XOffset)
            RightTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) RightText.XOffset = value UUF:UpdateFrames() end)
            RightTextXOffset:SetRelativeWidth(0.33)
            RightTextOptions:AddChild(RightTextXOffset)

            local RightTextYOffset = UUFGUI:Create("Slider")
            RightTextYOffset:SetLabel("Y Offset")
            RightTextYOffset:SetSliderValues(-64, 64, 1)
            RightTextYOffset:SetValue(RightText.YOffset)
            RightTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) RightText.YOffset = value UUF:UpdateFrames() end)
            RightTextYOffset:SetRelativeWidth(0.33)
            RightTextOptions:AddChild(RightTextYOffset)

            local RightTextTag = UUFGUI:Create("EditBox")
            RightTextTag:SetLabel("Tag")
            RightTextTag:SetText(RightText.Tag)
            RightTextTag:SetCallback("OnEnterPressed", function(widget, event, value) RightText.Tag = value UUF:UpdateFrames() end)
            RightTextTag:SetFullWidth(true)
            RightTextOptions:AddChild(RightTextTag)

            local CenterTextOptions = UUFGUI:Create("InlineGroup")
            CenterTextOptions:SetTitle("Center Text Options")
            CenterTextOptions:SetLayout("Flow")
            CenterTextOptions:SetFullWidth(true)
            TextOptions:AddChild(CenterTextOptions)

            local CenterTextFontSize = UUFGUI:Create("Slider")
            CenterTextFontSize:SetLabel("Font Size")
            CenterTextFontSize:SetSliderValues(1, 64, 1)
            CenterTextFontSize:SetValue(CenterText.FontSize)
            CenterTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) CenterText.FontSize = value UUF:UpdateFrames() end)
            CenterTextFontSize:SetRelativeWidth(0.33)
            CenterTextOptions:AddChild(CenterTextFontSize)

            local CenterTextXOffset = UUFGUI:Create("Slider")
            CenterTextXOffset:SetLabel("X Offset")
            CenterTextXOffset:SetSliderValues(-64, 64, 1)
            CenterTextXOffset:SetValue(CenterText.XOffset)
            CenterTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) CenterText.XOffset = value UUF:UpdateFrames() end)
            CenterTextXOffset:SetRelativeWidth(0.33)
            CenterTextOptions:AddChild(CenterTextXOffset)

            local CenterTextYOffset = UUFGUI:Create("Slider")
            CenterTextYOffset:SetLabel("Y Offset")
            CenterTextYOffset:SetSliderValues(-64, 64, 1)
            CenterTextYOffset:SetValue(CenterText.YOffset)
            CenterTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) CenterText.YOffset = value UUF:UpdateFrames() end)
            CenterTextYOffset:SetRelativeWidth(0.33)
            CenterTextOptions:AddChild(CenterTextYOffset)

            local CenterTextTag = UUFGUI:Create("EditBox")
            CenterTextTag:SetLabel("Tag")
            CenterTextTag:SetText(CenterText.Tag)
            CenterTextTag:SetCallback("OnEnterPressed", function(widget, event, value) CenterText.Tag = value UUF:UpdateFrames() end)
            CenterTextTag:SetFullWidth(true)
            CenterTextOptions:AddChild(CenterTextTag)
        end

        local function DrawAdditionalTextsContainer(UUFGUI_Container)
            local AdditionalTextOptions = UUFGUI:Create("InlineGroup")
            AdditionalTextOptions:SetTitle("Additional Text Options")
            AdditionalTextOptions:SetLayout("Flow")
            AdditionalTextOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(AdditionalTextOptions)

            local TopLeftTextOptions = UUFGUI:Create("InlineGroup")
            TopLeftTextOptions:SetTitle("Top Left Text Options")
            TopLeftTextOptions:SetLayout("Flow")
            TopLeftTextOptions:SetFullWidth(true)
            AdditionalTextOptions:AddChild(TopLeftTextOptions)

            local TopLeftTextFontSize = UUFGUI:Create("Slider")
            TopLeftTextFontSize:SetLabel("Font Size")
            TopLeftTextFontSize:SetSliderValues(1, 64, 1)
            TopLeftTextFontSize:SetValue(TopLeftText.FontSize)
            TopLeftTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) TopLeftText.FontSize = value UUF:UpdateFrames() end)
            TopLeftTextFontSize:SetRelativeWidth(0.33)
            TopLeftTextOptions:AddChild(TopLeftTextFontSize)

            local TopLeftTextXOffset = UUFGUI:Create("Slider")
            TopLeftTextXOffset:SetLabel("X Offset")
            TopLeftTextXOffset:SetSliderValues(-64, 64, 1)
            TopLeftTextXOffset:SetValue(TopLeftText.XOffset)
            TopLeftTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) TopLeftText.XOffset = value UUF:UpdateFrames() end)
            TopLeftTextXOffset:SetRelativeWidth(0.33)
            TopLeftTextOptions:AddChild(TopLeftTextXOffset)

            local TopLeftTextYOffset = UUFGUI:Create("Slider")
            TopLeftTextYOffset:SetLabel("Y Offset")
            TopLeftTextYOffset:SetSliderValues(-64, 64, 1)
            TopLeftTextYOffset:SetValue(TopLeftText.YOffset)
            TopLeftTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) TopLeftText.YOffset = value UUF:UpdateFrames() end)
            TopLeftTextYOffset:SetRelativeWidth(0.33)
            TopLeftTextOptions:AddChild(TopLeftTextYOffset)

            local TopLeftTextTag = UUFGUI:Create("EditBox")
            TopLeftTextTag:SetLabel("Tag")
            TopLeftTextTag:SetText(TopLeftText.Tag)
            TopLeftTextTag:SetCallback("OnEnterPressed", function(widget, event, value) TopLeftText.Tag = value UUF:UpdateFrames() end)
            TopLeftTextTag:SetFullWidth(true)
            TopLeftTextOptions:AddChild(TopLeftTextTag)

            local TopRightTextOptions = UUFGUI:Create("InlineGroup")
            TopRightTextOptions:SetTitle("Top Right Text Options")
            TopRightTextOptions:SetLayout("Flow")
            TopRightTextOptions:SetFullWidth(true)
            AdditionalTextOptions:AddChild(TopRightTextOptions)

            local TopRightTextFontSize = UUFGUI:Create("Slider")
            TopRightTextFontSize:SetLabel("Font Size")
            TopRightTextFontSize:SetSliderValues(1, 64, 1)
            TopRightTextFontSize:SetValue(TopRightText.FontSize)
            TopRightTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) TopRightText.FontSize = value UUF:UpdateFrames() end)
            TopRightTextFontSize:SetRelativeWidth(0.33)
            TopRightTextOptions:AddChild(TopRightTextFontSize)

            local TopRightTextXOffset = UUFGUI:Create("Slider")
            TopRightTextXOffset:SetLabel("X Offset")
            TopRightTextXOffset:SetSliderValues(-64, 64, 1)
            TopRightTextXOffset:SetValue(TopRightText.XOffset)
            TopRightTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) TopRightText.XOffset = value UUF:UpdateFrames() end)
            TopRightTextXOffset:SetRelativeWidth(0.33)
            TopRightTextOptions:AddChild(TopRightTextXOffset)

            local TopRightTextYOffset = UUFGUI:Create("Slider")
            TopRightTextYOffset:SetLabel("Y Offset")
            TopRightTextYOffset:SetSliderValues(-64, 64, 1)
            TopRightTextYOffset:SetValue(TopRightText.YOffset)
            TopRightTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) TopRightText.YOffset = value UUF:UpdateFrames() end)
            TopRightTextYOffset:SetRelativeWidth(0.33)
            TopRightTextOptions:AddChild(TopRightTextYOffset)

            local TopRightTextTag = UUFGUI:Create("EditBox")
            TopRightTextTag:SetLabel("Tag")
            TopRightTextTag:SetText(TopRightText.Tag)
            TopRightTextTag:SetCallback("OnEnterPressed", function(widget, event, value) TopRightText.Tag = value UUF:UpdateFrames() end)
            TopRightTextTag:SetFullWidth(true)
            TopRightTextOptions:AddChild(TopRightTextTag)

            local BottomLeftTextOptions = UUFGUI:Create("InlineGroup")
            BottomLeftTextOptions:SetTitle("Bottom Left Text Options")
            BottomLeftTextOptions:SetLayout("Flow")
            BottomLeftTextOptions:SetFullWidth(true)
            AdditionalTextOptions:AddChild(BottomLeftTextOptions)

            local BottomLeftTextFontSize = UUFGUI:Create("Slider")
            BottomLeftTextFontSize:SetLabel("Font Size")
            BottomLeftTextFontSize:SetSliderValues(1, 64, 1)
            BottomLeftTextFontSize:SetValue(BottomLeftText.FontSize)
            BottomLeftTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) BottomLeftText.FontSize = value UUF:UpdateFrames() end)
            BottomLeftTextFontSize:SetRelativeWidth(0.33)
            BottomLeftTextOptions:AddChild(BottomLeftTextFontSize)

            local BottomLeftTextXOffset = UUFGUI:Create("Slider")
            BottomLeftTextXOffset:SetLabel("X Offset")
            BottomLeftTextXOffset:SetSliderValues(-64, 64, 1)
            BottomLeftTextXOffset:SetValue(BottomLeftText.XOffset)
            BottomLeftTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) BottomLeftText.XOffset = value UUF:UpdateFrames() end)
            BottomLeftTextXOffset:SetRelativeWidth(0.33)
            BottomLeftTextOptions:AddChild(BottomLeftTextXOffset)

            local BottomLeftTextYOffset = UUFGUI:Create("Slider")
            BottomLeftTextYOffset:SetLabel("Y Offset")
            BottomLeftTextYOffset:SetSliderValues(-64, 64, 1)
            BottomLeftTextYOffset:SetValue(BottomLeftText.YOffset)
            BottomLeftTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) BottomLeftText.YOffset = value UUF:UpdateFrames() end)
            BottomLeftTextYOffset:SetRelativeWidth(0.33)
            BottomLeftTextOptions:AddChild(BottomLeftTextYOffset)

            local BottomLeftTextTag = UUFGUI:Create("EditBox")
            BottomLeftTextTag:SetLabel("Tag")
            BottomLeftTextTag:SetText(BottomLeftText.Tag)
            BottomLeftTextTag:SetCallback("OnEnterPressed", function(widget, event, value) BottomLeftText.Tag = value UUF:UpdateFrames() end)
            BottomLeftTextTag:SetFullWidth(true)
            BottomLeftTextOptions:AddChild(BottomLeftTextTag)

            local BottomRightTextOptions = UUFGUI:Create("InlineGroup")
            BottomRightTextOptions:SetTitle("Bottom Right Text Options")
            BottomRightTextOptions:SetLayout("Flow")
            BottomRightTextOptions:SetFullWidth(true)
            AdditionalTextOptions:AddChild(BottomRightTextOptions)

            local BottomRightTextFontSize = UUFGUI:Create("Slider")
            BottomRightTextFontSize:SetLabel("Font Size")
            BottomRightTextFontSize:SetSliderValues(1, 64, 1)
            BottomRightTextFontSize:SetValue(BottomRightText.FontSize)
            BottomRightTextFontSize:SetCallback("OnValueChanged", function(widget, event, value) BottomRightText.FontSize = value UUF:UpdateFrames() end)
            BottomRightTextFontSize:SetRelativeWidth(0.33)
            BottomRightTextOptions:AddChild(BottomRightTextFontSize)

            local BottomRightTextXOffset = UUFGUI:Create("Slider")
            BottomRightTextXOffset:SetLabel("X Offset")
            BottomRightTextXOffset:SetSliderValues(-64, 64, 1)
            BottomRightTextXOffset:SetValue(BottomRightText.XOffset)
            BottomRightTextXOffset:SetCallback("OnValueChanged", function(widget, event, value) BottomRightText.XOffset = value UUF:UpdateFrames() end)
            BottomRightTextXOffset:SetRelativeWidth(0.33)
            BottomRightTextOptions:AddChild(BottomRightTextXOffset)

            local BottomRightTextYOffset = UUFGUI:Create("Slider")
            BottomRightTextYOffset:SetLabel("Y Offset")
            BottomRightTextYOffset:SetSliderValues(-64, 64, 1)
            BottomRightTextYOffset:SetValue(BottomRightText.YOffset)
            BottomRightTextYOffset:SetCallback("OnValueChanged", function(widget, event, value) BottomRightText.YOffset = value UUF:UpdateFrames() end)
            BottomRightTextYOffset:SetRelativeWidth(0.33)
            BottomRightTextOptions:AddChild(BottomRightTextYOffset)

            local BottomRightTextTag = UUFGUI:Create("EditBox")
            BottomRightTextTag:SetLabel("Tag")
            BottomRightTextTag:SetText(BottomRightText.Tag)
            BottomRightTextTag:SetCallback("OnEnterPressed", function(widget, event, value) BottomRightText.Tag = value UUF:UpdateFrames() end)
            BottomRightTextTag:SetFullWidth(true)
            BottomRightTextOptions:AddChild(BottomRightTextTag)
        end

        local function SelectedGroup(UUFGUI_Container, Event, Group)
            UUFGUI_Container:ReleaseChildren()
            if Group == "Frame" then
                DrawFrameContainer(UUFGUI_Container)
            elseif Group == "Texts" then
                DrawTextsContainer(UUFGUI_Container)
            elseif Group == "Additional Texts" then
                DrawAdditionalTextsContainer(UUFGUI_Container)
            elseif Group == "Buffs" then
                DrawBuffsContainer(UUFGUI_Container)
            elseif Group == "Debuffs" then
                DrawDebuffsContainer(UUFGUI_Container)
            elseif Group == "TargetMarker" then
                DrawTargetMarkerContainer(UUFGUI_Container)
            end
        end

        GUIContainerTabGroup = UUFGUI:Create("TabGroup")
        GUIContainerTabGroup:SetLayout("Flow")
        GUIContainerTabGroup:SetTabs({
            { text = "Frame",                           value = "Frame"},
            { text = "Texts",                           value = "Texts" },
            { text = "Additional Texts",                value = "Additional Texts" },
            { text = "Buffs",                           value = "Buffs" },
            { text = "Debuffs",                         value = "Debuffs" },
            { text = "Target Marker",                   value = "TargetMarker" },
        })
        
        GUIContainerTabGroup:SetCallback("OnGroupSelected", SelectedGroup)
        GUIContainerTabGroup:SelectTab("Frame")
        GUIContainerTabGroup:SetFullWidth(true)
        UUFGUI_Container:AddChild(GUIContainerTabGroup)
    end

    local function DrawTagsContainer(UUFGUI_Container)

        local function DrawHealthTagContainer(UUFGUI_Container)
            local HealthTags = UUF:FetchHealthTagDescriptions()

            local HealthTagOptions = UUFGUI:Create("InlineGroup")
            HealthTagOptions:SetTitle("Health Tags")
            HealthTagOptions:SetLayout("Flow")
            HealthTagOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(HealthTagOptions)

            for Title, TableData in pairs(HealthTags) do
                local Tag, Desc = TableData.Tag, TableData.Desc
                HealthTagTitle = UUFGUI:Create("Heading")
                HealthTagTitle:SetText(Title)
                HealthTagTitle:SetRelativeWidth(1)
                HealthTagOptions:AddChild(HealthTagTitle)

                local HealthTagTag = UUFGUI:Create("EditBox")
                HealthTagTag:SetText(Tag)
                HealthTagTag:SetCallback("OnEnterPressed", function(widget, event, value) return end)
                HealthTagTag:SetRelativeWidth(0.25)
                HealthTagOptions:AddChild(HealthTagTag)

                HealthTagDescription = UUFGUI:Create("EditBox")
                HealthTagDescription:SetText(Desc)
                HealthTagDescription:SetCallback("OnEnterPressed", function(widget, event, value) return end)
                HealthTagDescription:SetRelativeWidth(0.75)
                HealthTagOptions:AddChild(HealthTagDescription)
            end
        end

        -- local function DrawPowerTagsContainer(UUFGUI_Container)
        --     -- local PowerTags = UUF:FetchPowerTagDescriptions()

        --     -- local PowerTagOptions = UUFGUI:Create("InlineGroup")
        --     -- PowerTagOptions:SetTitle("Power Tags")
        --     -- PowerTagOptions:SetLayout("Flow")
        --     -- PowerTagOptions:SetFullWidth(true)
        --     -- UUFGUI_Container:AddChild(PowerTagOptions)

        --     -- for Title, TableData in pairs(PowerTags) do
        --     --     local Tag, Desc = TableData.Tag, TableData.Desc
        --     --     PowerTagTitle = UUFGUI:Create("Label")
        --     --     PowerTagTitle:SetText(Title)
        --     --     PowerTagTitle:SetRelativeWidth(1)
        --     --     PowerTagOptions:AddChild(PowerTagTitle)

        --     --     local PowerTagTag = UUFGUI:Create("EditBox")
        --     --     PowerTagTag:SetText(Tag)
        --     --     PowerTagTag:SetCallback("OnEnterPressed", function(widget, event, value) return end)
        --     --     PowerTagTag:SetRelativeWidth(0.3)
        --     --     PowerTagOptions:AddChild(PowerTagTag)

        --     --     PowerTagDescription = UUFGUI:Create("EditBox")
        --     --     PowerTagDescription:SetText(Desc)
        --     --     PowerTagDescription:SetCallback("OnEnterPressed", function(widget, event, value) return end)
        --     --     PowerTagDescription:SetRelativeWidth(0.7)
        --     --     PowerTagOptions:AddChild(PowerTagDescription)
        --     -- end
        -- end

        local function DrawNameTagsContainer(UUFGUI_Container)
            local NameTags = UUF:FetchNameTagDescriptions()

            local NameTagOptions = UUFGUI:Create("InlineGroup")
            NameTagOptions:SetTitle("Name Tags")
            NameTagOptions:SetLayout("Flow")
            NameTagOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(NameTagOptions)

            for Title, TableData in pairs(NameTags) do
                local Tag, Desc = TableData.Tag, TableData.Desc
                NameTagTitle = UUFGUI:Create("Heading")
                NameTagTitle:SetText(Title)
                NameTagTitle:SetRelativeWidth(1)
                NameTagOptions:AddChild(NameTagTitle)

                local NameTagTag = UUFGUI:Create("EditBox")
                NameTagTag:SetText(Tag)
                NameTagTag:SetCallback("OnEnterPressed", function(widget, event, value) return end)
                NameTagTag:SetRelativeWidth(0.3)
                NameTagOptions:AddChild(NameTagTag)

                NameTagDescription = UUFGUI:Create("EditBox")
                NameTagDescription:SetText(Desc)
                NameTagDescription:SetCallback("OnEnterPressed", function(widget, event, value) return end)
                NameTagDescription:SetRelativeWidth(0.7)
                NameTagOptions:AddChild(NameTagDescription)
            end
        end

        local function SelectedGroup(UUFGUI_Container, Event, Group)
            UUFGUI_Container:ReleaseChildren()
            if Group == "Health" then
                DrawHealthTagContainer(UUFGUI_Container)
            -- elseif Group == "Power" then
            --     DrawPowerTagsContainer(UUFGUI_Container)
            elseif Group == "Name" then
                DrawNameTagsContainer(UUFGUI_Container)
            end
        end

        GUIContainerTabGroup = UUFGUI:Create("TabGroup")
        GUIContainerTabGroup:SetLayout("Flow")
        GUIContainerTabGroup:SetTabs({
            { text = "Health",                              value = "Health"},
            -- { text = "Power",                               value = "Power" },
            { text = "Name",                                value = "Name" },
        })
        
        GUIContainerTabGroup:SetCallback("OnGroupSelected", SelectedGroup)
        GUIContainerTabGroup:SelectTab("Health")
        GUIContainerTabGroup:SetFullWidth(true)
        UUFGUI_Container:AddChild(GUIContainerTabGroup)
    end

    function SelectedGroup(UUFGUI_Container, Event, Group)
        UUFGUI_Container:ReleaseChildren()
        if Group == "General" then
            DrawGeneralContainer(UUFGUI_Container)
        elseif Group == "Player" then
            DrawUnitContainer(UUFGUI_Container, Group)
        elseif Group == "Target" then
            DrawUnitContainer(UUFGUI_Container, Group)
        elseif Group == "TargetTarget" then
            DrawUnitContainer(UUFGUI_Container, Group)
        elseif Group == "Focus" then
            DrawUnitContainer(UUFGUI_Container, Group)
        elseif Group == "Pet" then
            DrawUnitContainer(UUFGUI_Container, Group)
        elseif Group == "Boss" then
            DrawUnitContainer(UUFGUI_Container, Group)
        elseif Group == "Tags" then
            DrawTagsContainer(UUFGUI_Container)
        end
    end

    GUIContainerTabGroup = UUFGUI:Create("TabGroup")
    GUIContainerTabGroup:SetLayout("Flow")
    GUIContainerTabGroup:SetTabs({
        { text = "General",                         value = "General"},
        { text = "Player",                          value = "Player" },
        { text = "Target",                          value = "Target" },
        { text = "Boss",                            value = "Boss" },
        { text = "Target of Target",                value = "TargetTarget" },
        { text = "Focus",                           value = "Focus" },
        { text = "Pet",                             value = "Pet" },
        { text = "Tags",                            value = "Tags" },
    })
    GUIContainerTabGroup:SetCallback("OnGroupSelected", SelectedGroup)
    GUIContainerTabGroup:SelectTab("General")
    UUFGUI_Container:AddChild(GUIContainerTabGroup)
end