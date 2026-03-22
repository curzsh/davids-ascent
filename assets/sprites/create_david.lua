-- David the Shepherd Boy - 32x32 pixel art sprite
-- Front-facing idle pose, centered
local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "david.aseprite"

local cel = spr.cels[1]
local img = cel.image

-- Color palette for David
local TRANSPARENT = Color{ r=0, g=0, b=0, a=0 }
local SKIN = Color{ r=194, g=148, b=108 }
local SKIN_DARK = Color{ r=160, g=120, b=85 }
local HAIR = Color{ r=80, g=50, b=30 }
local HAIR_DARK = Color{ r=55, g=35, b=20 }
local TUNIC = Color{ r=150, g=110, b=70 }
local TUNIC_DARK = Color{ r=120, g=85, b=50 }
local TUNIC_LIGHT = Color{ r=175, g=135, b=90 }
local BELT = Color{ r=100, g=70, b=40 }
local SANDAL = Color{ r=130, g=90, b=55 }
local SLING = Color{ r=110, g=80, b=50 }
local EYE = Color{ r=60, g=90, b=140 }
local WHITE = Color{ r=240, g=235, b=225 }
local OUTLINE = Color{ r=45, g=30, b=20 }
local STAFF = Color{ r=120, g=80, b=40 }
local STAFF_DARK = Color{ r=90, g=60, b=30 }

-- Helper to draw a pixel
local function px(x, y, c)
    if x >= 0 and x < 32 and y >= 0 and y < 32 then
        img:drawPixel(x, y, c)
    end
end

-- Helper to draw a horizontal line
local function hline(x1, x2, y, c)
    for x=x1,x2 do px(x, y, c) end
end

-- Clear to transparent
for y=0,31 do for x=0,31 do px(x,y,TRANSPARENT) end end

-- ============================================================
-- STAFF (behind character, left side)
-- ============================================================
-- Crook at top
px(7, 3, STAFF)
px(8, 2, STAFF)
px(9, 2, STAFF)
px(10, 3, STAFF_DARK)
-- Shaft
for y=3,27 do px(7, y, STAFF) end
px(7, 28, STAFF_DARK)

-- ============================================================
-- HEAD OUTLINE (top)
-- ============================================================
hline(13, 19, 4, OUTLINE)
px(12, 5, OUTLINE)
px(20, 5, OUTLINE)
px(11, 6, OUTLINE)
px(21, 6, OUTLINE)
px(11, 7, OUTLINE)
px(21, 7, OUTLINE)
px(11, 8, OUTLINE)
px(21, 8, OUTLINE)
px(11, 9, OUTLINE)
px(21, 9, OUTLINE)
px(11, 10, OUTLINE)
px(21, 10, OUTLINE)
px(12, 11, OUTLINE)
px(20, 11, OUTLINE)
px(13, 12, OUTLINE)
px(19, 12, OUTLINE)

-- ============================================================
-- HAIR (dark brown, front-facing, parted)
-- ============================================================
hline(13, 19, 5, HAIR)
hline(12, 20, 6, HAIR)
-- Hair sides framing face
px(12, 7, HAIR)
px(13, 7, HAIR)
px(19, 7, HAIR)
px(20, 7, HAIR)
px(12, 8, HAIR)
px(20, 8, HAIR)
-- Hair dark accents
px(13, 5, HAIR_DARK)
px(19, 5, HAIR_DARK)
px(12, 6, HAIR_DARK)
px(20, 6, HAIR_DARK)

-- ============================================================
-- FACE (front-facing, symmetrical)
-- ============================================================
-- Forehead
hline(14, 18, 7, SKIN)
-- Face rows
hline(13, 19, 8, SKIN)
hline(13, 19, 9, SKIN)
hline(13, 19, 10, SKIN)
hline(14, 18, 11, SKIN)

-- Eyes (symmetrical, blue iris outside, white inside)
px(14, 9, EYE)
px(15, 9, WHITE)
px(17, 9, WHITE)
px(18, 9, EYE)

-- Nose hint
px(16, 10, SKIN_DARK)

-- Mouth
px(15, 11, SKIN_DARK)
px(17, 11, SKIN_DARK)

-- ============================================================
-- NECK
-- ============================================================
px(15, 12, SKIN)
px(16, 12, SKIN)
px(17, 12, SKIN)

-- ============================================================
-- TUNIC (front-facing, symmetrical)
-- ============================================================
hline(12, 20, 13, TUNIC)
hline(11, 21, 14, TUNIC)
hline(11, 21, 15, TUNIC)
hline(11, 21, 16, TUNIC)
hline(11, 21, 17, TUNIC)

-- Tunic shading (left side darker, right side lighter)
px(11, 14, TUNIC_DARK)
px(11, 15, TUNIC_DARK)
px(11, 16, TUNIC_DARK)
px(11, 17, TUNIC_DARK)
px(21, 14, TUNIC_LIGHT)
px(21, 15, TUNIC_LIGHT)
px(21, 16, TUNIC_LIGHT)

-- Neckline detail
px(15, 13, TUNIC_DARK)
px(16, 13, TUNIC_DARK)
px(17, 13, TUNIC_DARK)

-- ============================================================
-- BELT
-- ============================================================
hline(12, 20, 18, BELT)

-- ============================================================
-- TUNIC SKIRT (below belt)
-- ============================================================
hline(12, 20, 19, TUNIC)
hline(12, 20, 20, TUNIC_LIGHT)
hline(13, 19, 21, TUNIC)
hline(13, 19, 22, TUNIC_DARK)

-- ============================================================
-- ARMS (symmetrical, at sides)
-- ============================================================
-- Left arm
px(10, 14, SKIN)
px(9, 15, SKIN)
px(9, 16, SKIN)
px(9, 17, SKIN_DARK)

-- Right arm
px(22, 14, SKIN)
px(23, 15, SKIN)
px(23, 16, SKIN)
px(23, 17, SKIN_DARK)

-- ============================================================
-- SLING (hanging from belt, right hip)
-- ============================================================
px(20, 18, SLING)
px(21, 19, SLING)
px(22, 19, SLING)
px(22, 20, SLING)
px(23, 20, SLING)

-- ============================================================
-- LEGS (front-facing, slight gap between)
-- ============================================================
-- Left leg
px(14, 23, SKIN)
px(14, 24, SKIN)
px(13, 23, SKIN)
px(13, 24, SKIN)

-- Right leg
px(18, 23, SKIN)
px(18, 24, SKIN)
px(19, 23, SKIN)
px(19, 24, SKIN)

-- ============================================================
-- SANDALS
-- ============================================================
-- Left sandal
hline(12, 15, 25, SANDAL)
px(12, 26, SANDAL)
px(13, 26, SANDAL)

-- Right sandal
hline(17, 20, 25, SANDAL)
px(19, 26, SANDAL)
px(20, 26, SANDAL)

-- ============================================================
-- BODY OUTLINE (key edges for readability at small size)
-- ============================================================
-- Tunic sides
px(10, 14, OUTLINE)
px(10, 15, OUTLINE)
px(10, 16, OUTLINE)
px(10, 17, OUTLINE)
px(22, 14, OUTLINE)
px(22, 15, OUTLINE)
px(22, 16, OUTLINE)
px(22, 17, OUTLINE)

-- Bottom of tunic
hline(13, 19, 23, OUTLINE)

-- ============================================================
-- Save
-- ============================================================
spr:saveCopyAs("C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\david.png")
spr:saveAs("C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\david.aseprite")
