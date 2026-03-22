-- Stage 5 Valley of Elah floor tile - 32x32, seamlessly tileable
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "env_tile_valley_floor.aseprite"

local BASE = PALETTE.SANDY_BROWN     -- #C8843C sandy base
local RK   = PALETTE.SLATE_GREY      -- #B0B0B0 river stones
local RH   = PALETTE.STONE_WHITE     -- #F0F0F0 stone highlights
local SH   = PALETTE.DESERT_SIENNA   -- #A05C2C earth shadow
local MID  = PALETTE.WARM_TAN        -- #E8B46A sand highlight
local DK   = PALETTE.TERRACOTTA      -- #6B3A1F darker earth
local DU   = PALETTE.DARK_UMBER      -- #3D1F00 deep shadow between stones

local img = spr.cels[1].image

-- Fill with sandy base
for y = 0, 31 do for x = 0, 31 do img:drawPixel(x, y, BASE) end end

-- Sand highlights (lighter patches)
local hiSpots = {
    {2,1}, {10,0}, {19,2}, {27,1},
    {5,8}, {14,7}, {23,9}, {31,6},
    {1,14}, {8,13}, {17,15}, {26,14},
    {4,20}, {12,19}, {21,21}, {29,20},
    {7,26}, {16,25}, {24,27}, {0,28},
    {11,31}, {20,30}, {28,29},
}
for _, pos in ipairs(hiSpots) do
    px(img, pos[1] % 32, pos[2] % 32, MID)
end

-- Darker earth patches
local dkSpots = {
    {6,3}, {18,4}, {29,5},
    {2,11}, {15,10}, {25,12},
    {9,17}, {20,18}, {31,16},
    {3,23}, {14,24}, {26,22},
    {8,29}, {19,28}, {0,31},
}
for _, pos in ipairs(dkSpots) do
    px(img, pos[1] % 32, pos[2] % 32, SH)
end

-- River stone clusters (the dramatic detail - larger than rocky tile rocks)
-- Stone cluster 1 (upper left area)
px(img, 3, 4, RK); px(img, 4, 4, RK); px(img, 5, 4, RK)
px(img, 3, 5, RK); px(img, 4, 5, RH); px(img, 5, 5, RK)
px(img, 4, 6, DU)  -- shadow below

-- Stone cluster 2 (upper right)
px(img, 22, 3, RK); px(img, 23, 3, RK)
px(img, 22, 4, RH); px(img, 23, 4, RK)
px(img, 22, 5, DU)

-- Stone cluster 3 (mid left)
px(img, 8, 14, RK); px(img, 9, 14, RK); px(img, 10, 14, RK); px(img, 11, 14, RK)
px(img, 8, 15, RK); px(img, 9, 15, RH); px(img, 10, 15, RH); px(img, 11, 15, RK)
px(img, 9, 16, DU); px(img, 10, 16, DU)  -- shadow below

-- Stone cluster 4 (mid right)
px(img, 27, 12, RK); px(img, 28, 12, RK)
px(img, 27, 13, RH); px(img, 28, 13, RK); px(img, 29, 13, RK)
px(img, 28, 14, DU)

-- Stone cluster 5 (lower center - largest, dramatic)
px(img, 15, 22, RK); px(img, 16, 22, RK); px(img, 17, 22, RK)
px(img, 14, 23, RK); px(img, 15, 23, RH); px(img, 16, 23, RH); px(img, 17, 23, RK); px(img, 18, 23, RK)
px(img, 14, 24, RK); px(img, 15, 24, RK); px(img, 16, 24, RK); px(img, 17, 24, RK); px(img, 18, 24, RK)
px(img, 15, 25, DU); px(img, 16, 25, DU); px(img, 17, 25, DU)  -- shadow

-- Stone cluster 6 (lower left)
px(img, 1, 26, RK); px(img, 2, 26, RK)
px(img, 1, 27, RH); px(img, 2, 27, RK)
px(img, 1, 28, DU)

-- Stone cluster 7 (bottom right)
px(img, 27, 28, RK); px(img, 28, 28, RK); px(img, 29, 28, RK)
px(img, 27, 29, RK); px(img, 28, 29, RH); px(img, 29, 29, RK)
px(img, 28, 30, DU)

-- Edge stones for seamless tiling
px(img, 0, 9, RK); px(img, 31, 9, RK)
px(img, 0, 10, RH); px(img, 31, 10, RH)

-- Scattered individual pebbles
px(img, 12, 8, RK); px(img, 25, 18, RK); px(img, 6, 20, RK)
px(img, 30, 24, RK); px(img, 19, 10, RK)

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage5_valley\\"
spr:saveCopyAs(outDir .. "env_tile_valley_floor.png")
spr:saveAs(outDir .. "env_tile_valley_floor.aseprite")
