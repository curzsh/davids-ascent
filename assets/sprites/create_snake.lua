-- Snake enemy move cycle - 4 frames at 8 FPS
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_snake_move.aseprite"

local O  = PALETTE.VOID_BLACK
local FD = PALETTE.DEEP_OLIVE       -- dark base
local FM = PALETTE.MEADOW_GREEN     -- mid green
local FH = PALETTE.SAGE_LIGHT       -- highlight
local EY = PALETTE.HARVEST_YELLOW   -- beady eyes
local N  = PALETTE.DARK_UMBER       -- tongue/mouth

-- Snake body segments as a series of points forming an S-curve
-- The snake is low to the ground, occupying roughly y=18-26
-- Each frame shifts the curves to animate slithering

local function drawSnake(img, phase)
    clear(img)

    local function p(x, y, c) px(img, x, y, c) end
    local function hl(x1, x2, y, c) for x=x1,x2 do p(x, y, c) end end

    -- Head (always roughly at right side, facing right)
    -- Head position shifts slightly with phase
    local hx = 22
    local hy = 18 + phase

    -- Head (3x3 block)
    p(hx, hy, FM); p(hx+1, hy, FM); p(hx+2, hy, FH)
    p(hx, hy+1, FM); p(hx+1, hy+1, FD); p(hx+2, hy+1, FM)
    p(hx, hy+2, FM); p(hx+1, hy+2, FM); p(hx+2, hy+2, FD)

    -- Eyes (beady)
    p(hx+1, hy, EY); p(hx+2, hy, EY)

    -- Tongue (flickers based on phase)
    if phase == 0 or phase == 2 then
        p(hx+3, hy+1, N); p(hx+4, hy+1, N)
        p(hx+5, hy, N); p(hx+5, hy+2, N)
    else
        p(hx+3, hy+1, N)
    end

    -- Head outline
    hl(hx-1, hx+2, hy-1, O)
    p(hx+3, hy, O); p(hx+3, hy-1, O)
    p(hx-1, hy, O); p(hx-1, hy+1, O); p(hx-1, hy+2, O)
    p(hx+3, hy+2, O); p(hx+3, hy+3, O)
    hl(hx-1, hx+2, hy+3, O)

    -- Body: S-curve that shifts per frame
    -- The body goes from head leftward in a sinusoidal pattern
    -- Each segment is 2px wide (top highlight, bottom shadow)
    local segments = {
        -- {x, y} positions forming the S-curve, phase shifts y
        {hx-1, hy+1},
        {hx-2, hy+1},
        {hx-3, hy+2 - phase%2},
        {hx-4, hy+2},
        {hx-5, hy+3 - phase%2},
        {hx-6, hy+3},
        {hx-7, hy+2 + phase%2},
        {hx-8, hy+2},
        {hx-9, hy+1 + phase%2},
        {hx-10, hy+1},
        {hx-11, hy+2 - phase%2},
        {hx-12, hy+2},
        {hx-13, hy+3 - phase%2},
        {hx-14, hy+3},
        {hx-15, hy+2 + phase%2},
        {hx-16, hy+2},
        {hx-17, hy+1 + phase%2},
        {hx-18, hy+1},
    }

    for _, seg in ipairs(segments) do
        local sx, sy = seg[1], seg[2]
        -- Body: 2px tall segment
        p(sx, sy, FM)
        p(sx, sy-1, FH)  -- highlight top
        p(sx, sy+1, FD)  -- shadow bottom
        -- Outline top and bottom
        p(sx, sy-2, O)
        p(sx, sy+2, O)
    end

    -- Tail (tapers at the end)
    local tx = hx - 19
    local ty = segments[#segments][2]
    p(tx, ty, FD)
    p(tx, ty-1, O); p(tx, ty+1, O)
    p(tx-1, ty, O)
end

-- Frame 1
drawSnake(spr.cels[1].image, 0)

-- Frame 2
local img2 = newFrame(spr)
drawSnake(img2, 1)

-- Frame 3
local img3 = newFrame(spr)
drawSnake(img3, 2)

-- Frame 4
local img4 = newFrame(spr)
drawSnake(img4, 1)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env1_snake\\"
os.execute('mkdir "' .. outDir:gsub("\\$","") .. '" 2>nul')
spr:saveAs(outDir .. "enemy_snake_move.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_snake_move.png",
    splitLayers=false,
    openGenerated=false,
}
