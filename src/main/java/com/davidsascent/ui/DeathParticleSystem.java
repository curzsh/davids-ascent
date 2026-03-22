package com.davidsascent.ui;

import com.davidsascent.core.PlaceholderGraphics;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Simple pooled particle burst for enemy death effects.
 * Spawns a cluster of small squares that fly outward and fade.
 */
public class DeathParticleSystem {

    private static final int POOL_SIZE = 300;
    private static final int PARTICLES_PER_BURST = 6;
    private static final float LIFETIME = 0.4f;
    private static final float SPEED = 150f;
    private static final float PARTICLE_SIZE = 4f;

    private final float[] px = new float[POOL_SIZE];
    private final float[] py = new float[POOL_SIZE];
    private final float[] vx = new float[POOL_SIZE];
    private final float[] vy = new float[POOL_SIZE];
    private final float[] age = new float[POOL_SIZE];
    private final Color[] colors = new Color[POOL_SIZE];
    private final boolean[] active = new boolean[POOL_SIZE];

    public DeathParticleSystem() {
        for (int i = 0; i < POOL_SIZE; i++) {
            active[i] = false;
        }
    }

    /** Spawn a burst of particles at the given position with the enemy's color. */
    public void burst(float x, float y, Color color) {
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
                colors[i] = color;
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
            float size = PARTICLE_SIZE * alpha;
            // Use the enemy's color but we can't easily set alpha, so just draw smaller
            PlaceholderGraphics.drawRect(batch,
                px[i] - size / 2f, py[i] - size / 2f,
                size, size, colors[i]);
        }
    }
}
