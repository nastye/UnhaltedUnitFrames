local _, UUF = ...
local UnhaltedUF = LibStub("AceAddon-3.0"):NewAddon("UnhaltedUF")

UUF.Defaults = {
    global = {
        General = {
            UIScale                 = 0.5333333333333,
            Font                    = "Fonts\\FRIZQT__.TTF",
            FontFlag                = "OUTLINE",
            ForegroundTexture       = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
            BackgroundTexture       = "Interface\\Buttons\\WHITE8X8",
            BorderTexture           = "Interface\\Buttons\\WHITE8X8",
            BackgroundColour        = {26 / 255, 26 / 255, 26 / 255, 1},
            ForegroundColour        = {26 / 255, 26 / 255, 26 / 255, 1},
            BorderColour            = {0 / 255, 0 / 255, 0 / 255, 1},
            BorderSize              = 1,
            ColourByClass           = true,
            ColourByReaction        = true,
            ColourIfDisconnected    = true,
            ColourIfTapped          = true,
            CustomColours = {
                Power = {
                    
                }
            }
        },
        Player = {
            Frame = {
                Width               = 272,
                Height              = 42,
                XPosition           = -425.1,
                YPosition           = -275.1,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
                AnchorParent        = "UIParent",
            },
            Buffs = {
                Enabled             = false,
                Size                = 38,
                Spacing             = 1,
                Num                 = 7,
                AnchorFrom          = "BOTTOMLEFT",
                AnchorTo            = "TOPLEFT",
                XOffset             = 0,
                YOffset             = 1,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            Debuffs = {
                Enabled             = false,
                Size                = 38,
                Spacing             = 1,
                Num                 = 7,
                AnchorFrom          = "BOTTOMLEFT",
                AnchorTo            = "TOPLEFT",
                XOffset             = 0,
                YOffset             = 1,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            TargetMarker = {
                Enabled             = true,
                Size                = 24,
                XOffset             = 0,
                YOffset             = 0,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
            },
            Texts = {
                Left = {
                    FontSize        = 12,
                    XOffset         = 3,
                    YOffset         = 0,
                    Tag             = "[name]",
                },
                Right = {
                    FontSize        = 12,
                    XOffset         = -3,
                    YOffset         = 0,
                    Tag             = "[curhp]",
                },
                Center = {
                    FontSize        = 12,
                    XOffset         = 0,
                    YOffset         = 0,
                    Tag             = "",
                },
            }
        },
        Target = {
            Frame = {
                Width               = 272,
                Height              = 42,
                XPosition           = 425.1,
                YPosition           = -275.1,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
                AnchorParent        = "UIParent",
            },
            Buffs = {
                Enabled             = true,
                Size                = 38,
                Spacing             = 1,
                Num                 = 7,
                AnchorFrom          = "BOTTOMLEFT",
                AnchorTo            = "TOPLEFT",
                XOffset             = 0,
                YOffset             = 1,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            Debuffs = {
                Enabled             = false,
                Size                = 38,
                Spacing             = 1,
                Num                 = 7,
                AnchorFrom          = "BOTTOMLEFT",
                AnchorTo            = "TOPLEFT",
                XOffset             = 0,
                YOffset             = 1,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            TargetMarker = {
                Enabled             = true,
                Size                = 24,
                XOffset             = 0,
                YOffset             = 0,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
            },
            Texts = {
                Left = {
                    FontSize        = 12,
                    XOffset         = 3,
                    YOffset         = 0,
                    Tag             = "[name]",
                },
                Right = {
                    FontSize        = 12,
                    XOffset         = -3,
                    YOffset         = 0,
                    Tag             = "[curhp]",
                },
                Center = {
                    FontSize        = 12,
                    XOffset         = 0,
                    YOffset         = 0,
                    Tag             = "",
                },
            }
        },
        TargetTarget = {
            Frame = {
                Enabled                 = true,
                Width               = 100,
                Height              = 42,
                XPosition           = 1.1,
                YPosition           = 0,
                AnchorFrom          = "TOPLEFT",
                AnchorTo            = "TOPRIGHT",
                AnchorParent        = "UUF_Target",
            },
            Buffs = {
                Enabled             = false,
                Size                = 42,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "LEFT",
                AnchorTo            = "RIGHT",
                XOffset             = 1,
                YOffset             = 0,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            Debuffs = {
                Enabled             = false,
                Size                = 38,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "LEFT",
                AnchorTo            = "RIGHT",
                XOffset             = 0,
                YOffset             = 0,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            TargetMarker = {
                Enabled             = true,
                Size                = 24,
                XOffset             = 0,
                YOffset             = 0,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
            },
            Texts = {
                Left = {
                    FontSize        = 12,
                    XOffset         = 3,
                    YOffset         = 0,
                    Tag             = "",
                },
                Right = {
                    FontSize        = 12,
                    XOffset         = -3,
                    YOffset         = 0,
                    Tag             = "",
                },
                Center = {
                    FontSize        = 12,
                    XOffset         = 0,
                    YOffset         = 0,
                    Tag             = "[name]",
                },
            }
        },
        Focus = {
            Frame = {
                Enabled                 = true,
                Width               = 272,
                Height              = 36,
                XPosition           = 0,
                YPosition           = 40.1,
                AnchorFrom          = "BOTTOMRIGHT",
                AnchorTo            = "TOPRIGHT",
                AnchorParent        = "UUF_Target",
            },
            Buffs = {
                Enabled             = false,
                Size                = 42,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "LEFT",
                AnchorTo            = "RIGHT",
                XOffset             = 1,
                YOffset             = 0,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            Debuffs = {
                Enabled             = false,
                Size                = 38,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "LEFT",
                AnchorTo            = "RIGHT",
                XOffset             = 0,
                YOffset             = 0,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            TargetMarker = {
                Enabled             = true,
                Size                = 24,
                XOffset             = 0,
                YOffset             = 0,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
            },
            Texts = {
                Left = {
                    FontSize        = 12,
                    XOffset         = 3,
                    YOffset         = 0,
                    Tag             = "[name]",
                },
                Right = {
                    FontSize        = 12,
                    XOffset         = -3,
                    YOffset         = 0,
                    Tag             = "[perhp]",
                },
                Center = {
                    FontSize        = 12,
                    XOffset         = 0,
                    YOffset         = 0,
                    Tag             = "",
                },
            }
        },
        Pet = {
            Frame = {
                Enabled                 = true,
                Width               = 272,
                Height              = 10,
                XPosition           = 0,
                YPosition           = -1.1,
                AnchorFrom          = "TOPLEFT",
                AnchorTo            = "BOTTOMLEFT",
                AnchorParent        = "UUF_Player",
            },
            Buffs = {
                Enabled             = false,
                Size                = 42,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "LEFT",
                AnchorTo            = "RIGHT",
                XOffset             = 1,
                YOffset             = 0,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            Debuffs = {
                Enabled             = false,
                Size                = 38,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "LEFT",
                AnchorTo            = "RIGHT",
                XOffset             = 0,
                YOffset             = 0,
                GrowthX             = "RIGHT",
                GrowthY             = "UP",
            },
            TargetMarker = {
                Enabled             = false,
                Size                = 24,
                XOffset             = 0,
                YOffset             = 0,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
            },
            Texts = {
                Left = {
                    FontSize        = 12,
                    XOffset         = 3,
                    YOffset         = 0,
                    Tag             = "",
                },
                Right = {
                    FontSize        = 12,
                    XOffset         = -3,
                    YOffset         = 0,
                    Tag             = "",
                },
                Center = {
                    FontSize        = 12,
                    XOffset         = 0,
                    YOffset         = 0,
                    Tag             = "[name]",
                },
            }
        },
        Boss = {
            Frame = {
                Width               = 250,
                Height              = 42,
                XPosition           = 750.1,
                YPosition           = 0,
                Spacing             = 1,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
                AnchorParent        = "UIParent",
            },
            Buffs = {
                Enabled             = true,
                Size                = 42,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "RIGHT",
                AnchorTo            = "LEFT",
                XOffset             = -1,
                YOffset             = 0,
                GrowthX             = "LEFT",
                GrowthY             = "UP",
            },
            Debuffs = {
                Enabled             = false,
                Size                = 42,
                Spacing             = 1,
                Num                 = 1,
                AnchorFrom          = "RIGHT",
                AnchorTo            = "LEFT",
                XOffset             = -1,
                YOffset             = 0,
                GrowthX             = "LEFT",
                GrowthY             = "UP",
            },
            TargetMarker = {
                Enabled             = true,
                Size                = 24,
                XOffset             = 0,
                YOffset             = 0,
                AnchorFrom          = "CENTER",
                AnchorTo            = "CENTER",
            },
            Texts = {
                Left = {
                    FontSize        = 12,
                    XOffset         = 3,
                    YOffset         = 0,
                    Tag             = "[name]",
                },
                Right = {
                    FontSize        = 12,
                    XOffset         = -3,
                    YOffset         = 0,
                    Tag             = "[curhp]",
                },
                Center = {
                    FontSize        = 12,
                    XOffset         = 0,
                    YOffset         = 0,
                    Tag             = "",
                },
            }
        }
    }
}

function UUF:SetupSlashCommands()
    SLASH_UUF1 = "/uuf"
    SLASH_UUF2 = "/unhalteduf"
    SLASH_UUF3 = "/unhaltedunitframes"
    SlashCmdList["UUF"] = function() UUF:CreateGUI() end
end

function UnhaltedUF:OnInitialize()
    UUF.DB = LibStub("AceDB-3.0"):New("UUFDB", UUF.Defaults)
    for k, v in pairs(UUF.Defaults) do
        if UUF.DB.global[k] == nil then
            UUF.DB.global[k] = v
        end
    end
end

function UnhaltedUF:OnEnable()
    UIParent:SetScale(UUF.DB.global.General.UIScale)
    UUF:SpawnPlayerFrame()
    UUF:SpawnTargetFrame()
    UUF:SpawnTargetTargetFrame()
    UUF:SpawnFocusFrame()
    UUF:SpawnPetFrame()
    UUF:SpawnBossFrame()
    UUF:SetupSlashCommands()
end