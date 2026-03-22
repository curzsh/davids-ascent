-- Health orbs - 16x16, full and empty versions
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

-- ============================================================
-- HEALTH ORB FULL (golden glow)
-- ============================================================
local spr = Sprite(16, 16, ColorMode.RGB)
spr.filename = "ui_health_orb_full.aseprite"

local O  = PALETTE.DARK_UMBER       -- #3D1F00 UI outline (warmer)
local GD = PALETTE.AGED_BRASS       -- #B87820 dark gold
local GM = PALETTE.POLISHED_BRONZE  -- #E8A820 mid gold
local GL = PALETTE.HARVEST_YELLOW   -- #F0C840 light gold
local GH = PALETTE.SUNLIT_LINEN    -- #F5D898 highlight
local W  = PALETTE.PURE_WHITE       -- specular

local img = spr.cels[1].image
clear(img)

-- Circular orb shape (centered in 16x16)
-- Row 3
hline(img, 5, 10, 3, O)
-- Row 4
px(img, 4, 4, O); hline(img, 5, 10, 4, GD); px(img, 11, 4, O)
-- Row 5
px(img, 3, 5, O); px(img, 4, 5, GD); hline(img, 5, 10, 5, GM); px(img, 11, 5, GD); px(img, 12, 5, O)
-- Row 6
px(img, 3, 6, O); px(img, 4, 6, GD); px(img, 5, 6, GM); hline(img, 6, 9, 6, GL); px(img, 10, 6, GM); px(img, 11, 6, GD); px(img, 12, 6, O)
-- Row 7
px(img, 2, 7, O); px(img, 3, 7, GD); px(img, 4, 7, GM); px(img, 5, 7, GL); hline(img, 6, 9, 7, GH); px(img, 10, 7, GL); px(img, 11, 7, GM); px(img, 12, 7, GD); px(img, 13, 7, O)
-- Row 8
px(img, 2, 8, O); px(img, 3, 8, GD); px(img, 4, 8, GM); px(img, 5, 8, GL); hline(img, 6, 9, 8, GH); px(img, 10, 8, GL); px(img, 11, 8, GM); px(img, 12, 8, GD); px(img, 13, 8, O)
-- Row 9
px(img, 3, 9, O); px(img, 4, 9, GD); px(img, 5, 9, GM); hline(img, 6, 9, 9, GL); px(img, 10, 9, GM); px(img, 11, 9, GD); px(img, 12, 9, O)
-- Row 10
px(img, 3, 10, O); px(img, 4, 10, GD); hline(img, 5, 10, 10, GM); px(img, 11, 10, GD); px(img, 12, 10, O)
-- Row 11
px(img, 4, 11, O); hline(img, 5, 10, 11, GD); px(img, 11, 11, O)
-- Row 12
hline(img, 5, 10, 12, O)

-- Specular highlight (upper-left)
px(img, 6, 5, W); px(img, 7, 5, W)
px(img, 5, 6, W)

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\ui\\hud\\"
spr:saveCopyAs(outDir .. "ui_health_orb_full.png")
spr:saveAs(outDir .. "ui_health_orb_full.aseprite")

-- ============================================================
-- HEALTH ORB EMPTY (greyed out, cracked)
-- ============================================================
local spr2 = Sprite(16, 16, ColorMode.RGB)
spr2.filename = "ui_health_orb_empty.aseprite"

local ED = PALETTE.DARK_UMBER       -- dark
local EM = PALETTE.TERRACOTTA       -- #6B3A1F mid grey-brown
local EL = PALETTE.DESERT_SIENNA    -- #A05C2C light grey-brown
local EH = PALETTE.SANDY_BROWN      -- slight highlight

local img2 = spr2.cels[1].image
clear(img2)

-- Same shape, duller colors
hline(img2, 5, 10, 3, O)
px(img2, 4, 4, O); hline(img2, 5, 10, 4, ED); px(img2, 11, 4, O)
px(img2, 3, 5, O); px(img2, 4, 5, ED); hline(img2, 5, 10, 5, EM); px(img2, 11, 5, ED); px(img2, 12, 5, O)
px(img2, 3, 6, O); px(img2, 4, 6, ED); px(img2, 5, 6, EM); hline(img2, 6, 9, 6, EL); px(img2, 10, 6, EM); px(img2, 11, 6, ED); px(img2, 12, 6, O)
px(img2, 2, 7, O); px(img2, 3, 7, ED); px(img2, 4, 7, EM); px(img2, 5, 7, EL); hline(img2, 6, 9, 7, EH); px(img2, 10, 7, EL); px(img2, 11, 7, EM); px(img2, 12, 7, ED); px(img2, 13, 7, O)
px(img2, 2, 8, O); px(img2, 3, 8, ED); px(img2, 4, 8, EM); px(img2, 5, 8, EL); hline(img2, 6, 9, 8, EH); px(img2, 10, 8, EL); px(img2, 11, 8, EM); px(img2, 12, 8, ED); px(img2, 13, 8, O)
px(img2, 3, 9, O); px(img2, 4, 9, ED); px(img2, 5, 9, EM); hline(img2, 6, 9, 9, EL); px(img2, 10, 9, EM); px(img2, 11, 9, ED); px(img2, 12, 9, O)
px(img2, 3, 10, O); px(img2, 4, 10, ED); hline(img2, 5, 10, 10, EM); px(img2, 11, 10, ED); px(img2, 12, 10, O)
px(img2, 4, 11, O); hline(img2, 5, 10, 11, ED); px(img2, 11, 11, O)
hline(img2, 5, 10, 12, O)

-- Crack lines (dark line through the orb)
px(img2, 7, 5, O); px(img2, 8, 6, O); px(img2, 7, 7, O); px(img2, 8, 8, O)
px(img2, 9, 9, O); px(img2, 8, 10, O)

spr2:saveCopyAs(outDir .. "ui_health_orb_empty.png")
spr2:saveAs(outDir .. "ui_health_orb_empty.aseprite")
