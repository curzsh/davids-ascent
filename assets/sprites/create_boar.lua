-- Boar enemy walk cycle - 4 frames at 8 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_boar_walk.aseprite"

local O  = PALETTE.VOID_BLACK
local FD = PALETTE.DARK_UMBER       -- dark fur/shadow
local F  = PALETTE.ROUGH_FLAX       -- base fur
local FH = PALETTE.DESERT_SIENNA    -- highlight
local FM = PALETTE.TERRACOTTA       -- mid accent
local EY = PALETTE.HARVEST_YELLOW   -- eyes
local TK = PALETTE.STONE_WHITE      -- tusks
local N  = PALETTE.DARK_UMBER       -- nose/snout

local function drawBoar(img, bodyY, leftPawOff, rightPawOff)
    clear(img)
    bodyY = bodyY or 0
    leftPawOff = leftPawOff or 0
    rightPawOff = rightPawOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Ears (small, pointy, angled out)
    p(12, 4, F); p(11, 3, O); p(12, 3, O); p(13, 4, O)
    p(20, 4, F); p(20, 3, O); p(21, 3, O); p(19, 4, O)

    -- Head (wide, low, prominent snout)
    hl(13, 19, 5, F)
    hl(12, 20, 6, F); hl(12, 20, 7, F)
    hl(11, 21, 8, F)
    hl(11, 22, 9, F)   -- snout extends forward
    hl(12, 23, 10, F)  -- prominent snout
    hl(13, 23, 11, F)
    -- Highlight upper-left
    p(13, 5, FH); p(14, 5, FH); p(13, 6, FH)

    -- Eyes (small)
    p(14, 7, EY); p(19, 7, EY)

    -- Snout detail
    hl(20, 22, 10, FD)  -- nostrils area
    p(22, 10, N); p(22, 11, N)  -- nostrils
    hl(20, 22, 11, FD)

    -- Tusks (2 white pixels each, protruding from jaw)
    p(21, 12, TK); p(22, 12, TK)  -- left tusk
    p(21, 13, O)   -- tusk outline tip

    -- Head outline
    hl(13, 19, 4, O)
    p(11, 5, O); p(20, 5, O)
    p(11, 6, O); p(21, 6, O)
    p(11, 7, O); p(21, 7, O)
    p(10, 8, O); p(22, 8, O)
    p(10, 9, O); p(23, 9, O)
    p(11, 10, O); p(24, 10, O)
    p(12, 11, O); p(24, 11, O)
    hl(13, 20, 12, O)
    p(23, 12, O)

    -- Body (stocky, barrel-shaped, low to ground)
    hl(8, 22, 12, F)
    hl(7, 22, 13, F); hl(7, 22, 14, F)
    hl(7, 22, 15, F); hl(7, 22, 16, F)
    hl(8, 21, 17, F)
    hl(9, 20, 18, F)

    -- Body shading
    for y=12,16 do
        p(7, y, FD); p(8, y, FD)
        p(21, y, FH); p(22, y, FH)
    end
    -- Belly lighter
    hl(12, 18, 16, FH)

    -- Bristly back ridge (darker stripe along spine)
    hl(10, 18, 12, FD)
    hl(10, 16, 13, FD)

    -- Body outline
    p(7, 12, O); p(23, 12, O)
    p(6, 13, O); p(23, 13, O)
    p(6, 14, O); p(23, 14, O)
    p(6, 15, O); p(23, 15, O)
    p(6, 16, O); p(23, 16, O)
    p(7, 17, O); p(22, 17, O)
    p(8, 18, O); p(21, 18, O)

    -- Front legs (short, stocky)
    p(12, 19+leftPawOff, FD); p(13, 19+leftPawOff, F); p(14, 19+leftPawOff, F)
    p(12, 20+leftPawOff, FD); p(13, 20+leftPawOff, F); p(14, 20+leftPawOff, F)
    p(12, 21+leftPawOff, FD); p(13, 21+leftPawOff, FD); p(14, 21+leftPawOff, FD)

    p(17, 19+rightPawOff, F); p(18, 19+rightPawOff, F); p(19, 19+rightPawOff, FH)
    p(17, 20+rightPawOff, F); p(18, 20+rightPawOff, F); p(19, 20+rightPawOff, FH)
    p(17, 21+rightPawOff, FD); p(18, 21+rightPawOff, FD); p(19, 21+rightPawOff, FD)

    -- Back legs
    p(9, 18, FD); p(10, 18, F); p(11, 18, F)
    p(9, 19, FD); p(10, 19, F); p(11, 19, F)
    p(9, 20, FD); p(10, 20, FD); p(11, 20, FD)

    p(20, 18, F); p(21, 18, FH)
    p(20, 19, F); p(21, 19, FH)
    p(20, 20, FD); p(21, 20, FD)

    -- Short curly tail
    p(7, 11, F); p(6, 10, FD); p(6, 9, O)
end

-- Frame 1: Contact
drawBoar(spr.cels[1].image, 0, -1, 1)

-- Frame 2: Down
local img2 = newFrame(spr)
drawBoar(img2, 1, 0, 1)

-- Frame 3: Passing
local img3 = newFrame(spr)
drawBoar(img3, 0, 0, 0)

-- Frame 4: Up
local img4 = newFrame(spr)
drawBoar(img4, -1, 1, -1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env2_boar\\"
os.execute('mkdir "' .. outDir:gsub("\\$","") .. '" 2>nul')
spr:saveAs(outDir .. "enemy_boar_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_boar_walk.png",
    splitLayers=false,
    openGenerated=false,
}
