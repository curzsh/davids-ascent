-- Philistine Shieldbearer walk cycle - 4 frames at 8 FPS
-- REDESIGNED: MASSIVE rectangular shield dominates sprite front (~60% coverage)
-- Head peeks above, feet below, sword arm to right. Walking wall of bronze.
-- Shield has Night Blue border, Philistine bird emblem, central boss with specular.
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_shieldbearer_walk.aseprite"

-- Color aliases per brief
local O   = PALETTE.VOID_BLACK      -- outlines
local DU  = PALETTE.DARK_UMBER      -- deepest shadow, eye iris
local TRC = PALETTE.TERRACOTTA      -- skin shadow
local DSN = PALETTE.DESERT_SIENNA   -- skin base (Philistine)
local WTN = PALETTE.WARM_TAN        -- skin highlight
local AB  = PALETTE.AGED_BRASS      -- shield face primary, helmet
local PB  = PALETTE.POLISHED_BRONZE -- shield highlight, armor
local WL  = PALETTE.WORN_LEATHER    -- leather straps
local BLN = PALETTE.BLEACHED_LINEN  -- plume feathers
local NGT = PALETTE.NIGHT_BLUE      -- shield border frame
local SGG = PALETTE.SLATE_GREY      -- short sword blade
local STW = PALETTE.STONE_WHITE     -- shield boss, eye white
local PW  = PALETTE.PURE_WHITE      -- 1px specular on boss

local function drawShieldbearer(img, bodyY, leftFoot, rightFoot)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    local by = bodyY

    -- ===== FEATHERED CREST (visible above shield, 3-4 BLN pixels) =====
    p(18, 2+by, BLN); p(19, 1+by, BLN); p(20, 1+by, BLN)
    p(19, 2+by, BLN)

    -- ===== HELMET (only 2-3 pixels visible above shield top) =====
    hl(15, 21, 3+by, AB)
    hl(15, 21, 4+by, AB)
    p(15, 3+by, PB); p(16, 3+by, PB) -- left highlight
    p(21, 3+by, DU); p(21, 4+by, DU) -- right shadow
    -- Specular on helmet
    p(16, 3+by, PW)

    -- ===== HEAD OUTLINE (partial, above shield) =====
    hl(15, 21, 2+by, O)
    p(14, 3+by, O); p(22, 3+by, O)
    p(14, 4+by, O); p(22, 4+by, O)
    p(14, 5+by, O); p(22, 5+by, O)

    -- ===== FACE (only upper portion visible above shield) =====
    hl(16, 20, 5+by, DSN)
    p(16, 5+by, WTN) -- left highlight
    p(20, 5+by, TRC) -- right shadow
    hl(16, 20, 6+by, DSN)
    p(20, 6+by, TRC)

    -- Eyes (only visible facial feature above shield, DUM iris)
    p(17, 5+by, STW); p(18, 5+by, DU)

    -- ===== LARGE RECTANGULAR SHIELD (the defining feature) =====
    -- Shield: 14px wide (x=6 to x=19), 18px tall (y=7 to y=24)
    -- This covers ~60% of visible sprite area

    -- Shield outline (rectangular)
    hl(6, 19, 6+by, O)   -- top edge
    hl(6, 19, 25+by, O)  -- bottom edge
    for sy=6,25 do p(5, sy+by, O) end   -- left edge
    for sy=6,25 do p(20, sy+by, O) end  -- right edge

    -- Shield face fill: 3-tone convex shading
    -- Left third: PB (lit), Center: AB, Right third: DU (shadow)
    for sy=7,24 do
        hl(6, 9, sy+by, PB)    -- left third, lit
        hl(10, 15, sy+by, AB)  -- center
        hl(16, 19, sy+by, DU)  -- right third, shadow
    end

    -- Night Blue border frame (1px inside outline)
    hl(6, 19, 7+by, NGT)   -- top inner border
    hl(6, 19, 24+by, NGT)  -- bottom inner border
    for sy=7,24 do p(6, sy+by, NGT) end  -- left inner border
    for sy=7,24 do p(19, sy+by, NGT) end -- right inner border

    -- Horizontal bar dividing shield in halves
    hl(7, 18, 15+by, DU)
    hl(7, 18, 16+by, DU)

    -- ===== PHILISTINE BIRD EMBLEM (stylized, 4px wide) =====
    -- Bird body (PB on shield center)
    p(12, 12+by, PB); p(13, 12+by, PB)  -- body center
    p(12, 13+by, PB); p(13, 13+by, PB)  -- body lower
    -- Wings angling up
    p(11, 11+by, PB)  -- left wing
    p(14, 11+by, PB)  -- right wing
    p(10, 10+by, PB)  -- left wingtip
    p(15, 10+by, PB)  -- right wingtip

    -- ===== SHIELD BOSS (central, STW circle 2px with specular) =====
    p(12, 18+by, STW); p(13, 18+by, STW)
    p(12, 19+by, STW); p(13, 19+by, STW)
    -- Specular on boss
    p(12, 18+by, PW)

    -- ===== BODY BEHIND SHIELD (mostly hidden) =====
    -- Heavy bronze armor visible at right edge
    for row=7,20 do p(21, row+by, PB) end
    for row=7,20 do p(22, row+by, AB) end
    -- Armor shadow
    for row=12,18 do p(23, row+by, DU) end
    -- Body outline right
    for row=7,22 do p(23, row+by, O) end

    -- ===== SWORD ARM (right side, extending past shield edge) =====
    -- Right arm visible from elbow to hand with short sword
    p(22, 11+by, DSN); p(23, 12+by, DSN)
    p(24, 13+by, DSN); p(24, 14+by, DSN)
    p(24, 15+by, TRC) -- wrist shadow
    -- Short sword (3px SGG blade)
    p(25, 12+by, SGG); p(25, 13+by, SGG); p(25, 14+by, SGG)
    p(25, 11+by, DU)  -- pommel
    p(25, 15+by, O)   -- tip outline
    -- Sword outline
    p(26, 12+by, O); p(26, 13+by, O); p(26, 14+by, O)

    -- ===== LEFT ARM (behind shield, mostly hidden, holding shield) =====
    -- Only visible as a shadow at shield back edge
    p(20, 12+by, DSN); p(20, 13+by, TRC)

    -- ===== LEGS (visible below shield, heavy planted walk) =====
    -- Only feet/greaves visible below shield bottom edge

    -- Left leg (greave + foot)
    p(10, 26+leftFoot, AB); p(11, 26+leftFoot, PB); p(12, 26+leftFoot, AB)
    p(10, 27+leftFoot, AB); p(11, 27+leftFoot, AB); p(12, 27+leftFoot, DU)

    -- Right leg (greave + foot)
    p(15, 26+rightFoot, AB); p(16, 26+rightFoot, PB); p(17, 26+rightFoot, DU)
    p(15, 27+rightFoot, AB); p(16, 27+rightFoot, AB); p(17, 27+rightFoot, DU)

    -- ===== BOOTS =====
    hl(9, 13, 28+leftFoot, WL)
    hl(9, 13, 29+leftFoot, DU)

    hl(14, 18, 28+rightFoot, WL)
    hl(14, 18, 29+rightFoot, DU)
end

-- Frame 1: Contact — very subtle, planted walk. Shield+body move as one unit.
-- Only feet animate under the shield.
drawShieldbearer(spr.cels[1].image, 0, 0, 1)

-- Frame 2: Down — weight settles
local img2 = newFrame(spr)
drawShieldbearer(img2, 1, 0, 0)

-- Frame 3: Passing — other foot forward
local img3 = newFrame(spr)
drawShieldbearer(img3, 0, 1, 0)

-- Frame 4: Up — slight rise
local img4 = newFrame(spr)
drawShieldbearer(img4, 0, 0, 0)

-- 8 FPS = 125ms per frame
for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env4_shieldbearer\\"
spr:saveAs(outDir .. "enemy_shieldbearer_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_shieldbearer_walk.png",
    splitLayers=false,
    openGenerated=false,
}
