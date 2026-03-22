-- Small enemy death VFX - 32x32, 6 frames at 10 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "vfx_death_small.aseprite"

local W  = PALETTE.PURE_WHITE
local Y  = PALETTE.HARVEST_YELLOW
local G  = PALETTE.STRAW_GOLD
local L  = PALETTE.SUNLIT_LINEN
local D  = PALETTE.WARM_TAN

-- Frame 1: Initial flash
local img = spr.cels[1].image
clear(img)
px(img, 15, 15, W); px(img, 16, 15, W); px(img, 15, 16, W); px(img, 16, 16, W)
px(img, 14, 15, Y); px(img, 17, 15, Y); px(img, 15, 14, Y); px(img, 16, 14, Y)
px(img, 15, 17, Y); px(img, 16, 17, Y)

-- Frame 2: Expanding star
img = newFrame(spr)
clear(img)
px(img, 15, 15, W); px(img, 16, 15, W); px(img, 15, 16, W); px(img, 16, 16, W)
px(img, 13, 15, Y); px(img, 18, 15, Y); px(img, 15, 13, Y); px(img, 16, 18, Y)
px(img, 12, 15, L); px(img, 19, 16, L); px(img, 15, 12, L); px(img, 16, 19, L)
px(img, 13, 13, Y); px(img, 18, 13, Y); px(img, 13, 18, Y); px(img, 18, 18, Y)

-- Frame 3: Max expansion
img = newFrame(spr)
clear(img)
px(img, 15, 15, L); px(img, 16, 16, L)
px(img, 10, 15, Y); px(img, 21, 15, Y); px(img, 15, 10, Y); px(img, 16, 21, Y)
px(img, 11, 11, Y); px(img, 20, 11, Y); px(img, 11, 20, Y); px(img, 20, 20, Y)
px(img, 9, 14, G); px(img, 22, 16, G); px(img, 14, 9, G); px(img, 17, 22, G)
px(img, 8, 12, L); px(img, 23, 12, L); px(img, 8, 19, L); px(img, 23, 19, L)

-- Frame 4: Dissipating
img = newFrame(spr)
clear(img)
px(img, 8, 14, G); px(img, 23, 14, G); px(img, 14, 8, G); px(img, 17, 23, G)
px(img, 9, 9, D); px(img, 22, 9, D); px(img, 9, 22, D); px(img, 22, 22, D)
px(img, 6, 11, L); px(img, 25, 11, L); px(img, 6, 20, L); px(img, 25, 20, L)
px(img, 15, 15, G)

-- Frame 5: Nearly gone
img = newFrame(spr)
clear(img)
px(img, 6, 10, D); px(img, 25, 10, D); px(img, 6, 21, D); px(img, 25, 21, D)
px(img, 4, 8, G); px(img, 27, 8, G)
px(img, 14, 14, L)

-- Frame 6: Final twinkle
img = newFrame(spr)
clear(img)
px(img, 4, 7, D); px(img, 27, 7, D)
px(img, 15, 15, L)

for i=1,#spr.frames do spr.frames[i].duration = 0.1 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\vfx\\deaths\\"
spr:saveAs(outDir .. "vfx_death_small.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "vfx_death_small.png",
    splitLayers=false,
    openGenerated=false,
}
