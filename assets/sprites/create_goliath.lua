-- Goliath boss idle cycle - 4 frames at 6 FPS
-- REDESIGNED: 48x64 massive armored Philistine warrior
-- Full bronze scale armor (checkerboard pattern), massive spear, tall plumed helmet
-- Menacing weight shift (lateral, not vertical bounce) to convey immovable weight
-- Fills 85-90% of canvas. Inverted triangle silhouette.
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(48, 64, ColorMode.RGB)
spr.filename = "char_goliath_idle.aseprite"

-- Color aliases per brief
local O   = PALETTE.VOID_BLACK      -- outlines
local DU  = PALETTE.DARK_UMBER      -- deepest shadow, eye iris, scale gaps
local TRC = PALETTE.TERRACOTTA      -- skin shadow (face, arms)
local DSN = PALETTE.DESERT_SIENNA   -- skin base (Philistine, darker than David)
local WTN = PALETTE.WARM_TAN        -- skin highlight (exposed face, arms)
local AB  = PALETTE.AGED_BRASS      -- bronze armor primary (~20%)
local PB  = PALETTE.POLISHED_BRONZE -- bronze highlight (~8%)
local WL  = PALETTE.WORN_LEATHER    -- leather straps, armor binding
local SBN = PALETTE.STAFF_BROWN     -- spear shaft
local BLN = PALETTE.BLEACHED_LINEN  -- plume strand mid-tone
local NGT = PALETTE.NIGHT_BLUE      -- deepest armor shadow, greave creases
local SGG = PALETTE.SLATE_GREY      -- helmet body, cloth under armor
local STW = PALETTE.STONE_WHITE     -- plume tips, specular on armor
local FW  = PALETTE.FLAX_WEAVE      -- battle skirt fabric
local PW  = PALETTE.PURE_WHITE      -- 1px specular on shiny bronze

-- Scale armor pattern helper: draws fish-scale texture on the breastplate
-- Even rows start at baseX, odd rows offset by 2px
-- Each scale: 4px wide, 3px tall. Top 2px = PB, bottom 1px = AB, gap = DU
local function drawScaleArmor(p, x1, x2, y1, y2, shiftX)
    shiftX = shiftX or 0
    local scaleW = 4
    local scaleH = 3
    local rowIdx = 0
    local y = y1
    while y <= y2 do
        local offset = (rowIdx % 2 == 0) and 0 or 2
        offset = offset + shiftX
        local x = x1 + offset
        while x <= x2 do
            -- Scale top 2 rows: PB (lit face)
            for dy=0,1 do
                for dx=0, math.min(scaleW-1, x2-x) do
                    if y+dy <= y2 then
                        p(x+dx, y+dy, PB)
                    end
                end
            end
            -- Scale bottom row: AB (shadow edge)
            if y+2 <= y2 then
                for dx=0, math.min(scaleW-1, x2-x) do
                    p(x+dx, y+2, AB)
                end
            end
            x = x + scaleW
        end
        -- Gap row between scale rows: DU shadow
        if y + scaleH <= y2 then
            for gx=x1,x2 do
                p(gx, y+scaleH, DU)
            end
        end
        rowIdx = rowIdx + 1
        y = y + scaleH + 1  -- 3px scale + 1px gap
    end
end

local function drawGoliath(img, shiftX, leftFootOff, rightFootOff, pauldronL, pauldronR)
    clear(img)
    shiftX = shiftX or 0      -- lateral weight shift (NOT vertical bounce)
    leftFootOff = leftFootOff or 0
    rightFootOff = rightFootOff or 0
    pauldronL = pauldronL or 0  -- left pauldron vertical offset
    pauldronR = pauldronR or 0  -- right pauldron vertical offset

    local function p(x, y, c) px(img, x+shiftX, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end
    local function vl(x, y1, y2, c) for y=y1,y2 do p(x, y, c) end end

    -- ===== SPEAR (behind character, right side, massive diagonal) =====
    -- 2px wide shaft from top-right, entering at (38,0) to hand at (38,44)
    vl(37, 0, 44, SBN)
    vl(38, 0, 44, SBN)
    -- Dark shadow edge
    vl(39, 4, 42, DU)
    -- Bronze spear tip at top
    p(37, 0, PB); p(38, 0, PB)
    p(37, 1, PB); p(38, 1, PB)
    hl(36, 39, 2, PB)
    -- Tip specular
    p(37, 0, PW)
    -- Tip outline
    p(36, 0, O); p(39, 0, O)
    p(36, 1, O); p(39, 1, O)

    -- ===== FEATHERED HELMET CREST (plume arcs right, 10 rows tall) =====
    -- 5-7 BLN/STW strands fanning from helmet crown
    -- Plume base (wider, from helmet)
    hl(22, 27, 5, BLN)
    hl(21, 28, 4, BLN)
    -- Plume strands arcing right
    p(23, 3, BLN); p(24, 3, BLN); p(25, 3, BLN); p(26, 3, STW)
    p(24, 2, BLN); p(25, 2, STW); p(26, 2, STW)
    p(25, 1, STW); p(26, 1, STW)  -- tips catch light
    p(27, 2, STW)  -- outermost tip (arcs right 1-2px)
    p(28, 3, BLN)  -- outer strand
    -- Plume intentionally asymmetric: leans right

    -- ===== HELMET (bronze dome, wide, SGG body) =====
    -- Helmet rows 6-12
    hl(17, 31, 6, SGG)
    hl(16, 32, 7, SGG)
    hl(15, 33, 8, SGG)
    hl(15, 33, 9, SGG)
    hl(15, 33, 10, SGG)
    -- Left side highlight
    p(16, 7, PB); p(17, 7, PB); p(18, 7, PB)
    p(15, 8, PB); p(16, 8, PB); p(17, 8, PB)
    p(15, 9, PB)
    -- Center mid
    -- already SGG
    -- Right side shadow
    p(31, 7, DU); p(32, 7, DU)
    p(32, 8, DU); p(33, 8, DU)
    p(33, 9, DU); p(33, 10, DU)
    -- Bronze brim
    hl(15, 33, 11, AB)
    p(15, 11, PB); p(16, 11, PB)  -- brim highlight left
    p(32, 11, DU); p(33, 11, DU)  -- brim shadow right
    -- Specular on helmet
    p(17, 8, PW)

    -- Helmet outline
    hl(17, 31, 5, O)
    p(16, 6, O); p(32, 6, O)
    p(15, 7, O); p(33, 7, O)
    p(14, 8, O); p(34, 8, O)
    p(14, 9, O); p(34, 9, O)
    p(14, 10, O); p(34, 10, O)
    p(14, 11, O); p(34, 11, O)

    -- ===== FACE (10px wide, contemptuous expression) =====
    -- Face rows 12-18
    hl(17, 31, 12, DSN)
    hl(16, 32, 13, DSN)
    hl(16, 32, 14, DSN)
    hl(17, 31, 15, DSN)
    hl(17, 31, 16, DSN)
    hl(18, 30, 17, DSN)
    hl(18, 30, 18, DSN)

    -- Skin highlight (upper-left light, left cheekbone)
    p(17, 12, WTN); p(18, 12, WTN); p(19, 12, WTN)
    p(16, 13, WTN); p(17, 13, WTN)
    p(16, 14, WTN)

    -- Skin shadow (right side)
    p(30, 12, TRC); p(31, 12, TRC)
    p(31, 13, TRC); p(32, 13, TRC)
    p(31, 14, TRC); p(32, 14, TRC)
    p(30, 15, TRC); p(31, 15, TRC)
    p(30, 16, TRC)

    -- Heavy brow ridge (DU or TRC protruding)
    hl(19, 22, 13, DU)  -- left brow
    hl(26, 29, 13, DU)  -- right brow
    -- Slightly raised right eyebrow (1px higher)
    p(26, 12, TRC)

    -- Eyes (small, mean: DUM iris, STW tiny white)
    p(20, 14, STW); p(21, 14, DU)  -- left eye
    p(27, 14, DU); p(28, 14, STW)  -- right eye

    -- Nose
    p(24, 15, TRC); p(24, 16, TRC)

    -- Contemptuous mouth (downturned corners)
    p(22, 17, DU); p(23, 17, DU); p(24, 17, DU); p(25, 17, DU); p(26, 17, DU)
    p(21, 18, DU)  -- left corner down
    p(27, 18, DU)  -- right corner down

    -- Beard shadow
    hl(20, 28, 18, TRC)

    -- Face outline
    p(16, 12, O); p(32, 12, O)
    p(15, 13, O); p(33, 13, O)
    p(15, 14, O); p(33, 14, O)
    p(16, 15, O); p(32, 15, O)
    p(16, 16, O); p(32, 16, O)
    p(17, 17, O); p(31, 17, O)
    p(17, 18, O); p(31, 18, O)
    p(18, 19, O); p(30, 19, O)

    -- ===== NECK =====
    hl(20, 28, 19, DSN)
    hl(21, 27, 20, TRC) -- neck in shadow from head

    -- ===== SHOULDER PAULDRONS (flare to ~40px wide) =====
    -- Left pauldron
    hl(6, 20, 21+pauldronL, AB)
    hl(5, 20, 22+pauldronL, PB)
    hl(6, 20, 23+pauldronL, AB)
    -- Left pauldron highlight
    p(6, 22+pauldronL, PB); p(7, 22+pauldronL, PB)
    p(5, 22+pauldronL, PW) -- specular on left edge
    -- Left pauldron shadow
    p(19, 21+pauldronL, DU); p(20, 21+pauldronL, DU)
    -- Left pauldron outline
    p(5, 21+pauldronL, O); p(4, 22+pauldronL, O); p(5, 23+pauldronL, O)
    for sx=6,20 do p(sx, 20+pauldronL, O) end

    -- Right pauldron
    hl(28, 42, 21+pauldronR, AB)
    hl(28, 43, 22+pauldronR, AB)
    hl(28, 42, 23+pauldronR, AB)
    -- Right pauldron shadow (right side = shadow)
    p(41, 22+pauldronR, DU); p(42, 22+pauldronR, DU); p(43, 22+pauldronR, DU)
    p(42, 21+pauldronR, DU)
    -- Right pauldron outline
    p(43, 21+pauldronR, O); p(44, 22+pauldronR, O); p(43, 23+pauldronR, O)
    for sx=28,42 do p(sx, 20+pauldronR, O) end

    -- ===== BRONZE SCALE ARMOR (breastplate rows 24-38) =====
    -- The most complex pixel pattern in the game: fish-scale tile
    drawScaleArmor(p, 14, 34, 24, 38)

    -- Specular on leftmost scales (upper-left light)
    p(14, 24, PW); p(14, 28, PW); p(14, 32, PW)

    -- Armor shadow on right side and bottom
    for row=32,38 do
        p(33, row, DU); p(34, row, DU)
    end

    -- Deep armor shadow
    for row=35,38 do p(34, row, NGT) end

    -- Armor outline
    for row=24,38 do
        p(13, row, O); p(35, row, O)
    end

    -- ===== BELT =====
    hl(14, 34, 39, WL)
    hl(14, 34, 40, DU)
    p(13, 39, O); p(35, 39, O)
    p(13, 40, O); p(35, 40, O)
    -- Belt buckle (bronze)
    p(23, 39, PB); p(24, 39, PB); p(25, 39, PB)
    p(24, 40, PB)

    -- ===== BATTLE SKIRT =====
    hl(14, 34, 41, FW)
    hl(14, 34, 42, FW)
    hl(15, 33, 43, FW)
    hl(15, 33, 44, FW)
    hl(16, 32, 45, FW)
    -- Skirt folds (dark)
    p(18, 41, WL); p(24, 42, WL); p(30, 41, WL)
    p(20, 43, WL); p(28, 44, WL)
    -- Skirt lit left edge
    p(14, 41, BLN); p(14, 42, BLN)
    -- Skirt shadow right edge
    p(34, 41, DU); p(34, 42, DU)
    -- Skirt outline
    p(13, 41, O); p(35, 41, O)
    p(13, 42, O); p(35, 42, O)
    p(14, 43, O); p(34, 43, O)
    p(14, 44, O); p(34, 44, O)
    p(15, 45, O); p(33, 45, O)

    -- ===== ARMS (enormous, wider than David's torso) =====
    -- Left arm
    vl(11, 24, 36, DSN)
    vl(12, 24, 36, DSN)
    vl(13, 24, 36, DSN)
    -- Left arm highlight
    vl(11, 24, 30, WTN)
    -- Left arm shadow
    vl(13, 30, 36, TRC)
    -- Left fist
    p(11, 37, DSN); p(12, 37, DSN); p(13, 37, DSN)
    p(11, 38, TRC); p(12, 38, TRC); p(13, 38, TRC)
    -- Left arm outline
    vl(10, 24, 38, O)
    vl(14, 24, 38, O)

    -- Right arm (holding spear)
    vl(35, 24, 36, DSN)
    vl(36, 24, 36, DSN)
    vl(37, 24, 36, DSN)
    -- Right arm shadow
    vl(37, 28, 36, TRC)
    -- Right fist gripping spear
    p(36, 37, DSN); p(37, 37, DSN); p(38, 37, DSN)
    p(36, 38, TRC); p(37, 38, TRC); p(38, 38, TRC)
    -- Right arm outline
    vl(34, 24, 38, O)
    vl(39, 24, 38, O)

    -- ===== LEGS (wide pillars, DSN thighs + AB greaves) =====
    -- Left leg thigh
    hl(17, 22, 46+leftFootOff, DSN)
    hl(17, 22, 47+leftFootOff, DSN)
    p(17, 46+leftFootOff, WTN) -- highlight
    p(22, 47+leftFootOff, TRC) -- shadow

    -- Left greave (bronze, rows 48-55)
    for row=48,55 do
        hl(16, 23, row+leftFootOff, AB)
    end
    -- Greave highlight left edge
    for row=48,54 do p(16, row+leftFootOff, PB) end
    -- Greave shadow right
    for row=49,55 do p(23, row+leftFootOff, DU) end
    -- Greave specular
    p(17, 49+leftFootOff, PW)
    -- Greave outline
    for row=48,55 do
        p(15, row+leftFootOff, O); p(24, row+leftFootOff, O)
    end

    -- Right leg thigh
    hl(26, 31, 46+rightFootOff, DSN)
    hl(26, 31, 47+rightFootOff, DSN)
    p(31, 46+rightFootOff, TRC); p(31, 47+rightFootOff, TRC) -- shadow

    -- Right greave
    for row=48,55 do
        hl(25, 32, row+rightFootOff, AB)
    end
    -- Right greave shadow
    for row=49,55 do p(32, row+rightFootOff, DU) end
    -- Right greave outline
    for row=48,55 do
        p(24, row+rightFootOff, O); p(33, row+rightFootOff, O)
    end

    -- ===== FEET (planted firmly) =====
    -- Left foot
    hl(14, 24, 56+leftFootOff, DU)
    hl(13, 24, 57+leftFootOff, WL)
    p(13, 56+leftFootOff, O); p(25, 56+leftFootOff, O)
    p(12, 57+leftFootOff, O); p(25, 57+leftFootOff, O)

    -- Right foot
    hl(24, 34, 56+rightFootOff, DU)
    hl(24, 35, 57+rightFootOff, WL)
    p(23, 56+rightFootOff, O); p(35, 56+rightFootOff, O)
    p(23, 57+rightFootOff, O); p(36, 57+rightFootOff, O)

    -- Leg outline at thigh
    p(16, 46+leftFootOff, O); p(23, 46+leftFootOff, O)
    p(16, 47+leftFootOff, O); p(23, 47+leftFootOff, O)
    p(25, 46+rightFootOff, O); p(32, 46+rightFootOff, O)
    p(25, 47+rightFootOff, O); p(32, 47+rightFootOff, O)
end

-- IDLE ANIMATION: Menacing weight shift (lateral, not vertical)
-- Frame 1: Neutral stance
drawGoliath(spr.cels[1].image, 0, 0, 0, 0, 0)

-- Frame 2: Weight shifts RIGHT — right foot planted, left raised 3px
-- Right pauldron drops 1px, left rises 1px (torso rotation)
local img2 = newFrame(spr)
drawGoliath(img2, 1, 3, 0, -1, 1)

-- Frame 3: Return to neutral
local img3 = newFrame(spr)
drawGoliath(img3, 0, 0, 0, 0, 0)

-- Frame 4: Weight shifts LEFT — left foot planted, right raised 3px
-- Left pauldron drops, right rises
local img4 = newFrame(spr)
drawGoliath(img4, -1, 0, 3, 1, -1)

-- 6 FPS = ~167ms per frame
for i=1,#spr.frames do spr.frames[i].duration = 0.167 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\characters\\"
spr:saveAs(outDir .. "char_goliath_idle.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "char_goliath_idle.png",
    splitLayers=false,
    openGenerated=false,
}
