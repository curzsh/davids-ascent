-- XP gem (small) - 8x8, 2-frame sparkle
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(8, 8, ColorMode.RGB)
spr.filename = "ui_xpgem_small.aseprite"

local Y  = PALETTE.HARVEST_YELLOW
local YH = PALETTE.SUNLIT_LINEN
local YD = PALETTE.STRAW_GOLD
local W  = PALETTE.PURE_WHITE
local O  = PALETTE.AGED_BRASS

-- Frame 1: Base gem
local img = spr.cels[1].image
clear(img)
px(img, 3, 1, O); px(img, 4, 1, O)
px(img, 2, 2, O); px(img, 3, 2, YH); px(img, 4, 2, Y); px(img, 5, 2, O)
px(img, 1, 3, O); px(img, 2, 3, YH); px(img, 3, 3, Y); px(img, 4, 3, Y); px(img, 5, 3, YD); px(img, 6, 3, O)
px(img, 1, 4, O); px(img, 2, 4, Y); px(img, 3, 4, Y); px(img, 4, 4, YD); px(img, 5, 4, YD); px(img, 6, 4, O)
px(img, 2, 5, O); px(img, 3, 5, YD); px(img, 4, 5, YD); px(img, 5, 5, O)
px(img, 3, 6, O); px(img, 4, 6, O)

-- Frame 2: Sparkle
img = newFrame(spr)
clear(img)
px(img, 3, 1, O); px(img, 4, 1, O)
px(img, 2, 2, O); px(img, 3, 2, Y); px(img, 4, 2, YH); px(img, 5, 2, O)
px(img, 1, 3, O); px(img, 2, 3, Y); px(img, 3, 3, W); px(img, 4, 3, YH); px(img, 5, 3, Y); px(img, 6, 3, O)
px(img, 1, 4, O); px(img, 2, 4, Y); px(img, 3, 4, YH); px(img, 4, 4, Y); px(img, 5, 4, YD); px(img, 6, 4, O)
px(img, 2, 5, O); px(img, 3, 5, Y); px(img, 4, 5, YD); px(img, 5, 5, O)
px(img, 3, 6, O); px(img, 4, 6, O)

for i=1,#spr.frames do spr.frames[i].duration = 0.25 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\ui\\hud\\"
spr:saveAs(outDir .. "ui_xpgem_small.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "ui_xpgem_small.png",
    splitLayers=false,
    openGenerated=false,
}
