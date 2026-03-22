-- Stone impact VFX - 16x16, 4 frames at 16 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(16, 16, ColorMode.RGB)
spr.filename = "vfx_hit_stone_small.aseprite"

local W  = PALETTE.PURE_WHITE
local L  = PALETTE.SUNLIT_LINEN
local M  = PALETTE.SANDY_BROWN
local D  = PALETTE.DESERT_SIENNA

-- Frame 1: Initial impact
local img = spr.cels[1].image
clear(img)
px(img, 7, 7, W); px(img, 8, 7, W)
px(img, 7, 8, W); px(img, 8, 8, W)
px(img, 6, 7, L); px(img, 9, 7, L)
px(img, 7, 6, L); px(img, 8, 6, L)

-- Frame 2: Expanding
img = newFrame(spr)
clear(img)
px(img, 7, 7, W); px(img, 8, 7, W)
px(img, 7, 8, L); px(img, 8, 8, L)
px(img, 6, 6, L); px(img, 9, 6, L); px(img, 6, 9, L); px(img, 9, 9, L)
px(img, 5, 7, M); px(img, 10, 7, M)
px(img, 7, 5, M); px(img, 8, 5, M)
px(img, 7, 10, M); px(img, 8, 10, M)
px(img, 4, 5, D); px(img, 11, 5, D)
px(img, 4, 10, D); px(img, 11, 9, D)

-- Frame 3: Larger, fading
img = newFrame(spr)
clear(img)
px(img, 7, 7, L); px(img, 8, 7, L)
px(img, 5, 5, M); px(img, 10, 5, M); px(img, 5, 10, M); px(img, 10, 10, M)
px(img, 4, 7, M); px(img, 11, 7, M); px(img, 7, 4, M); px(img, 8, 11, M)
px(img, 3, 4, D); px(img, 12, 4, D); px(img, 3, 11, D); px(img, 12, 11, D)
px(img, 6, 6, L); px(img, 9, 9, L)

-- Frame 4: Dissipating
img = newFrame(spr)
clear(img)
px(img, 4, 4, D); px(img, 11, 4, D)
px(img, 3, 10, D); px(img, 12, 10, D)
px(img, 6, 6, M); px(img, 9, 9, M)
px(img, 7, 7, L)

for i=1,#spr.frames do spr.frames[i].duration = 0.0625 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\vfx\\hits\\"
spr:saveAs(outDir .. "vfx_hit_stone_small.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "vfx_hit_stone_small.png",
    splitLayers=false,
    openGenerated=false,
}
