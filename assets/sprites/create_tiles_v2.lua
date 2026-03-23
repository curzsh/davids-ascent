-- Redesigned stage tiles - darker, more muted backgrounds that don't clash with sprites
-- These serve as BACKGROUNDS, not focal points. Low contrast, low saturation.
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

-- Darker versions of palette colors for backgrounds
local function darken(c, amount)
    return Color{
        r = math.floor(c.red * (1 - amount)),
        g = math.floor(c.green * (1 - amount)),
        b = math.floor(c.blue * (1 - amount)),
        a = 255
    }
end

-- ===== STAGE 1: Wilderness (dark green-brown grass) =====
local spr1 = Sprite(32, 32, ColorMode.RGB)
local img1 = spr1.cels[1].image
local bg1 = darken(PALETTE.DEEP_OLIVE, 0.3)       -- very dark olive base
local d1  = darken(PALETTE.DEEP_OLIVE, 0.5)        -- darker patches
local l1  = darken(PALETTE.MEADOW_GREEN, 0.4)      -- subtle lighter grass

for y=0,31 do for x=0,31 do img1:drawPixel(x, y, bg1) end end
-- Sparse, subtle variation
local spots1 = {{3,2},{14,5},{25,8},{8,12},{19,15},{30,18},{4,22},{15,25},{26,28},{9,30}}
for _, s in ipairs(spots1) do px(img1, s[1], s[2], l1) end
local dark1 = {{7,4},{18,9},{1,14},{22,19},{11,24},{5,29},{27,1},{16,27}}
for _, s in ipairs(dark1) do px(img1, s[1], s[2], d1) end

local outDir1 = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage1_wilderness\\"
os.execute('mkdir "' .. outDir1 .. '" 2>NUL')
spr1:saveCopyAs(outDir1 .. "env_tile_grass_plain.png")
spr1:saveAs(outDir1 .. "env_tile_grass_plain.aseprite")

-- ===== STAGE 2: Rocky Hills (dark brown-grey) =====
local spr2 = Sprite(32, 32, ColorMode.RGB)
local img2 = spr2.cels[1].image
local bg2 = darken(PALETTE.TERRACOTTA, 0.5)        -- dark brown-grey
local d2  = darken(PALETTE.DARK_UMBER, 0.2)        -- very dark
local l2  = darken(PALETTE.DESERT_SIENNA, 0.4)     -- slightly lighter brown
local r2  = darken(PALETTE.SLATE_GREY, 0.5)        -- dark rock

for y=0,31 do for x=0,31 do img2:drawPixel(x, y, bg2) end end
local spots2 = {{5,3},{16,7},{27,11},{8,16},{19,20},{2,25},{13,29},{24,4},{10,22}}
for _, s in ipairs(spots2) do px(img2, s[1], s[2], l2) end
-- Rock fragments (2px clusters)
px(img2, 7, 5, r2); px(img2, 8, 5, r2)
px(img2, 22, 14, r2); px(img2, 23, 14, r2)
px(img2, 3, 21, r2); px(img2, 4, 21, r2)
local darkr2 = {{12,8},{25,17},{6,26},{18,2},{29,22}}
for _, s in ipairs(darkr2) do px(img2, s[1], s[2], d2) end

local outDir2 = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage2_hills\\"
os.execute('mkdir "' .. outDir2 .. '" 2>NUL')
spr2:saveCopyAs(outDir2 .. "env_tile_rockyearth_plain.png")
spr2:saveAs(outDir2 .. "env_tile_rockyearth_plain.aseprite")

-- ===== STAGE 3: Border (dark dusty tan) =====
local spr3 = Sprite(32, 32, ColorMode.RGB)
local img3 = spr3.cels[1].image
local bg3 = darken(PALETTE.DESERT_SIENNA, 0.5)     -- dark dusty
local d3  = darken(PALETTE.DARK_UMBER, 0.3)
local l3  = darken(PALETTE.SANDY_BROWN, 0.5)

for y=0,31 do for x=0,31 do img3:drawPixel(x, y, bg3) end end
local spots3 = {{4,3},{17,8},{28,15},{9,21},{20,27},{1,11},{12,30}}
for _, s in ipairs(spots3) do px(img3, s[1], s[2], l3) end
local dark3 = {{8,6},{21,12},{3,18},{14,24},{26,3},{11,28}}
for _, s in ipairs(dark3) do px(img3, s[1], s[2], d3) end

local outDir3 = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage3_border\\"
os.execute('mkdir "' .. outDir3 .. '" 2>NUL')
spr3:saveCopyAs(outDir3 .. "env_tile_dust_plain.png")
spr3:saveAs(outDir3 .. "env_tile_dust_plain.aseprite")

-- ===== STAGE 4: Battlefield (dark churned earth) =====
local spr4 = Sprite(32, 32, ColorMode.RGB)
local img4 = spr4.cels[1].image
local bg4 = darken(PALETTE.DARK_UMBER, 0.2)        -- very dark brown
local d4  = Color{ r=15, g=8, b=3, a=255 }         -- near black
local l4  = darken(PALETTE.TERRACOTTA, 0.5)

for y=0,31 do for x=0,31 do img4:drawPixel(x, y, bg4) end end
-- Torn earth streaks (horizontal 3-4px)
for x=5,8 do px(img4, x, 7, d4) end
for x=18,22 do px(img4, x, 16, d4) end
for x=2,5 do px(img4, x, 24, d4) end
local spots4 = {{10,4},{23,10},{6,18},{15,26},{28,8},{3,30}}
for _, s in ipairs(spots4) do px(img4, s[1], s[2], l4) end

local outDir4 = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage4_battlefield\\"
os.execute('mkdir "' .. outDir4 .. '" 2>NUL')
spr4:saveCopyAs(outDir4 .. "env_tile_battlefield_plain.png")
spr4:saveAs(outDir4 .. "env_tile_battlefield_plain.aseprite")

-- ===== STAGE 5: Valley of Elah (dark grey-brown with stones) =====
local spr5 = Sprite(32, 32, ColorMode.RGB)
local img5 = spr5.cels[1].image
local bg5 = darken(PALETTE.TERRACOTTA, 0.55)       -- dark earth
local d5  = darken(PALETTE.DARK_UMBER, 0.3)
local l5  = darken(PALETTE.SLATE_GREY, 0.5)        -- dark stone
local s5  = darken(PALETTE.STONE_WHITE, 0.6)       -- stone highlight

for y=0,31 do for x=0,31 do img5:drawPixel(x, y, bg5) end end
-- Subtle river stones (small clusters)
px(img5, 8, 6, l5); px(img5, 9, 6, l5); px(img5, 8, 7, s5)
px(img5, 22, 15, l5); px(img5, 23, 15, l5); px(img5, 22, 16, s5)
px(img5, 5, 23, l5); px(img5, 6, 23, l5)
px(img5, 28, 28, l5)
local dark5 = {{12,4},{25,11},{3,18},{16,26},{20,3}}
for _, s in ipairs(dark5) do px(img5, s[1], s[2], d5) end

local outDir5 = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\environment\\stage5_valley\\"
os.execute('mkdir "' .. outDir5 .. '" 2>NUL')
spr5:saveCopyAs(outDir5 .. "env_tile_valley_floor.png")
spr5:saveAs(outDir5 .. "env_tile_valley_floor.aseprite")

print("All 5 tiles regenerated (dark, muted backgrounds)")
