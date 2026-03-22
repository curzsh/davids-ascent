package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Enemy;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * Divine Fire — area of effect weapon.
 * Periodically erupts a ring of fire around David, damaging all enemies
 * within range. Burns enemies with damage over time.
 */
public class DivineFireWeapon implements Weapon {

    private float fireRate = 0.4f;     // eruptions per second
    private float fireTimer = 0f;
    private float radius = 80f;        // damage radius
    private int damage = 12;

    // Visual flash
    private float flashTimer = 0f;
    private static final float FLASH_DURATION = 0.25f;
    private static final Color FIRE_COLOR = new Color(1f, 0.4f, 0f, 0.5f);
    private static final Color FIRE_INNER = new Color(1f, 0.8f, 0.2f, 0.4f);

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles) {
        fireTimer += delta;
        if (flashTimer > 0) flashTimer -= delta;

        if (fireTimer >= 1f / fireRate) {
            fireTimer = 0f;
            flashTimer = FLASH_DURATION;

            // Damage all enemies in radius
            for (Enemy e : enemies) {
                if (!e.isAlive()) continue;
                float dist = Collision.distance(playerX, playerY, e.getX(), e.getY());
                if (dist < radius) {
                    e.takeDamage(damage);
                }
            }
        }
    }

    @Override
    public void render(TextureBatch batch, float playerX, float playerY) {
        if (flashTimer > 0) {
            float progress = flashTimer / FLASH_DURATION;
            float currentRadius = radius * (1f - progress * 0.3f); // slight pulse

            // Outer ring
            float outerSize = currentRadius * 2;
            PlaceholderGraphics.drawRect(batch,
                playerX - currentRadius, playerY - 4,
                outerSize, 8, FIRE_COLOR);
            PlaceholderGraphics.drawRect(batch,
                playerX - 4, playerY - currentRadius,
                8, outerSize, FIRE_COLOR);

            // Inner ring
            float innerRadius = currentRadius * 0.6f;
            float innerSize = innerRadius * 2;
            PlaceholderGraphics.drawRect(batch,
                playerX - innerRadius, playerY - 3,
                innerSize, 6, FIRE_INNER);
            PlaceholderGraphics.drawRect(batch,
                playerX - 3, playerY - innerRadius,
                6, innerSize, FIRE_INNER);
        }
    }

    @Override
    public String getName() { return "Divine Fire"; }

    public void increaseDamage(int amount) { damage += amount; }
    public void increaseRadius(float amount) { radius += amount; }
    public void increaseFireRate(float amount) { fireRate += amount; }
    public int getDamage() { return damage; }
    public float getRadius() { return radius; }
}
