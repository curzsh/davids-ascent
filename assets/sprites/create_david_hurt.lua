-- David hurt animation - 2 frames at 12 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "char_david_hurt.aseprite"

-- Frame 1: White flash
local img1 = spr.cels[1].image
clear(img1)
drawDavidBase(img1, 0, 0)
-- Replace all non-transparent pixels with white
for y=0,31 do
    for x=0,31 do
        local c = img1:getPixel(x, y)
        local a = app.pixelColor.rgbaA(c)
        if a > 0 then
            img1:drawPixel(x, y, PALETTE.PURE_WHITE)
        end
    end
end

-- Frame 2: Recoil (shifted 2px right)
local img2 = newFrame(spr)
clear(img2)
drawDavidBase(img2, 2, 0)

for i=1,#spr.frames do spr.frames[i].duration = 0.083 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\characters\\"
spr:saveAs(outDir .. "char_david_hurt.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "char_david_hurt.png",
    splitLayers=false,
    openGenerated=false,
}
