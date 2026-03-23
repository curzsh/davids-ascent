-- Philistine Scout walk cycle - 4 frames at 8 FPS
-- REDESIGNED: 3-tone shading, proper skin (DSN), feathered headdress, alert posture
-- Light leather jerkin over tunic, short spear + small shield, forward lean
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_scout_walk.aseprite"

-- Color aliases per brief
local O   = PALETTE.VOID_BLACK      -- outlines
local DU  = PALETTE.DARK_UMBER      -- deepest shadow, eye pupil/iris
local TRC = PALETTE.TERRACOTTA      -- skin shadow
local DSN = PALETTE.DESERT_SIENNA   -- skin base (Philistine faction skin)
local WTN = PALETTE.WARM_TAN        -- skin highlight
local AB  = PALETTE.AGED_BRASS      -- bronze helmet mid
local PB  = PALETTE.POLISHED_BRONZE -- bronze highlight
local WL  = PALETTE.WORN_LEATHER    -- leather jerkin mid, belt, boots
local SBN = PALETTE.STAFF_BROWN     -- jerkin highlight, spear shaft
local FW  = PALETTE.FLAX_WEAVE      -- tunic visible at collar/hem
local BLN = PALETTE.BLEACHED_LINEN  -- helmet plume feathers
local SGG = PALETTE.SLATE_GREY      -- optional helmet stone detail
local STW = PALETTE.STONE_WHITE     -- eye white
local PW  = PALETTE.PURE_WHITE      -- 1px specular on bronze

local function drawScout(img, bodyY, leftFoot, rightFoot, spearTipOff, armSwingL, armSwingR)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0
    spearTipOff = spearTipOff or 0
    armSwingL = armSwingL or 0
    armSwingR = armSwingR or 0

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- The body bobs but feet stay planted. We apply bodyY to everything above ankles.
    local by = bodyY

    -- ===== SPEAR (right hand, diagonal from upper-right) =====
    -- Shaft: 1px wide + 1px shadow, diagonal from (21,3) to (23,12)
    -- Tip shifts with spearTipOff for animation
    local spX = 21 + spearTipOff
    p(spX, 2+by, PB)  -- spear tip bronze
    p(spX, 3+by, PB)
    p(spX-1, 2+by, O); p(spX+1, 2+by, O) -- tip outline
    p(spX, 1+by, PB)  -- very tip
    p(spX+1, 3+by, DU) -- shadow edge on tip
    -- Shaft
    for sy=4,11 do
        p(22, sy+by, SBN)
        p(23, sy+by, WL)  -- shadow edge
    end

    -- ===== FEATHERED HEADDRESS (asymmetric plume fanning right) =====
    -- 3-4 BLN feather strands fanning from helmet crown to the right
    p(17, 3+by, BLN); p(18, 2+by, BLN); p(19, 2+by, BLN)
    p(18, 3+by, BLN); p(19, 3+by, BLN)
    p(20, 3+by, BLN)  -- outermost feather tip

    -- ===== HELMET (bronze dome) =====
    -- Left face: PB highlight, Center: AB mid, Right: DU shadow
    hl(13, 19, 4+by, AB)
    p(13, 4+by, PB); p(14, 4+by, PB)  -- left highlight
    p(19, 4+by, DU)                     -- right shadow
    hl(13, 19, 5+by, AB)
    p(13, 5+by, PB)                     -- left highlight
    p(18, 5+by, DU); p(19, 5+by, DU)   -- right shadow
    -- Specular on helmet
    p(14, 4+by, PW)
    -- Cheek guards
    p(12, 6+by, AB); p(20, 6+by, DU)

    -- ===== HEAD OUTLINE =====
    hl(13, 19, 3+by, O)
    p(12, 4+by, O); p(20, 4+by, O)
    p(11, 5+by, O); p(21, 5+by, O)
    p(11, 6+by, O); p(21, 6+by, O)
    p(11, 7+by, O); p(21, 7+by, O)
    p(11, 8+by, O); p(21, 8+by, O)
    p(12, 9+by, O); p(20, 9+by, O)
    p(13, 10+by, O); p(19, 10+by, O)

    -- ===== FACE (DSN skin base, 3-tone shading) =====
    -- Upper face
    hl(14, 18, 6+by, DSN)
    p(14, 6+by, WTN); p(15, 6+by, WTN)  -- left highlight
    p(18, 6+by, TRC)                      -- right shadow
    -- Mid face
    hl(13, 19, 7+by, DSN)
    p(13, 7+by, WTN)                      -- left highlight
    p(19, 7+by, TRC)                      -- right shadow
    -- Lower face
    hl(14, 18, 8+by, DSN)
    p(18, 8+by, TRC)                      -- right shadow
    -- Chin
    hl(14, 18, 9+by, DSN)
    p(14, 9+by, TRC); p(18, 9+by, TRC)   -- jaw shadow

    -- Eyes (DUM iris per brief - human enemy, not predator)
    p(14, 7+by, STW); p(15, 7+by, DU)    -- left eye: white + dark iris
    p(17, 7+by, DU); p(18, 7+by, STW)    -- right eye: dark iris + white

    -- Nose
    p(16, 8+by, TRC)
    -- Mouth
    p(15, 9+by, DU); p(17, 9+by, DU)

    -- ===== NECK =====
    p(15, 10+by, DSN); p(16, 10+by, DSN); p(17, 10+by, DSN)
    p(15, 10+by, TRC) -- neck shadow (under chin)

    -- ===== TORSO: Leather jerkin over tunic =====
    -- The scout leans 1px forward (body shifted left of center slightly)
    -- Jerkin: WL mid, SBN highlight left, DU shadow right
    -- Tunic visible at collar: FW (brighter linen)

    -- Collar (tunic showing)
    hl(13, 19, 11+by, FW)
    p(15, 11+by, DU); p(16, 11+by, DU); p(17, 11+by, DU)  -- neckline V shadow

    -- Jerkin body (rows 12-16)
    for row=12,16 do
        hl(11, 21, row+by, WL)  -- leather base
    end
    -- Left edge lit (jerkin highlight)
    for row=12,16 do p(11, row+by, SBN) end
    -- Right edge shadow
    for row=12,16 do p(21, row+by, DU) end
    -- Center vertical fold
    for row=12,15 do p(16, row+by, DU) end
    -- Tunic peeking at armholes
    p(12, 13+by, FW); p(20, 13+by, FW)
    -- Bronze chest strip (minimal armor)
    hl(14, 18, 12+by, AB)
    p(14, 12+by, PB)  -- left armor highlight
    p(18, 12+by, DU)  -- right armor shadow

    -- Belt
    hl(12, 20, 17+by, WL)
    p(12, 17+by, SBN) -- belt highlight left
    p(20, 17+by, DU)  -- belt shadow right

    -- Tunic skirt below belt
    hl(12, 20, 18+by, FW)
    hl(13, 19, 19+by, FW)
    hl(13, 19, 20+by, WL)  -- hem shadow
    -- Skirt shading
    p(12, 18+by, BLN)  -- lit left edge
    p(20, 18+by, DU)   -- shadow right
    p(16, 19+by, DU)   -- center fold

    -- ===== SHIELD (left arm, small round ~6px diameter) =====
    -- Shield outline
    p(7, 12+by, O); p(8, 11+by, O); p(9, 11+by, O); p(10, 11+by, O); p(11, 12+by, O)
    p(7, 16+by, O); p(8, 17+by, O); p(9, 17+by, O); p(10, 17+by, O); p(11, 16+by, O)
    p(6, 13+by, O); p(6, 14+by, O); p(6, 15+by, O)
    -- Shield face (3-tone bronze)
    for sy=13,15 do hl(7, 10, sy+by, AB) end
    p(7, 12+by, AB); p(8, 12+by, AB); p(9, 12+by, AB); p(10, 12+by, AB)
    p(7, 16+by, AB); p(8, 16+by, AB); p(9, 16+by, AB); p(10, 16+by, AB)
    -- Shield highlight (left catches light)
    p(7, 13+by, PB); p(7, 14+by, PB)
    -- Shield shadow (right)
    p(10, 14+by, DU); p(10, 15+by, DU)
    -- Shield boss center
    p(8, 14+by, PB); p(9, 14+by, PB)
    -- Specular on boss
    p(8, 14+by, PW)

    -- ===== LEFT ARM (holding shield, swing offset) =====
    p(10+armSwingL, 12+by, DSN)
    p(9+armSwingL, 13+by, DSN); p(9+armSwingL, 14+by, TRC)

    -- ===== RIGHT ARM (holding spear, swing offset) =====
    p(22+armSwingR, 12+by, DSN)
    p(23+armSwingR, 13+by, DSN); p(23+armSwingR, 14+by, DSN)
    p(23+armSwingR, 15+by, TRC)  -- shadow at wrist

    -- ===== BODY OUTLINE =====
    p(10, 11+by, O); p(10, 12+by, O)
    for row=13,17 do p(10, row+by, O) end
    p(22, 11+by, O); p(22, 12+by, O)
    p(23, 13+by, O); p(24, 14+by, O); p(24, 15+by, O)
    p(11, 18+by, O); p(21, 18+by, O)
    p(12, 19+by, O); p(20, 19+by, O)
    p(12, 20+by, O); p(20, 20+by, O)

    -- ===== LEGS (3px wide thigh tapering to 2px ankle, 6 rows) =====
    -- Left leg
    p(13, 21+leftFoot, DSN); p(14, 21+leftFoot, DSN); p(15, 21+leftFoot, DSN)  -- thigh
    p(13, 22+leftFoot, DSN); p(14, 22+leftFoot, DSN); p(15, 22+leftFoot, TRC)  -- thigh shadow
    p(14, 23+leftFoot, DSN); p(15, 23+leftFoot, DSN)  -- shin
    p(14, 24+leftFoot, DSN); p(15, 24+leftFoot, TRC)  -- shin shadow
    -- Left leg highlight
    p(13, 21+leftFoot, WTN)

    -- Right leg
    p(17, 21+rightFoot, DSN); p(18, 21+rightFoot, DSN); p(19, 21+rightFoot, DSN)
    p(17, 22+rightFoot, TRC); p(18, 22+rightFoot, DSN); p(19, 22+rightFoot, DSN)
    p(17, 23+rightFoot, DSN); p(18, 23+rightFoot, DSN)
    p(17, 24+rightFoot, TRC); p(18, 24+rightFoot, DSN)
    -- Right leg shadow
    p(19, 21+rightFoot, TRC)

    -- Leg separation
    p(16, 21+by, DU)

    -- ===== SANDALS (boot-like, 2px tall) =====
    -- Left sandal
    hl(12, 16, 25+leftFoot, WL)
    hl(12, 16, 26+leftFoot, DU)
    p(12, 25+leftFoot, SBN)  -- strap highlight

    -- Right sandal
    hl(16, 20, 25+rightFoot, WL)
    hl(16, 20, 26+rightFoot, DU)
    p(16, 25+rightFoot, SBN)  -- strap highlight
end

-- Frame 1: Contact — right foot forward, left back; left arm back, right forward
drawScout(spr.cels[1].image, 0, 1, -1, 0, -1, 0)

-- Frame 2: Down — weight loads, body drops 1px
local img2 = newFrame(spr)
drawScout(img2, 1, 0, 0, 0, 0, 0)

-- Frame 3: Passing — mid-stride, feet even
local img3 = newFrame(spr)
drawScout(img3, 0, -1, 1, 1, 0, 0)

-- Frame 4: Up — push off, body rises 1px; mirror of frame 1
local img4 = newFrame(spr)
drawScout(img4, -1, -1, 1, 0, 1, -1)

-- 8 FPS = 125ms per frame
for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env3_scout\\"
spr:saveAs(outDir .. "enemy_scout_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_scout_walk.png",
    splitLayers=false,
    openGenerated=false,
}
