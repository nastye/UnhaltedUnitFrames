local _, UUF = ...
local oUF = UUF.oUF
local UUFGUI = LibStub:GetLibrary("AceGUI-3.0")
local GUI_WIDTH = 800
local GUI_HEIGHT = 640
local GUI_TITLE = C_AddOns.GetAddOnMetadata("UnhaltedUF", "Title")
local GUI_VERSION = C_AddOns.GetAddOnMetadata("UnhaltedUF", "Version")
local LSM = LibStub("LibSharedMedia-3.0")
local LSMFonts = {}
local LSMTextures = {}

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

function UUF:GenerateLSMFonts()
    local Fonts = LSM:HashTable("font")
    for Path, Font in pairs(Fonts) do
        LSMFonts[Font] = Path
    end
    return LSMFonts
end

function UUF:GenerateLSMTextures()
    local Textures = LSM:HashTable("statusbar")
    for Path, Texture in pairs(Textures) do
        LSMTextures[Texture] = Path
    end
    return LSMTextures
end

function UUF:UpdateFrames()
    UUF:UpdatePlayerFrame(self.PlayerFrame)
    UUF:UpdateTargetFrame(self.TargetFrame)
    UUF:UpdateFocusFrame(self.FocusFrame)
    UUF:UpdatePetFrame(self.PetFrame)
    UUF:UpdateTargetTargetFrame(self.TargetTargetFrame)
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
        Font:SetList(UUF:GenerateLSMFonts())
        Font:SetValue(General.Font)
        Font:SetCallback("OnValueChanged", function(widget, event, value) General.Font = value UUF:UpdateFrames() end)
        Font:SetRelativeWidth(0.5)
        FontOptionsContainer:AddChild(Font)
        
        local FontFlag = UUFGUI:Create("Dropdown")
        FontFlag:SetLabel("Font Flag")
        FontFlag:SetList({
            ["NONE"] = "None",
            ["OUTLINE"] = "Outline",
            ["THICKOUTLINE"] = "Thick Outline",
        })
        FontFlag:SetValue(General.FontFlag)
        FontFlag:SetCallback("OnValueChanged", function(widget, event, value) General.FontFlag = value UUF:UpdateFrames() end)
        FontFlag:SetRelativeWidth(0.5)
        FontOptionsContainer:AddChild(FontFlag)

        UUFGUI_Container:AddChild(FontOptionsContainer)

        -- Texture Options
        local TextureOptionsContainer = UUFGUI:Create("InlineGroup")
        TextureOptionsContainer:SetTitle("Texture Options")
        TextureOptionsContainer:SetLayout("Flow")
        TextureOptionsContainer:SetFullWidth(true)

        local ForegroundTexture = UUFGUI:Create("Dropdown")
        ForegroundTexture:SetLabel("Foreground Texture")
        ForegroundTexture:SetList(UUF:GenerateLSMTextures())
        ForegroundTexture:SetValue(General.ForegroundTexture)
        ForegroundTexture:SetCallback("OnValueChanged", function(widget, event, value) General.ForegroundTexture = value UUF:UpdateFrames() end)
        ForegroundTexture:SetRelativeWidth(0.5)
        TextureOptionsContainer:AddChild(ForegroundTexture)

        local BackgroundTexture = UUFGUI:Create("Dropdown")
        BackgroundTexture:SetLabel("Background Texture")
        BackgroundTexture:SetList(UUF:GenerateLSMTextures())
        BackgroundTexture:SetValue(General.BackgroundTexture)
        BackgroundTexture:SetCallback("OnValueChanged", function(widget, event, value) General.BackgroundTexture = value UUF:UpdateFrames() end)
        BackgroundTexture:SetRelativeWidth(0.5)
        TextureOptionsContainer:AddChild(BackgroundTexture)
        
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

        UUFGUI_Container:AddChild(ColouringOptionsContainer)
    end

    local function DrawUnitContainer(UUFGUI_Container, Unit)
        local Frame = UUF.DB.global[Unit].Frame
        local Buffs = UUF.DB.global[Unit].Buffs
        local Debuffs = UUF.DB.global[Unit].Debuffs
        local TargetMarker = UUF.DB.global[Unit].TargetMarker
        local LeftText = UUF.DB.global[Unit].Texts.Left
        local RightText = UUF.DB.global[Unit].Texts.Right
        local CenterText = UUF.DB.global[Unit].Texts.Center

        local function DrawFrameContainer(UUFGUI_Container)
            if Unit == "Focus" or Unit == "Pet" or Unit == "TargetTarget" then 
                local Enabled = UUFGUI:Create("CheckBox")
                Enabled:SetLabel("Enable Frame [|cFF8080FFReload|r]")
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
        end

        local function DrawBuffsContainer(UUFGUI_Container)
            local BuffOptions = UUFGUI:Create("InlineGroup")
            BuffOptions:SetTitle("Buff Options")
            BuffOptions:SetLayout("Flow")
            BuffOptions:SetFullWidth(true)
            UUFGUI_Container:AddChild(BuffOptions)
    
            local BuffsEnabled = UUFGUI:Create("CheckBox")
            BuffsEnabled:SetLabel("Enable Buffs [|cFF8080FFReload|r]")
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
            DebuffsEnabled:SetLabel("Enable Debuffs [|cFF8080FFReload|r]")
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
            TargetMarkerEnabled:SetLabel("Enable Target Marker [|cFF8080FFReload|r]")
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

        local function SelectedGroup(UUFGUI_Container, Event, Group)
            UUFGUI_Container:ReleaseChildren()
            if Group == "Frame" then
                DrawFrameContainer(UUFGUI_Container)
            elseif Group == "Texts" then
                DrawTextsContainer(UUFGUI_Container)
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
            { text = "Buffs",                           value = "Buffs" },
            { text = "Debuffs",                         value = "Debuffs" },
            { text = "Target Marker",                   value = "TargetMarker" },
        })
        
        GUIContainerTabGroup:SetCallback("OnGroupSelected", SelectedGroup)
        GUIContainerTabGroup:SelectTab("Frame")
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
    })
    GUIContainerTabGroup:SetCallback("OnGroupSelected", SelectedGroup)
    GUIContainerTabGroup:SelectTab("General")
    UUFGUI_Container:AddChild(GUIContainerTabGroup)
end