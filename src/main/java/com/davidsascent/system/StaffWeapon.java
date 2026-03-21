package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Enemy;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * Shepherd's Staff — melee sweep weapon.
 * Damages all enemies within a radius around David on a cooldown.
 * Visual: a brief arc flash around the player.
 */
public class StaffWeapon implements Weapon {

    private float fireRate = 0.8f;     // sweeps per second
    private float fireTimer = 0f;
    private float radius = 60f;        // melee range
    private int damage = 15;
    private float knockback = 150f;    // push enemies away on hit

    // Visual flash
    private float flashTimer = 0f;
    private static final float FLASH_DURATION = 0.15f;
    private static final Color STAFF_COLOR = Color.BROWN;
    private static final Color FLASH_COLOR = new Color(0.8f, 0.6f, 0.3f, 0.6f);

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles) {
        fireTimer += delta;
        if (flashTimer > 0) flashTimer -= delta;

        if (fireTimer >= 1f / fireRate) {
            boolean hitAny = false;

            for (Enemy e : enemies) {
                if (!e.isAlive()) continue;
                float dist = Collision.distance(playerX, playerY, e.getX(), e.getY());
                if (dist < radius) {
                    e.takeDamage(damage);
                    // Knockback — push enemy away from player
                    float dx = e.getX() - playerX;
                    float dy = e.getY() - playerY;
                    if (dist > 1f) {
                        e.push(dx / dist * knockback, dy / dist * knockback);
                    }
                    hitAny = true;
                }
            }

            if (hitAny || !enemies.isEmpty()) {
                flashTimer = FLASH_DURATION;
            }
            fireTimer = 0f;
        }
    }

    @Override
    public void render(TextureBatch batch, float playerX, float playerY) {
        if (flashTimer > 0) {
            // Draw a sweep arc as 4 rectangles around the player
            float size = radius * 2;
            float thickness = 8f;
            float x = playerX - radius;
            float y = playerY - radius;

            PlaceholderGraphics.drawRect(batch, x, playerY - thickness / 2, size, thickness, FLASH_COLOR); // horizontal
            PlaceholderGraphics.drawRect(batch, playerX - thickness / 2, y, thickness, size, FLASH_COLOR); // vertical
        }
    }

    @Override
    public String getName() { return "Shepherd's Staff"; }

    public void increaseDamage(int amount) { damage += amount; }
    public void increaseRadius(float amount) { radius += amount; }
    public void increaseFireRate(float amount) { fireRate += amount; }
    public void increaseKnockback(float amount) { knockback += amount; }
    public int getDamage() { return damage; }
    public float getRadius() { return radius; }
}
