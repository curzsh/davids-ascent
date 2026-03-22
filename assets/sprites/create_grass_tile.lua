-- Stage 1 grass plain tile - 32x32, seamlessly tileable
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "env_tile_grass_plain.aseprite"

local G1 = PALETTE.MEADOW_GREEN    -- #4A7A2A base grass
local G2 = PALETTE.SAGE_LIGHT      -- #80B040 lighter grass
local G3 = PALETTE.DEEP_OLIVE      -- #2A4A1A dark grass shadow
local E  = PALETTE.DESERT_SIENNA   -- #A05C2C earth peek-through

local img = spr.cels[1].image

-- Fill with base green
for y=0,31 do for x=0,31 do img:drawPixel(x, y, G1) end end

-- Scatter lighter grass tufts (pseudo-random but tileable)
-- Pattern repeats at edges for seamless tiling
local lightSpots = {
    {3,2}, {14,1}, {25,3}, {8,7}, {19,6}, {30,8},
    {1,12}, {12,11}, {23,13}, {6,17}, {17,16}, {28,18},
    {4,22}, {15,21}, {26,23}, {9,27}, {20,26}, {31,28},
    {2,30}, {13,29}, {24,31},
}
for _, pos in ipairs(lightSpots) do
    px(img, pos[1] % 32, pos[2] % 32, G2)
end

-- Scatter dark grass shadows
local darkSpots = {
    {5,4}, {16,3}, {27,5}, {10,9}, {21,8}, {0,10},
    {3,14}, {14,15}, {25,14}, {8,19}, {19,20}, {30,19},
    {6,24}, {17,25}, {28,24}, {11,29}, {22,30}, {1,28},
}
for _, pos in ipairs(darkSpots) do
    px(img, pos[1] % 32, pos[2] % 32, G3)
end

-- Tiny earth peek-through (very sparse)
local earthSpots = {
    {7,5}, {22,12}, {3,20}, {18,27},
}
for _, pos in ipairs(earthSpots) do
    px(img, pos[1], pos[2], E)
end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage1_wilderness\\"
spr:saveCopyAs(outDir .. "env_tile_grass_plain.png")
spr:saveAs(outDir .. "env_tile_grass_plain.aseprite")
