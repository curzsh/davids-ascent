-- Wolf enemy walk cycle - 4 frames at 8 FPS
-- Redesigned: lean grey predator, pointy ears, head thrust forward, 4-leg independent anim
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_wolf_walk.aseprite"

-- Color aliases
local O   = PALETTE.VOID_BLACK     -- outline
local FD  = PALETTE.DARK_UMBER     -- deep shadow, dorsal stripe
local G   = PALETTE.SLATE_GREY     -- coat primary
local GH  = PALETTE.STONE_WHITE    -- coat highlight
local M   = PALETTE.TERRACOTTA     -- paws, inner ear skin
local EY  = PALETTE.HARVEST_YELLOW -- predator eyes
local SB  = PALETTE.SANDY_BROWN    -- inner ear
local PW  = PALETTE.PURE_WHITE     -- specular

local function drawWolf(img, bodyY, flOff, frOff, rlOff, rrOff, tailOff)
    clear(img)
    bodyY   = bodyY   or 0
    flOff   = flOff   or 0
    frOff   = frOff   or 0
    rlOff   = rlOff   or 0
    rrOff   = rrOff   or 0
    tailOff = tailOff or 0

    local function p(x, y, c) px(img, x, y+bodyY, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- === TAIL (held low, 2px wide, aggressive hunting position) ===
    p(4, 16+tailOff, G);   p(5, 16+tailOff, FD)
    p(3, 15+tailOff, G);   p(4, 15+tailOff, FD)
    p(3, 14+tailOff, GH);  p(4, 14+tailOff, G)
    p(4, 13+tailOff, GH);  p(5, 13+tailOff, G)
    p(5, 12+tailOff, GH);  p(6, 12+tailOff, G)
    -- Tail outline
    p(3, 13+tailOff, O); p(2, 14+tailOff, O); p(2, 15+tailOff, O)
    p(3, 16+tailOff, O); p(5, 17+tailOff, O)

    -- === EARS (pointed triangles, 3px base x 3px tall - wolf's defining feature) ===
    -- Left ear
    p(19, 2, O)
    p(18, 3, O); p(19, 3, GH); p(20, 3, O)
    p(17, 4, O); p(18, 4, G);  p(19, 4, SB); p(20, 4, O)
    -- Right ear
    p(24, 2, O)
    p(23, 3, O); p(24, 3, GH); p(25, 3, O)
    p(23, 4, O); p(24, 4, G);  p(25, 4, SB); p(26, 4, O)

    -- === HEAD (narrow triangular, thrust forward to x~26, hunting posture) ===
    -- Skull outline
    hl(18, 26, 5, O)
    p(17, 6, O); p(27, 6, O)
    p(17, 7, O); p(27, 7, O)
    p(17, 8, O); p(28, 8, O)
    p(18, 9, O); p(28, 9, O)
    hl(19, 27, 10, O)

    -- Skull fill with 3-tone shading
    -- Top highlight (STW)
    p(19, 5, GH); p(20, 5, GH); p(21, 5, GH); p(22, 5, GH); p(23, 5, GH); p(24, 5, GH); p(25, 5, GH)
    -- Left (lit): GH highlight
    p(18, 6, GH); p(19, 6, GH); p(20, 6, G); p(21, 6, G); p(22, 6, G)
    p(18, 7, GH); p(19, 7, G);  p(20, 7, G); p(21, 7, G); p(22, 7, G)
    -- Right (shadow): FD
    p(23, 6, G);  p(24, 6, FD); p(25, 6, FD); p(26, 6, FD)
    p(23, 7, G);  p(24, 7, FD); p(25, 7, FD); p(26, 7, FD)

    -- Dorsal stripe on skull
    p(21, 5, FD); p(22, 5, FD)

    -- Snout (extends forward, narrower than skull)
    p(18, 8, G); p(19, 8, G); p(20, 8, G); p(21, 8, G); p(22, 8, G)
    p(23, 8, G); p(24, 8, G); p(25, 8, GH); p(26, 8, G); p(27, 8, FD)
    p(19, 9, G); p(20, 9, G); p(21, 9, G); p(22, 9, FD)
    p(23, 9, FD); p(24, 9, FD); p(25, 9, GH); p(26, 9, G); p(27, 9, FD)
    -- Snout top ridge: GH highlight (upper-left light)
    p(25, 8, GH); p(25, 9, GH)

    -- Eyes: HYL amber predator eyes with outline
    p(20, 7, FD); p(21, 7, EY); p(22, 7, FD)  -- left eye
    p(24, 7, FD); p(25, 7, EY); p(26, 7, FD)  -- right eye
    -- Specular dot on left eye
    p(21, 7, PW)

    -- Nose (wet, at snout tip with specular)
    p(26, 9, FD); p(27, 9, FD)
    p(27, 9, PW)  -- specular on wet nose

    -- Mouth underside
    p(23, 9, FD); p(24, 9, FD)

    -- === BODY (low-slung, lean, asymmetric - haunches near x=8) ===
    -- Body outline
    p(7, 10, O); p(19, 10, O)
    p(6, 11, O); p(20, 11, O)
    p(6, 12, O); p(21, 12, O)
    p(6, 13, O); p(21, 13, O)
    p(6, 14, O); p(21, 14, O)
    p(7, 15, O); p(20, 15, O)
    p(8, 16, O); p(19, 16, O)
    hl(9, 18, 17, O)

    -- Neck transition
    p(16, 10, G); p(17, 10, G); p(18, 10, G)

    -- Dorsal stripe (1px FD from skull to tail)
    p(15, 10, FD); p(14, 11, FD); p(13, 12, FD); p(12, 13, FD); p(11, 14, FD)

    -- Left flank: GH highlight (upper-left light)
    p(7, 11, GH);  p(7, 12, GH);  p(7, 13, GH)
    p(8, 11, GH);  p(8, 12, GH);  p(8, 13, GH)
    p(9, 11, GH);  p(9, 12, GH);  p(9, 13, GH)

    -- Mid body: G base
    hl(10, 18, 11, G)
    hl(10, 20, 12, G)
    hl(10, 20, 13, G)
    hl(10, 20, 14, G)
    hl(9, 19, 15, G)
    hl(10, 18, 16, G)

    -- Right flank: FD shadow (wolf belly is dark, low to ground)
    p(19, 11, FD); p(20, 12, FD); p(20, 13, FD); p(20, 14, FD)
    p(19, 15, FD)

    -- Re-apply left highlight
    p(7, 11, GH); p(7, 12, GH); p(7, 13, GH)
    p(8, 11, GH); p(8, 12, GH); p(8, 13, GH)

    -- === LEGS (4 independent, 3px wide, larger stride than lion) ===
    -- Front-left leg (cols 13-15)
    local fly = 17 + flOff
    p(13, fly, FD);   p(14, fly, G);   p(15, fly, GH)
    p(13, fly+1, FD); p(14, fly+1, G); p(15, fly+1, GH)
    p(13, fly+2, FD); p(14, fly+2, G); p(15, fly+2, G)
    -- Paw
    p(13, fly+3, O); p(14, fly+3, M); p(15, fly+3, O)
    -- Outline
    p(12, fly, O); p(16, fly, O)
    p(12, fly+1, O); p(16, fly+1, O)
    p(12, fly+2, O); p(16, fly+2, O)

    -- Front-right leg (cols 17-19)
    local fry = 17 + frOff
    p(17, fry, FD);   p(18, fry, G);   p(19, fry, GH)
    p(17, fry+1, FD); p(18, fry+1, G); p(19, fry+1, GH)
    p(17, fry+2, FD); p(18, fry+2, G); p(19, fry+2, G)
    -- Paw
    p(17, fry+3, O); p(18, fry+3, M); p(19, fry+3, O)
    -- Outline
    p(16, fry, O); p(20, fry, O)
    p(16, fry+1, O); p(20, fry+1, O)
    p(16, fry+2, O); p(20, fry+2, O)

    -- Rear-left leg (cols 8-10)
    local rly = 17 + rlOff
    p(8, rly, FD);   p(9, rly, G);   p(10, rly, GH)
    p(8, rly+1, FD); p(9, rly+1, G); p(10, rly+1, GH)
    p(8, rly+2, FD); p(9, rly+2, G); p(10, rly+2, G)
    -- Paw
    p(8, rly+3, O); p(9, rly+3, M); p(10, rly+3, O)
    -- Outline
    p(7, rly, O); p(11, rly, O)
    p(7, rly+1, O); p(11, rly+1, O)
    p(7, rly+2, O); p(11, rly+2, O)

    -- Rear-right leg (cols 11-13, behind front-left)
    local rry = 17 + rrOff
    p(11, rry, FD);   p(12, rry, G);   p(13, rry, GH)
    p(11, rry+1, FD); p(12, rry+1, G); p(13, rry+1, GH)
    p(11, rry+2, FD); p(12, rry+2, G); p(13, rry+2, G)
    -- Paw
    p(11, rry+3, O); p(12, rry+3, M); p(13, rry+3, O)
    -- Outline
    p(10, rry, O); p(14, rry, O)
    p(10, rry+1, O); p(14, rry+1, O)
    p(10, rry+2, O); p(14, rry+2, O)
end

-- Frame 1: Contact (FL+BR forward) - larger strides (+/-3px) for speed
drawWolf(spr.cels[1].image, 0, -3, 1, 1, -2, 0)

-- Frame 2: Down (weight loads, body drops)
local img2 = newFrame(spr)
drawWolf(img2, 1, -2, 0, 0, -1, -2)

-- Frame 3: Passing (FR+BL forward)
local img3 = newFrame(spr)
drawWolf(img3, 0, 1, -3, -2, 1, 2)

-- Frame 4: Up (push-off)
local img4 = newFrame(spr)
drawWolf(img4, -1, 0, -1, -1, 0, -1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env1_wolf\\"
os.execute('mkdir "' .. outDir .. '" 2>NUL')
spr:saveAs(outDir .. "enemy_wolf_walk.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_wolf_walk.png",
    splitLayers=false,
    openGenerated=false,
}
