-- David idle animation - 4 frames, breathing bob at 6 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "char_david_idle.aseprite"

-- Frame 1: Base position (cel already exists)
local img1 = spr.cels[1].image
clear(img1)
drawDavidBase(img1, 0, 0)

-- Frame 2: 1px up
local img2 = newFrame(spr)
clear(img2)
drawDavidBase(img2, 0, -1)

-- Frame 3: 1px up (hold)
local img3 = newFrame(spr)
clear(img3)
drawDavidBase(img3, 0, -1)

-- Frame 4: Back to base
local img4 = newFrame(spr)
clear(img4)
drawDavidBase(img4, 0, 0)

-- Set frame durations (6 FPS = ~167ms per frame)
for i=1,#spr.frames do spr.frames[i].duration = 0.167 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\characters\\"
spr:saveAs(outDir .. "char_david_idle.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "char_david_idle.png",
    splitLayers=false,
    openGenerated=false,
}
