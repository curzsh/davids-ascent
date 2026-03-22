-- Sling stone projectile - 8x8, 2 frames spinning
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(8, 8, ColorMode.RGB)
spr.filename = "proj_slingstone_fly.aseprite"

local O  = PALETTE.VOID_BLACK
local SD = PALETTE.SLATE_GREY
local SM = PALETTE.STONE_WHITE
local SH = PALETTE.PURE_WHITE

-- Frame 1: Stone rotation A
local img1 = spr.cels[1].image
clear(img1)
px(img1, 2, 1, O); px(img1, 3, 1, O); px(img1, 4, 1, O); px(img1, 5, 1, O)
px(img1, 1, 2, O); px(img1, 2, 2, SD); px(img1, 3, 2, SD); px(img1, 4, 2, SM); px(img1, 5, 2, SM); px(img1, 6, 2, O)
px(img1, 1, 3, O); px(img1, 2, 3, SD); px(img1, 3, 3, SM); px(img1, 4, 3, SM); px(img1, 5, 3, SH); px(img1, 6, 3, O)
px(img1, 1, 4, O); px(img1, 2, 4, SD); px(img1, 3, 4, SD); px(img1, 4, 4, SM); px(img1, 5, 4, SM); px(img1, 6, 4, O)
px(img1, 1, 5, O); px(img1, 2, 5, SD); px(img1, 3, 5, SD); px(img1, 4, 5, SD); px(img1, 5, 5, SM); px(img1, 6, 5, O)
px(img1, 2, 6, O); px(img1, 3, 6, O); px(img1, 4, 6, O); px(img1, 5, 6, O)

-- Frame 2: Stone rotation B
local img2 = newFrame(spr)
clear(img2)
px(img2, 2, 1, O); px(img2, 3, 1, O); px(img2, 4, 1, O); px(img2, 5, 1, O)
px(img2, 1, 2, O); px(img2, 2, 2, SM); px(img2, 3, 2, SD); px(img2, 4, 2, SD); px(img2, 5, 2, SM); px(img2, 6, 2, O)
px(img2, 1, 3, O); px(img2, 2, 3, SM); px(img2, 3, 3, SH); px(img2, 4, 3, SM); px(img2, 5, 3, SD); px(img2, 6, 3, O)
px(img2, 1, 4, O); px(img2, 2, 4, SM); px(img2, 3, 4, SM); px(img2, 4, 4, SD); px(img2, 5, 4, SD); px(img2, 6, 4, O)
px(img2, 1, 5, O); px(img2, 2, 5, SD); px(img2, 3, 5, SD); px(img2, 4, 5, SD); px(img2, 5, 5, SD); px(img2, 6, 5, O)
px(img2, 2, 6, O); px(img2, 3, 6, O); px(img2, 4, 6, O); px(img2, 5, 6, O)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\projectiles\\"
spr:saveAs(outDir .. "proj_slingstone_fly.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "proj_slingstone_fly.png",
    splitLayers=false,
    openGenerated=false,
}
