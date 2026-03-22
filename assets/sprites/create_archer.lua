-- Philistine Archer walk cycle - 4 frames at 8 FPS
-- Light armor, feathered headdress, holding bow
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_archer_walk.aseprite"

local O  = PALETTE.VOID_BLACK      -- outlines
local SK = PALETTE.TERRACOTTA      -- skin
local SD = PALETTE.DARK_UMBER      -- skin dark
local SH = PALETTE.DESERT_SIENNA   -- skin highlight
local AB = PALETTE.AGED_BRASS      -- minimal armor
local PB = PALETTE.POLISHED_BRONZE -- accent
local RF = PALETTE.ROUGH_FLAX      -- tunic
local FL = PALETTE.FLAX_WEAVE      -- tunic highlight
local BW = PALETTE.STAFF_BROWN     -- bow wood
local WL = PALETTE.WORN_LEATHER    -- leather
local EY = PALETTE.HARVEST_YELLOW  -- eye
local PW = PALETTE.PARCHMENT       -- feather highlight
local SN = PALETTE.SANDY_BROWN     -- string/light detail

local function drawArcher(img, bodyY, leftFoot, rightFoot, bowOff)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0
    bowOff = bowOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Bow (left side)
    -- Bow limb upper
    p(7, 8+bowOff, BW); p(7, 9+bowOff, BW); p(7, 10+bowOff, BW)
    p(8, 7+bowOff, BW)
    -- Bow limb lower
    p(7, 16+bowOff, BW); p(7, 17+bowOff, BW); p(7, 18+bowOff, BW)
    p(8, 19+bowOff, BW)
    -- Bow grip
    p(7, 11+bowOff, WL); p(7, 12+bowOff, WL); p(7, 13+bowOff, WL)
    p(7, 14+bowOff, WL); p(7, 15+bowOff, WL)
    -- Bowstring
    p(9, 8+bowOff, SN); p(9, 9+bowOff, SN); p(9, 10+bowOff, SN)
    p(9, 11+bowOff, SN); p(9, 12+bowOff, SN); p(9, 13+bowOff, SN)
    p(9, 14+bowOff, SN); p(9, 15+bowOff, SN); p(9, 16+bowOff, SN)
    p(9, 17+bowOff, SN); p(9, 18+bowOff, SN)

    -- Feathered headdress (2 pixels tall)
    p(15, 4, PW); p(16, 4, AB); p(17, 4, PW)
    hl(14, 18, 5, AB)

    -- Helmet base
    hl(13, 19, 6, AB)
    p(13, 7, AB); p(19, 7, AB)

    -- Head / face
    hl(14, 18, 7, SK)
    hl(13, 19, 8, SK)
    hl(14, 18, 9, SK)
    hl(14, 18, 10, SK)
    -- Skin shading
    p(14, 7, SH); p(15, 7, SH)
    p(14, 8, SH)

    -- Eyes
    p(14, 8, EY); p(15, 8, SD)
    p(17, 8, SD); p(18, 8, EY)

    -- Nose + mouth
    p(16, 9, SD)
    p(15, 10, SD); p(17, 10, SD)

    -- Head outline
    hl(14, 18, 3, O)
    p(13, 4, O); p(19, 4, O)
    p(12, 5, O); p(20, 5, O)
    p(12, 6, O); p(20, 6, O)
    p(12, 7, O); p(20, 7, O)
    p(12, 8, O); p(20, 8, O)
    p(12, 9, O); p(20, 9, O)
    p(13, 10, O); p(19, 10, O)
    p(13, 11, O); p(19, 11, O)

    -- Neck
    p(15, 11, SK); p(16, 11, SK); p(17, 11, SK)

    -- Tunic body (lighter flax)
    hl(12, 20, 12, RF)
    hl(11, 21, 13, RF)
    hl(11, 21, 14, RF)
    hl(11, 21, 15, FL)
    hl(11, 21, 16, RF)
    -- Minimal armor (shoulder guards only)
    p(12, 12, AB); p(13, 12, AB); p(19, 12, AB); p(20, 12, AB)
    p(12, 13, AB); p(20, 13, AB)

    -- Belt with quiver strap
    hl(12, 20, 17, WL)
    p(20, 16, WL); p(20, 15, WL); p(20, 14, WL) -- strap diagonal

    -- Tunic skirt
    hl(12, 20, 18, RF)
    hl(13, 19, 19, FL)
    hl(13, 19, 20, RF)

    -- Left arm (holding bow out)
    p(10, 13, SK); p(9, 14, SK); p(8, 15, SK); p(8, 14, SD)

    -- Right arm (at side)
    p(21, 13, SK); p(22, 14, SK); p(22, 15, SK); p(22, 16, SD)

    -- Quiver on back (right side hint)
    p(21, 11, WL); p(22, 11, WL); p(22, 12, WL)
    p(22, 10, SN) -- arrow feathers visible

    -- Body outline
    p(10, 12, O); p(10, 13, O)
    p(9, 14, O); p(9, 15, O); p(9, 16, O)
    p(10, 16, O); p(10, 17, O)
    p(22, 12, O); p(23, 13, O); p(23, 14, O); p(23, 15, O); p(23, 16, O)
    p(11, 17, O); p(21, 17, O)

    -- Legs
    -- Left leg
    p(14, 21+leftFoot, SK); p(14, 22+leftFoot, SK)
    p(13, 21+leftFoot, SK); p(13, 22+leftFoot, SK)
    -- Right leg
    p(18, 21+rightFoot, SK); p(18, 22+rightFoot, SK)
    p(19, 21+rightFoot, SK); p(19, 22+rightFoot, SK)

    -- Sandals
    hl(12, 15, 23+leftFoot, WL)
    p(12, 24+leftFoot, WL); p(13, 24+leftFoot, WL)
    hl(17, 20, 23+rightFoot, WL)
    p(19, 24+rightFoot, WL); p(20, 24+rightFoot, WL)
end

-- Frame 1: Contact
drawArcher(spr.cels[1].image, 0, -1, 1, 0)

-- Frame 2: Down
local img2 = newFrame(spr)
drawArcher(img2, 1, 0, 1, -1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawArcher(img3, 0, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawArcher(img4, -1, 1, -1, 1)

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
