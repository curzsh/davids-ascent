-- Bear enemy walk cycle - 4 frames at 8 FPS
-- Redesigned: massive dark brown bear, fills 90%+ canvas, shoulder hump, head bob, claws
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_bear_walk.aseprite"

-- Color aliases (bear is DARK - DUM primary, not warm SBR like lion)
local O   = PALETTE.VOID_BLACK     -- outline
local FD  = PALETTE.DARK_UMBER     -- body primary (dark brown fur)
local FM  = PALETTE.TERRACOTTA     -- body highlight (left flank, ear inner)
local FS  = PALETTE.WORN_LEATHER   -- deepest shadow (right side, under belly)
local MZ  = PALETTE.DESERT_SIENNA  -- muzzle, paw pads
local MH  = PALETTE.WARM_TAN       -- muzzle highlight
local EW  = PALETTE.STONE_WHITE    -- eye white
local PW  = PALETTE.PURE_WHITE     -- specular

local function drawBear(img, bodyY, flOff, frOff, rlOff, rrOff, headBob)
    clear(img)
    bodyY   = bodyY   or 0
    flOff   = flOff   or 0
    frOff   = frOff   or 0
    rlOff   = rlOff   or 0
    rrOff   = rrOff   or 0
    headBob = headBob or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function ph(x, y, c) px(img, x, y+bodyY+headBob, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- === HEAD (domed skull, small round ears, lighter muzzle) ===
    -- Ears (2-3px wide, 2px tall, rounded)
    -- Left ear
    ph(14, 2, O); ph(15, 2, O); ph(16, 2, O)
    ph(14, 3, O); ph(15, 3, FM); ph(16, 3, O)  -- inner ear: FM
    -- Right ear
    ph(20, 2, O); ph(21, 2, O); ph(22, 2, O)
    ph(20, 3, O); ph(21, 3, FD); ph(22, 3, O)  -- outer ear: FD

    -- Skull outline
    hl(13, 23, 4, O)
    ph(12, 5, O); ph(24, 5, O)
    ph(12, 6, O); ph(24, 6, O)
    ph(12, 7, O); ph(24, 7, O)
    ph(12, 8, O); ph(25, 8, O)
    ph(13, 9, O); ph(25, 9, O)
    hl(14, 24, 10, O)

    -- Skull fill: left half FM (light from upper-left), right half FD
    ph(14, 4, FM); ph(15, 4, FM); ph(16, 4, FM); ph(17, 4, FM); ph(18, 4, FD)
    ph(19, 4, FD); ph(20, 4, FD); ph(21, 4, FD); ph(22, 4, FD)
    ph(13, 5, FM); ph(14, 5, FM); ph(15, 5, FM); ph(16, 5, FM); ph(17, 5, FD)
    ph(18, 5, FD); ph(19, 5, FD); ph(20, 5, FD); ph(21, 5, FD); ph(22, 5, FD); ph(23, 5, FD)
    ph(13, 6, FM); ph(14, 6, FM); ph(15, 6, FM)
    ph(16, 6, FD); ph(17, 6, FD); ph(18, 6, FD); ph(19, 6, FD); ph(20, 6, FD)
    ph(21, 6, FD); ph(22, 6, FD); ph(23, 6, FD)

    -- Muzzle (lighter DSN/WTN, distinct from dark skull)
    ph(13, 7, FM); ph(14, 7, MH); ph(15, 7, MZ); ph(16, 7, MZ); ph(17, 7, MZ)
    ph(18, 7, MZ); ph(19, 7, MZ); ph(20, 7, FD); ph(21, 7, FD); ph(22, 7, FD); ph(23, 7, FD)
    ph(13, 8, FM); ph(14, 8, MH); ph(15, 8, MZ); ph(16, 8, MZ); ph(17, 8, MZ)
    ph(18, 8, MZ); ph(19, 8, MZ); ph(20, 8, MZ); ph(21, 8, FD); ph(22, 8, FD); ph(23, 8, FD); ph(24, 8, FD)
    ph(14, 9, FM); ph(15, 9, MZ); ph(16, 9, MZ); ph(17, 9, MZ); ph(18, 9, MZ)
    ph(19, 9, MZ); ph(20, 9, MZ); ph(21, 9, FD); ph(22, 9, FD); ph(23, 9, FD); ph(24, 9, FD)

    -- Eyes (small, low on face)
    ph(15, 6, EW); ph(16, 6, O)   -- left eye
    ph(20, 6, O);  ph(21, 6, EW)  -- right eye

    -- Dark nose (2x1 block at muzzle tip + specular)
    ph(17, 8, O); ph(18, 8, O)
    ph(17, 8, PW)  -- specular on wet nose

    -- === BODY (massive, fills canvas x=1 to x=30, shoulder hump) ===
    -- Shoulder hump outline (peaks at y=4, higher than head at y=5)
    p(7, 3, O);  p(8, 3, O);  p(9, 3, O);  p(10, 3, O); p(11, 3, O); p(12, 3, O)
    p(6, 4, O);  p(5, 5, O);  p(4, 6, O);  p(3, 7, O);  p(2, 8, O)

    -- Body outline (sides)
    p(1, 9, O);  p(1, 10, O); p(1, 11, O); p(1, 12, O); p(1, 13, O)
    p(1, 14, O); p(1, 15, O); p(1, 16, O); p(1, 17, O)
    -- Right side outline
    p(30, 8, O); p(30, 9, O); p(30, 10, O); p(30, 11, O); p(30, 12, O)
    p(30, 13, O); p(30, 14, O); p(30, 15, O); p(30, 16, O); p(30, 17, O)

    -- Top outline (from hump to rump)
    hl(25, 29, 7, O)
    p(24, 8, O)

    -- Bottom outline (with gaps for legs)
    hl(2, 5, 18, O); hl(12, 15, 18, O); hl(20, 23, 18, O); hl(28, 30, 18, O)

    -- Shoulder hump fill (FM = lighter, catching light)
    p(7, 4, FM);  p(8, 4, FM);  p(9, 4, FM);  p(10, 4, FM); p(11, 4, FM)
    p(6, 5, FM);  p(7, 5, FM);  p(8, 5, FM);  p(9, 5, FM);  p(10, 5, FM); p(11, 5, FM)
    p(5, 6, FM);  p(6, 6, FM);  p(7, 6, FM);  p(8, 6, FM);  p(9, 6, FM);  p(10, 6, FM)
    p(4, 7, FM);  p(5, 7, FM);  p(6, 7, FM);  p(7, 7, FM)
    p(3, 8, FM);  p(4, 8, FM);  p(5, 8, FM)

    -- Body fill: left side = FM highlight
    for row=9,13 do
        p(2, row, FM); p(3, row, FM); p(4, row, FM); p(5, row, FM)
    end
    for row=14,17 do
        p(2, row, FM); p(3, row, FM); p(4, row, FM)
    end

    -- Body fill: center = FD primary (dark brown)
    for row=5,7 do
        for col=11,24 do p(col, row, FD) end
    end
    for row=8,9 do
        for col=6,29 do p(col, row, FD) end
    end
    for row=10,13 do
        for col=6,29 do p(col, row, FD) end
    end
    for row=14,17 do
        for col=5,29 do p(col, row, FD) end
    end

    -- Body fill: right side = FS deepest shadow
    for row=9,17 do
        p(28, row, FS); p(29, row, FS)
    end
    for row=14,17 do
        p(26, row, FS); p(27, row, FS)
    end

    -- Under belly shadow
    hl(8, 25, 17, FS)

    -- Re-apply left highlight over center fill
    for row=9,13 do
        p(2, row, FM); p(3, row, FM); p(4, row, FM); p(5, row, FM)
    end
    for row=14,17 do
        p(2, row, FM); p(3, row, FM); p(4, row, FM)
    end

    -- Re-apply shoulder hump highlight
    p(7, 4, FM);  p(8, 4, FM);  p(9, 4, FM);  p(10, 4, FM); p(11, 4, FM)
    p(6, 5, FM);  p(7, 5, FM);  p(8, 5, FM);  p(9, 5, FM);  p(10, 5, FM); p(11, 5, FM)
    p(5, 6, FM);  p(6, 6, FM);  p(7, 6, FM);  p(8, 6, FM);  p(9, 6, FM);  p(10, 6, FM)
    p(4, 7, FM);  p(5, 7, FM);  p(6, 7, FM);  p(7, 7, FM)
    p(3, 8, FM);  p(4, 8, FM);  p(5, 8, FM)

    -- === LEGS (4 independent, thick 4px wide, short, with claws) ===
    -- Front-left leg (cols 6-9)
    local fly = 18 + flOff
    for col=6,9 do
        p(col, fly, FM); p(col, fly+1, FD); p(col, fly+2, FD); p(col, fly+3, MZ)
    end
    -- Claws (3 tiny BLK pixels, spaced 1px apart)
    p(6, fly+4, O); p(8, fly+4, O); p(9, fly+4, O)
    -- Leg outline
    p(5, fly, O); p(10, fly, O)
    p(5, fly+1, O); p(10, fly+1, O)
    p(5, fly+2, O); p(10, fly+2, O)
    p(5, fly+3, O); p(10, fly+3, O)

    -- Front-right leg (cols 16-19)
    local fry = 18 + frOff
    for col=16,19 do
        p(col, fry, FD); p(col, fry+1, FD); p(col, fry+2, FS); p(col, fry+3, MZ)
    end
    -- Claws
    p(16, fry+4, O); p(18, fry+4, O); p(19, fry+4, O)
    -- Leg outline
    p(15, fry, O); p(20, fry, O)
    p(15, fry+1, O); p(20, fry+1, O)
    p(15, fry+2, O); p(20, fry+2, O)
    p(15, fry+3, O); p(20, fry+3, O)

    -- Rear-left leg (cols 2-5)
    local rly = 18 + rlOff
    for col=2,5 do
        p(col, rly, FM); p(col, rly+1, FD); p(col, rly+2, FD); p(col, rly+3, MZ)
    end
    -- Claws
    p(2, rly+4, O); p(4, rly+4, O); p(5, rly+4, O)
    -- Leg outline
    p(1, rly, O); p(6, rly, O)
    p(1, rly+1, O); p(6, rly+1, O)
    p(1, rly+2, O); p(6, rly+2, O)
    p(1, rly+3, O); p(6, rly+3, O)

    -- Rear-right leg (cols 24-27)
    local rry = 18 + rrOff
    for col=24,27 do
        p(col, rry, FD); p(col, rry+1, FS); p(col, rry+2, FS); p(col, rry+3, MZ)
    end
    -- Claws
    p(24, rry+4, O); p(26, rry+4, O); p(27, rry+4, O)
    -- Leg outline
    p(23, rry, O); p(28, rry, O)
    p(23, rry+1, O); p(28, rry+1, O)
    p(23, rry+2, O); p(28, rry+2, O)
    p(23, rry+3, O); p(28, rry+3, O)
end

-- Frame 1: Contact (FL+RR forward, FR+RL back) - diagonal gait
drawBear(spr.cels[1].image, 0, -2, 2, 2, -2, 0)

-- Frame 2: Down (weight loads, body drops, head bobs down extra)
local img2 = newFrame(spr)
drawBear(img2, 1, 0, 0, 0, 0, 1)

-- Frame 3: Passing (FR+RL forward, FL+RR back)
local img3 = newFrame(spr)
drawBear(img3, 0, 2, -2, -2, 2, 0)

-- Frame 4: Down return (weight loads again, head bobs)
local img4 = newFrame(spr)
drawBear(img4, 1, 0, 0, 0, 0, 1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env3_bear\\"
os.execute('mkdir "' .. outDir .. '" 2>NUL')
spr:saveAs(outDir .. "enemy_bear_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_bear_walk.png",
    splitLayers=false,
    openGenerated=false,
}
