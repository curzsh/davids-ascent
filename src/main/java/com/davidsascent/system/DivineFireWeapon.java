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
 * Rendered as dense circular particles arranged in concentric rings.
 */
public class DivineFireWeapon implements Weapon {

    private float radius;
    private float ringThickness;
    private int damage;
    private float damageInterval;

    public DivineFireWeapon() {
        this.radius = com.davidsascent.core.BalanceConfig.getFloat("fire.radius", 80f);
        this.ringThickness = com.davidsascent.core.BalanceConfig.getFloat("fire.ringThickness", 12f);
        this.damage = com.davidsascent.core.BalanceConfig.getInt("fire.damage", 8);
        this.damageInterval = com.davidsascent.core.BalanceConfig.getFloat("fire.damageInterval", 0.3f);
    }

    /** Per-frame rotation for visual spin effect. */
    private float rotation = 0f;
    private static final float SPIN_SPEED = 1.5f; // radians per second

    /** Outer ring: 36 particles at 3x3 pixels. */
    private static final int OUTER_RING_PARTICLES = 36;
    private static final float OUTER_PARTICLE_SIZE = 3f;

    /** Inner ring: 28 particles at 2x2 pixels, offset for thickness. */
    private static final int INNER_RING_PARTICLES = 28;
    private static final float INNER_PARTICLE_SIZE = 2f;

    /** Middle ring: 32 particles at 4x4 for the core glow. */
    private static final int MID_RING_PARTICLES = 32;
    private static final float MID_PARTICLE_SIZE = 4f;

    /** Flicker accumulator for per-particle alpha variation. */
    private float flickerTime = 0f;

    /** Global damage cooldown so we don't melt enemies instantly. */
    private float damageCooldown = 0f;

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles,
                       com.davidsascent.ui.DamageNumberSystem dmgNumbers) {
        rotation += SPIN_SPEED * delta;
        flickerTime += delta * 12f; // fast flicker
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
        // --- Outer ring: small dim particles (dark orange/red) ---
        float outerRadius = radius + 4f;
        float outerStep = (float) (2 * Math.PI / OUTER_RING_PARTICLES);
        for (int i = 0; i < OUTER_RING_PARTICLES; i++) {
            float angle = outerStep * i + rotation * 0.8f;
            float px = playerX + (float) Math.cos(angle) * outerRadius;
            float py = playerY + (float) Math.sin(angle) * outerRadius;

            // Per-particle flicker: vary alpha between 0.4 and 0.8
            float flicker = 0.4f + 0.4f * (float) Math.abs(Math.sin(flickerTime + i * 1.7f));
            Color c = new Color(0.9f, 0.25f, 0f, flicker);

            float half = OUTER_PARTICLE_SIZE / 2f;
            PlaceholderGraphics.drawRect(batch,
                px - half, py - half,
                OUTER_PARTICLE_SIZE, OUTER_PARTICLE_SIZE, c);
        }

        // --- Middle ring: core glow particles (bright yellow / orange alternating) ---
        float midStep = (float) (2 * Math.PI / MID_RING_PARTICLES);
        for (int i = 0; i < MID_RING_PARTICLES; i++) {
            float angle = midStep * i + rotation;
            float px = playerX + (float) Math.cos(angle) * radius;
            float py = playerY + (float) Math.sin(angle) * radius;

            float flicker = 0.7f + 0.25f * (float) Math.abs(Math.sin(flickerTime * 1.3f + i * 2.1f));
            Color c = (i % 2 == 0)
                ? new Color(1f, 0.85f, 0.2f, flicker)   // bright yellow
                : new Color(1f, 0.45f, 0f, flicker);     // orange

            float half = MID_PARTICLE_SIZE / 2f;
            PlaceholderGraphics.drawRect(batch,
                px - half, py - half,
                MID_PARTICLE_SIZE, MID_PARTICLE_SIZE, c);
        }

        // --- Inner ring: tiny bright particles for thickness ---
        float innerRadius = radius - 5f;
        float innerStep = (float) (2 * Math.PI / INNER_RING_PARTICLES);
        for (int i = 0; i < INNER_RING_PARTICLES; i++) {
            float angle = innerStep * i + rotation * 1.2f + innerStep / 2f;
            float px = playerX + (float) Math.cos(angle) * innerRadius;
            float py = playerY + (float) Math.sin(angle) * innerRadius;

            float flicker = 0.6f + 0.35f * (float) Math.abs(Math.sin(flickerTime * 1.6f + i * 0.9f));
            Color c = new Color(1f, 0.85f, 0.2f, flicker); // bright yellow

            float half = INNER_PARTICLE_SIZE / 2f;
            PlaceholderGraphics.drawRect(batch,
                px - half, py - half,
                INNER_PARTICLE_SIZE, INNER_PARTICLE_SIZE, c);
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
