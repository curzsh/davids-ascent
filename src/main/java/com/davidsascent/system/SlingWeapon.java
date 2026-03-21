package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.entity.Enemy;
import valthorne.graphics.Color;

import java.util.List;

/**
 * The Sling — David's starter weapon.
 * Auto-fires a stone at the nearest enemy within range.
 */
public class SlingWeapon {

    private float fireRate = 1.0f;    // shots per second
    private float fireTimer = 0f;
    private float range = 250f;        // pixels — max detection range
    private static final float MIN_RANGE = 40f; // don't target enemies sitting on top of player
    private int damage = 10;
    private float projectileSpeed = 400f;
    private float projectileSize = 8f;
    private float projectileLifetime = 2f;
    private static final Color STONE_COLOR = Color.LIGHT_GRAY;

    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles) {
        fireTimer += delta;

        if (fireTimer >= 1f / fireRate) {
            Enemy target = findNearestEnemy(playerX, playerY, enemies);
            if (target != null) {
                fireAt(playerX, playerY, target, projectiles);
                fireTimer = 0f;
            }
        }
    }

    private Enemy findNearestEnemy(float px, float py, List<Enemy> enemies) {
        Enemy nearest = null;
        float nearestDist = range * range; // compare squared distances
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

    // --- Upgrade methods (for level-up system later) ---
    public void increaseFireRate(float amount) { fireRate += amount; }
    public void increaseDamage(int amount) { damage += amount; }
    public void increaseRange(float amount) { range += amount; }
    public float getFireRate() { return fireRate; }
    public int getDamage() { return damage; }
    public float getRange() { return range; }
}
