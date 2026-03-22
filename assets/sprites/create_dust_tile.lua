-- Stage 3 dusty ground tile - 32x32, seamlessly tileable
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "env_tile_dust_plain.aseprite"

local BASE = PALETTE.SANDY_BROWN     -- #C8843C base dust
local HI   = PALETTE.WARM_TAN        -- #E8B46A highlights
local SH   = PALETTE.DESERT_SIENNA   -- #A05C2C shadows

local img = spr.cels[1].image

-- Fill with base dusty color
for y = 0, 31 do for x = 0, 31 do img:drawPixel(x, y, BASE) end end

-- Sparse highlight spots (sun-bleached patches, fewer than grass)
local hiSpots = {
    {5,2}, {17,1}, {28,4},
    {2,9}, {14,8}, {26,10},
    {8,15}, {20,14}, {31,16},
    {3,21}, {16,20}, {29,22},
    {10,27}, {22,26}, {0,29},
    {13,31}, {25,30},
}
for _, pos in ipairs(hiSpots) do
    px(img, pos[1] % 32, pos[2] % 32, HI)
end

-- Shadow spots (subtle depressions in dust)
local shSpots = {
    {8,3}, {21,2}, {0,6},
    {12,10}, {24,9}, {5,12},
    {18,17}, {30,15}, {1,18},
    {10,22}, {23,23}, {7,24},
    {15,28}, {27,27}, {4,30},
    {19,31}, {31,0},
}
for _, pos in ipairs(shSpots) do
    px(img, pos[1] % 32, pos[2] % 32, SH)
end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage3_border\\"
spr:saveCopyAs(outDir .. "env_tile_dust_plain.png")
spr:saveAs(outDir .. "env_tile_dust_plain.aseprite")
