package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.entity.Enemy;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * The Sling — David's starter weapon.
 * Auto-fires a stone at the nearest enemy within range.
 */
public class SlingWeapon implements Weapon {

    private float fireRate = 1.2f;
    private float fireTimer = 0f;
    private float range = 250f;
    private static final float MIN_RANGE = 40f;
    private int damage = 10;
    private float projectileSpeed = 400f;
    private float projectileSize = 8f;
    private float projectileLifetime = 2f;
    private static final Color STONE_COLOR = Color.LIGHT_GRAY;

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles,
                       com.davidsascent.ui.DamageNumberSystem dmgNumbers) {
        fireTimer += delta;
        float interval = 1f / fireRate;

        if (fireTimer >= interval) {
            Enemy target = findNearestEnemy(playerX, playerY, enemies);
            if (target != null) {
                fireAt(playerX, playerY, target, projectiles);
                fireTimer = 0f;
            } else {
                fireTimer = interval; // cap so it doesn't burst on first target
            }
        }
    }

    @Override
    public void render(TextureBatch batch, float playerX, float playerY) {
        // Sling has no special visual — just projectiles
    }

    @Override
    public String getName() { return "Sling"; }

    private Enemy findNearestEnemy(float px, float py, List<Enemy> enemies) {
        Enemy nearest = null;
        float nearestDist = range * range;
        float minDist = MIN_RANGE * MIN_RANGE;

        for (Enemy e : enemies) {
            if (!e.isAlive()) continue;
            float dist = Collision.distanceSquared(px, py, e.getX(), e.getY());
            if (dist >= minDist && dist < nearestDist) {
                nearestDist = dist;
                nearest = e;
            }
        }
        return nearest;
    }

    private void fireAt(float px, float py, Enemy target,
                        ProjectileSystem projectiles) {
        float dx = target.getX() - px;
        float dy = target.getY() - py;
        float dist = (float) Math.sqrt(dx * dx + dy * dy);
        if (dist < 1f) return;

        float velX = (dx / dist) * projectileSpeed;
        float velY = (dy / dist) * projectileSpeed;

        projectiles.spawn(px, py, velX, velY, damage,
                         projectileSize, projectileLifetime, STONE_COLOR);
    }

    public void increaseFireRate(float amount) { fireRate += amount; }
    public void increaseDamage(int amount) { damage += amount; }
    public void increaseRange(float amount) { range += amount; }
    public float getFireRate() { return fireRate; }
    public int getDamage() { return damage; }
    public float getRange() { return range; }
}
