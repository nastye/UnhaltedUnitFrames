local _, UUF = ...
local oUF = UUF.oUF
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
                    [0] = {0, 0, 1},
                    [1] = {1, 0, 0},
                    [2] = {1, 0.5, 0.25},
                    [3] = {1, 1, 0},
                    [4] = {1, 0.96, 0.41},
                    [5] = {0.5, 0.5, 0.5},
                    [6] = {0, 0.82, 1},
                    [7] = {0.5, 0, 0.5},
                    [8] = {0.3, 0.52, 0.9},
                    [9] = {1, 0.9, 0.4},
                    [11] = {0, 0.5, 1},
                    [13] = {0.4, 0, 0.8},
                    [17] = {0.8, 0.3, 0.3},
                    [18] = {0.5, 0.2, 0.2}
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
                AdditionalTexts = {
                    TopLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    TopRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                }  
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
                AdditionalTexts = {
                    TopLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    TopRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                }  
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
                AdditionalTexts = {
                    TopLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    TopRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                }  
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
                AdditionalTexts = {
                    TopLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    TopRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                }  
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
                AdditionalTexts = {
                    TopLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    TopRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                }                
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
                AdditionalTexts = {
                    TopLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    TopRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomLeft = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                    BottomRight = {
                        FontSize        = 12,
                        XOffset         = 0,
                        YOffset         = 0,
                        Tag             = "",
                    },
                }
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

function UUF:LoadCustomColours()
    local General = UUF.DB.global.General
    local PowerTypesToString = {
        [0] = "MANA",
        [1] = "RAGE",
        [2] = "FOCUS",
        [3] = "ENERGY",
        [4] = "COMBO_POINTS",
        [5] = "RUNES",
        [6] = "RUNIC_POWER",
        [7] = "SOUL_SHARDS",
        [8] = "LUNAR_POWER",
        [9] = "HOLY_POWER",
        [11] = "MAELSTROM",
        [13] = "INSANITY",
        [17] = "FURY",
        [18] = "PAIN"
    }
    for powerType, color in pairs(General.CustomColours.Power) do
        local powerTypeString = PowerTypesToString[powerType]
        if powerTypeString then
            oUF.colors.power[powerTypeString] = color
        end
    end
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
    UUF:LoadCustomColours()
    UUF:SpawnPlayerFrame()
    UUF:SpawnTargetFrame()
    UUF:SpawnTargetTargetFrame()
    UUF:SpawnFocusFrame()
    UUF:SpawnPetFrame()
    UUF:SpawnBossFrame()
    UUF:SetupSlashCommands()
end