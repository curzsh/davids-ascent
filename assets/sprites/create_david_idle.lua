-- David idle animation - 4 frames, breathing bob at 6 FPS
-- REDESIGNED: 3-tone shading, proper proportions, per-region animation
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "char_david_idle.aseprite"

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

-- Draw David's redesigned base pose with per-region offsets
-- headOY: vertical offset for head+torso (breathing bob, does NOT move feet)
-- The staff bottom stays planted; only the body above the sandals bobs
function drawDavidIdle(img, headOY)
    headOY = headOY or 0
    clear(img)

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- ===== STAFF (behind character, left side, stays planted) =====
    -- Shepherd's hook at top (shifts with body)
    p(8, 2+headOY, ST); p(9, 2+headOY, ST); p(9, 3+headOY, STD)
    -- Shaft from top to ground (blends between body offset and ground)
    for y=3,5 do p(7, y+headOY, ST) end  -- upper portion moves with body
    for y=6,28 do p(7, y, ST) end         -- lower portion stays planted
    p(7, 29, STD)                          -- ground contact shadow

    -- ===== HAIR (rows 4-8, cols 12-20) with headOY =====
    local ho = headOY
    -- Hair crown: TRC mid with DUM shadow on right + part line
    hl(13, 19, 4+ho, O)                    -- top outline
    p(12, 5+ho, O); p(20, 5+ho, O)        -- side outline
    p(13, 5+ho, H); p(14, 5+ho, H); p(15, 5+ho, H)
    p(16, 5+ho, HD)                        -- part line
    p(17, 5+ho, H); p(18, 5+ho, H); p(19, 5+ho, HD) -- right shadow
    -- Row 6
    p(11, 6+ho, O); p(21, 6+ho, O)
    p(12, 6+ho, HD); p(13, 6+ho, H); p(14, 6+ho, H)
    p(15, 6+ho, WTN)                       -- hair highlight (light from upper-left)
    p(16, 6+ho, H); p(17, 6+ho, H); p(18, 6+ho, H)
    p(19, 6+ho, HD); p(20, 6+ho, HD)      -- right side shadow
    -- Sides of hair rows 7-8
    p(11, 7+ho, O); p(12, 7+ho, H); p(13, 7+ho, H)
    p(19, 7+ho, HD); p(20, 7+ho, H); p(21, 7+ho, O)
    p(11, 8+ho, O); p(12, 8+ho, H); p(20, 8+ho, HD); p(21, 8+ho, O)

    -- ===== FACE (rows 7-11) with headOY =====
    -- Row 7: upper face
    p(14, 7+ho, SH); p(15, 7+ho, SH); p(16, 7+ho, S); p(17, 7+ho, S); p(18, 7+ho, S)
    -- Row 8: forehead with highlight
    p(13, 8+ho, SH); p(14, 8+ho, SH); p(15, 8+ho, SH)
    p(16, 8+ho, S); p(17, 8+ho, S); p(18, 8+ho, S); p(19, 8+ho, SD)
    -- Row 9: eyes
    p(11, 9+ho, O); p(21, 9+ho, O)
    p(13, 9+ho, S)
    p(14, 9+ho, EW); p(15, 9+ho, E)       -- left eye: white then iris
    p(16, 9+ho, S)                          -- bridge of nose
    p(17, 9+ho, E); p(18, 9+ho, EW)       -- right eye: iris then white
    p(19, 9+ho, SD)
    -- Specular dots on eyes (PURE_WHITE)
    p(14, 9+ho, PW)                         -- left eye specular
    p(18, 9+ho, PW)                         -- right eye specular (on the white)
    -- Row 10: nose
    p(11, 10+ho, O); p(21, 10+ho, O)
    p(13, 10+ho, S); p(14, 10+ho, S); p(15, 10+ho, S)
    p(16, 10+ho, SD)                        -- nose shadow
    p(17, 10+ho, S); p(18, 10+ho, S); p(19, 10+ho, SD)
    -- Row 11: mouth
    p(12, 11+ho, O); p(20, 11+ho, O)
    p(13, 11+ho, S); p(14, 11+ho, S)
    p(15, 11+ho, SD); p(16, 11+ho, S); p(17, 11+ho, SD) -- mouth
    p(18, 11+ho, S); p(19, 11+ho, SD)
    -- Chin outline
    p(13, 12+ho, O); p(19, 12+ho, O)

    -- ===== NECK (row 12) with headOY =====
    p(14, 12+ho, SD); p(15, 12+ho, S); p(16, 12+ho, S); p(17, 12+ho, S); p(18, 12+ho, SD)

    -- ===== TORSO / ROBE (rows 13-17) with headOY =====
    -- Row 13: shoulders with neckline V-shape
    p(11, 13+ho, O); p(21, 13+ho, O)
    p(12, 13+ho, RH); p(13, 13+ho, RH)    -- left shoulder lit
    p(14, 13+ho, R); p(15, 13+ho, RD)     -- neckline V interior
    p(16, 13+ho, RD); p(17, 13+ho, RD)    -- neckline V interior
    p(18, 13+ho, R); p(19, 13+ho, RD); p(20, 13+ho, RD) -- right shadow

    -- Row 14: upper chest
    p(10, 14+ho, O); p(22, 14+ho, O)
    p(11, 14+ho, RH); p(12, 14+ho, RH); p(13, 14+ho, RH) -- left side lit
    p(14, 14+ho, R); p(15, 14+ho, R)
    p(16, 14+ho, RD)                        -- center fold crease
    p(17, 14+ho, R); p(18, 14+ho, R)
    p(19, 14+ho, RD); p(20, 14+ho, RD); p(21, 14+ho, RD) -- right shadow

    -- Row 15: mid chest
    p(10, 15+ho, O); p(22, 15+ho, O)
    p(11, 15+ho, RH); p(12, 15+ho, RH); p(13, 15+ho, R)
    p(14, 15+ho, R); p(15, 15+ho, R)
    p(16, 15+ho, RD)                        -- fold crease
    p(17, 15+ho, R); p(18, 15+ho, R)
    p(19, 15+ho, RD); p(20, 15+ho, RD); p(21, 15+ho, RD)

    -- Row 16: lower chest
    p(10, 16+ho, O); p(22, 16+ho, O)
    p(11, 16+ho, RH); p(12, 16+ho, R); p(13, 16+ho, R)
    p(14, 16+ho, R); p(15, 16+ho, R)
    p(16, 16+ho, RD)                        -- fold crease
    p(17, 16+ho, R); p(18, 16+ho, R)
    p(19, 16+ho, RD); p(20, 16+ho, RD); p(21, 16+ho, RD)

    -- Row 17: bottom of upper robe
    p(10, 17+ho, O); p(22, 17+ho, O)
    p(11, 17+ho, R); p(12, 17+ho, R); p(13, 17+ho, R)
    p(14, 17+ho, R); p(15, 17+ho, R)
    p(16, 17+ho, RD)
    p(17, 17+ho, R); p(18, 17+ho, R)
    p(19, 17+ho, RD); p(20, 17+ho, RD); p(21, 17+ho, RD)

    -- ===== BELT (row 18) with headOY =====
    p(11, 18+ho, O); p(22, 18+ho, O)
    hl(12, 20, 18+ho, B)
    -- Belt buckle highlight
    p(16, 18+ho, STD)

    -- ===== ARMS (rows 14-20) with headOY =====
    -- Left arm (holds staff, catches light — slightly higher position)
    p(10, 13+ho, SH); p(9, 14+ho, SH); p(9, 15+ho, S)
    p(9, 16+ho, S); p(9, 17+ho, SD)
    -- Left hand on staff
    p(8, 17+ho, S)

    -- Right arm (hangs loose, in shadow)
    p(22, 13+ho, SD); p(23, 14+ho, S); p(23, 15+ho, S)
    p(23, 16+ho, SD); p(23, 17+ho, SD)
    -- Arm outlines
    p(8, 13+ho, O); p(8, 14+ho, O); p(8, 15+ho, O); p(8, 16+ho, O); p(8, 17+ho, O); p(8, 18+ho, O)
    p(24, 14+ho, O); p(24, 15+ho, O); p(24, 16+ho, O); p(24, 17+ho, O)

    -- ===== SLING at right hip (rows 18-22) with headOY =====
    p(21, 18+ho, SL)
    p(22, 19+ho, SL); p(23, 19+ho, SL)    -- cord diagonal
    p(23, 20+ho, SL); p(24, 20+ho, SL)    -- cord continues
    -- Sling pouch (2x2 cluster)
    p(23, 21+ho, SL); p(24, 21+ho, SL)
    p(23, 22+ho, DU); p(24, 22+ho, SL)    -- pouch with shadow pixel

    -- ===== SKIRT (rows 19-22) with headOY =====
    -- Row 19: slight taper inward from belt
    p(11, 19+ho, O); p(22, 19+ho, O)
    p(12, 19+ho, RH); p(13, 19+ho, RH)    -- left side lit
    p(14, 19+ho, R); p(15, 19+ho, R); p(16, 19+ho, R)
    p(17, 19+ho, R); p(18, 19+ho, R)
    p(19, 19+ho, RD); p(20, 19+ho, RD)    -- right shadow

    -- Row 20: slight flare
    p(11, 20+ho, O); p(22, 20+ho, O)
    p(12, 20+ho, RH); p(13, 20+ho, R)
    p(14, 20+ho, R); p(15, 20+ho, R); p(16, 20+ho, R)
    p(17, 20+ho, R); p(18, 20+ho, R)
    p(19, 20+ho, RD); p(20, 20+ho, RD); p(21, 20+ho, RD)

    -- Row 21: flare out
    p(11, 21+ho, O); p(22, 21+ho, O)
    p(12, 21+ho, RH); p(13, 21+ho, R)
    p(14, 21+ho, R); p(15, 21+ho, R); p(16, 21+ho, R)
    p(17, 21+ho, R); p(18, 21+ho, R)
    p(19, 21+ho, RD); p(20, 21+ho, RD); p(21, 21+ho, RD)

    -- Row 22: hem in shadow
    p(12, 22+ho, O); p(21, 22+ho, O)
    p(13, 22+ho, RD); p(14, 22+ho, RD); p(15, 22+ho, RD)
    p(16, 22+ho, RD); p(17, 22+ho, RD); p(18, 22+ho, RD)
    p(19, 22+ho, RD); p(20, 22+ho, RD)
    -- Between legs shadow at row 23
    p(16, 23+ho, RD)

    -- ===== LEGS (rows 23-28, 3-4px wide tapering to 2px) — NO headOY, feet stay planted =====
    -- Left leg: thigh (4px wide) rows 23-24
    p(12, 23, O); p(17, 23, O)             -- outline between legs
    p(13, 23, SH); p(14, 23, S); p(15, 23, S); p(16, 23, SD)
    p(13, 24, SH); p(14, 24, S); p(15, 24, S); p(16, 24, SD)
    -- Left leg: shin (3px wide) rows 25-26
    p(13, 25, S); p(14, 25, S); p(15, 25, SD)
    p(13, 26, S); p(14, 26, S); p(15, 26, SD)
    -- Left leg outlines
    p(12, 24, O); p(12, 25, O); p(12, 26, O)

    -- Right leg: thigh (4px wide) rows 23-24
    p(17, 23, SD); p(18, 23, S); p(19, 23, S); p(20, 23, SD)
    p(17, 24, SD); p(18, 24, S); p(19, 24, S); p(20, 24, SD)
    -- Right leg: shin (3px wide) rows 25-26
    p(17, 25, SD); p(18, 25, S); p(19, 25, SD)
    p(17, 26, SD); p(18, 26, S); p(19, 26, SD)
    -- Right leg outlines
    p(20, 23, O); p(20, 24, O); p(20, 25, O); p(20, 26, O)

    -- ===== SANDALS (rows 27-28) — planted on ground =====
    -- Left sandal: 4px wide
    p(11, 27, O); p(16, 27, O)
    p(12, 27, SN); p(13, 27, SN); p(14, 27, SN); p(15, 27, SN)
    p(13, 27, SL)                           -- strap across foot
    -- Left sole
    p(11, 28, O); p(16, 28, O)
    p(12, 28, SN); p(13, 28, SN); p(14, 28, SN); p(15, 28, SN)

    -- Right sandal: 4px wide
    p(17, 27, O); p(21, 27, O)
    p(18, 27, SN); p(19, 27, SN); p(20, 27, SN)
    p(19, 27, SL)                           -- strap across foot
    -- Right sole
    p(17, 28, O); p(21, 28, O)
    p(18, 28, SN); p(19, 28, SN); p(20, 28, SN)

    -- Bottom outline under sandals
    hl(12, 15, 29, O); hl(18, 20, 29, O)
end

-- Frame 1: Base position (cel already exists)
local img1 = spr.cels[1].image
drawDavidIdle(img1, 0)

-- Frame 2: 1px up shift on head/torso (breathing in), feet stay
local img2 = newFrame(spr)
drawDavidIdle(img2, -1)

-- Frame 3: Hold at top of breath
local img3 = newFrame(spr)
drawDavidIdle(img3, -1)

-- Frame 4: Return to base
local img4 = newFrame(spr)
drawDavidIdle(img4, 0)

-- Set frame durations (6 FPS = ~167ms per frame)
for i=1,#spr.frames do spr.frames[i].duration = 0.167 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\characters\\"
spr:saveAs(outDir .. "char_david_idle.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "char_david_idle.png",
    splitLayers=false,
    openGenerated=false,
}
