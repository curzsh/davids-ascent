package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.entity.Player;
import com.davidsascent.entity.Projectile;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Projectile pool for boss attacks (spear throws, etc.).
 * These projectiles damage the player, not enemies.
 */
public class BossProjectileSystem {

    private static final int POOL_SIZE = 20;
    private final Projectile[] pool;

    public BossProjectileSystem() {
        pool = new Projectile[POOL_SIZE];
        for (int i = 0; i < POOL_SIZE; i++) {
            pool[i] = new Projectile();
        }
    }

    /** Spawn a boss projectile. */
    public void spawn(float x, float y, float velX, float velY,
                      int damage, float size, float lifetime, Color color) {
        for (Projectile p : pool) {
            if (!p.isActive()) {
                p.init(x, y, velX, velY, damage, size, lifetime, color);
                return;
            }
        }
    }

    public void update(float delta) {
        for (Projectile p : pool) {
            if (p.isActive()) p.update(delta);
        }
    }

    /** Check boss projectiles against the player. Deals damage on hit. */
    public void checkPlayerCollisions(Player player) {
        for (Projectile p : pool) {
            if (!p.isActive()) continue;
            if (Collision.circlesOverlap(
                    p.getX(), p.getY(), p.getRadius(),
                    player.getCenterX(), player.getCenterY(), Player.WIDTH / 2f)) {
                player.takeDamage(p.getDamage());
                p.deactivate();
            }
        }
    }

    public void render(TextureBatch batch) {
        for (Projectile p : pool) {
            if (p.isActive()) p.render(batch);
        }
    }

    public void clear() {
        for (Projectile p : pool) {
            p.deactivate();
        }
    }
}
