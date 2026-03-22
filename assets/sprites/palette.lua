-- Holy Land Master Palette (32 colors)
-- Shared across all sprite creation scripts
PALETTE = {
    VOID_BLACK      = Color{ r=26,  g=10,  b=0,   a=255 },  -- #1A0A00 outlines
    DARK_UMBER      = Color{ r=61,  g=31,  b=0,   a=255 },  -- #3D1F00
    TERRACOTTA      = Color{ r=107, g=58,  b=31,  a=255 },  -- #6B3A1F
    DESERT_SIENNA   = Color{ r=160, g=92,  b=44,  a=255 },  -- #A05C2C
    SANDY_BROWN     = Color{ r=200, g=132, b=60,  a=255 },  -- #C8843C
    WARM_TAN        = Color{ r=232, g=180, b=106, a=255 },  -- #E8B46A
    SUNLIT_LINEN    = Color{ r=245, g=216, b=152, a=255 },  -- #F5D898
    PARCHMENT       = Color{ r=255, g=240, b=192, a=255 },  -- #FFF0C0
    WORN_LEATHER    = Color{ r=92,  g=58,  b=26,  a=255 },  -- #5C3A1A
    STAFF_BROWN     = Color{ r=140, g=90,  b=40,  a=255 },  -- #8C5A28
    STRAW_GOLD      = Color{ r=212, g=160, b=80,  a=255 },  -- #D4A050
    HARVEST_YELLOW  = Color{ r=240, g=200, b=64,  a=255 },  -- #F0C840
    AGED_BRASS      = Color{ r=184, g=120, b=32,  a=255 },  -- #B87820
    POLISHED_BRONZE = Color{ r=232, g=168, b=32,  a=255 },  -- #E8A820
    ROUGH_FLAX      = Color{ r=107, g=64,  b=32,  a=255 },  -- #6B4020
    FLAX_WEAVE      = Color{ r=176, g=128, b=64,  a=255 },  -- #B08040
    BLEACHED_LINEN  = Color{ r=212, g=184, b=120, a=255 },  -- #D4B878
    DEEP_OLIVE      = Color{ r=42,  g=74,  b=26,  a=255 },  -- #2A4A1A
    MEADOW_GREEN    = Color{ r=74,  g=122, b=42,  a=255 },  -- #4A7A2A
    SAGE_LIGHT      = Color{ r=128, g=176, b=64,  a=255 },  -- #80B040
    PALE_SAGE       = Color{ r=168, g=200, b=112, a=255 },  -- #A8C870
    NIGHT_BLUE      = Color{ r=26,  g=48,  b=80,  a=255 },  -- #1A3050
    SKY_BLUE        = Color{ r=40,  g=96,  b=160, a=255 },  -- #2860A0
    PALE_SKY        = Color{ r=96,  g=160, b=216, a=255 },  -- #60A0D8
    HEAVEN_HAZE     = Color{ r=160, g=200, b=240, a=255 },  -- #A0C8F0
    BLOOD_SHADOW    = Color{ r=106, g=48,  b=64,  a=255 },  -- #6A3040
    DANGER_RED      = Color{ r=192, g=64,  b=64,  a=255 },  -- #C04040
    BRIGHT_RED      = Color{ r=240, g=96,  b=96,  a=255 },  -- #F06060
    FOREST_DARK     = Color{ r=32,  g=64,  b=32,  a=255 },  -- #204020
    STONE_WHITE     = Color{ r=240, g=240, b=240, a=255 },  -- #F0F0F0
    SLATE_GREY      = Color{ r=176, g=176, b=176, a=255 },  -- #B0B0B0
    PURE_WHITE      = Color{ r=255, g=255, b=255, a=255 },  -- #FFFFFF
    TRANSPARENT     = Color{ r=0,   g=0,   b=0,   a=0   },
}

-- David-specific color aliases
DAVID = {
    SKIN      = PALETTE.SANDY_BROWN,     -- #C8843C ruddy skin
    SKIN_DARK = PALETTE.DESERT_SIENNA,   -- #A05C2C
    SKIN_HI   = PALETTE.WARM_TAN,        -- #E8B46A
    HAIR      = PALETTE.TERRACOTTA,       -- #6B3A1F
    HAIR_DARK = PALETTE.DARK_UMBER,      -- #3D1F00
    ROBE      = PALETTE.FLAX_WEAVE,      -- #B08040
    ROBE_DARK = PALETTE.ROUGH_FLAX,      -- #6B4020
    ROBE_HI   = PALETTE.BLEACHED_LINEN,  -- #D4B878
    BELT      = PALETTE.WORN_LEATHER,    -- #5C3A1A
    SANDAL    = PALETTE.STAFF_BROWN,     -- #8C5A28
    SLING     = PALETTE.WORN_LEATHER,    -- #5C3A1A
    EYE       = PALETTE.SKY_BLUE,        -- #2860A0
    EYE_WHITE = PALETTE.STONE_WHITE,     -- #F0F0F0
    OUTLINE   = PALETTE.VOID_BLACK,      -- #1A0A00
    STAFF     = PALETTE.STAFF_BROWN,     -- #8C5A28
    STAFF_DK  = PALETTE.WORN_LEATHER,    -- #5C3A1A
}

-- Helper functions
function px(img, x, y, c)
    if x >= 0 and x < img.width and y >= 0 and y < img.height then
        img:drawPixel(x, y, c)
    end
end

function hline(img, x1, x2, y, c)
    for x=x1,x2 do px(img, x, y, c) end
end

function vline(img, x, y1, y2, c)
    for y=y1,y2 do px(img, x, y, c) end
end

function clear(img, c)
    for y=0,img.height-1 do
        for x=0,img.width-1 do
            img:drawPixel(x, y, c or PALETTE.TRANSPARENT)
        end
    end
end

-- Create a new animation frame and return its image (properly creates cel)
function newFrame(spr)
    local frame = spr:newEmptyFrame()
    local layer = spr.layers[1]
    local cel = spr:newCel(layer, frame)
    return cel.image, frame
end

-- Get image for a given frame number (works for frame 1 which already has a cel)
function getFrameImage(spr, frameNum)
    if frameNum == 1 then
        return spr.cels[1].image
    end
    -- Find the cel for this frame
    for _, cel in ipairs(spr.cels) do
        if cel.frameNumber == frameNum then
            return cel.image
        end
    end
    return nil
end

-- Draw David's base pose (front-facing) on an image with optional offsets
-- ox, oy: pixel offset for the whole character (for bob/recoil)
function drawDavidBase(img, ox, oy, leftFoot, rightFoot)
    ox = ox or 0
    oy = oy or 0
    leftFoot = leftFoot or 0   -- vertical offset for left foot
    rightFoot = rightFoot or 0 -- vertical offset for right foot

    local O = DAVID.OUTLINE
    local S = DAVID.SKIN
    local SD = DAVID.SKIN_DARK
    local SH = DAVID.SKIN_HI
    local H = DAVID.HAIR
    local HD = DAVID.HAIR_DARK
    local R = DAVID.ROBE
    local RD = DAVID.ROBE_DARK
    local RH = DAVID.ROBE_HI
    local B = DAVID.BELT
    local SN = DAVID.SANDAL
    local SL = DAVID.SLING
    local E = DAVID.EYE
    local EW = DAVID.EYE_WHITE
    local ST = DAVID.STAFF
    local STD = DAVID.STAFF_DK

    local function p(x, y, c) px(img, x+ox, y+oy, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Staff (behind character, left side)
    p(7, 3, ST); p(8, 2, ST); p(9, 2, ST); p(10, 3, STD)
    for y=3,27 do p(7, y, ST) end
    p(7, 28, STD)

    -- Hair
    hl(13, 19, 5, H)
    hl(12, 20, 6, H)
    p(12, 7, H); p(13, 7, H); p(19, 7, H); p(20, 7, H)
    p(12, 8, H); p(20, 8, H)
    -- Hair dark accents
    p(13, 5, HD); p(19, 5, HD)
    p(12, 6, HD); p(20, 6, HD)

    -- Face
    hl(14, 18, 7, S)
    hl(13, 19, 8, S)
    hl(13, 19, 9, S)
    hl(13, 19, 10, S)
    hl(14, 18, 11, S)
    -- Skin highlight (upper-left light)
    p(14, 8, SH); p(15, 8, SH)

    -- Eyes
    p(14, 9, E); p(15, 9, EW)
    p(17, 9, EW); p(18, 9, E)

    -- Nose
    p(16, 10, SD)
    -- Mouth
    p(15, 11, SD); p(17, 11, SD)

    -- Head outline
    hl(13, 19, 4, O)
    p(12, 5, O); p(20, 5, O)
    p(11, 6, O); p(21, 6, O)
    p(11, 7, O); p(21, 7, O)
    p(11, 8, O); p(21, 8, O)
    p(11, 9, O); p(21, 9, O)
    p(11, 10, O); p(21, 10, O)
    p(12, 11, O); p(20, 11, O)
    p(13, 12, O); p(19, 12, O)

    -- Neck
    p(15, 12, S); p(16, 12, S); p(17, 12, S)

    -- Tunic body
    hl(12, 20, 13, R)
    hl(11, 21, 14, R)
    hl(11, 21, 15, R)
    hl(11, 21, 16, R)
    hl(11, 21, 17, R)
    -- Tunic shading
    p(11, 14, RD); p(11, 15, RD); p(11, 16, RD); p(11, 17, RD)
    p(21, 14, RH); p(21, 15, RH); p(21, 16, RH)
    -- Neckline
    p(15, 13, RD); p(16, 13, RD); p(17, 13, RD)

    -- Belt
    hl(12, 20, 18, B)

    -- Tunic skirt
    hl(12, 20, 19, R)
    hl(12, 20, 20, RH)
    hl(13, 19, 21, R)
    hl(13, 19, 22, RD)

    -- Arms
    p(10, 14, S); p(9, 15, S); p(9, 16, S); p(9, 17, SD)
    p(22, 14, S); p(23, 15, S); p(23, 16, S); p(23, 17, SD)

    -- Sling at right hip
    p(20, 18, SL); p(21, 19, SL); p(22, 19, SL); p(22, 20, SL)

    -- Legs (with foot offsets for walk animation)
    -- Left leg
    p(14, 23+leftFoot, S); p(14, 24+leftFoot, S)
    p(13, 23+leftFoot, S); p(13, 24+leftFoot, S)
    -- Right leg
    p(18, 23+rightFoot, S); p(18, 24+rightFoot, S)
    p(19, 23+rightFoot, S); p(19, 24+rightFoot, S)

    -- Sandals
    hl(12, 15, 25+leftFoot, SN)
    p(12, 26+leftFoot, SN); p(13, 26+leftFoot, SN)
    hl(17, 20, 25+rightFoot, SN)
    p(19, 26+rightFoot, SN); p(20, 26+rightFoot, SN)

    -- Body outline
    p(10, 13, O); p(10, 14, O); p(10, 15, O); p(10, 16, O); p(10, 17, O)
    p(22, 13, O); p(22, 14, O); p(22, 15, O); p(22, 16, O); p(22, 17, O)
end
