-- Stage 4 battlefield tile - 32x32, seamlessly tileable
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "env_tile_battlefield_plain.aseprite"

local BASE = PALETTE.DESERT_SIENNA   -- #A05C2C base churned earth
local TORN = PALETTE.DARK_UMBER      -- #3D1F00 torn/disturbed earth
local MID  = PALETTE.TERRACOTTA      -- #6B3A1F mid ground
local DK   = PALETTE.VOID_BLACK      -- darkest patches (scorched)

local img = spr.cels[1].image

-- Fill with base churned earth
for y = 0, 31 do for x = 0, 31 do img:drawPixel(x, y, BASE) end end

-- Mid-tone earth patches (terracotta variation)
local midSpots = {
    {1,0}, {7,2}, {13,1}, {20,3}, {27,0}, {31,2},
    {3,6}, {10,5}, {16,7}, {23,6}, {29,8},
    {0,11}, {6,10}, {12,12}, {19,11}, {25,13}, {31,10},
    {2,16}, {9,15}, {15,17}, {22,16}, {28,18},
    {4,21}, {11,20}, {17,22}, {24,21}, {30,23},
    {1,26}, {7,25}, {14,27}, {21,26}, {27,28},
    {5,31}, {12,30}, {18,29}, {25,31}, {31,30},
}
for _, pos in ipairs(midSpots) do
    px(img, pos[1] % 32, pos[2] % 32, MID)
end

-- Torn earth patches (darker disturbed soil, more dense than other tiles)
local tornSpots = {
    -- Churned strip 1
    {3,3}, {4,3}, {5,3}, {4,4},
    -- Churned strip 2
    {18,8}, {19,8}, {20,8}, {19,9}, {20,9},
    -- Churned strip 3
    {8,13}, {9,13}, {10,13}, {9,14},
    -- Churned strip 4
    {26,16}, {27,16}, {28,16}, {27,17}, {26,17},
    -- Churned strip 5
    {14,21}, {15,21}, {16,21}, {15,22}, {14,22},
    -- Churned strip 6
    {2,28}, {3,28}, {4,28}, {3,29},
    -- Churned strip 7
    {22,27}, {23,27}, {24,27}, {23,28},
    -- Edge patches for tiling
    {0,7}, {31,8}, {0,22}, {31,23},
}
for _, pos in ipairs(tornSpots) do
    px(img, pos[1] % 32, pos[2] % 32, TORN)
end

-- Darkest disturbed patches (very sparse - scorched/trampled)
local darkSpots = {
    {4,4}, {19,9}, {9,14}, {27,17},
    {15,22}, {3,29}, {23,28},
}
for _, pos in ipairs(darkSpots) do
    px(img, pos[1] % 32, pos[2] % 32, DK)
end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage4_battlefield\\"
spr:saveCopyAs(outDir .. "env_tile_battlefield_plain.png")
spr:saveAs(outDir .. "env_tile_battlefield_plain.aseprite")
