package com.davidsascent.system;

import com.davidsascent.entity.Enemy;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * Base interface for all weapons. Each weapon auto-fires on its own
 * cooldown and has its own targeting/projectile behavior.
 */
public interface Weapon {

    /** Update weapon timer and fire when ready. */
    void update(float delta, float playerX, float playerY,
                List<Enemy> enemies, ProjectileSystem projectiles);

    /** Render any weapon-specific visuals (melee arcs, etc.). */
    void render(TextureBatch batch, float playerX, float playerY);

    String getName();
}
