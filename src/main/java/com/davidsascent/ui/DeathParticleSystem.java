package com.davidsascent.ui;

import com.davidsascent.core.PlaceholderGraphics;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Simple pooled particle burst for enemy death effects.
 * Spawns a cluster of tiny pixel particles that fly outward and fade.
 */
public class DeathParticleSystem {

    private static final int POOL_SIZE = 300;
    private static final int PARTICLES_PER_BURST = 6;
    private static final float LIFETIME = 0.4f;
    private static final float SPEED = 150f;
    /** Small particle sizes: 2x2 or 3x3 to look like pixel particles, not rectangles. */
    private static final float PARTICLE_SIZE_SMALL = 2f;
    private static final float PARTICLE_SIZE_LARGE = 3f;

    private final float[] px = new float[POOL_SIZE];
    private final float[] py = new float[POOL_SIZE];
    private final float[] vx = new float[POOL_SIZE];
    private final float[] vy = new float[POOL_SIZE];
    private final float[] age = new float[POOL_SIZE];
    private final float[] sizes = new float[POOL_SIZE];
    private final float[] colorR = new float[POOL_SIZE];
    private final float[] colorG = new float[POOL_SIZE];
    private final float[] colorB = new float[POOL_SIZE];
    private final boolean[] active = new boolean[POOL_SIZE];

    public DeathParticleSystem() {
        for (int i = 0; i < POOL_SIZE; i++) {
            active[i] = false;
        }
    }

    /** Spawn a burst of particles at the given position with the enemy's color. */
    public void burst(float x, float y, Color color) {
        // Extract color components once via getRed/getGreen/getBlue (0-255 int)
        float cr = color.getRed() / 255f;
        float cg = color.getGreen() / 255f;
        float cb = color.getBlue() / 255f;

        int spawned = 0;
        for (int i = 0; i < POOL_SIZE && spawned < PARTICLES_PER_BURST; i++) {
            if (!active[i]) {
                float angle = (float)(Math.random() * Math.PI * 2);
                float speed = SPEED * (0.5f + (float) Math.random() * 0.5f);
                px[i] = x;
                py[i] = y;
                vx[i] = (float) Math.cos(angle) * speed;
                vy[i] = (float) Math.sin(angle) * speed;
                age[i] = 0f;
                colorR[i] = cr;
                colorG[i] = cg;
                colorB[i] = cb;
                // Randomly pick 2x2 or 3x3 for variety
                sizes[i] = Math.random() < 0.5 ? PARTICLE_SIZE_SMALL : PARTICLE_SIZE_LARGE;
                active[i] = true;
                spawned++;
            }
        }
    }

    public void update(float delta) {
        for (int i = 0; i < POOL_SIZE; i++) {
            if (!active[i]) continue;
            age[i] += delta;
            if (age[i] >= LIFETIME) {
                active[i] = false;
                continue;
            }
            px[i] += vx[i] * delta;
            py[i] += vy[i] * delta;
        }
    }

    public void render(TextureBatch batch) {
        for (int i = 0; i < POOL_SIZE; i++) {
            if (!active[i]) continue;
            float alpha = 1f - (age[i] / LIFETIME);
            float size = sizes[i] * alpha;
            if (size < 1f) size = 1f; // minimum 1px so it stays visible
            Color c = new Color(colorR[i], colorG[i], colorB[i], alpha);
            PlaceholderGraphics.drawRect(batch,
                px[i] - size / 2f, py[i] - size / 2f,
                size, size, c);
        }
    }
}
