-- Lion enemy walk cycle - 4 frames at 8 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_lion_walk.aseprite"

local O  = PALETTE.VOID_BLACK
local FD = PALETTE.DARK_UMBER
local FM = PALETTE.DESERT_SIENNA
local F  = PALETTE.SANDY_BROWN
local FH = PALETTE.WARM_TAN
local M  = PALETTE.TERRACOTTA
local MH = PALETTE.ROUGH_FLAX
local ML = PALETTE.STRAW_GOLD
local EY = PALETTE.HARVEST_YELLOW
local N  = PALETTE.DARK_UMBER

local function drawLion(img, bodyY, leftPawOff, rightPawOff, tailOff)
    clear(img)
    bodyY = bodyY or 0
    leftPawOff = leftPawOff or 0
    rightPawOff = rightPawOff or 0
    tailOff = tailOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Tail
    p(6, 12+tailOff, FM); p(5, 11+tailOff, FM); p(4, 10+tailOff, F)
    p(3, 10+tailOff, FH); p(3, 9+tailOff, FD)

    -- Mane
    hl(11, 21, 3, M)
    hl(10, 22, 4, M)
    p(9, 5, M); p(10, 5, MH); p(22, 5, MH); p(23, 5, M)
    p(9, 6, M); p(10, 6, MH); p(22, 6, MH); p(23, 6, M)
    p(9, 7, M); p(10, 7, MH); p(22, 7, MH); p(23, 7, M)
    p(9, 8, M); p(10, 8, M); p(22, 8, M); p(23, 8, M)
    hl(10, 22, 9, M)
    hl(11, 21, 10, MH)

    -- Head
    hl(13, 19, 4, F)
    hl(12, 20, 5, F); hl(12, 20, 6, F); hl(12, 20, 7, F)
    hl(13, 19, 8, F)
    p(15, 5, FH); p(16, 5, FH); p(17, 5, FH)

    -- Eyes
    p(14, 6, EY); p(13, 6, FD)
    p(18, 6, EY); p(19, 6, FD)

    -- Nose
    p(16, 7, N); p(15, 8, FD); p(17, 8, FD)

    -- Head outline
    hl(12, 20, 3, O)
    p(11, 4, O); p(21, 4, O)
    p(8, 5, O); p(24, 5, O)
    p(8, 6, O); p(24, 6, O)
    p(8, 7, O); p(24, 7, O)
    p(8, 8, O); p(24, 8, O)
    p(9, 9, O); p(23, 9, O)

    -- Body
    hl(10, 22, 11, F)
    hl(9, 23, 12, F); hl(9, 23, 13, F); hl(9, 23, 14, F); hl(9, 23, 15, F)
    hl(10, 22, 16, F)
    hl(11, 21, 17, FM)
    p(9, 12, FM); p(9, 13, FM); p(9, 14, FM); p(9, 15, FM)
    p(23, 12, FH); p(23, 13, FH); p(23, 14, FH)
    hl(14, 18, 15, FH)

    -- Body outline
    p(8, 11, O); p(24, 11, O)
    p(8, 12, O); p(24, 12, O); p(8, 13, O); p(24, 13, O)
    p(8, 14, O); p(24, 14, O); p(8, 15, O); p(24, 15, O)
    p(9, 16, O); p(23, 16, O)
    p(10, 17, O); p(22, 17, O)

    -- Front legs
    p(12, 18+leftPawOff, FM); p(13, 18+leftPawOff, F)
    p(12, 19+leftPawOff, FM); p(13, 19+leftPawOff, F)
    p(12, 20+leftPawOff, FM); p(13, 20+leftPawOff, F)
    p(12, 21+leftPawOff, FD); p(13, 21+leftPawOff, FD)

    p(19, 18+rightPawOff, F); p(20, 18+rightPawOff, FH)
    p(19, 19+rightPawOff, F); p(20, 19+rightPawOff, FH)
    p(19, 20+rightPawOff, F); p(20, 20+rightPawOff, FH)
    p(19, 21+rightPawOff, FD); p(20, 21+rightPawOff, FD)

    -- Back legs
    p(10, 17, FM); p(11, 17, F)
    p(10, 18, FM); p(11, 18, F)
    p(10, 19, FM); p(11, 19, F)
    p(10, 20, FD); p(11, 20, FD)

    p(21, 17, F); p(22, 17, FH)
    p(21, 18, F); p(22, 18, FH)
    p(21, 19, F); p(22, 19, FH)
    p(21, 20, FD); p(22, 20, FD)
end

-- Frame 1: Contact
drawLion(spr.cels[1].image, 0, -1, 1, 0)

-- Frame 2: Down
local img2 = newFrame(spr)
drawLion(img2, 1, 0, 1, -1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawLion(img3, 0, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawLion(img4, -1, 1, -1, 1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env1_lion\\"
spr:saveAs(outDir .. "enemy_lion_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_lion_walk.png",
    splitLayers=false,
    openGenerated=false,
}
