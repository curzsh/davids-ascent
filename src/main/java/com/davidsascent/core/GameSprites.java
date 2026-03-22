package com.davidsascent.core;

import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureFilter;

/**
 * Central registry for all game sprites.
 * All assets are loaded from classpath (inside the JAR).
 * Paths are relative to the resources/assets/ directory.
 */
public final class GameSprites {

    // Player animations
    public static SpriteSheet davidIdle;
    public static SpriteSheet davidWalk;
    public static SpriteSheet davidHurt;

    // Enemy animations
    public static SpriteSheet lionWalk;

    // Projectiles
    public static SpriteSheet slingStone;

    // VFX
    public static SpriteSheet hitStone;
    public static SpriteSheet deathSmall;

    // UI
    public static SpriteSheet xpGem;
    public static Texture healthOrbFull;
    public static Texture healthOrbEmpty;

    // Environment
    public static Texture grassTile;

    private GameSprites() {}

    /**
     * Load all Tier 1 sprites from classpath. Call once during init().
     */
    public static void init() {
        // Player (32x32 frames)
        davidIdle = new SpriteSheet("sprites/characters/char_david_idle.png", 32, 32, 6f);
        davidWalk = new SpriteSheet("sprites/characters/char_david_walk.png", 32, 32, 8f);
        davidHurt = new SpriteSheet("sprites/characters/char_david_hurt.png", 32, 32, 12f);
        davidHurt.setLooping(false);

        // Enemies
        lionWalk = new SpriteSheet("sprites/enemies/enemy_lion_walk.png", 32, 32, 8f);

        // Projectiles (8x8 frames)
        slingStone = new SpriteSheet("sprites/projectiles/proj_slingstone_fly.png", 8, 8, 8f);

        // VFX
        hitStone = new SpriteSheet("sprites/vfx/vfx_hit_stone_small.png", 16, 16, 16f);
        hitStone.setLooping(false);
        deathSmall = new SpriteSheet("sprites/vfx/vfx_death_small.png", 32, 32, 10f);
        deathSmall.setLooping(false);

        // UI (8x8 frames for gem)
        xpGem = new SpriteSheet("sprites/ui/ui_xpgem_small.png", 8, 8, 4f);

        // Static textures loaded via classpath
        healthOrbFull = loadTexture("sprites/ui/ui_health_orb_full.png");
        healthOrbEmpty = loadTexture("sprites/ui/ui_health_orb_empty.png");
        grassTile = loadTexture("sprites/environment/env_tile_grass_plain.png");
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
        if (slingStone != null) slingStone.dispose();
        if (hitStone != null) hitStone.dispose();
        if (deathSmall != null) deathSmall.dispose();
        if (xpGem != null) xpGem.dispose();
        if (healthOrbFull != null) healthOrbFull.dispose();
        if (healthOrbEmpty != null) healthOrbEmpty.dispose();
        if (grassTile != null) grassTile.dispose();
    }
}
