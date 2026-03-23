-- Lion enemy walk cycle - 4 frames at 8 FPS
-- Redesigned: 3-tone shading, irregular mane, independent 4-leg animation
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_lion_walk.aseprite"

-- Color aliases
local O   = PALETTE.VOID_BLACK     -- outline
local FD  = PALETTE.DARK_UMBER     -- fur deep shadow, nose, mane shadow
local FM  = PALETTE.DESERT_SIENNA  -- fur shadow
local F   = PALETTE.SANDY_BROWN    -- fur base
local FH  = PALETTE.WARM_TAN       -- fur highlight
local M   = PALETTE.TERRACOTTA     -- mane primary
local MF  = PALETTE.ROUGH_FLAX     -- mane inner fringe (lighter)
local ML  = PALETTE.STRAW_GOLD     -- tail tuft, paw pads
local EY  = PALETTE.HARVEST_YELLOW -- predator eyes
local PW  = PALETTE.PURE_WHITE     -- specular

local function drawLion(img, bodyY, flOff, frOff, rlOff, rrOff, tailOff, headOff)
    clear(img)
    bodyY   = bodyY   or 0
    flOff   = flOff   or 0  -- front-left leg offset
    frOff   = frOff   or 0  -- front-right leg offset
    rlOff   = rlOff   or 0  -- rear-left leg offset
    rrOff   = rrOff   or 0  -- rear-right leg offset
    tailOff = tailOff or 0
    headOff = headOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function ph(x, y, c) px(img, x, y+bodyY+headOff, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- === TAIL (2px wide arc, tuft at end) ===
    p(6, 13+tailOff, F);  p(7, 13+tailOff, FM)
    p(5, 12+tailOff, F);  p(6, 12+tailOff, FM)
    p(4, 11+tailOff, FH); p(5, 11+tailOff, F)
    p(3, 10+tailOff, FH); p(4, 10+tailOff, F)
    p(3, 9+tailOff, F);   p(4, 9+tailOff, FM)
    -- Tuft (3px wide)
    p(2, 8+tailOff, FD); p(3, 8+tailOff, ML); p(4, 8+tailOff, FD)

    -- === MANE (irregular outer edge around face) ===
    -- Mane outline (top arc, irregular)
    p(12, 2, O); hl(13, 19, 2, O); p(20, 2, O)
    p(10, 3, O); p(22, 3, O)
    p(9, 4, O);  p(23, 4, O)
    p(8, 5, O);  p(24, 5, O)
    p(8, 6, O);  p(24, 6, O)
    p(8, 7, O);  p(24, 7, O)
    p(8, 8, O);  p(24, 8, O)
    p(9, 9, O);  p(23, 9, O)
    p(10, 10, O); p(22, 10, O)
    hl(11, 21, 11, O)

    -- Mane outer ring: DUM (darkest edge, irregular)
    ph(13, 3, FD); ph(14, 3, FD); ph(18, 3, FD); ph(19, 3, FD)
    ph(11, 3, FD); ph(21, 3, FD)
    -- Irregularity: skip some to create fur texture
    ph(10, 4, FD); ph(11, 4, FD); ph(21, 4, FD); ph(22, 4, FD)
    ph(9, 5, FD);  ph(10, 5, FD); ph(22, 5, FD); ph(23, 5, FD)
    ph(9, 6, FD);  ph(23, 6, FD)
    ph(9, 7, FD);  ph(23, 7, FD)
    ph(9, 8, FD);  ph(10, 8, FD); ph(22, 8, FD); ph(23, 8, FD)
    ph(10, 9, FD); ph(11, 9, FD); ph(21, 9, FD); ph(22, 9, FD)
    ph(12, 10, FD); ph(20, 10, FD)

    -- Mane mid ring: TRC
    ph(15, 3, M); ph(16, 3, M); ph(17, 3, M)
    ph(12, 4, M); ph(13, 4, M); ph(19, 4, M); ph(20, 4, M)
    ph(11, 5, M); ph(12, 5, M); ph(20, 5, M); ph(21, 5, M)
    ph(10, 6, M); ph(11, 6, M); ph(21, 6, M); ph(22, 6, M)
    ph(10, 7, M); ph(11, 7, M); ph(21, 7, M); ph(22, 7, M)
    ph(11, 8, M); ph(21, 8, M)
    ph(12, 9, M); ph(20, 9, M)
    ph(13, 10, M); ph(14, 10, M); ph(18, 10, M); ph(19, 10, M)

    -- Mane inner fringe: MF (lighter where mane meets face)
    ph(14, 4, MF); ph(18, 4, MF)
    ph(13, 5, MF); ph(19, 5, MF)
    ph(12, 6, MF); ph(20, 6, MF)
    ph(12, 7, MF); ph(20, 7, MF)
    ph(12, 8, MF); ph(20, 8, MF)
    ph(13, 9, MF); ph(19, 9, MF)
    ph(15, 10, MF); ph(16, 10, MF); ph(17, 10, MF)

    -- Light on left mane (upper-left light source)
    ph(10, 4, FH); ph(10, 5, FH)

    -- === HEAD (inside mane) ===
    -- Face fill
    ph(15, 4, F); ph(16, 4, F); ph(17, 4, F)
    ph(14, 5, FH); ph(15, 5, FH); ph(16, 5, F); ph(17, 5, F); ph(18, 5, F)
    ph(13, 6, F); ph(14, 6, F); ph(15, 6, F); ph(16, 6, F); ph(17, 6, F); ph(18, 6, FM); ph(19, 6, FM)
    ph(13, 7, F); ph(14, 7, F); ph(15, 7, F); ph(16, 7, F); ph(17, 7, F); ph(18, 7, FM); ph(19, 7, FM)
    ph(14, 8, F); ph(15, 8, F); ph(16, 8, F); ph(17, 8, F); ph(18, 8, FM)

    -- Muzzle (3px wide bump rows 8-9)
    ph(14, 9, FM); ph(15, 9, FH); ph(16, 9, F); ph(17, 9, FM); ph(18, 9, FM)

    -- Eyes: 1px outline + HYL iris + pupil slit
    ph(14, 6, FD); ph(15, 6, EY); ph(16, 6, FD)  -- left eye
    ph(17, 6, FD); ph(18, 6, EY); ph(19, 6, FD)  -- right eye

    -- Nose: 2x1 DUM block + PWH specular
    ph(15, 8, FD); ph(16, 8, FD)
    ph(15, 8, PW)  -- specular on nose (upper-left)

    -- Mouth corners
    ph(14, 9, FD); ph(18, 9, FD)

    -- === BODY (with form shading) ===
    -- Body outline top
    p(7, 11, O); p(25, 11, O)

    -- Dorsal ridge (DSN shadow - spine)
    hl(12, 20, 11, FM)

    -- Body fill with 3-tone shading
    -- Left flank: WTN highlight (light from upper-left)
    p(9, 12, FH);  p(9, 13, FH);  p(9, 14, FH)
    p(10, 12, FH); p(10, 13, FH); p(10, 14, FH)

    -- Mid body: SBR base
    hl(11, 21, 12, F)
    hl(11, 21, 13, F)
    hl(11, 21, 14, F)
    hl(11, 20, 15, F)
    hl(12, 19, 16, F)

    -- Right flank: DSN shadow
    p(22, 12, FM); p(23, 12, FM)
    p(22, 13, FM); p(23, 13, FM)
    p(22, 14, FM); p(23, 14, FM)
    p(21, 15, FM); p(22, 15, FM)

    -- Belly tuck: WTN highlight (reflected ground light)
    hl(14, 18, 16, FH)
    hl(15, 17, 17, FH)

    -- Body outline sides
    p(8, 12, O); p(24, 12, O)
    p(8, 13, O); p(24, 13, O)
    p(8, 14, O); p(24, 14, O)
    p(9, 15, O); p(23, 15, O)
    p(10, 16, O); p(22, 16, O)
    p(11, 17, O); p(21, 17, O)

    -- Shoulder hump
    p(11, 11, FH); p(12, 11, FH)
    -- Haunch hump
    p(20, 11, FM); p(21, 11, FM)

    -- === LEGS (4 independent, each 3px wide) ===
    -- Front-left leg (cols 12-14)
    local fly = 18 + flOff
    p(12, fly, FM);   p(13, fly, F);   p(14, fly, FH)
    p(12, fly+1, FM); p(13, fly+1, F); p(14, fly+1, FH)
    p(12, fly+2, FM); p(13, fly+2, F); p(14, fly+2, FH)
    p(12, fly+3, FM); p(13, fly+3, F); p(14, fly+3, F)
    -- Paw pad
    p(12, fly+4, O); p(13, fly+4, ML); p(14, fly+4, O)
    -- Outline
    p(11, fly, O); p(15, fly, O)
    p(11, fly+1, O); p(15, fly+1, O)
    p(11, fly+2, O); p(15, fly+2, O)
    p(11, fly+3, O); p(15, fly+3, O)

    -- Front-right leg (cols 18-20)
    local fry = 18 + frOff
    p(18, fry, FM);   p(19, fry, F);   p(20, fry, FH)
    p(18, fry+1, FM); p(19, fry+1, F); p(20, fry+1, FH)
    p(18, fry+2, FM); p(19, fry+2, F); p(20, fry+2, FH)
    p(18, fry+3, FM); p(19, fry+3, F); p(20, fry+3, F)
    -- Paw pad
    p(18, fry+4, O); p(19, fry+4, ML); p(20, fry+4, O)
    -- Outline
    p(17, fry, O); p(21, fry, O)
    p(17, fry+1, O); p(21, fry+1, O)
    p(17, fry+2, O); p(21, fry+2, O)
    p(17, fry+3, O); p(21, fry+3, O)

    -- Rear-left leg (cols 10-12)
    local rly = 18 + rlOff
    p(10, rly, FM);   p(11, rly, F);   p(12, rly, FH)
    p(10, rly+1, FM); p(11, rly+1, F); p(12, rly+1, FH)
    p(10, rly+2, FM); p(11, rly+2, F); p(12, rly+2, F)
    -- Paw pad
    p(10, rly+3, O); p(11, rly+3, ML); p(12, rly+3, O)
    -- Outline
    p(9, rly, O); p(13, rly, O)
    p(9, rly+1, O); p(13, rly+1, O)
    p(9, rly+2, O); p(13, rly+2, O)

    -- Rear-right leg (cols 20-22)
    local rry = 18 + rrOff
    p(20, rry, FM);   p(21, rry, F);   p(22, rry, FH)
    p(20, rry+1, FM); p(21, rry+1, F); p(22, rry+1, FH)
    p(20, rry+2, FM); p(21, rry+2, F); p(22, rry+2, F)
    -- Paw pad
    p(20, rry+3, O); p(21, rry+3, ML); p(22, rry+3, O)
    -- Outline
    p(19, rry, O); p(23, rry, O)
    p(19, rry+1, O); p(23, rry+1, O)
    p(19, rry+2, O); p(23, rry+2, O)

    -- Leg separation lines (1px BLK between adjacent legs)
    for row=18,22 do
        p(15, row, O)  -- between front legs
        p(17, row, O)  -- gap marker
    end
end

-- Frame 1: Contact (FL+BR forward, FR+BL back) - diagonal gait
drawLion(spr.cels[1].image, 0, -2, 1, 1, -1, 0, 0)

-- Frame 2: Down (weight loads, body drops 1px)
local img2 = newFrame(spr)
drawLion(img2, 1, -1, 0, 0, 0, -1, 0)

-- Frame 3: Passing (FR+BL forward, FL+BR back)
local img3 = newFrame(spr)
drawLion(img3, 0, 1, -2, -1, 1, 1, 0)

-- Frame 4: Up (push-off, body rises 1px)
local img4 = newFrame(spr)
drawLion(img4, -1, 0, -1, 0, 0, 0, 0)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env1_lion\\"
os.execute('mkdir "' .. outDir .. '" 2>NUL')
spr:saveAs(outDir .. "enemy_lion_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_lion_walk.png",
    splitLayers=false,
    openGenerated=false,
}
