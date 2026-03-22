-- Philistine Shieldbearer walk cycle - 4 frames at 8 FPS
-- Most armored regular enemy, large rectangular shield covers front, slow planted walk
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_shieldbearer_walk.aseprite"

local O  = PALETTE.VOID_BLACK      -- outlines
local SK = PALETTE.TERRACOTTA      -- skin
local SD = PALETTE.DARK_UMBER      -- skin dark
local SH = PALETTE.DESERT_SIENNA   -- skin highlight
local AB = PALETTE.AGED_BRASS      -- shield trim, armor accent
local PB = PALETTE.POLISHED_BRONZE -- heavy armor
local SG = PALETTE.SLATE_GREY      -- shield face
local BS = PALETTE.BLOOD_SHADOW    -- dark cloth
local WL = PALETTE.WORN_LEATHER    -- leather
local EY = PALETTE.HARVEST_YELLOW  -- eye
local PW = PALETTE.PARCHMENT       -- feather highlight
local ST = PALETTE.STRAW_GOLD      -- gold trim
local SW = PALETTE.STONE_WHITE     -- shield highlight

local function drawShieldbearer(img, bodyY, leftFoot, rightFoot)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Feathered crest (2 pixels, compact)
    p(16, 3, PW); p(17, 3, AB); p(18, 3, PW)
    hl(15, 19, 4, AB)

    -- Helmet (full bronze, visible behind shield)
    hl(14, 20, 5, PB)
    p(14, 6, PB); p(15, 6, PB); p(20, 6, PB)
    p(14, 7, PB); p(20, 7, PB)

    -- Face (partially visible right of shield)
    hl(16, 19, 6, SK)
    hl(15, 19, 7, SK)
    hl(16, 19, 8, SK)
    hl(16, 19, 9, SK)
    -- Skin shading
    p(16, 6, SH)

    -- Eyes (only right eye fully visible)
    p(17, 7, SD); p(18, 7, EY)

    -- Nose + mouth
    p(17, 8, SD)
    p(17, 9, SD)

    -- Head outline
    hl(15, 19, 2, O)
    p(14, 3, O); p(20, 3, O)
    p(13, 4, O); p(21, 4, O)
    p(13, 5, O); p(21, 5, O)
    p(13, 6, O); p(21, 6, O)
    p(13, 7, O); p(21, 7, O)
    p(13, 8, O); p(21, 8, O)
    p(14, 9, O); p(21, 9, O)
    p(14, 10, O); p(20, 10, O)

    -- Neck (armored)
    p(16, 10, AB); p(17, 10, AB); p(18, 10, AB); p(19, 10, AB)

    -- Heavy bronze armor (body behind shield)
    hl(14, 21, 11, PB)
    hl(14, 21, 12, PB)
    hl(14, 21, 13, PB)
    hl(14, 21, 14, PB)
    hl(14, 21, 15, PB)
    -- Armor detail
    p(14, 11, AB); p(14, 12, AB); p(14, 13, AB); p(14, 14, AB); p(14, 15, AB)
    p(21, 11, ST); p(21, 12, ST); p(21, 13, ST)

    -- War skirt
    hl(14, 20, 16, BS)
    hl(14, 20, 17, WL)
    hl(15, 19, 18, BS)
    hl(15, 19, 19, WL)

    -- Right arm (behind body, resting)
    p(22, 12, SK); p(22, 13, SK); p(22, 14, SD)

    -- Body outline (right side)
    p(22, 11, O); p(22, 12, O)
    p(23, 13, O); p(23, 14, O)
    p(22, 15, O); p(22, 16, O)
    p(13, 11, O); p(13, 12, O); p(13, 13, O); p(13, 14, O); p(13, 15, O)
    p(13, 16, O); p(13, 17, O)
    p(21, 16, O); p(21, 17, O)

    -- LARGE RECTANGULAR SHIELD (the defining feature)
    -- Shield covers most of front, from rows 6 to 20, columns 5-14
    -- Shield outline
    hl(5, 13, 5, O)    -- top edge
    hl(5, 13, 21, O)   -- bottom edge
    for y=5,21 do p(4, y, O) end   -- left edge
    for y=5,21 do p(14, y, O) end  -- right edge (overlaps body outline)

    -- Shield face (slate grey)
    for y=6,20 do hl(5, 13, y, SG) end

    -- Shield brass trim (horizontal bands)
    hl(5, 13, 7, AB)
    hl(5, 13, 13, AB)
    hl(5, 13, 19, AB)

    -- Shield boss (center)
    p(8, 12, AB); p(9, 12, AB); p(10, 12, AB)
    p(8, 13, AB); p(9, 13, ST); p(10, 13, AB)
    p(8, 14, AB); p(9, 14, AB); p(10, 14, AB)

    -- Shield highlight (upper left, light source)
    p(5, 6, SW); p(6, 6, SW)
    p(5, 8, SW); p(6, 8, SW)

    -- Left arm (holding shield, visible at edges)
    p(13, 11, SK); p(13, 12, SK)

    -- Legs (heavy, planted walk)
    -- Left leg
    p(15, 20+leftFoot, PB); p(15, 21+leftFoot, PB)
    p(16, 20+leftFoot, AB); p(16, 21+leftFoot, AB)
    -- Right leg
    p(18, 20+rightFoot, AB); p(18, 21+rightFoot, AB)
    p(19, 20+rightFoot, PB); p(19, 21+rightFoot, PB)

    -- Heavy boots
    hl(14, 17, 22+leftFoot, WL)
    hl(14, 17, 23+leftFoot, WL)
    hl(17, 20, 22+rightFoot, WL)
    hl(17, 20, 23+rightFoot, WL)
end

-- Frame 1: Contact (very subtle movement — slow, planted)
drawShieldbearer(spr.cels[1].image, 0, 0, 1)

-- Frame 2: Down
local img2 = newFrame(spr)
drawShieldbearer(img2, 1, 0, 0)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawShieldbearer(img3, 0, 1, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawShieldbearer(img4, 0, 0, 0)

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
