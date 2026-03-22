package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.entity.Enemy;
import com.davidsascent.entity.Projectile;
import com.davidsascent.ui.DamageNumberSystem;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.ArrayList;
import java.util.List;

/**
 * Manages all active projectiles. Pre-allocates a pool of projectiles
 * to avoid garbage collection during gameplay.
 */
public class ProjectileSystem {

    private static final int POOL_SIZE = 1000;
    private final Projectile[] pool;

    public ProjectileSystem() {
        pool = new Projectile[POOL_SIZE];
        for (int i = 0; i < POOL_SIZE; i++) {
            pool[i] = new Projectile();
        }
    }

    /**
     * Spawn a new projectile from the pool.
     * @return the spawned projectile, or null if the pool is exhausted
     */
    public Projectile spawn(float x, float y, float velX, float velY,
                            int damage, float size, float lifetime, Color color) {
        for (Projectile p : pool) {
            if (!p.isActive()) {
                p.init(x, y, velX, velY, damage, size, lifetime, color);
                return p;
            }
        }
        return null; // pool exhausted — not great but fine for jam
    }

    public void update(float delta) {
        for (Projectile p : pool) {
            if (p.isActive()) {
                p.update(delta);
            }
        }
    }

    /**
     * Check all active projectiles against all alive enemies.
     * Deactivates projectiles on hit and deals damage to enemies.
     * @return list of enemies killed this frame (for XP drops)
     */
    public List<Enemy> checkCollisions(List<Enemy> enemies, DamageNumberSystem dmgNumbers) {
        List<Enemy> killed = new ArrayList<>();

        for (Projectile p : pool) {
            if (!p.isActive()) continue;

            for (Enemy e : enemies) {
                if (!e.isAlive()) continue;

                if (Collision.circlesOverlap(
                        p.getX(), p.getY(), p.getRadius(),
                        e.getX(), e.getY(), e.getRadius())) {
                    if (e.takeDamage(p.getDamage())) {
                        dmgNumbers.spawn(e.getX(), e.getY(), p.getDamage());
                    }
                    p.deactivate();

                    if (!e.isAlive()) {
                        killed.add(e);
                    }
                    break; // projectile is consumed — move to next projectile
                }
            }
        }
        return killed;
    }

    public void render(TextureBatch batch) {
        for (Projectile p : pool) {
            if (p.isActive()) {
                p.render(batch);
            }
        }
    }

    /** Count active projectiles (for debug). */
    public int getActiveCount() {
        int count = 0;
        for (Projectile p : pool) {
            if (p.isActive()) count++;
        }
        return count;
    }
}
