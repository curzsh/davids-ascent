-- Stage 2 rocky earth tile - 32x32, seamlessly tileable
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "env_tile_rockyearth_plain.aseprite"

local BASE = PALETTE.TERRACOTTA      -- #6B3A1F base earth
local DARK = PALETTE.DARK_UMBER      -- #3D1F00 dark patches
local MID  = PALETTE.DESERT_SIENNA   -- #A05C2C mid tones
local RK   = PALETTE.SLATE_GREY      -- #B0B0B0 rock fragments
local RH   = PALETTE.STONE_WHITE     -- #F0F0F0 rock highlights

local img = spr.cels[1].image

-- Fill with base earth color
for y = 0, 31 do for x = 0, 31 do img:drawPixel(x, y, BASE) end end

-- Mid-tone earth variation (scattered for texture)
local midSpots = {
    {2,1}, {8,0}, {15,2}, {22,1}, {28,3},
    {4,6}, {11,5}, {18,7}, {25,6}, {31,4},
    {1,10}, {7,11}, {14,9}, {20,12}, {27,10},
    {3,15}, {10,16}, {17,14}, {23,17}, {30,15},
    {0,20}, {6,21}, {13,19}, {19,22}, {26,20},
    {2,25}, {9,26}, {16,24}, {22,27}, {29,25},
    {5,30}, {12,29}, {18,31}, {25,30}, {31,28},
}
for _, pos in ipairs(midSpots) do
    px(img, pos[1] % 32, pos[2] % 32, MID)
end

-- Dark earth patches (shadow areas)
local darkSpots = {
    {5,3}, {16,4}, {27,2}, {0,5},
    {10,8}, {21,9}, {3,11}, {30,7},
    {8,14}, {19,13}, {26,15}, {1,16},
    {6,18}, {14,20}, {24,19}, {31,21},
    {3,23}, {12,24}, {22,22}, {28,26},
    {7,28}, {17,27}, {25,29}, {0,31},
    {9,31}, {20,30}, {30,28},
}
for _, pos in ipairs(darkSpots) do
    px(img, pos[1] % 32, pos[2] % 32, DARK)
end

-- Rock fragments (small stone pieces scattered on ground)
-- Each rock is 2-3 pixels for visibility
local rocks = {
    -- Rock cluster 1 (upper area)
    {4,4, RK}, {5,4, RK}, {4,5, RH},
    -- Rock cluster 2
    {18,6, RK}, {19,6, RH},
    -- Rock cluster 3
    {28,11, RK}, {29,11, RK}, {28,12, RH},
    -- Rock cluster 4
    {7,16, RK}, {8,16, RK}, {7,17, RH},
    -- Rock cluster 5
    {22,15, RK}, {23,15, RH},
    -- Rock cluster 6
    {13,23, RK}, {14,23, RK}, {13,24, RH},
    -- Rock cluster 7
    {1,27, RK}, {2,27, RH},
    -- Rock cluster 8
    {26,28, RK}, {27,28, RK}, {27,29, RH},
    -- Edge rocks (for seamless tiling)
    {31,2, RK}, {0,3, RH},
    {0,18, RK}, {31,19, RH},
}
for _, r in ipairs(rocks) do
    px(img, r[1] % 32, r[2] % 32, r[3])
end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage2_hills\\"
spr:saveCopyAs(outDir .. "env_tile_rockyearth_plain.png")
spr:saveAs(outDir .. "env_tile_rockyearth_plain.aseprite")
