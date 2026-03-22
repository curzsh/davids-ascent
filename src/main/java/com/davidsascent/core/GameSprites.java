package com.davidsascent.core;

import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureFilter;

/**
 * Central registry for all game sprites.
 * All assets are loaded from classpath (inside the JAR).
 * Paths are relative to the assets/ resource root.
 */
public final class GameSprites {

    // Player animations
    public static SpriteSheet davidIdle;
    public static SpriteSheet davidWalk;
    public static SpriteSheet davidHurt;

    // Enemy animations — Stage 1
    public static SpriteSheet lionWalk;
    public static SpriteSheet wolfWalk;
    public static SpriteSheet snakeMove;

    // Enemy animations — Stage 2
    public static SpriteSheet bearWalk;
    public static SpriteSheet boarWalk;

    // Enemy animations — Stage 3
    public static SpriteSheet scoutWalk;
    public static SpriteSheet archerWalk;

    // Enemy animations — Stage 4
    public static SpriteSheet soldierWalk;
    public static SpriteSheet shieldbearerWalk;

    // Boss
    public static SpriteSheet goliathIdle;

    // Projectiles
    public static SpriteSheet slingStone;

    // VFX
    public static SpriteSheet hitStone;
    public static SpriteSheet deathSmall;

    // UI
    public static SpriteSheet xpGem;
    public static Texture healthOrbFull;
    public static Texture healthOrbEmpty;

    // Environment tiles
    public static Texture grassTile;
    public static Texture rockyTile;
    public static Texture dustTile;
    public static Texture battlefieldTile;
    public static Texture valleyTile;

    private GameSprites() {}

    /**
     * Load all sprites from classpath. Call once during init().
     */
    public static void init() {
        // Player (32x32 frames)
        davidIdle = new SpriteSheet("sprites/characters/char_david_idle.png", 32, 32, 6f);
        davidWalk = new SpriteSheet("sprites/characters/char_david_walk.png", 32, 32, 8f);
        davidHurt = new SpriteSheet("sprites/characters/char_david_hurt.png", 32, 32, 12f);
        davidHurt.setLooping(false);

        // Stage 1 enemies (32x32)
        lionWalk = new SpriteSheet("sprites/enemies/enemy_lion_walk.png", 32, 32, 8f);
        wolfWalk = new SpriteSheet("sprites/enemies/enemy_wolf_walk.png", 32, 32, 8f);
        snakeMove = new SpriteSheet("sprites/enemies/enemy_snake_move.png", 32, 32, 8f);

        // Stage 2 enemies (32x32)
        bearWalk = new SpriteSheet("sprites/enemies/enemy_bear_walk.png", 32, 32, 8f);
        boarWalk = new SpriteSheet("sprites/enemies/enemy_boar_walk.png", 32, 32, 8f);

        // Stage 3 enemies (32x32)
        scoutWalk = new SpriteSheet("sprites/enemies/enemy_scout_walk.png", 32, 32, 8f);
        archerWalk = new SpriteSheet("sprites/enemies/enemy_archer_walk.png", 32, 32, 8f);

        // Stage 4 enemies (32x32)
        soldierWalk = new SpriteSheet("sprites/enemies/enemy_soldier_walk.png", 32, 32, 8f);
        shieldbearerWalk = new SpriteSheet("sprites/enemies/enemy_shieldbearer_walk.png", 32, 32, 8f);

        // Boss (48x64 frames)
        goliathIdle = new SpriteSheet("sprites/characters/char_goliath_idle.png", 48, 64, 6f);

        // Projectiles (8x8 frames)
        slingStone = new SpriteSheet("sprites/projectiles/proj_slingstone_fly.png", 8, 8, 8f);

        // VFX
        hitStone = new SpriteSheet("sprites/vfx/vfx_hit_stone_small.png", 16, 16, 16f);
        hitStone.setLooping(false);
        deathSmall = new SpriteSheet("sprites/vfx/vfx_death_small.png", 32, 32, 10f);
        deathSmall.setLooping(false);

        // UI (8x8 frames for gem)
        xpGem = new SpriteSheet("sprites/ui/ui_xpgem_small.png", 8, 8, 4f);

        // Static textures
        healthOrbFull = loadTexture("sprites/ui/ui_health_orb_full.png");
        healthOrbEmpty = loadTexture("sprites/ui/ui_health_orb_empty.png");

        // Stage tiles
        grassTile = loadTexture("sprites/environment/env_tile_grass_plain.png");
        rockyTile = loadTexture("sprites/environment/env_tile_rockyearth_plain.png");
        dustTile = loadTexture("sprites/environment/env_tile_dust_plain.png");
        battlefieldTile = loadTexture("sprites/environment/env_tile_battlefield_plain.png");
        valleyTile = loadTexture("sprites/environment/env_tile_valley_floor.png");
    }

    private static Texture loadTexture(String path) {
        Texture tex = SpriteSheet.loadTextureFromClasspath(path);
        tex.setFilter(TextureFilter.NEAREST);
        return tex;
    }

    public static void dispose() {
        if (davidIdle != null) davidIdle.dispose();
        if (davidWalk != null) davidWalk.dispose();
        if (davidHurt != null) davidHurt.dispose();
        if (lionWalk != null) lionWalk.dispose();
        if (wolfWalk != null) wolfWalk.dispose();
        if (snakeMove != null) snakeMove.dispose();
        if (bearWalk != null) bearWalk.dispose();
        if (boarWalk != null) boarWalk.dispose();
        if (scoutWalk != null) scoutWalk.dispose();
        if (archerWalk != null) archerWalk.dispose();
        if (soldierWalk != null) soldierWalk.dispose();
        if (shieldbearerWalk != null) shieldbearerWalk.dispose();
        if (goliathIdle != null) goliathIdle.dispose();
        if (slingStone != null) slingStone.dispose();
        if (hitStone != null) hitStone.dispose();
        if (deathSmall != null) deathSmall.dispose();
        if (xpGem != null) xpGem.dispose();
        if (healthOrbFull != null) healthOrbFull.dispose();
        if (healthOrbEmpty != null) healthOrbEmpty.dispose();
        if (grassTile != null) grassTile.dispose();
        if (rockyTile != null) rockyTile.dispose();
        if (dustTile != null) dustTile.dispose();
        if (battlefieldTile != null) battlefieldTile.dispose();
        if (valleyTile != null) valleyTile.dispose();
    }
}
