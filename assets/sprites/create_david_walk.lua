-- David walk cycle - 4 frames at 8 FPS
-- Contact / Down / Passing / Up
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "char_david_walk.aseprite"

local O = DAVID.OUTLINE
local S = DAVID.SKIN
local SD = DAVID.SKIN_DARK
local SH = DAVID.SKIN_HI
local H = DAVID.HAIR
local HD = DAVID.HAIR_DARK
local R = DAVID.ROBE
local RD = DAVID.ROBE_DARK
local RH = DAVID.ROBE_HI
local B = DAVID.BELT
local SN = DAVID.SANDAL
local SL = DAVID.SLING
local E = DAVID.EYE
local EW = DAVID.EYE_WHITE
local ST = DAVID.STAFF
local STD = DAVID.STAFF_DK

local function drawWalkFrame(img, bodyY, leftLegOff, rightLegOff, leftArmOff, rightArmOff)
    clear(img)
    local oy = bodyY or 0
    local la = leftArmOff or 0
    local ra = rightArmOff or 0
    local ll = leftLegOff or 0
    local rl = rightLegOff or 0

    local function p(x, y, c) px(img, x, y+oy, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Staff
    p(7, 3, ST); p(8, 2, ST); p(9, 2, ST); p(10, 3, STD)
    for y=3,27 do p(7, y, ST) end
    p(7, 28, STD)

    -- Hair
    hl(13, 19, 5, H); hl(12, 20, 6, H)
    p(12, 7, H); p(13, 7, H); p(19, 7, H); p(20, 7, H)
    p(12, 8, H); p(20, 8, H)
    p(13, 5, HD); p(19, 5, HD); p(12, 6, HD); p(20, 6, HD)

    -- Face
    hl(14, 18, 7, S)
    hl(13, 19, 8, S); hl(13, 19, 9, S); hl(13, 19, 10, S)
    hl(14, 18, 11, S)
    p(14, 8, SH); p(15, 8, SH)
    p(14, 9, E); p(15, 9, EW); p(17, 9, EW); p(18, 9, E)
    p(16, 10, SD); p(15, 11, SD); p(17, 11, SD)

    -- Head outline
    hl(13, 19, 4, O)
    p(12, 5, O); p(20, 5, O)
    p(11, 6, O); p(21, 6, O); p(11, 7, O); p(21, 7, O)
    p(11, 8, O); p(21, 8, O); p(11, 9, O); p(21, 9, O)
    p(11, 10, O); p(21, 10, O)
    p(12, 11, O); p(20, 11, O); p(13, 12, O); p(19, 12, O)

    -- Neck
    p(15, 12, S); p(16, 12, S); p(17, 12, S)

    -- Tunic
    hl(12, 20, 13, R)
    hl(11, 21, 14, R); hl(11, 21, 15, R); hl(11, 21, 16, R); hl(11, 21, 17, R)
    p(11, 14, RD); p(11, 15, RD); p(11, 16, RD); p(11, 17, RD)
    p(21, 14, RH); p(21, 15, RH); p(21, 16, RH)
    p(15, 13, RD); p(16, 13, RD); p(17, 13, RD)

    -- Belt
    hl(12, 20, 18, B)

    -- Tunic skirt
    hl(12, 20, 19, R); hl(12, 20, 20, RH)
    hl(13, 19, 21, R); hl(13, 19, 22, RD)

    -- Arms with swing
    p(10, 14+la, S); p(9, 15+la, S); p(9, 16+la, S); p(9, 17+la, SD)
    p(22, 14+ra, S); p(23, 15+ra, S); p(23, 16+ra, S); p(23, 17+ra, SD)

    -- Sling
    p(20, 18, SL); p(21, 19, SL); p(22, 19, SL); p(22, 20, SL)

    -- Legs
    p(14, 23+ll, S); p(14, 24+ll, S); p(13, 23+ll, S); p(13, 24+ll, S)
    p(18, 23+rl, S); p(18, 24+rl, S); p(19, 23+rl, S); p(19, 24+rl, S)
    -- Sandals
    hl(12, 15, 25+ll, SN); p(12, 26+ll, SN); p(13, 26+ll, SN)
    hl(17, 20, 25+rl, SN); p(19, 26+rl, SN); p(20, 26+rl, SN)

    -- Body outline
    p(10, 13, O); p(10, 14, O); p(10, 15, O); p(10, 16, O); p(10, 17, O)
    p(22, 13, O); p(22, 14, O); p(22, 15, O); p(22, 16, O); p(22, 17, O)
end

-- Frame 1: Contact
drawWalkFrame(spr.cels[1].image, 0, -1, 1, 1, -1)

-- Frame 2: Down
local img2 = newFrame(spr)
drawWalkFrame(img2, 1, 0, 1, 0, -1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawWalkFrame(img3, 0, 0, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawWalkFrame(img4, -1, 1, -1, -1, 1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\characters\\"
spr:saveAs(outDir .. "char_david_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "char_david_walk.png",
    splitLayers=false,
    openGenerated=false,
}
