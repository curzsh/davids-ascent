-- Wild Boar enemy walk cycle - 4 frames at 8 FPS
-- Redesigned: stocky low body, curved white tusks, bristled spine, curly tail, 4-leg anim
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_boar_walk.aseprite"

-- Color aliases (grey-brown palette, distinct from bear's dark and wolf's cool grey)
local O   = PALETTE.VOID_BLACK     -- outline
local FD  = PALETTE.DARK_UMBER     -- body shadow, spine bristles
local G   = PALETTE.SLATE_GREY     -- body primary (grey-brown bristle)
local GH  = PALETTE.WARM_TAN       -- body highlight (left side)
local M   = PALETTE.TERRACOTTA     -- snout, underbelly
local MZ  = PALETTE.DESERT_SIENNA  -- snout side, ear
local TK  = PALETTE.STONE_WHITE    -- tusks (near-white)
local SN  = PALETTE.STAFF_BROWN    -- tail
local PW  = PALETTE.PURE_WHITE     -- specular

local function drawBoar(img, bodyY, flOff, frOff, rlOff, rrOff)
    clear(img)
    bodyY = bodyY or 0
    flOff = flOff or 0
    frOff = frOff or 0
    rlOff = rlOff or 0
    rrOff = rrOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- === CURLY TAIL (3px S-curl at rump, reads as pig) ===
    p(3, 12, O)
    p(4, 11, SN)
    p(3, 10, SN)
    p(4, 9,  SN)
    p(3, 9,  O)
    p(5, 12, O)

    -- === SPINE BRISTLES (1px DUM spikes above dorsal outline, 3-4 total) ===
    p(10, 7, FD)   -- bristle 1
    p(13, 6, FD)   -- bristle 2
    p(17, 7, FD)   -- bristle 3
    p(21, 7, FD)   -- bristle 4

    -- === BODY (barrel-shaped, humped back, low to ground) ===
    -- Body outline top (humped back)
    hl(5, 22, 8, O)
    p(4, 9, O)

    -- Body outline sides
    p(4, 10, O); p(4, 11, O); p(4, 12, O); p(4, 13, O)
    p(4, 14, O); p(4, 15, O); p(4, 16, O)

    -- Body outline bottom (gaps for legs)
    hl(5, 7, 17, O); hl(12, 15, 17, O); hl(19, 21, 17, O)

    -- Body fill with 3-tone shading
    -- Left/top: GH highlight (upper-left light source)
    p(5, 9, GH);  p(6, 9, GH);  p(7, 9, GH);  p(8, 9, GH)
    p(5, 10, GH); p(6, 10, GH); p(7, 10, GH)
    p(5, 11, GH); p(6, 11, GH)

    -- Center: G mid
    for row=9,16 do
        hl(5, 21, row, G)
    end

    -- Re-apply highlight over G fill
    p(5, 9, GH);  p(6, 9, GH);  p(7, 9, GH);  p(8, 9, GH)
    p(5, 10, GH); p(6, 10, GH); p(7, 10, GH)
    p(5, 11, GH); p(6, 11, GH)

    -- Dorsal spine shadow (1px DUM along back)
    hl(6, 21, 9, FD)

    -- Right/bottom: FD shadow
    for row=13,16 do
        p(20, row, FD); p(21, row, FD)
    end

    -- Underbelly: M (terracotta, warm tone)
    hl(8, 19, 16, M)
    hl(10, 17, 15, M)

    -- === HEAD (large, ~40% of sprite length, angled slightly down) ===
    -- Head outline
    hl(22, 28, 8, O)
    p(21, 9, O);  p(29, 9, O)
    p(21, 10, O); p(30, 10, O)
    p(21, 11, O); p(30, 11, O)
    p(21, 12, O); p(30, 12, O)
    p(21, 13, O); p(30, 13, O)
    p(21, 14, O); p(29, 14, O)
    hl(22, 28, 15, O)

    -- Skull fill with 3-tone shading
    -- Top-left: GH highlight
    p(22, 9, GH);  p(23, 9, GH);  p(24, 9, G);   p(25, 9, G);   p(26, 9, G);   p(27, 9, FD);  p(28, 9, FD)
    p(22, 10, GH); p(23, 10, GH); p(24, 10, G);  p(25, 10, G);  p(26, 10, G);  p(27, 10, FD)
    p(22, 11, GH); p(23, 11, G);  p(24, 11, G);  p(25, 11, G);  p(26, 11, G);  p(27, 11, FD)
    p(22, 12, G);  p(23, 12, G);  p(24, 12, G);  p(25, 12, G);  p(26, 12, FD); p(27, 12, FD)
    p(22, 13, G);  p(23, 13, G);  p(24, 13, G);  p(25, 13, FD); p(26, 13, FD); p(27, 13, FD)
    p(22, 14, G);  p(23, 14, G);  p(24, 14, FD); p(25, 14, FD); p(26, 14, FD); p(27, 14, FD); p(28, 14, FD)

    -- Snout disc (flattened oval at front of head)
    p(28, 10, M); p(29, 10, M)
    p(28, 11, M); p(29, 11, MZ)
    p(28, 12, M); p(29, 12, MZ)
    p(28, 13, MZ); p(29, 13, FD)
    -- Nose (dark center with specular)
    p(29, 11, O); p(29, 12, O)
    p(29, 11, PW)  -- specular on wet nose

    -- Ear (small, at skull top)
    p(23, 8, O); p(24, 8, MZ); p(25, 8, O)

    -- Eye (VOID_BLACK iris - herbivore, not predator yellow)
    p(24, 10, O); p(25, 10, O)

    -- === TUSKS (curved white arcs, 3-4px, defining feature!) ===
    -- Left tusk (curves upward from lower jaw corner)
    p(27, 15, TK); p(28, 14, TK); p(29, 13, TK); p(29, 12, TK)
    -- Right tusk (partially visible behind)
    p(28, 15, TK); p(29, 14, TK)

    -- === LEGS (4 independent, 3px wide, short stride) ===
    -- Front-left leg (cols 16-18)
    local fly = 17 + flOff
    p(16, fly, G);   p(17, fly, G);   p(18, fly, FD)
    p(16, fly+1, G); p(17, fly+1, G); p(18, fly+1, FD)
    p(16, fly+2, G); p(17, fly+2, FD); p(18, fly+2, FD)
    p(16, fly+3, O); p(17, fly+3, O); p(18, fly+3, O) -- hooves
    -- Outline
    p(15, fly, O); p(19, fly, O)
    p(15, fly+1, O); p(19, fly+1, O)
    p(15, fly+2, O); p(19, fly+2, O)

    -- Front-right leg (cols 20-22, visible behind/below head)
    local fry = 17 + frOff
    p(20, fry, G);   p(21, fry, FD)
    p(20, fry+1, G); p(21, fry+1, FD)
    p(20, fry+2, FD); p(21, fry+2, FD)
    p(20, fry+3, O); p(21, fry+3, O) -- hooves
    -- Outline
    p(19, fry, O); p(22, fry, O)
    p(19, fry+1, O); p(22, fry+1, O)
    p(19, fry+2, O); p(22, fry+2, O)

    -- Rear-left leg (cols 5-7)
    local rly = 17 + rlOff
    p(5, rly, GH);  p(6, rly, G);   p(7, rly, G)
    p(5, rly+1, G); p(6, rly+1, G); p(7, rly+1, FD)
    p(5, rly+2, G); p(6, rly+2, FD); p(7, rly+2, FD)
    p(5, rly+3, O); p(6, rly+3, O); p(7, rly+3, O) -- hooves
    -- Outline
    p(4, rly, O); p(8, rly, O)
    p(4, rly+1, O); p(8, rly+1, O)
    p(4, rly+2, O); p(8, rly+2, O)

    -- Rear-right leg (cols 9-11)
    local rry = 17 + rrOff
    p(9, rry, G);   p(10, rry, G);   p(11, rry, FD)
    p(9, rry+1, G); p(10, rry+1, FD); p(11, rry+1, FD)
    p(9, rry+2, FD); p(10, rry+2, FD); p(11, rry+2, FD)
    p(9, rry+3, O); p(10, rry+3, O); p(11, rry+3, O) -- hooves
    -- Outline
    p(8, rry, O); p(12, rry, O)
    p(8, rry+1, O); p(12, rry+1, O)
    p(8, rry+2, O); p(12, rry+2, O)
end

-- Frame 1: Contact (FL+RR forward, FR+RL back) - small stride (short legs)
drawBoar(spr.cels[1].image, 0, -1, 1, 1, -1)

-- Frame 2: Down (weight loads)
local img2 = newFrame(spr)
drawBoar(img2, 1, 0, 0, 0, 0)

-- Frame 3: Passing (FR+RL forward, FL+RR back)
local img3 = newFrame(spr)
drawBoar(img3, 0, 1, -1, -1, 1)

-- Frame 4: Down return
local img4 = newFrame(spr)
drawBoar(img4, 1, 0, 0, 0, 0)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env3_boar\\"
os.execute('mkdir "' .. outDir .. '" 2>NUL')
spr:saveAs(outDir .. "enemy_boar_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_boar_walk.png",
    splitLayers=false,
    openGenerated=false,
}
