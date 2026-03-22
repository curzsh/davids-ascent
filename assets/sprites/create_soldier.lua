-- Philistine Soldier walk cycle - 4 frames at 8 FPS
-- Heavy armor, full bronze breastplate, helmet with feathered crest, shield + long spear
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_soldier_walk.aseprite"

local O  = PALETTE.VOID_BLACK      -- outlines
local SK = PALETTE.TERRACOTTA      -- skin
local SD = PALETTE.DARK_UMBER      -- skin dark
local SH = PALETTE.DESERT_SIENNA   -- skin highlight
local AB = PALETTE.AGED_BRASS      -- shield / armor accent
local PB = PALETTE.POLISHED_BRONZE -- main armor
local BS = PALETTE.BLOOD_SHADOW    -- dark cloth under armor
local SB = PALETTE.STAFF_BROWN     -- spear shaft
local WL = PALETTE.WORN_LEATHER    -- leather
local SG = PALETTE.SLATE_GREY      -- metal details
local EY = PALETTE.HARVEST_YELLOW  -- eye
local PW = PALETTE.PARCHMENT       -- feather highlight
local ST = PALETTE.STRAW_GOLD      -- gold trim

local function drawSoldier(img, bodyY, leftFoot, rightFoot, spearOff)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0
    spearOff = spearOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Long spear (right side)
    for y=1,12 do p(23, y+spearOff, SB) end
    -- Spear tip
    p(23, 0+spearOff, PB); p(22, 0+spearOff, O); p(24, 0+spearOff, O)
    p(23, -1+spearOff, PB)

    -- Feathered crest (3 pixels tall, imposing)
    p(14, 2, PW); p(15, 2, PW); p(16, 2, AB); p(17, 2, PW); p(18, 2, PW)
    hl(14, 18, 3, PB)
    hl(13, 19, 4, AB)

    -- Helmet (full coverage)
    hl(12, 20, 5, PB)
    p(12, 6, PB); p(13, 6, PB); p(19, 6, PB); p(20, 6, PB)
    p(12, 7, PB); p(20, 7, PB)
    -- Cheek guards
    p(12, 8, AB); p(20, 8, AB)

    -- Face (narrower due to helmet)
    hl(14, 18, 6, SK)
    hl(13, 19, 7, SK)
    hl(14, 18, 8, SK)
    hl(14, 18, 9, SK)
    -- Skin shading
    p(14, 6, SH); p(15, 6, SH)

    -- Eyes
    p(14, 7, EY); p(15, 7, SD)
    p(17, 7, SD); p(18, 7, EY)

    -- Nose + mouth
    p(16, 8, SD)
    p(15, 9, SD); p(17, 9, SD)

    -- Head outline
    hl(13, 19, 1, O)
    p(12, 2, O); p(20, 2, O)
    p(11, 3, O); p(21, 3, O)
    p(11, 4, O); p(21, 4, O)
    p(11, 5, O); p(21, 5, O)
    p(11, 6, O); p(21, 6, O)
    p(11, 7, O); p(21, 7, O)
    p(11, 8, O); p(21, 8, O)
    p(12, 9, O); p(20, 9, O)
    p(13, 10, O); p(19, 10, O)

    -- Neck (armored gorget)
    p(15, 10, AB); p(16, 10, AB); p(17, 10, AB)

    -- Full bronze breastplate
    hl(12, 20, 11, PB)
    hl(11, 21, 12, PB)
    hl(11, 21, 13, PB)
    hl(11, 21, 14, PB)
    hl(11, 21, 15, PB)
    -- Armor detail lines
    hl(13, 19, 11, ST) -- gold neckline trim
    p(16, 12, AB); p(16, 13, AB); p(16, 14, AB) -- center line
    p(11, 12, AB); p(11, 13, AB); p(11, 14, AB); p(11, 15, AB) -- left shadow
    p(21, 12, ST); p(21, 13, ST); p(21, 14, ST) -- right highlight

    -- War skirt (pteruges)
    hl(12, 20, 16, BS)
    hl(12, 20, 17, WL)
    hl(13, 19, 18, BS)
    hl(13, 19, 19, WL)
    hl(14, 18, 20, BS)

    -- Shield (left arm) — round shield
    p(7, 12, O); p(8, 11, O); p(9, 11, O); p(10, 11, O)
    p(7, 13, AB); p(8, 12, AB); p(9, 12, SG); p(10, 12, SG)
    p(7, 14, AB); p(8, 13, SG); p(9, 13, AB); p(10, 13, SG) -- boss
    p(7, 15, AB); p(8, 14, SG); p(9, 14, SG); p(10, 14, SG)
    p(7, 16, O); p(8, 15, O); p(9, 15, O); p(10, 15, O)
    p(6, 12, O); p(6, 13, O); p(6, 14, O); p(6, 15, O)

    -- Right arm (holding spear)
    p(22, 12, SK); p(23, 13, SK); p(23, 14, SK); p(23, 15, SD)

    -- Body outline
    p(10, 11, O); p(10, 12, O); p(10, 13, O); p(10, 14, O); p(10, 15, O)
    p(10, 16, O); p(10, 17, O)
    p(22, 11, O); p(22, 12, O)
    p(24, 13, O); p(24, 14, O); p(24, 15, O)
    p(11, 16, O); p(21, 16, O)

    -- Legs (armored greaves)
    -- Left leg
    p(14, 21+leftFoot, AB); p(14, 22+leftFoot, AB)
    p(13, 21+leftFoot, PB); p(13, 22+leftFoot, PB)
    -- Right leg
    p(18, 21+rightFoot, PB); p(18, 22+rightFoot, PB)
    p(19, 21+rightFoot, AB); p(19, 22+rightFoot, AB)

    -- Sandals (heavier)
    hl(12, 15, 23+leftFoot, WL)
    hl(12, 15, 24+leftFoot, WL)
    hl(17, 20, 23+rightFoot, WL)
    hl(17, 20, 24+rightFoot, WL)
end

-- Frame 1: Contact
drawSoldier(spr.cels[1].image, 0, -1, 1, 0)

-- Frame 2: Down
local img2 = newFrame(spr)
drawSoldier(img2, 1, 0, 1, -1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawSoldier(img3, 0, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawSoldier(img4, -1, 1, -1, 1)

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
