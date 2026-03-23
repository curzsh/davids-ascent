-- Philistine Archer walk cycle - 4 frames at 8 FPS
-- REDESIGNED: 3-tone shading, DSN skin, feathered headdress, bow + quiver
-- Lighter armor than scout, bow as defining prop, tunic more visible
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_archer_walk.aseprite"

-- Color aliases per brief
local O   = PALETTE.VOID_BLACK      -- outlines
local DU  = PALETTE.DARK_UMBER      -- deepest shadow, eye iris (human enemy)
local TRC = PALETTE.TERRACOTTA      -- skin shadow
local DSN = PALETTE.DESERT_SIENNA   -- skin base (Philistine faction)
local WTN = PALETTE.WARM_TAN        -- skin highlight
local AB  = PALETTE.AGED_BRASS      -- helmet mid, minimal armor
local PB  = PALETTE.POLISHED_BRONZE -- helmet highlight
local WL  = PALETTE.WORN_LEATHER    -- leather details, quiver
local SBN = PALETTE.STAFF_BROWN     -- bow wood, arrow shafts
local FW  = PALETTE.FLAX_WEAVE      -- tunic mid (more visible than scout)
local RFX = PALETTE.ROUGH_FLAX      -- tunic shadow
local BLN = PALETTE.BLEACHED_LINEN  -- helmet plume, tunic highlight
local STW = PALETTE.STONE_WHITE     -- eye white
local PW  = PALETTE.PURE_WHITE      -- 1px specular on bronze

local function drawArcher(img, bodyY, leftFoot, rightFoot, bowArmOff, stringArmOff)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0
    bowArmOff = bowArmOff or 0
    stringArmOff = stringArmOff or 0

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    local by = bodyY

    -- ===== BOW (left side, recurve arc) =====
    -- Bow limb upper: curved arc 3px suggesting recurve
    p(6+bowArmOff, 7+by, SBN)  -- upper tip
    p(7+bowArmOff, 8+by, SBN)  -- upper curve
    p(7+bowArmOff, 9+by, SBN)
    p(8+bowArmOff, 10+by, SBN) -- mid-upper (center indented = curve)
    -- Bow grip
    p(8+bowArmOff, 11+by, WL)
    p(8+bowArmOff, 12+by, WL)
    p(8+bowArmOff, 13+by, WL)
    -- Bow limb lower
    p(8+bowArmOff, 14+by, SBN)
    p(7+bowArmOff, 15+by, SBN)
    p(7+bowArmOff, 16+by, SBN)
    p(6+bowArmOff, 17+by, SBN) -- lower tip

    -- Bowstring (BLK line from upper tip to lower tip)
    for sy=7,17 do
        p(9+bowArmOff, sy+by, O)
    end

    -- ===== FEATHERED HEADDRESS (asymmetric plume fanning right) =====
    -- Same design as scout: faction marker
    p(17, 3+by, BLN); p(18, 2+by, BLN); p(19, 2+by, BLN)
    p(18, 3+by, BLN); p(20, 3+by, BLN)

    -- ===== HELMET (bronze dome, smaller/lighter than scout) =====
    hl(13, 19, 4+by, AB)
    p(13, 4+by, PB); p(14, 4+by, PB) -- left highlight
    p(19, 4+by, DU)                    -- right shadow
    hl(13, 19, 5+by, AB)
    p(13, 5+by, PB)                    -- left highlight
    p(19, 5+by, DU)                    -- right shadow
    -- Specular
    p(14, 4+by, PW)
    -- Cheek guards (lighter than scout, less coverage)
    p(12, 6+by, AB); p(20, 6+by, AB)

    -- ===== HEAD OUTLINE =====
    hl(13, 19, 3+by, O)
    p(12, 4+by, O); p(20, 4+by, O)
    p(11, 5+by, O); p(21, 5+by, O)
    p(11, 6+by, O); p(21, 6+by, O)
    p(11, 7+by, O); p(21, 7+by, O)
    p(11, 8+by, O); p(21, 8+by, O)
    p(12, 9+by, O); p(20, 9+by, O)
    p(13, 10+by, O); p(19, 10+by, O)

    -- ===== FACE (DSN base, 3-tone) =====
    hl(14, 18, 6+by, DSN)
    p(14, 6+by, WTN); p(15, 6+by, WTN) -- left highlight
    p(18, 6+by, TRC)                     -- right shadow
    hl(13, 19, 7+by, DSN)
    p(13, 7+by, WTN)                     -- left highlight
    p(19, 7+by, TRC)                     -- right shadow
    hl(14, 18, 8+by, DSN)
    p(18, 8+by, TRC)
    hl(14, 18, 9+by, DSN)
    p(14, 9+by, TRC); p(18, 9+by, TRC)

    -- Eyes (DUM iris = human enemy)
    p(14, 7+by, STW); p(15, 7+by, DU)
    p(17, 7+by, DU); p(18, 7+by, STW)

    -- Nose
    p(16, 8+by, TRC)
    -- Mouth
    p(15, 9+by, DU); p(17, 9+by, DU)

    -- ===== NECK =====
    p(15, 10+by, DSN); p(16, 10+by, DSN); p(17, 10+by, DSN)
    p(15, 10+by, TRC) -- shadow under chin

    -- ===== TORSO: Lighter than scout, more tunic visible =====
    -- Tunic collar
    hl(13, 19, 11+by, BLN)
    p(15, 11+by, RFX); p(16, 11+by, RFX); p(17, 11+by, RFX) -- neckline V shadow

    -- Tunic body (lighter armor than scout: FW base with shoulder guards only)
    for row=12,16 do
        hl(11, 21, row+by, FW)
    end
    -- Tunic shading (left lit, right shadow)
    for row=12,16 do p(11, row+by, BLN) end -- left highlight
    for row=12,16 do p(21, row+by, RFX) end -- right shadow
    -- Center fold
    for row=12,15 do p(16, row+by, RFX) end
    -- Tunic on sides visible (lighter armor than scout)
    p(12, 13+by, FW); p(20, 13+by, FW)

    -- Shoulder guards only (minimal bronze)
    p(12, 12+by, AB); p(13, 12+by, AB)
    p(19, 12+by, AB); p(20, 12+by, AB)
    p(12, 12+by, PB)  -- left shoulder highlight

    -- Quiver strap (diagonal across chest)
    p(20, 13+by, WL); p(20, 14+by, WL); p(20, 15+by, WL)

    -- Belt
    hl(12, 20, 17+by, WL)
    p(12, 17+by, SBN) -- highlight
    p(20, 17+by, DU)  -- shadow

    -- Tunic skirt
    hl(12, 20, 18+by, FW)
    hl(13, 19, 19+by, FW)
    hl(13, 19, 20+by, RFX) -- hem shadow
    p(12, 18+by, BLN) -- lit left
    p(20, 18+by, RFX) -- shadow right
    p(16, 19+by, RFX) -- center fold

    -- ===== QUIVER on right hip =====
    -- 2x4 rectangle with arrow fletching tops
    p(21, 15+by, WL); p(22, 15+by, WL)
    p(21, 16+by, WL); p(22, 16+by, WL)
    p(21, 17+by, WL); p(22, 17+by, WL)
    p(21, 18+by, WL); p(22, 18+by, WL)
    -- Arrow fletching tops (SBN vertical lines)
    p(21, 14+by, SBN); p(22, 14+by, SBN)
    p(21, 13+by, SBN) -- taller arrow
    -- Quiver outline
    p(20, 14+by, O); p(23, 15+by, O); p(23, 16+by, O); p(23, 17+by, O); p(23, 18+by, O)

    -- ===== LEFT ARM (bow arm, extended forward) =====
    p(10+bowArmOff, 12+by, DSN)
    p(9+bowArmOff, 13+by, DSN)
    p(8+bowArmOff, 14+by, DSN)
    p(8+bowArmOff, 13+by, TRC)  -- shadow

    -- ===== RIGHT ARM (string arm, at side) =====
    p(22+stringArmOff, 12+by, DSN)
    p(23+stringArmOff, 13+by, DSN)
    p(23+stringArmOff, 14+by, DSN)
    p(23+stringArmOff, 15+by, TRC) -- shadow

    -- ===== BODY OUTLINE =====
    p(10, 11+by, O); p(10, 12+by, O)
    for row=13,17 do p(10, row+by, O) end
    p(22, 11+by, O); p(22, 12+by, O)
    p(24, 14+by, O); p(24, 15+by, O)
    p(11, 18+by, O); p(21, 18+by, O)
    p(12, 19+by, O); p(20, 19+by, O)
    p(12, 20+by, O); p(20, 20+by, O)

    -- ===== LEGS (3px wide thigh, 2px ankle, 6 rows) =====
    -- Left leg
    p(13, 21+leftFoot, DSN); p(14, 21+leftFoot, DSN); p(15, 21+leftFoot, DSN)
    p(13, 22+leftFoot, DSN); p(14, 22+leftFoot, DSN); p(15, 22+leftFoot, TRC)
    p(14, 23+leftFoot, DSN); p(15, 23+leftFoot, DSN)
    p(14, 24+leftFoot, DSN); p(15, 24+leftFoot, TRC)
    p(13, 21+leftFoot, WTN) -- highlight

    -- Right leg
    p(17, 21+rightFoot, DSN); p(18, 21+rightFoot, DSN); p(19, 21+rightFoot, DSN)
    p(17, 22+rightFoot, TRC); p(18, 22+rightFoot, DSN); p(19, 22+rightFoot, DSN)
    p(17, 23+rightFoot, DSN); p(18, 23+rightFoot, DSN)
    p(17, 24+rightFoot, TRC); p(18, 24+rightFoot, DSN)
    p(19, 21+rightFoot, TRC) -- shadow

    -- Leg separation
    p(16, 21+by, DU)

    -- ===== SANDALS =====
    hl(12, 16, 25+leftFoot, WL)
    hl(12, 16, 26+leftFoot, DU)
    p(12, 25+leftFoot, SBN)

    hl(16, 20, 25+rightFoot, WL)
    hl(16, 20, 26+rightFoot, DU)
    p(16, 25+rightFoot, SBN)
end

-- Frame 1: Contact — right foot forward, left back
drawArcher(spr.cels[1].image, 0, 1, -1, 0, 0)

-- Frame 2: Down — weight drops 1px
local img2 = newFrame(spr)
drawArcher(img2, 1, 0, 0, 0, 0)

-- Frame 3: Passing — mid-stride
local img3 = newFrame(spr)
drawArcher(img3, 0, -1, 1, 0, 0)

-- Frame 4: Up — push off, body rises 1px
local img4 = newFrame(spr)
drawArcher(img4, -1, -1, 1, 0, 0)

-- 8 FPS = 125ms per frame
for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env3_archer\\"
spr:saveAs(outDir .. "enemy_archer_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_archer_walk.png",
    splitLayers=false,
    openGenerated=false,
}
