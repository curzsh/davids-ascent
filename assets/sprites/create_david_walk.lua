-- David walk cycle - 4 frames at 8 FPS
-- REDESIGNED: per-region animation, 3-tone shading, proper proportions
-- Frame 1: Contact | Frame 2: Down | Frame 3: Passing | Frame 4: Up
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "char_david_walk.aseprite"

-- Color aliases
local O   = DAVID.OUTLINE
local S   = DAVID.SKIN
local SD  = DAVID.SKIN_DARK
local SH  = DAVID.SKIN_HI
local H   = DAVID.HAIR
local HD  = DAVID.HAIR_DARK
local R   = DAVID.ROBE
local RD  = DAVID.ROBE_DARK
local RH  = DAVID.ROBE_HI
local B   = DAVID.BELT
local SN  = DAVID.SANDAL
local SL  = DAVID.SLING
local E   = DAVID.EYE
local EW  = DAVID.EYE_WHITE
local ST  = DAVID.STAFF
local STD = DAVID.STAFF_DK
local PW  = PALETTE.PURE_WHITE
local DU  = PALETTE.DARK_UMBER
local WTN = PALETTE.WARM_TAN

-- Draw David walk frame with independent region offsets
-- bodyOY: global body vertical offset (down=+1, up=-1, neutral=0)
-- leftLegOY: left leg vertical offset (forward=-1, back=+1)
-- rightLegOY: right leg vertical offset
-- leftArmOX: left arm horizontal offset (forward=+1, back=-1)
-- rightArmOX: right arm horizontal offset
-- staffTiltX: staff top-end horizontal offset (0=vertical, 1=tilted right)
-- slingOX: sling cord horizontal offset
function drawDavidWalk(img, bodyOY, leftLegOY, rightLegOY, leftArmOX, rightArmOX, staffTiltX, slingOX)
    bodyOY     = bodyOY or 0
    leftLegOY  = leftLegOY or 0
    rightLegOY = rightLegOY or 0
    leftArmOX  = leftArmOX or 0
    rightArmOX = rightArmOX or 0
    staffTiltX = staffTiltX or 0
    slingOX    = slingOX or 0
    clear(img)

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    local bo = bodyOY -- shorthand for body offset

    -- ===== STAFF (stays planted at ground, only top moves with body + tilt) =====
    -- Shepherd's hook at top
    p(8+staffTiltX, 2+bo, ST); p(9+staffTiltX, 2+bo, ST); p(9+staffTiltX, 3+bo, STD)
    -- Upper shaft moves with body
    for y=3,5 do p(7+staffTiltX, y+bo, ST) end
    -- Lower shaft stays planted (gradual blend: tilt fades out toward ground)
    for y=6,28 do p(7, y, ST) end
    p(7, 29, STD)  -- ground contact

    -- ===== HAIR (rows 4-8) with body offset =====
    -- Top outline
    hl(13, 19, 4+bo, O)
    p(12, 5+bo, O); p(20, 5+bo, O)
    -- Hair fill with 3-tone shading
    p(13, 5+bo, H); p(14, 5+bo, H); p(15, 5+bo, H)
    p(16, 5+bo, HD)  -- part line
    p(17, 5+bo, H); p(18, 5+bo, H); p(19, 5+bo, HD)
    -- Row 6
    p(11, 6+bo, O); p(21, 6+bo, O)
    p(12, 6+bo, HD); p(13, 6+bo, H); p(14, 6+bo, H)
    p(15, 6+bo, WTN)  -- hair highlight
    p(16, 6+bo, H); p(17, 6+bo, H); p(18, 6+bo, H)
    p(19, 6+bo, HD); p(20, 6+bo, HD)
    -- Side hair
    p(11, 7+bo, O); p(12, 7+bo, H); p(13, 7+bo, H)
    p(19, 7+bo, HD); p(20, 7+bo, H); p(21, 7+bo, O)
    p(11, 8+bo, O); p(12, 8+bo, H); p(20, 8+bo, HD); p(21, 8+bo, O)

    -- ===== FACE (rows 7-12) with body offset =====
    -- Row 7: upper face
    p(14, 7+bo, SH); p(15, 7+bo, SH); p(16, 7+bo, S); p(17, 7+bo, S); p(18, 7+bo, S)
    -- Row 8: forehead highlight
    p(13, 8+bo, SH); p(14, 8+bo, SH); p(15, 8+bo, SH)
    p(16, 8+bo, S); p(17, 8+bo, S); p(18, 8+bo, S); p(19, 8+bo, SD)
    -- Row 9: eyes
    p(11, 9+bo, O); p(21, 9+bo, O)
    p(13, 9+bo, S)
    p(14, 9+bo, PW); p(15, 9+bo, E)   -- left eye: specular + iris
    p(16, 9+bo, S)
    p(17, 9+bo, E); p(18, 9+bo, PW)   -- right eye: iris + specular
    p(19, 9+bo, SD)
    -- Row 10: nose
    p(11, 10+bo, O); p(21, 10+bo, O)
    p(13, 10+bo, S); p(14, 10+bo, S); p(15, 10+bo, S)
    p(16, 10+bo, SD)  -- nose
    p(17, 10+bo, S); p(18, 10+bo, S); p(19, 10+bo, SD)
    -- Row 11: mouth
    p(12, 11+bo, O); p(20, 11+bo, O)
    p(13, 11+bo, S); p(14, 11+bo, S)
    p(15, 11+bo, SD); p(16, 11+bo, S); p(17, 11+bo, SD)
    p(18, 11+bo, S); p(19, 11+bo, SD)
    -- Chin outline
    p(13, 12+bo, O); p(19, 12+bo, O)

    -- ===== NECK (row 12) =====
    p(14, 12+bo, SD); p(15, 12+bo, S); p(16, 12+bo, S); p(17, 12+bo, S); p(18, 12+bo, SD)

    -- ===== TORSO / ROBE (rows 13-17) with body offset =====
    -- Row 13: shoulders + neckline V
    p(11, 13+bo, O); p(21, 13+bo, O)
    p(12, 13+bo, RH); p(13, 13+bo, RH)
    p(14, 13+bo, R); p(15, 13+bo, RD); p(16, 13+bo, RD); p(17, 13+bo, RD)
    p(18, 13+bo, R); p(19, 13+bo, RD); p(20, 13+bo, RD)
    -- Row 14: upper chest, 3-tone shading
    p(10, 14+bo, O); p(22, 14+bo, O)
    p(11, 14+bo, RH); p(12, 14+bo, RH); p(13, 14+bo, RH)
    p(14, 14+bo, R); p(15, 14+bo, R)
    p(16, 14+bo, RD)  -- fold crease
    p(17, 14+bo, R); p(18, 14+bo, R)
    p(19, 14+bo, RD); p(20, 14+bo, RD); p(21, 14+bo, RD)
    -- Row 15
    p(10, 15+bo, O); p(22, 15+bo, O)
    p(11, 15+bo, RH); p(12, 15+bo, RH); p(13, 15+bo, R)
    p(14, 15+bo, R); p(15, 15+bo, R)
    p(16, 15+bo, RD)
    p(17, 15+bo, R); p(18, 15+bo, R)
    p(19, 15+bo, RD); p(20, 15+bo, RD); p(21, 15+bo, RD)
    -- Row 16
    p(10, 16+bo, O); p(22, 16+bo, O)
    p(11, 16+bo, RH); p(12, 16+bo, R); p(13, 16+bo, R)
    p(14, 16+bo, R); p(15, 16+bo, R)
    p(16, 16+bo, RD)
    p(17, 16+bo, R); p(18, 16+bo, R)
    p(19, 16+bo, RD); p(20, 16+bo, RD); p(21, 16+bo, RD)
    -- Row 17
    p(10, 17+bo, O); p(22, 17+bo, O)
    p(11, 17+bo, R); p(12, 17+bo, R); p(13, 17+bo, R)
    p(14, 17+bo, R); p(15, 17+bo, R)
    p(16, 17+bo, RD)
    p(17, 17+bo, R); p(18, 17+bo, R)
    p(19, 17+bo, RD); p(20, 17+bo, RD); p(21, 17+bo, RD)

    -- ===== BELT (row 18) =====
    p(11, 18+bo, O); p(22, 18+bo, O)
    hl(12, 20, 18+bo, B)
    p(16, 18+bo, STD)  -- buckle

    -- ===== ARMS with independent horizontal offsets =====
    -- Left arm (holds staff, catches light)
    local lax = leftArmOX
    p(10+lax, 13+bo, SH); p(9+lax, 14+bo, SH); p(9+lax, 15+bo, S)
    p(9+lax, 16+bo, S); p(9+lax, 17+bo, SD)
    p(8+lax, 17+bo, S)  -- hand on staff
    -- Left arm outline
    p(8+lax, 13+bo, O); p(8+lax, 14+bo, O); p(8+lax, 15+bo, O)
    p(8+lax, 16+bo, O); p(8+lax, 17+bo, O); p(8+lax, 18+bo, O)

    -- Right arm (hangs loose, in shadow)
    local rax = rightArmOX
    p(22+rax, 13+bo, SD); p(23+rax, 14+bo, S); p(23+rax, 15+bo, S)
    p(23+rax, 16+bo, SD); p(23+rax, 17+bo, SD)
    -- Right arm outline
    p(24+rax, 14+bo, O); p(24+rax, 15+bo, O); p(24+rax, 16+bo, O); p(24+rax, 17+bo, O)

    -- ===== SLING at right hip with offset =====
    p(21+slingOX, 18+bo, SL)
    p(22+slingOX, 19+bo, SL); p(23+slingOX, 19+bo, SL)
    p(23+slingOX, 20+bo, SL); p(24+slingOX, 20+bo, SL)
    -- Pouch (2x2 with shadow)
    p(23+slingOX, 21+bo, SL); p(24+slingOX, 21+bo, SL)
    p(23+slingOX, 22+bo, DU); p(24+slingOX, 22+bo, SL)

    -- ===== SKIRT (rows 19-22) with body offset =====
    -- Row 19
    p(11, 19+bo, O); p(22, 19+bo, O)
    p(12, 19+bo, RH); p(13, 19+bo, RH)
    p(14, 19+bo, R); p(15, 19+bo, R); p(16, 19+bo, R)
    p(17, 19+bo, R); p(18, 19+bo, R)
    p(19, 19+bo, RD); p(20, 19+bo, RD)
    -- Row 20
    p(11, 20+bo, O); p(22, 20+bo, O)
    p(12, 20+bo, RH); p(13, 20+bo, R)
    p(14, 20+bo, R); p(15, 20+bo, R); p(16, 20+bo, R)
    p(17, 20+bo, R); p(18, 20+bo, R)
    p(19, 20+bo, RD); p(20, 20+bo, RD); p(21, 20+bo, RD)
    -- Row 21
    p(11, 21+bo, O); p(22, 21+bo, O)
    p(12, 21+bo, RH); p(13, 21+bo, R)
    p(14, 21+bo, R); p(15, 21+bo, R); p(16, 21+bo, R)
    p(17, 21+bo, R); p(18, 21+bo, R)
    p(19, 21+bo, RD); p(20, 21+bo, RD); p(21, 21+bo, RD)
    -- Row 22: hem shadow
    p(12, 22+bo, O); p(21, 22+bo, O)
    p(13, 22+bo, RD); p(14, 22+bo, RD); p(15, 22+bo, RD)
    p(16, 22+bo, RD); p(17, 22+bo, RD); p(18, 22+bo, RD)
    p(19, 22+bo, RD); p(20, 22+bo, RD)
    -- Between-legs shadow
    p(16, 23+bo, RD)

    -- ===== LEGS (rows 23-28) — independent vertical offsets per leg =====
    -- Legs do NOT use bodyOY; they have their own offsets for walk cycle

    -- Left leg: thigh 4px wide (rows 23-24), shin 3px (rows 25-26)
    local ll = leftLegOY
    p(12, 23+ll, O); p(17, 23+ll, O)
    p(13, 23+ll, SH); p(14, 23+ll, S); p(15, 23+ll, S); p(16, 23+ll, SD)
    p(13, 24+ll, SH); p(14, 24+ll, S); p(15, 24+ll, S); p(16, 24+ll, SD)
    p(12, 24+ll, O)
    p(13, 25+ll, S); p(14, 25+ll, S); p(15, 25+ll, SD)
    p(12, 25+ll, O); p(12, 26+ll, O)
    p(13, 26+ll, S); p(14, 26+ll, S); p(15, 26+ll, SD)
    -- Left sandal
    p(11, 27+ll, O); p(16, 27+ll, O)
    p(12, 27+ll, SN); p(13, 27+ll, SN); p(14, 27+ll, SN); p(15, 27+ll, SN)
    p(13, 27+ll, SL)  -- strap
    p(11, 28+ll, O); p(16, 28+ll, O)
    p(12, 28+ll, SN); p(13, 28+ll, SN); p(14, 28+ll, SN); p(15, 28+ll, SN)
    hl(12, 15, 29+ll, O)  -- sole outline

    -- Right leg: thigh 4px wide, shin 3px
    local rl = rightLegOY
    p(20, 23+rl, O)
    p(17, 23+rl, SD); p(18, 23+rl, S); p(19, 23+rl, S); p(20, 23+rl, SD)
    p(17, 24+rl, SD); p(18, 24+rl, S); p(19, 24+rl, S); p(20, 24+rl, SD)
    p(20, 24+rl, O)
    p(17, 25+rl, SD); p(18, 25+rl, S); p(19, 25+rl, SD)
    p(20, 25+rl, O); p(20, 26+rl, O)
    p(17, 26+rl, SD); p(18, 26+rl, S); p(19, 26+rl, SD)
    -- Right sandal
    p(17, 27+rl, O); p(21, 27+rl, O)
    p(18, 27+rl, SN); p(19, 27+rl, SN); p(20, 27+rl, SN)
    p(19, 27+rl, SL)  -- strap
    p(17, 28+rl, O); p(21, 28+rl, O)
    p(18, 28+rl, SN); p(19, 28+rl, SN); p(20, 28+rl, SN)
    hl(18, 20, 29+rl, O)  -- sole outline
end

-- ===== FRAME 1: Contact pose =====
-- Left foot forward (-1), right foot back (+1)
-- Left arm back (-1), right arm forward (+1, sling trails)
drawDavidWalk(spr.cels[1].image,
    0,     -- bodyOY: neutral
    -1,    -- leftLegOY: forward (up)
    1,     -- rightLegOY: back (down)
    -1,    -- leftArmOX: pulled back
    0,     -- rightArmOX: pushed forward slightly
    0,     -- staffTiltX: vertical
    0      -- slingOX: neutral
)

-- ===== FRAME 2: Down pose (weight on front foot) =====
local img2 = newFrame(spr)
-- Body drops 1px, legs crossing
drawDavidWalk(img2,
    1,     -- bodyOY: down (weight on front foot)
    0,     -- leftLegOY: crossing to neutral
    0,     -- rightLegOY: rising
    0,     -- leftArmOX: forward to center
    -1,    -- rightArmOX: pulling back
    0,     -- staffTiltX: vertical
    0      -- slingOX
)

-- ===== FRAME 3: Passing pose (mid-stride, equal balance) =====
local img3 = newFrame(spr)
-- Both feet at same level, body neutral, staff tilts slightly
drawDavidWalk(img3,
    0,     -- bodyOY: neutral
    0,     -- leftLegOY: even
    0,     -- rightLegOY: even
    0,     -- leftArmOX: centered
    0,     -- rightArmOX: centered
    1,     -- staffTiltX: tilts 1px right (walking motion)
    0      -- slingOX
)

-- ===== FRAME 4: Up pose (pushing off back foot) =====
local img4 = newFrame(spr)
-- Body rises 1px, mirror of frame 1
drawDavidWalk(img4,
    -1,    -- bodyOY: up (pushing off)
    1,     -- leftLegOY: back (down)
    -1,    -- rightLegOY: forward (up)
    1,     -- leftArmOX: swings forward
    0,     -- rightArmOX: neutral
    0,     -- staffTiltX: vertical
    -1     -- slingOX: swings left
)

-- Set frame durations (8 FPS = 125ms per frame)
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
