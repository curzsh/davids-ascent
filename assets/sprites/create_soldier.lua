-- Philistine Soldier walk cycle - 4 frames at 8 FPS
-- REDESIGNED: Heavy bronze breastplate, tall feathered crest, round shield + long spear
-- Most armored regular human enemy. Bronze-dominant palette.
-- Shield on left arm (extends further left), spear on right.
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_soldier_walk.aseprite"

-- Color aliases per brief
local O   = PALETTE.VOID_BLACK      -- outlines
local DU  = PALETTE.DARK_UMBER      -- deepest shadow, eye iris, armor crevices
local TRC = PALETTE.TERRACOTTA      -- skin shadow
local DSN = PALETTE.DESERT_SIENNA   -- skin base (Philistine)
local WTN = PALETTE.WARM_TAN        -- skin highlight
local AB  = PALETTE.AGED_BRASS      -- bronze armor mid, shield
local PB  = PALETTE.POLISHED_BRONZE -- armor highlight, breastplate ridges
local WL  = PALETTE.WORN_LEATHER    -- leather straps, pteruges
local SBN = PALETTE.STAFF_BROWN     -- spear shaft
local BLN = PALETTE.BLEACHED_LINEN  -- plume feathers (largest of regular enemies)
local NGT = PALETTE.NIGHT_BLUE      -- deepest armor shadow
local STW = PALETTE.STONE_WHITE     -- eye white
local PW  = PALETTE.PURE_WHITE      -- specular on bronze

local function drawSoldier(img, bodyY, leftFoot, rightFoot, spearTipOff)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0
    spearTipOff = spearTipOff or 0

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    local by = bodyY

    -- ===== LONG SPEAR (right side, diagonal) =====
    -- Shaft from (23, 1+spearTipOff) down to (23, 14)
    local stx = 23
    p(stx, 0+by+spearTipOff, PB)  -- tip
    p(stx, 1+by+spearTipOff, PB)
    p(stx-1, 0+by+spearTipOff, O); p(stx+1, 0+by+spearTipOff, O) -- tip outline
    p(stx+1, 1+by+spearTipOff, DU) -- tip shadow
    -- Specular on tip
    p(stx, 0+by+spearTipOff, PW)
    -- Shaft
    for sy=2,14 do
        p(stx, sy+by, SBN)
        p(stx+1, sy+by, WL) -- shadow edge
    end

    -- ===== FEATHERED CREST (5-6 feathers, largest of regular enemies) =====
    -- Dramatic fan arcing right from helmet crown
    p(16, 1+by, BLN); p(17, 1+by, BLN)  -- base strands
    p(18, 0+by, BLN); p(19, 0+by, BLN)  -- upper fan
    p(20, 0+by, BLN); p(21, 1+by, BLN)  -- outer fan
    p(17, 0+by, BLN)  -- inner strand

    -- ===== HELMET (full bronze dome, larger than scout) =====
    hl(12, 20, 2+by, AB)
    hl(11, 21, 3+by, AB)
    hl(11, 21, 4+by, AB)
    -- Left highlight
    p(12, 2+by, PB); p(13, 2+by, PB)
    p(11, 3+by, PB); p(12, 3+by, PB)
    -- Right shadow
    p(20, 2+by, DU); p(20, 3+by, DU); p(21, 3+by, DU)
    p(21, 4+by, DU)
    -- Specular
    p(13, 3+by, PW)
    -- Cheek guards (heavy)
    p(11, 5+by, AB); p(12, 5+by, AB)
    p(20, 5+by, DU); p(21, 5+by, AB)

    -- ===== HEAD OUTLINE =====
    hl(12, 20, 1+by, O)
    p(11, 2+by, O); p(21, 2+by, O)
    p(10, 3+by, O); p(22, 3+by, O)
    p(10, 4+by, O); p(22, 4+by, O)
    p(10, 5+by, O); p(22, 5+by, O)
    p(10, 6+by, O); p(22, 6+by, O)
    p(10, 7+by, O); p(22, 7+by, O)
    p(11, 8+by, O); p(21, 8+by, O)
    p(12, 9+by, O); p(20, 9+by, O)

    -- ===== FACE (DSN base, narrow due to helmet) =====
    hl(13, 19, 5+by, DSN)
    p(13, 5+by, WTN); p(14, 5+by, WTN) -- left highlight
    p(19, 5+by, TRC)                     -- right shadow
    hl(12, 20, 6+by, DSN)
    p(12, 6+by, WTN)
    p(20, 6+by, TRC)
    hl(13, 19, 7+by, DSN)
    p(19, 7+by, TRC)
    hl(13, 19, 8+by, DSN)
    p(13, 8+by, TRC); p(19, 8+by, TRC)

    -- Eyes (DUM iris)
    p(13, 6+by, STW); p(14, 6+by, DU)
    p(18, 6+by, DU); p(19, 6+by, STW)

    -- Nose
    p(16, 7+by, TRC)
    -- Mouth
    p(15, 8+by, DU); p(17, 8+by, DU)

    -- ===== NECK (armored gorget) =====
    p(14, 9+by, AB); p(15, 9+by, AB); p(16, 9+by, AB); p(17, 9+by, AB); p(18, 9+by, AB)

    -- ===== BRONZE BREASTPLATE (full, the defining armor) =====
    -- Breastplate rows 10-15: ABR base, PBR pectoral ridges, DU center crease
    for row=10,15 do
        hl(11, 21, row+by, AB)
    end
    -- Left pectoral plate (PB highlight)
    p(12, 10+by, PB); p(13, 10+by, PB); p(14, 10+by, PB)
    p(12, 11+by, PB); p(13, 11+by, PB); p(14, 11+by, PB)
    p(12, 12+by, PB); p(13, 12+by, PB)
    -- Right pectoral plate (PB)
    p(18, 10+by, PB); p(19, 10+by, PB); p(20, 10+by, PB)
    p(18, 11+by, PB); p(19, 11+by, PB)
    -- Center crease (DU vertical line)
    for row=10,14 do p(16, row+by, DU) end
    -- Left edge highlight
    for row=10,15 do p(11, row+by, PB) end
    -- Right edge shadow
    for row=10,15 do p(21, row+by, DU) end
    -- Bottom armor shadow
    hl(12, 20, 15+by, DU)
    -- Specular on left pectoral
    p(13, 11+by, PW)
    -- Deepest shadow at armpit
    p(11, 14+by, NGT); p(21, 14+by, NGT)

    -- ===== PTERUGES (war skirt) =====
    hl(12, 20, 16+by, WL)
    hl(12, 20, 17+by, WL)
    hl(13, 19, 18+by, WL)
    hl(13, 19, 19+by, WL)
    -- Pteruge strip separations
    p(14, 16+by, DU); p(16, 16+by, DU); p(18, 16+by, DU)
    p(14, 17+by, DU); p(16, 17+by, DU); p(18, 17+by, DU)
    p(15, 18+by, DU); p(17, 18+by, DU)
    -- Left lit edge
    p(12, 16+by, SBN); p(12, 17+by, SBN)
    -- Right shadow
    p(20, 16+by, DU); p(20, 17+by, DU)

    -- ===== ROUND SHIELD (left arm, ~8px diameter) =====
    -- Shield extends from approximately x=4 to x=12 (left-heavy silhouette)
    -- Shield outline (circular)
    p(6, 10+by, O); p(7, 9+by, O); p(8, 9+by, O); p(9, 9+by, O); p(10, 9+by, O); p(11, 10+by, O)
    p(6, 17+by, O); p(7, 18+by, O); p(8, 18+by, O); p(9, 18+by, O); p(10, 18+by, O); p(11, 17+by, O)
    p(5, 11+by, O); p(5, 12+by, O); p(5, 13+by, O); p(5, 14+by, O); p(5, 15+by, O); p(5, 16+by, O)
    p(12, 11+by, O); p(12, 12+by, O); p(12, 13+by, O); p(12, 14+by, O); p(12, 15+by, O); p(12, 16+by, O)

    -- Shield face (3-tone bronze)
    for sy=11,16 do hl(6, 11, sy+by, AB) end
    -- Shield highlight (left catches light)
    for sy=11,15 do p(6, sy+by, PB) end
    p(7, 11+by, PB); p(7, 12+by, PB)
    -- Shield shadow (right edge)
    for sy=12,16 do p(11, sy+by, DU) end
    -- Shield rim shadow
    for sy=10,17 do p(6, sy+by, AB) end
    p(7, 10+by, AB); p(8, 10+by, AB); p(9, 10+by, AB); p(10, 10+by, AB)
    p(7, 17+by, AB); p(8, 17+by, AB); p(9, 17+by, AB); p(10, 17+by, AB)
    -- Central boss (1px PB highlight)
    p(8, 13+by, PB); p(9, 13+by, PB)
    p(8, 14+by, PB); p(9, 14+by, PB)
    -- Specular on boss
    p(8, 13+by, PW)

    -- ===== LEFT ARM (behind shield) =====
    p(11, 11+by, DSN); p(11, 12+by, TRC)

    -- ===== RIGHT ARM (spear arm) =====
    p(22, 10+by, DSN)
    p(22, 11+by, DSN); p(22, 12+by, DSN)
    p(22, 13+by, TRC) -- shadow at wrist

    -- ===== BODY OUTLINE =====
    p(10, 10+by, O)
    for row=11,17 do p(10, row+by, O) end
    p(22, 10+by, O)
    p(24, 11+by, O); p(24, 12+by, O); p(24, 13+by, O)
    p(11, 16+by, O); p(21, 16+by, O)
    p(12, 19+by, O); p(20, 19+by, O)

    -- ===== LEGS (greaves: bronze shin armor) =====
    -- Left leg
    p(13, 20+leftFoot, DSN); p(14, 20+leftFoot, DSN); p(15, 20+leftFoot, DSN)  -- thigh
    p(13, 21+leftFoot, DSN); p(14, 21+leftFoot, TRC); p(15, 21+leftFoot, TRC)
    -- Left greave
    p(13, 22+leftFoot, AB); p(14, 22+leftFoot, PB); p(15, 22+leftFoot, AB)
    p(13, 23+leftFoot, AB); p(14, 23+leftFoot, PB); p(15, 23+leftFoot, AB)
    p(13, 24+leftFoot, AB); p(14, 24+leftFoot, AB); p(15, 24+leftFoot, DU)
    p(13, 22+leftFoot, PB) -- greave left highlight

    -- Right leg
    p(17, 20+rightFoot, DSN); p(18, 20+rightFoot, DSN); p(19, 20+rightFoot, DSN)
    p(17, 21+rightFoot, TRC); p(18, 21+rightFoot, DSN); p(19, 21+rightFoot, TRC)
    -- Right greave
    p(17, 22+rightFoot, AB); p(18, 22+rightFoot, PB); p(19, 22+rightFoot, DU)
    p(17, 23+rightFoot, AB); p(18, 23+rightFoot, AB); p(19, 23+rightFoot, DU)
    p(17, 24+rightFoot, AB); p(18, 24+rightFoot, AB); p(19, 24+rightFoot, DU)

    -- Leg separation
    p(16, 20+by, DU)

    -- ===== SANDALS (heavy military) =====
    hl(12, 16, 25+leftFoot, WL)
    hl(12, 16, 26+leftFoot, DU)
    p(12, 25+leftFoot, SBN)

    hl(16, 20, 25+rightFoot, WL)
    hl(16, 20, 26+rightFoot, DU)
    p(16, 25+rightFoot, SBN)
end

-- Frame 1: Contact — right foot forward
drawSoldier(spr.cels[1].image, 0, 1, -1, 0)

-- Frame 2: Down — weight load
local img2 = newFrame(spr)
drawSoldier(img2, 1, 0, 0, 0)

-- Frame 3: Passing — mid-stride, spear tip shifts 1px
local img3 = newFrame(spr)
drawSoldier(img3, 0, -1, 1, 1)

-- Frame 4: Up — push off
local img4 = newFrame(spr)
drawSoldier(img4, -1, -1, 1, 0)

-- 8 FPS = 125ms per frame
for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env4_soldier\\"
spr:saveAs(outDir .. "enemy_soldier_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_soldier_walk.png",
    splitLayers=false,
    openGenerated=false,
}
