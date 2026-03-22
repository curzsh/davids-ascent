-- Goliath boss idle cycle - 4 frames at 6 FPS
-- 48x64 sprite - massive armored Philistine warrior
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(48, 64, ColorMode.RGB)
spr.filename = "char_goliath_idle.aseprite"

local O   = PALETTE.VOID_BLACK       -- outlines
local PB  = PALETTE.POLISHED_BRONZE  -- bright armor
local AB  = PALETTE.AGED_BRASS       -- darker armor
local SK  = PALETTE.TERRACOTTA       -- skin base
local SD  = PALETTE.DESERT_SIENNA    -- skin shadow
local SH  = PALETTE.SANDY_BROWN     -- skin highlight
local SB  = PALETTE.STAFF_BROWN      -- spear shaft
local SG  = PALETTE.SLATE_GREY       -- iron tip / shield
local SW  = PALETTE.STONE_WHITE      -- metal highlight
local DU  = PALETTE.DARK_UMBER       -- deep shadow
local WL  = PALETTE.WORN_LEATHER     -- leather straps
local FL  = PALETTE.FLAX_WEAVE       -- skirt fabric

local function drawGoliath(img, bob)
    clear(img)
    bob = bob or 0

    local function p(x, y, c) px(img, x, y + bob, c) end
    local function hl(x1, x2, y, c) for x = x1, x2 do p(x, y, c) end end
    local function vl(x, y1, y2, c) for y = y1, y2 do p(x, y, c) end end

    -- ===== SPEAR (behind character, right side) =====
    -- Shaft runs from top to near bottom
    vl(37, 2, 52, SB)
    vl(38, 2, 52, SB)
    -- Dark edge on shaft
    vl(38, 10, 50, DU)
    -- Iron spearhead (top)
    p(37, 1, SG); p(38, 1, SG)
    p(37, 0, SG); p(38, 0, SG)
    hl(36, 39, 2, SG)
    p(37, 3, SW); p(38, 3, SW)

    -- ===== HELMET with crest/plume =====
    -- Plume top (tall crest)
    hl(22, 26, 3, PB)
    hl(21, 27, 4, PB)
    p(23, 2, AB); p(24, 2, AB); p(25, 2, AB)
    p(24, 1, PB)
    -- Plume highlight
    p(23, 3, AB); p(25, 3, AB)

    -- Helmet dome
    hl(18, 30, 5, AB)
    hl(17, 31, 6, PB)
    hl(16, 32, 7, PB)
    hl(16, 32, 8, AB)
    -- Helmet brim / face guard
    hl(16, 32, 9, AB)
    -- Helmet highlights (upper-left light)
    p(18, 6, PB); p(19, 6, PB); p(20, 6, PB)
    p(17, 7, SW); p(18, 7, SW)
    -- Helmet outline
    hl(18, 30, 4, O)
    p(17, 5, O); p(31, 5, O)
    p(16, 6, O); p(32, 6, O)
    p(15, 7, O); p(33, 7, O)
    p(15, 8, O); p(33, 8, O)
    p(15, 9, O); p(33, 9, O)

    -- ===== FACE (visible below helmet) =====
    hl(17, 31, 10, SK)
    hl(17, 31, 11, SK)
    hl(18, 30, 12, SK)
    hl(18, 30, 13, SK)
    -- Skin shadow (right side)
    p(30, 10, SD); p(31, 10, SD)
    p(30, 11, SD); p(31, 11, SD)
    p(29, 12, SD); p(30, 12, SD)
    -- Skin highlight (upper-left light)
    p(17, 10, SH); p(18, 10, SH); p(19, 10, SH)
    -- Eyes (menacing, dark)
    p(20, 11, O); p(21, 11, SW)
    p(27, 11, SW); p(28, 11, O)
    -- Nose
    p(24, 12, SD)
    -- Mouth / beard shadow
    hl(21, 27, 13, SD)
    -- Face outline
    p(16, 10, O); p(32, 10, O)
    p(16, 11, O); p(32, 11, O)
    p(17, 12, O); p(31, 12, O)
    p(17, 13, O); p(31, 13, O)

    -- ===== NECK =====
    hl(20, 28, 14, SK)
    hl(21, 27, 15, SD)

    -- ===== BRONZE SCALE ARMOR (torso) =====
    -- Shoulder pauldrons
    hl(12, 36, 16, PB)
    hl(11, 37, 17, AB)
    hl(12, 36, 18, PB)
    -- Pauldron outlines
    p(11, 16, O); p(37, 16, O)
    p(10, 17, O); p(38, 17, O)
    p(11, 18, O); p(37, 18, O)

    -- Torso armor - scale pattern (alternating bronze/brass grid)
    for row = 19, 32 do
        hl(14, 34, row, PB)
        -- Scale pattern: darken every other column each row
        for col = 14, 34 do
            if (col + row) % 3 == 0 then
                p(col, row, AB)
            end
        end
    end
    -- Armor highlights (upper-left)
    for row = 19, 24 do
        p(15, row, SW)
        p(16, row, PB)
    end
    -- Armor shadow (right side + bottom)
    for row = 28, 32 do
        p(33, row, DU)
        p(34, row, DU)
    end
    -- Armor outline
    for row = 19, 32 do
        p(13, row, O)
        p(35, row, O)
    end

    -- ===== BELT =====
    hl(14, 34, 33, WL)
    hl(14, 34, 34, DU)
    p(13, 33, O); p(35, 33, O)
    p(13, 34, O); p(35, 34, O)
    -- Belt buckle
    p(24, 33, PB); p(24, 34, PB)

    -- ===== BATTLE SKIRT =====
    hl(14, 34, 35, FL)
    hl(14, 34, 36, FL)
    hl(15, 33, 37, FL)
    hl(15, 33, 38, FL)
    hl(16, 32, 39, FL)
    -- Skirt dark folds
    p(18, 35, WL); p(24, 36, WL); p(30, 35, WL)
    p(20, 37, WL); p(28, 38, WL)
    -- Skirt outline
    p(13, 35, O); p(35, 35, O)
    p(13, 36, O); p(35, 36, O)
    p(14, 37, O); p(34, 37, O)
    p(14, 38, O); p(34, 38, O)
    p(15, 39, O); p(33, 39, O)

    -- ===== ARMS =====
    -- Left arm (holding shield, partially visible)
    vl(11, 19, 30, SK)
    vl(12, 19, 30, SK)
    vl(10, 19, 30, SD)
    -- Arm outline left
    vl(9, 19, 30, O)
    vl(13, 19, 30, O)

    -- Right arm (holding spear)
    vl(36, 19, 30, SK)
    vl(35, 19, 30, SK)
    vl(37, 19, 30, SD)
    -- Arm outline right
    vl(34, 19, 30, O)
    vl(38, 19, 30, O)

    -- Hand gripping spear
    p(36, 28, SK); p(37, 28, SK)
    p(36, 29, SK); p(37, 29, SK)

    -- ===== SHIELD (left side, partially visible) =====
    vl(7, 18, 32, SG)
    vl(8, 18, 32, SG)
    vl(9, 18, 32, SG)
    -- Shield highlight
    vl(8, 19, 26, SW)
    -- Shield dark edge
    vl(7, 18, 32, DU)
    -- Shield outline
    vl(6, 17, 33, O)
    vl(10, 17, 33, O)
    p(7, 17, O); p(8, 17, O); p(9, 17, O)
    p(7, 33, O); p(8, 33, O); p(9, 33, O)

    -- ===== GREAVES (bronze leg armor) =====
    -- Left leg
    hl(17, 22, 40, SK)
    hl(17, 22, 41, SK)
    -- Left greave
    hl(16, 23, 42, AB)
    hl(16, 23, 43, PB)
    hl(16, 23, 44, PB)
    hl(16, 23, 45, AB)
    hl(16, 23, 46, PB)
    hl(16, 23, 47, AB)
    -- Left greave highlight
    p(17, 43, SW); p(17, 44, SW)
    -- Left leg outline
    p(15, 40, O); p(24, 40, O)
    p(15, 41, O); p(24, 41, O)
    for row = 42, 47 do
        p(15, row, O); p(24, row, O)
    end

    -- Right leg
    hl(26, 31, 40, SK)
    hl(26, 31, 41, SD)
    -- Right greave
    hl(25, 32, 42, AB)
    hl(25, 32, 43, PB)
    hl(25, 32, 44, AB)
    hl(25, 32, 45, PB)
    hl(25, 32, 46, AB)
    hl(25, 32, 47, AB)
    -- Right leg outline
    p(24, 40, O); p(33, 40, O)
    p(24, 41, O); p(33, 41, O)
    for row = 42, 47 do
        p(24, row, O); p(33, row, O)
    end

    -- ===== SANDALS / FEET =====
    -- Left foot
    hl(15, 24, 48, DU)
    hl(14, 24, 49, WL)
    p(14, 48, O); p(25, 48, O)
    p(13, 49, O); p(25, 49, O)

    -- Right foot
    hl(24, 33, 48, DU)
    hl(24, 34, 49, WL)
    p(23, 48, O); p(34, 48, O)
    p(23, 49, O); p(35, 49, O)
end

-- Frame 1: Neutral stance
drawGoliath(spr.cels[1].image, 0)

-- Frame 2: Slight rise (weight shift up)
local img2 = newFrame(spr)
drawGoliath(img2, -1)

-- Frame 3: Neutral (same as frame 1)
local img3 = newFrame(spr)
drawGoliath(img3, 0)

-- Frame 4: Slight sink (weight shift down)
local img4 = newFrame(spr)
drawGoliath(img4, 1)

-- Set frame durations (6 FPS = ~167ms)
for i = 1, #spr.frames do spr.frames[i].duration = 0.167 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\characters\\"
spr:saveAs(outDir .. "char_goliath_idle.aseprite")

app.command.ExportSpriteSheet{
    ui = false,
    type = SpriteSheetType.HORIZONTAL,
    textureFilename = outDir .. "char_goliath_idle.png",
    splitLayers = false,
    openGenerated = false,
}
