-- Bear enemy walk cycle - 4 frames at 8 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_bear_walk.aseprite"

local O  = PALETTE.VOID_BLACK
local FD = PALETTE.DARK_UMBER       -- shadow
local FM = PALETTE.TERRACOTTA       -- mid fur
local F  = PALETTE.DESERT_SIENNA    -- highlight
local EY = PALETTE.HARVEST_YELLOW   -- eyes
local N  = PALETTE.DARK_UMBER       -- nose

local function drawBear(img, bodyY, leftPawOff, rightPawOff)
    clear(img)
    bodyY = bodyY or 0
    leftPawOff = leftPawOff or 0
    rightPawOff = rightPawOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Ears (small, rounded)
    p(12, 2, FM); p(13, 2, FM)
    p(19, 2, FM); p(20, 2, FM)
    -- Ear outline
    p(11, 2, O); p(14, 2, O); p(12, 1, O); p(13, 1, O)
    p(18, 2, O); p(21, 2, O); p(19, 1, O); p(20, 1, O)

    -- Head (wide, round)
    hl(12, 20, 3, FM)
    hl(11, 21, 4, FM); hl(11, 21, 5, FM)
    hl(11, 21, 6, FM); hl(11, 21, 7, FM)
    hl(12, 20, 8, FM)
    -- Highlight upper-left
    p(12, 3, F); p(13, 3, F); p(14, 3, F)
    p(12, 4, F); p(13, 4, F)

    -- Eyes
    p(14, 5, EY); p(18, 5, EY)
    p(13, 5, FD); p(19, 5, FD)

    -- Snout / nose area
    hl(14, 18, 7, F)
    p(16, 6, N); p(15, 7, FD); p(17, 7, FD)

    -- Head outline
    hl(12, 20, 2, O)
    p(10, 3, O); p(21, 3, O)
    p(10, 4, O); p(22, 4, O)
    p(10, 5, O); p(22, 5, O)
    p(10, 6, O); p(22, 6, O)
    p(10, 7, O); p(22, 7, O)
    p(11, 8, O); p(21, 8, O)

    -- Neck / massive shoulders
    hl(9, 23, 9, FM)
    hl(8, 24, 10, FM)

    -- Body (very bulky, fills canvas)
    hl(7, 25, 11, FM); hl(7, 25, 12, FM)
    hl(7, 25, 13, FM); hl(7, 25, 14, FM)
    hl(7, 25, 15, FM); hl(7, 25, 16, FM)
    hl(8, 24, 17, FM)
    hl(9, 23, 18, FM)

    -- Body shading: left side darker, right highlight
    for y=11,16 do
        p(7, y, FD); p(8, y, FD)
        p(24, y, F); p(25, y, F)
    end
    -- Belly highlight
    hl(13, 19, 15, F); hl(13, 19, 16, F)

    -- Hunched shoulder mass
    hl(9, 14, 9, F); hl(9, 14, 10, F)

    -- Body outline
    p(8, 9, O); p(24, 9, O)
    p(7, 10, O); p(25, 10, O)
    p(6, 11, O); p(26, 11, O)
    p(6, 12, O); p(26, 12, O)
    p(6, 13, O); p(26, 13, O)
    p(6, 14, O); p(26, 14, O)
    p(6, 15, O); p(26, 15, O)
    p(6, 16, O); p(26, 16, O)
    p(7, 17, O); p(25, 17, O)
    p(8, 18, O); p(24, 18, O)

    -- Front legs (thick, powerful)
    hl(11, 14, 19+leftPawOff, FD)
    hl(11, 14, 20+leftPawOff, FM)
    hl(11, 14, 21+leftPawOff, FM)
    hl(11, 14, 22+leftPawOff, FM)
    hl(11, 14, 23+leftPawOff, FD)
    -- Front left highlight
    p(13, 20+leftPawOff, F); p(14, 20+leftPawOff, F)

    hl(18, 21, 19+rightPawOff, FD)
    hl(18, 21, 20+rightPawOff, FM)
    hl(18, 21, 21+rightPawOff, FM)
    hl(18, 21, 22+rightPawOff, FM)
    hl(18, 21, 23+rightPawOff, FD)
    -- Front right highlight
    p(20, 20+rightPawOff, F); p(21, 20+rightPawOff, F)

    -- Back legs (slightly behind front legs)
    hl(8, 11, 18, FD)
    hl(8, 11, 19, FM)
    hl(8, 11, 20, FM)
    hl(8, 11, 21, FD)

    hl(21, 24, 18, FD)
    hl(21, 24, 19, FM)
    hl(21, 24, 20, FM)
    hl(21, 24, 21, FD)
end

-- Frame 1: Contact
drawBear(spr.cels[1].image, 0, -1, 1)

-- Frame 2: Down
local img2 = newFrame(spr)
drawBear(img2, 1, 0, 1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawBear(img3, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawBear(img4, -1, 1, -1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env2_bear\\"
os.execute('mkdir "' .. outDir:gsub("\\$","") .. '" 2>nul')
spr:saveAs(outDir .. "enemy_bear_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_bear_walk.png",
    splitLayers=false,
    openGenerated=false,
}
