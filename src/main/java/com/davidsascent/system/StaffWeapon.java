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
 * Visual: an arc of small particles radiating outward from the player.
 */
public class StaffWeapon implements Weapon {

    private float fireRate;
    private float fireTimer = 0f;
    private float radius;
    private int damage;
    private float knockback;

    public StaffWeapon() {
        this.fireRate = com.davidsascent.core.BalanceConfig.getFloat("staff.fireRate", 0.8f);
        this.damage = com.davidsascent.core.BalanceConfig.getInt("staff.damage", 15);
        this.radius = com.davidsascent.core.BalanceConfig.getFloat("staff.radius", 60f);
        this.knockback = com.davidsascent.core.BalanceConfig.getFloat("staff.knockback", 150f);
    }

    // Visual flash
    private float flashTimer = 0f;
    private static final float FLASH_DURATION = 0.15f;
    private static final int ARC_PARTICLES = 14;
    private static final float ARC_SPREAD = (float) Math.PI; // 180 degrees

    /** Direction of the last sweep (angle in radians). */
    private float sweepAngle = 0f;

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles,
                       com.davidsascent.ui.DamageNumberSystem dmgNumbers) {
        fireTimer += delta;
        if (flashTimer > 0) flashTimer -= delta;

        if (fireTimer >= 1f / fireRate) {
            boolean hitAny = false;
            // Track closest hit enemy to aim the sweep visual
            float closestDist = Float.MAX_VALUE;
            float closestAngle = sweepAngle;

            for (Enemy e : enemies) {
                if (!e.isAlive()) continue;
                float dist = Collision.distance(playerX, playerY, e.getX(), e.getY());
                if (dist < radius) {
                    if (e.takeDamage(damage)) {
                        dmgNumbers.spawn(e.getX(), e.getY(), damage);
                    }
                    // Knockback — push enemy away from player
                    float dx = e.getX() - playerX;
                    float dy = e.getY() - playerY;
                    if (dist > 1f) {
                        e.push(dx / dist * knockback, dy / dist * knockback);
                    }
                    if (dist < closestDist) {
                        closestDist = dist;
                        closestAngle = (float) Math.atan2(dy, dx);
                    }
                    hitAny = true;
                }
            }

            if (hitAny) {
                sweepAngle = closestAngle;
            }
            if (hitAny || !enemies.isEmpty()) {
                // If no hit, aim toward nearest enemy for the visual
                if (!hitAny) {
                    float nearestDist = Float.MAX_VALUE;
                    for (Enemy e : enemies) {
                        if (!e.isAlive()) continue;
                        float dist = Collision.distance(playerX, playerY, e.getX(), e.getY());
                        if (dist < nearestDist) {
                            nearestDist = dist;
                            float dx = e.getX() - playerX;
                            float dy = e.getY() - playerY;
                            sweepAngle = (float) Math.atan2(dy, dx);
                        }
                    }
                }
                flashTimer = FLASH_DURATION;
            }
            fireTimer = 0f;
        }
    }

    @Override
    public void render(TextureBatch batch, float playerX, float playerY) {
        if (flashTimer <= 0) return;

        float progress = 1f - (flashTimer / FLASH_DURATION); // 0 -> 1 as flash fades
        float startAngle = sweepAngle - ARC_SPREAD / 2f;
        float angleStep = ARC_SPREAD / (ARC_PARTICLES - 1);

        for (int i = 0; i < ARC_PARTICLES; i++) {
            float angle = startAngle + angleStep * i;
            // Particles expand outward over the flash duration
            float dist = radius * (0.3f + 0.7f * progress);

            float px = playerX + (float) Math.cos(angle) * dist;
            float py = playerY + (float) Math.sin(angle) * dist;

            // Fade from bright at center of arc to dim at edges
            float edgeFactor = Math.abs(i - (ARC_PARTICLES - 1) / 2f) / ((ARC_PARTICLES - 1) / 2f);
            float alpha = (1f - edgeFactor * 0.6f) * (1f - progress * 0.5f);

            // Center particles: bright warm gold; edge particles: dim brown
            Color c = (edgeFactor < 0.4f)
                ? new Color(0.95f, 0.8f, 0.4f, alpha)
                : new Color(0.7f, 0.5f, 0.2f, alpha);

            // Inner particles are 4x4, outer are 3x3
            float size = edgeFactor < 0.4f ? 4f : 3f;
            float half = size / 2f;
            PlaceholderGraphics.drawRect(batch,
                px - half, py - half,
                size, size, c);
        }

        // Second layer: a few trailing particles closer to player for thickness
        int trailCount = 8;
        float trailAngleStep = ARC_SPREAD / (trailCount - 1);
        for (int i = 0; i < trailCount; i++) {
            float angle = startAngle + trailAngleStep * i;
            float dist = radius * (0.15f + 0.4f * progress);

            float px = playerX + (float) Math.cos(angle) * dist;
            float py = playerY + (float) Math.sin(angle) * dist;

            float alpha = 0.5f * (1f - progress);
            Color c = new Color(0.95f, 0.8f, 0.4f, alpha);

            PlaceholderGraphics.drawRect(batch,
                px - 1.5f, py - 1.5f,
                3f, 3f, c);
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
