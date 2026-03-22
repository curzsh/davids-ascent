-- Wolf enemy walk cycle - 4 frames at 8 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_wolf_walk.aseprite"

local O  = PALETTE.VOID_BLACK
local FD = PALETTE.DARK_UMBER      -- shadow
local F  = PALETTE.SLATE_GREY      -- base fur
local FH = PALETTE.STONE_WHITE     -- highlight
local FM = PALETTE.ROUGH_FLAX      -- mid-shadow accent
local EY = PALETTE.HARVEST_YELLOW  -- eyes
local N  = PALETTE.DARK_UMBER      -- nose

local function drawWolf(img, bodyY, leftPawOff, rightPawOff, tailOff)
    clear(img)
    bodyY = bodyY or 0
    leftPawOff = leftPawOff or 0
    rightPawOff = rightPawOff or 0
    tailOff = tailOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Tail (thin, curved up)
    p(5, 11+tailOff, F); p(4, 10+tailOff, F); p(3, 9+tailOff, FH)
    p(3, 8+tailOff, FD)

    -- Ears (pointy, taller than lion)
    p(14, 2, O); p(13, 3, O); p(14, 3, F); p(15, 3, O)
    p(19, 2, O); p(18, 3, O); p(19, 3, F); p(20, 3, O)

    -- Head (narrower, more angular than lion)
    hl(13, 20, 4, F)
    hl(12, 20, 5, F); hl(12, 20, 6, F)
    hl(12, 21, 7, F)
    hl(13, 22, 8, F)    -- elongated snout
    hl(14, 22, 9, F)
    -- Highlight upper-left
    p(13, 4, FH); p(14, 4, FH); p(13, 5, FH)

    -- Eyes
    p(14, 6, EY); p(19, 6, EY)
    p(15, 6, FD); p(18, 6, FD)

    -- Nose/snout
    p(21, 8, N); p(22, 8, O)
    p(21, 9, N); p(22, 9, O)

    -- Head outline
    hl(13, 20, 3, O)
    p(12, 4, O); p(21, 4, O)
    p(11, 5, O); p(21, 5, O)
    p(11, 6, O); p(21, 6, O)
    p(11, 7, O); p(22, 7, O)
    p(12, 8, O); p(23, 8, O)
    p(13, 9, O); p(23, 9, O)
    hl(14, 22, 10, O)

    -- Neck / shoulder transition
    hl(10, 20, 10, F)
    hl(9, 19, 11, F)

    -- Body (leaner than lion)
    hl(8, 20, 12, F); hl(8, 20, 13, F)
    hl(8, 19, 14, F); hl(9, 19, 15, F)
    hl(10, 18, 16, F)
    -- Shading
    p(8, 12, FD); p(8, 13, FD); p(8, 14, FD)
    p(20, 12, FH); p(20, 13, FH)
    hl(13, 17, 14, FH)  -- belly highlight

    -- Body outline
    p(9, 10, O); p(21, 10, O)
    p(7, 11, O); p(20, 11, O)
    p(7, 12, O); p(21, 12, O)
    p(7, 13, O); p(21, 13, O)
    p(7, 14, O); p(20, 14, O)
    p(8, 15, O); p(20, 15, O)
    p(9, 16, O); p(19, 16, O)

    -- Front legs (thinner than lion)
    p(12, 17+leftPawOff, FD); p(13, 17+leftPawOff, F)
    p(12, 18+leftPawOff, FD); p(13, 18+leftPawOff, F)
    p(12, 19+leftPawOff, FD); p(13, 19+leftPawOff, F)
    p(12, 20+leftPawOff, FD); p(13, 20+leftPawOff, FD)

    p(17, 17+rightPawOff, F); p(18, 17+rightPawOff, FH)
    p(17, 18+rightPawOff, F); p(18, 18+rightPawOff, FH)
    p(17, 19+rightPawOff, F); p(18, 19+rightPawOff, FH)
    p(17, 20+rightPawOff, FD); p(18, 20+rightPawOff, FD)

    -- Back legs
    p(9, 16, FD); p(10, 16, F)
    p(9, 17, FD); p(10, 17, F)
    p(9, 18, FD); p(10, 18, F)
    p(9, 19, FD); p(10, 19, FD)

    p(19, 16, F); p(20, 16, FH)
    p(19, 17, F); p(20, 17, FH)
    p(19, 18, F); p(20, 18, FH)
    p(19, 19, FD); p(20, 19, FD)
end

-- Frame 1: Contact
drawWolf(spr.cels[1].image, 0, -1, 1, 0)

-- Frame 2: Down
local img2 = newFrame(spr)
drawWolf(img2, 1, 0, 1, -1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawWolf(img3, 0, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawWolf(img4, -1, 1, -1, 1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env1_wolf\\"
os.execute('mkdir "' .. outDir:gsub("\\$","") .. '" 2>nul')
spr:saveAs(outDir .. "enemy_wolf_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_wolf_walk.png",
    splitLayers=false,
    openGenerated=false,
}
