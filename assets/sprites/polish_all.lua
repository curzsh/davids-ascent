-- Batch polish all game sprites
-- Applies colored outlines, hue-shifted shading, and edge highlights
dofile("C:/code/Valthorne_David_Vs_Goliath/my-game/assets/sprites/polish_sprite.lua")

local BASE = "C:\\code\\Valthorne_David_Vs_Goliath\\my-game\\assets\\sprites\\"

-- List of all sprites to polish: {aseprite source, output aseprite, output png}
local sprites = {
    -- Player
    {
        BASE .. "characters\\char_david_idle.aseprite",
        BASE .. "characters\\char_david_idle.aseprite",
        BASE .. "characters\\char_david_idle.png",
    },
    {
        BASE .. "characters\\char_david_walk.aseprite",
        BASE .. "characters\\char_david_walk.aseprite",
        BASE .. "characters\\char_david_walk.png",
    },
    {
        BASE .. "characters\\char_david_hurt.aseprite",
        BASE .. "characters\\char_david_hurt.aseprite",
        BASE .. "characters\\char_david_hurt.png",
    },
    -- Goliath
    {
        BASE .. "characters\\char_goliath_idle.aseprite",
        BASE .. "characters\\char_goliath_idle.aseprite",
        BASE .. "characters\\char_goliath_idle.png",
    },
    -- Stage 1 enemies
    {
        BASE .. "enemies\\env1_lion\\enemy_lion_walk.aseprite",
        BASE .. "enemies\\env1_lion\\enemy_lion_walk.aseprite",
        BASE .. "enemies\\env1_lion\\enemy_lion_walk.png",
    },
    {
        BASE .. "enemies\\env1_wolf\\enemy_wolf_walk.aseprite",
        BASE .. "enemies\\env1_wolf\\enemy_wolf_walk.aseprite",
        BASE .. "enemies\\env1_wolf\\enemy_wolf_walk.png",
    },
    {
        BASE .. "enemies\\env1_snake\\enemy_snake_move.aseprite",
        BASE .. "enemies\\env1_snake\\enemy_snake_move.aseprite",
        BASE .. "enemies\\env1_snake\\enemy_snake_move.png",
    },
    -- Stage 2 enemies
    {
        BASE .. "enemies\\env2_bear\\enemy_bear_walk.aseprite",
        BASE .. "enemies\\env2_bear\\enemy_bear_walk.aseprite",
        BASE .. "enemies\\env2_bear\\enemy_bear_walk.png",
    },
    {
        BASE .. "enemies\\env2_boar\\enemy_boar_walk.aseprite",
        BASE .. "enemies\\env2_boar\\enemy_boar_walk.aseprite",
        BASE .. "enemies\\env2_boar\\enemy_boar_walk.png",
    },
    -- Stage 3 enemies
    {
        BASE .. "enemies\\env3_scout\\enemy_scout_walk.aseprite",
        BASE .. "enemies\\env3_scout\\enemy_scout_walk.aseprite",
        BASE .. "enemies\\env3_scout\\enemy_scout_walk.png",
    },
    {
        BASE .. "enemies\\env3_archer\\enemy_archer_walk.aseprite",
        BASE .. "enemies\\env3_archer\\enemy_archer_walk.aseprite",
        BASE .. "enemies\\env3_archer\\enemy_archer_walk.png",
    },
    -- Stage 4 enemies
    {
        BASE .. "enemies\\env4_soldier\\enemy_soldier_walk.aseprite",
        BASE .. "enemies\\env4_soldier\\enemy_soldier_walk.aseprite",
        BASE .. "enemies\\env4_soldier\\enemy_soldier_walk.png",
    },
    {
        BASE .. "enemies\\env4_shieldbearer\\enemy_shieldbearer_walk.aseprite",
        BASE .. "enemies\\env4_shieldbearer\\enemy_shieldbearer_walk.aseprite",
        BASE .. "enemies\\env4_shieldbearer\\enemy_shieldbearer_walk.png",
    },
}

print("=== Polishing all sprites ===")
print("")

local success = 0
local failed = 0

for _, entry in ipairs(sprites) do
    local input, outAse, outPng = entry[1], entry[2], entry[3]
    print("Polishing: " .. input)
    if polishFile(input, outAse, outPng) then
        success = success + 1
        print("  OK")
    else
        failed = failed + 1
        print("  FAILED")
    end
    print("")
end

print(string.format("=== Done: %d polished, %d failed ===", success, failed))
