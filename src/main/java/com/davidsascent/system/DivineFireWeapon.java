package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Enemy;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * Divine Fire — a constant ring of fire around David.
 * The ring is always visible and damages any enemy that touches it.
 * Rendered as small squares arranged in a circle.
 */
public class DivineFireWeapon implements Weapon {

    private float radius = 80f;
    private float ringThickness = 12f;
    private int damage = 8;
    private float damageInterval = 0.3f; // seconds between damage ticks

    /** Per-frame rotation for visual spin effect. */
    private float rotation = 0f;
    private static final float SPIN_SPEED = 1.5f; // radians per second

    /** Number of segments to draw the ring. */
    private static final int RING_SEGMENTS = 20;
    private static final float SEGMENT_SIZE = 8f;

    private static final Color FIRE_OUTER = new Color(1f, 0.3f, 0f, 0.8f);
    private static final Color FIRE_INNER = new Color(1f, 0.7f, 0.1f, 0.9f);

    /** Global damage cooldown so we don't melt enemies instantly. */
    private float damageCooldown = 0f;

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles,
                       com.davidsascent.ui.DamageNumberSystem dmgNumbers) {
        rotation += SPIN_SPEED * delta;
        if (damageCooldown > 0) damageCooldown -= delta;

        // Damage enemies touching the ring
        if (damageCooldown <= 0) {
            boolean hitAny = false;
            float innerRadius = radius - ringThickness / 2f;
            float outerRadius = radius + ringThickness / 2f;

            for (Enemy e : enemies) {
                if (!e.isAlive()) continue;
                float dist = Collision.distance(playerX, playerY, e.getX(), e.getY());
                // Enemy touches ring if its edge overlaps the ring band
                float enemyInner = dist - e.getRadius();
                float enemyOuter = dist + e.getRadius();
                if (enemyOuter >= innerRadius && enemyInner <= outerRadius) {
                    if (e.takeDamage(damage)) {
                        dmgNumbers.spawn(e.getX(), e.getY(), damage);
                    }
                    hitAny = true;
                }
            }
            if (hitAny) {
                damageCooldown = damageInterval;
            }
        }
    }

    @Override
    public void render(TextureBatch batch, float playerX, float playerY) {
        // Draw the ring as small squares arranged in a circle
        float angleStep = (float) (2 * Math.PI / RING_SEGMENTS);

        for (int i = 0; i < RING_SEGMENTS; i++) {
            float angle = angleStep * i + rotation;
            float x = playerX + (float) Math.cos(angle) * radius;
            float y = playerY + (float) Math.sin(angle) * radius;

            // Alternate colors for a flickering fire effect
            Color color = (i % 2 == 0) ? FIRE_OUTER : FIRE_INNER;

            PlaceholderGraphics.drawRect(batch,
                x - SEGMENT_SIZE / 2f, y - SEGMENT_SIZE / 2f,
                SEGMENT_SIZE, SEGMENT_SIZE, color);
        }

        // Draw a second inner ring for thickness
        float innerRadius = radius - SEGMENT_SIZE * 0.6f;
        for (int i = 0; i < RING_SEGMENTS; i++) {
            float angle = angleStep * i + rotation + angleStep / 2f; // offset for fill
            float x = playerX + (float) Math.cos(angle) * innerRadius;
            float y = playerY + (float) Math.sin(angle) * innerRadius;

            Color color = (i % 2 == 0) ? FIRE_INNER : FIRE_OUTER;

            PlaceholderGraphics.drawRect(batch,
                x - SEGMENT_SIZE / 2f, y - SEGMENT_SIZE / 2f,
                SEGMENT_SIZE * 0.7f, SEGMENT_SIZE * 0.7f, color);
        }
    }

    @Override
    public String getName() { return "Divine Fire"; }

    public void increaseDamage(int amount) { damage += amount; }
    public void increaseRadius(float amount) { radius += amount; }
    public void increaseFireRate(float amount) { /* reduce damage interval */ damageInterval = Math.max(0.1f, damageInterval - amount * 0.1f); }
    public int getDamage() { return damage; }
    public float getRadius() { return radius; }
}
