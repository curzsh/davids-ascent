-- Sprite Polishing Script
-- Applies professional pixel art techniques to an existing sprite:
--   1. Selective colored outlines (outlines tinted by nearby fill colors)
--   2. Auto-shading enhancement (darken lower-right, lighten upper-left)
--   3. Sub-pixel edge smoothing at color boundaries
--
-- Usage: Run in Aseprite with a sprite open, or call polishFile(path)

-- Helper: get pixel color components
local function rgba(c)
    return app.pixelColor.rgbaR(c),
           app.pixelColor.rgbaG(c),
           app.pixelColor.rgbaB(c),
           app.pixelColor.rgbaA(c)
end

local function makeColor(r, g, b, a)
    return app.pixelColor.rgba(
        math.max(0, math.min(255, math.floor(r))),
        math.max(0, math.min(255, math.floor(g))),
        math.max(0, math.min(255, math.floor(b))),
        math.max(0, math.min(255, math.floor(a or 255)))
    )
end

local function isTransparent(c)
    return app.pixelColor.rgbaA(c) == 0
end

local function isOutline(c)
    local r, g, b, a = rgba(c)
    return a > 0 and r < 40 and g < 20 and b < 10
end

-- Darken a color (shift toward blue/purple for hue-shifted shadows)
local function darken(c, amount)
    local r, g, b, a = rgba(c)
    -- Hue shift: shadows go slightly cooler (more blue)
    r = r * (1 - amount * 0.9)
    g = g * (1 - amount * 0.85)
    b = b * (1 - amount * 0.6)  -- blue drops less = cooler shadow
    return makeColor(r, g, b, a)
end

-- Lighten a color (shift toward yellow/warm for highlights)
local function lighten(c, amount)
    local r, g, b, a = rgba(c)
    -- Hue shift: highlights go slightly warmer
    r = r + (255 - r) * amount * 0.9
    g = g + (255 - g) * amount * 0.75
    b = b + (255 - b) * amount * 0.4  -- blue rises less = warmer highlight
    return makeColor(r, g, b, a)
end

-- Blend two colors
local function blend(c1, c2, t)
    local r1, g1, b1, a1 = rgba(c1)
    local r2, g2, b2, a2 = rgba(c2)
    return makeColor(
        r1 + (r2 - r1) * t,
        g1 + (g2 - g1) * t,
        b1 + (b2 - b1) * t,
        a1 + (a2 - a1) * t
    )
end

-- Get average color of non-transparent, non-outline neighbors
local function avgNeighborColor(img, x, y, w, h)
    local totalR, totalG, totalB, count = 0, 0, 0, 0
    for dy = -1, 1 do
        for dx = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local nx, ny = x + dx, y + dy
                if nx >= 0 and nx < w and ny >= 0 and ny < h then
                    local c = img:getPixel(nx, ny)
                    if not isTransparent(c) and not isOutline(c) then
                        local r, g, b = rgba(c)
                        totalR = totalR + r
                        totalG = totalG + g
                        totalB = totalB + b
                        count = count + 1
                    end
                end
            end
        end
    end
    if count == 0 then return nil end
    return makeColor(totalR / count, totalG / count, totalB / count, 255)
end

-- Check if pixel is on the edge of the sprite (adjacent to transparent)
local function isEdgePixel(img, x, y, w, h)
    for dy = -1, 1 do
        for dx = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local nx, ny = x + dx, y + dy
                if nx < 0 or nx >= w or ny < 0 or ny >= h then
                    return true
                end
                if isTransparent(img:getPixel(nx, ny)) then
                    return true
                end
            end
        end
    end
    return false
end

-- PASS 1: Selective colored outlines
-- Replace pure black outlines with darkened versions of nearby fill colors
local function colorizeOutlines(img, w, h)
    -- First collect which pixels to change (don't modify while reading)
    local changes = {}
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local c = img:getPixel(x, y)
            if isOutline(c) then
                local neighbor = avgNeighborColor(img, x, y, w, h)
                if neighbor then
                    -- Make a very dark version of the neighbor color
                    local tinted = darken(neighbor, 0.7)
                    table.insert(changes, {x = x, y = y, c = tinted})
                end
            end
        end
    end
    for _, ch in ipairs(changes) do
        img:drawPixel(ch.x, ch.y, ch.c)
    end
    return #changes
end

-- PASS 2: Light-direction shading enhancement
-- Subtly darken pixels toward lower-right, lighten toward upper-left
local function enhanceShading(img, w, h)
    local changes = {}
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local c = img:getPixel(x, y)
            if not isTransparent(c) and not isOutline(c) then
                -- Normalized position (0-1)
                local nx = x / w
                local ny = y / h
                -- Light from upper-left: distance from (0,0)
                local lightDist = math.sqrt(nx * nx + ny * ny) / 1.414
                -- Subtle adjustment: -0.08 to +0.08
                local adjustment = (lightDist - 0.4) * 0.15

                local newC
                if adjustment > 0 then
                    newC = darken(c, adjustment)
                else
                    newC = lighten(c, -adjustment)
                end
                if newC ~= c then
                    table.insert(changes, {x = x, y = y, c = newC})
                end
            end
        end
    end
    for _, ch in ipairs(changes) do
        img:drawPixel(ch.x, ch.y, ch.c)
    end
    return #changes
end

-- PASS 3: Edge highlight/shadow
-- Add a subtle highlight on upper-left edges, shadow on lower-right edges
local function edgeHighlightShadow(img, w, h)
    local changes = {}
    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local c = img:getPixel(x, y)
            if not isTransparent(c) and not isOutline(c) and isEdgePixel(img, x, y, w, h) then
                -- Check which direction the transparency is
                local topEmpty = (y == 0) or isTransparent(img:getPixel(x, math.max(0, y - 1)))
                local leftEmpty = (x == 0) or isTransparent(img:getPixel(math.max(0, x - 1), y))
                local bottomEmpty = (y == h - 1) or isTransparent(img:getPixel(x, math.min(h - 1, y + 1)))
                local rightEmpty = (x == w - 1) or isTransparent(img:getPixel(math.min(w - 1, x + 1), y))

                if topEmpty or leftEmpty then
                    -- Upper-left edge = highlight
                    table.insert(changes, {x = x, y = y, c = lighten(c, 0.15)})
                elseif bottomEmpty or rightEmpty then
                    -- Lower-right edge = shadow
                    table.insert(changes, {x = x, y = y, c = darken(c, 0.12)})
                end
            end
        end
    end
    for _, ch in ipairs(changes) do
        img:drawPixel(ch.x, ch.y, ch.c)
    end
    return #changes
end

-- Apply all polish passes to a single image
local function polishImage(img)
    local w, h = img.width, img.height
    local c1 = colorizeOutlines(img, w, h)
    local c2 = enhanceShading(img, w, h)
    local c3 = edgeHighlightShadow(img, w, h)
    return c1, c2, c3
end

-- Process a sprite file
function polishFile(inputPath, outputAseprite, outputPng, frameW, frameH)
    local spr = app.open(inputPath)
    if not spr then
        print("ERROR: Could not open " .. inputPath)
        return false
    end

    -- Polish each frame
    for i, cel in ipairs(spr.cels) do
        local c1, c2, c3 = polishImage(cel.image)
        print(string.format("  Frame %d: %d outline, %d shading, %d edge changes", i, c1, c2, c3))
    end

    -- Save
    if outputAseprite then
        spr:saveAs(outputAseprite)
    end

    -- Export sprite sheet if multi-frame
    if outputPng and #spr.frames > 1 then
        app.command.ExportSpriteSheet{
            ui = false,
            type = SpriteSheetType.HORIZONTAL,
            textureFilename = outputPng,
            splitLayers = false,
            openGenerated = false,
        }
    elseif outputPng then
        spr:saveCopyAs(outputPng)
    end

    spr:close()
    return true
end
