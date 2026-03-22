-- Philistine Scout walk cycle - 4 frames at 8 FPS
-- Light armor, crouched aggressive pose, feathered headdress, shield + spear
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_scout_walk.aseprite"

local O  = PALETTE.VOID_BLACK      -- outlines
local SK = PALETTE.TERRACOTTA      -- skin
local SD = PALETTE.DARK_UMBER      -- skin dark
local SH = PALETTE.DESERT_SIENNA   -- skin highlight
local AB = PALETTE.AGED_BRASS      -- bronze armor
local PB = PALETTE.POLISHED_BRONZE -- polished bronze
local BS = PALETTE.BLOOD_SHADOW    -- purple tunic
local RF = PALETTE.ROUGH_FLAX      -- tunic accent
local SB = PALETTE.STAFF_BROWN     -- spear shaft
local WL = PALETTE.WORN_LEATHER    -- leather details
local SG = PALETTE.SLATE_GREY      -- shield face
local EY = PALETTE.HARVEST_YELLOW  -- eye
local PW = PALETTE.PARCHMENT       -- feather highlight

local function drawScout(img, bodyY, leftFoot, rightFoot, spearOff)
    clear(img)
    bodyY = bodyY or 0
    leftFoot = leftFoot or 0
    rightFoot = rightFoot or 0
    spearOff = spearOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Spear (right hand, behind body slightly)
    p(22, 3+spearOff, SB); p(22, 4+spearOff, SB); p(22, 5+spearOff, SB)
    p(22, 6+spearOff, SB); p(22, 7+spearOff, SB); p(22, 8+spearOff, SB)
    p(22, 9+spearOff, SB); p(22, 10+spearOff, SB)
    -- Spear tip
    p(22, 2+spearOff, PB); p(22, 1+spearOff, PB)
    p(21, 2+spearOff, O); p(23, 2+spearOff, O)

    -- Feathered headdress (3 pixels tall)
    p(15, 3, PW); p(16, 3, AB); p(17, 3, PW)
    p(14, 4, AB); hl(15, 17, 4, PB); p(18, 4, AB)
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
    hl(14, 18, 2, O)
    p(13, 3, O); p(19, 3, O)
    p(12, 4, O); p(20, 4, O)
    p(12, 5, O); p(20, 5, O)
    p(12, 6, O); p(20, 6, O)
    p(12, 7, O); p(20, 7, O)
    p(12, 8, O); p(20, 8, O)
    p(12, 9, O); p(20, 9, O)
    p(13, 10, O); p(19, 10, O)
    p(13, 11, O); p(19, 11, O)

    -- Neck
    p(15, 11, SK); p(16, 11, SK); p(17, 11, SK)

    -- Tunic body (purple-tinted)
    hl(12, 20, 12, BS)
    hl(11, 21, 13, BS)
    hl(11, 21, 14, BS)
    hl(11, 21, 15, BS)
    hl(11, 21, 16, BS)
    -- Bronze chest armor (breastplate strips)
    hl(13, 19, 12, AB)
    hl(13, 19, 13, PB)
    hl(14, 18, 14, AB)

    -- Belt
    hl(12, 20, 17, WL)

    -- Tunic skirt
    hl(12, 20, 18, BS)
    hl(13, 19, 19, RF)
    hl(13, 19, 20, BS)

    -- Shield (left arm) — small round shield
    p(8, 13, O); p(9, 12, O); p(10, 12, O); p(11, 12, O)
    p(8, 14, SG); p(9, 13, SG); p(10, 13, SG)
    p(8, 15, SG); p(9, 14, SG); p(10, 14, SG)
    p(8, 16, O); p(9, 15, SG); p(10, 15, SG)
    p(9, 16, O); p(10, 16, O)
    -- Shield boss
    p(9, 14, AB)
    -- Shield outline top/bottom
    p(7, 13, O); p(7, 14, O); p(7, 15, O)

    -- Right arm (holding spear)
    p(21, 13, SK); p(22, 14, SK); p(22, 15, SK); p(22, 16, SD)

    -- Body outline
    p(10, 12, O); p(10, 13, O); p(10, 14, O); p(10, 15, O); p(10, 16, O)
    p(22, 12, O); p(22, 13, O)
    p(23, 14, O); p(23, 15, O); p(23, 16, O)
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
drawScout(spr.cels[1].image, 0, -1, 1, 0)

-- Frame 2: Down
local img2 = newFrame(spr)
drawScout(img2, 1, 0, 1, -1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawScout(img3, 0, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawScout(img4, -1, 1, -1, 1)

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
