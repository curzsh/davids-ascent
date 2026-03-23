-- Snake enemy move cycle - 4 frames at 8 FPS
-- Redesigned: S-curve serpent, 3px body width, forked tongue, diamond pattern, undulation
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/palette.lua")

local spr = Sprite(32, 32, ColorMode.RGB)
spr.filename = "enemy_snake_move.aseprite"

-- Color aliases
local O   = PALETTE.VOID_BLACK      -- outline
local FD  = PALETTE.DARK_UMBER      -- underside scales
local FM  = PALETTE.TERRACOTTA      -- body shadow (inside curves)
local F   = PALETTE.DESERT_SIENNA   -- body base
local FH  = PALETTE.WARM_TAN        -- body highlight (outside curves)
local DM  = PALETTE.STRAW_GOLD      -- diamond pattern
local EY  = PALETTE.HARVEST_YELLOW  -- eye
local TG  = PALETTE.DANGER_RED      -- forked tongue
local PW  = PALETTE.PURE_WHITE      -- specular

-- Pre-computed S-curve spine: each entry is {x, y} for body center
-- Head at upper-right, curves left then right, tail at lower-left
-- Smooth S-curve: each row shifts x by at most 1px
local BASE_SPINE = {
    -- Head segment (wider, handled separately)
    {x=23, y=4},   -- [1] head center
    {x=23, y=5},   -- [2] head
    {x=23, y=6},   -- [3] head
    -- Neck (2px wide)
    {x=22, y=7},   -- [4] neck
    {x=21, y=8},   -- [5] neck
    -- Body (3px wide, S-curve)
    {x=20, y=9},   -- [6]
    {x=19, y=10},  -- [7]
    {x=18, y=11},  -- [8]
    {x=16, y=12},  -- [9]  first curve peak
    {x=14, y=13},  -- [10]
    {x=12, y=14},  -- [11]
    {x=10, y=15},  -- [12] bottom of first curve
    {x=9,  y=16},  -- [13]
    {x=10, y=17},  -- [14] reversal
    {x=12, y=18},  -- [15]
    {x=14, y=19},  -- [16]
    {x=16, y=20},  -- [17]
    {x=18, y=21},  -- [18] second curve peak
    {x=20, y=22},  -- [19]
    {x=21, y=23},  -- [20]
    {x=20, y=24},  -- [21] reversal
    {x=18, y=25},  -- [22]
    {x=16, y=26},  -- [23] tail narrows to 2px
    {x=14, y=27},  -- [24]
    {x=12, y=28},  -- [25] tail tip
}

local function drawSnake(img, phase)
    clear(img)

    -- Apply phase shift to spine for undulation animation
    -- Phase shifts x positions using sine wave, head stays relatively fixed
    local spine = {}
    for i, seg in ipairs(BASE_SPINE) do
        local sx = seg.x
        local sy = seg.y
        if i > 3 then  -- don't shift the head
            local shift = math.floor(math.sin((i + phase * 1.5) * 0.7) * 1.5 + 0.5)
            sx = sx + shift
        end
        spine[i] = {x=sx, y=sy}
    end

    -- === DRAW BODY SEGMENTS (3px wide with shading based on curve direction) ===
    for i = 6, #spine do
        local seg = spine[i]
        local cx = seg.x
        local y  = seg.y

        -- Determine which side is convex by comparing to neighbors
        local prevX = spine[i-1] and spine[i-1].x or cx
        local nextX = spine[i+1] and spine[i+1].x or cx
        local curving_left = (prevX > cx) or (nextX < cx)

        local left, mid, right
        if curving_left then
            -- Left side is inner/concave = shadow, right is outer = highlight
            left  = FM
            mid   = F
            right = FH
        else
            -- Left is outer/convex = highlight
            left  = FH
            mid   = F
            right = FM
        end

        -- Determine body width (tail segments are narrower)
        local w = 3
        if i >= 23 then w = 2 end  -- tail narrows

        if w == 3 then
            -- Outline
            px(img, cx-1, y, O)
            px(img, cx+3, y, O)
            -- Fill with shading
            px(img, cx,   y, left)
            px(img, cx+1, y, mid)
            px(img, cx+2, y, right)

            -- Diamond pattern: every 3rd segment gets STG center pixel
            if (i % 3) == 0 then
                px(img, cx+1, y, DM)
            end

            -- Underside scale accent (every other segment)
            if (i % 2) == 0 then
                px(img, cx+1, y, FD)
            end
        else
            -- Narrow tail: 2px
            px(img, cx-1, y, O)
            px(img, cx+2, y, O)
            px(img, cx,   y, left)
            px(img, cx+1, y, right)
        end
    end

    -- Neck segments (2px wide)
    for i = 4, 5 do
        local seg = spine[i]
        px(img, seg.x-1, seg.y, O)
        px(img, seg.x,   seg.y, F)
        px(img, seg.x+1, seg.y, FM)
        px(img, seg.x+2, seg.y, O)
    end

    -- === HEAD (4px wide, distinct from 3px body) ===
    local hx = spine[1].x
    local hy = spine[1].y

    -- Head outline
    px(img, hx-1, hy-1, O); px(img, hx, hy-1, O); px(img, hx+1, hy-1, O)
    px(img, hx+2, hy-1, O); px(img, hx+3, hy-1, O)
    px(img, hx-2, hy,   O); px(img, hx+4, hy,   O)
    px(img, hx-2, hy+1, O); px(img, hx+4, hy+1, O)
    px(img, hx-2, hy+2, O); px(img, hx+4, hy+2, O)
    px(img, hx-1, hy+3, O); px(img, hx, hy+3, O); px(img, hx+1, hy+3, O)
    px(img, hx+2, hy+3, O); px(img, hx+3, hy+3, O)

    -- Head fill (5px wide interior)
    px(img, hx-1, hy,   FM); px(img, hx, hy,   F);  px(img, hx+1, hy,   F)
    px(img, hx+2, hy,   FH); px(img, hx+3, hy,   FM)
    px(img, hx-1, hy+1, FM); px(img, hx, hy+1, F);  px(img, hx+1, hy+1, F)
    px(img, hx+2, hy+1, FH); px(img, hx+3, hy+1, FM)
    px(img, hx-1, hy+2, FM); px(img, hx, hy+2, F);  px(img, hx+1, hy+2, F)
    px(img, hx+2, hy+2, F);  px(img, hx+3, hy+2, FM)

    -- Eye (lateral position, upper-right of head)
    px(img, hx+2, hy, O)     -- eye outline
    px(img, hx+2, hy+1, EY)  -- HYL iris
    -- Specular on eye
    px(img, hx+2, hy, PW)

    -- === FORKED TONGUE (Y-shape: stem + 2 fork tips) ===
    -- Tongue extends from snout (top of head)
    px(img, hx+1, hy-1, TG)  -- stem (overwrite outline)
    px(img, hx,   hy-2, TG)  -- left fork tip
    px(img, hx+2, hy-2, TG)  -- right fork tip

    -- === TAIL TIP ===
    local last = spine[#spine]
    px(img, last.x, last.y+1, O)
    px(img, last.x+1, last.y+1, O)
end

-- Frame 1: Base S-curve position
drawSnake(spr.cels[1].image, 0)

-- Frame 2: Phase shift 1
local img2 = newFrame(spr)
drawSnake(img2, 1)

-- Frame 3: Phase shift 2
local img3 = newFrame(spr)
drawSnake(img3, 2)

-- Frame 4: Phase shift 3
local img4 = newFrame(spr)
drawSnake(img4, 3)

for i=1,#spr.frames do spr.frames[i].duration = 0.125 end

local outDir = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\enemies\\env2_snake\\"
os.execute('mkdir "' .. outDir .. '" 2>NUL')
spr:saveAs(outDir .. "enemy_snake_move.aseprite")

app.command.ExportSpriteSheet{
    ui=false,
    type=SpriteSheetType.HORIZONTAL,
    textureFilename=outDir .. "enemy_snake_move.png",
    splitLayers=false,
    openGenerated=false,
}
