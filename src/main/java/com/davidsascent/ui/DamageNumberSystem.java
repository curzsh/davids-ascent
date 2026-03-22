package com.davidsascent.ui;

import valthorne.graphics.texture.TextureBatch;

/**
 * Manages a pool of floating damage numbers.
 */
public class DamageNumberSystem {

    private static final int POOL_SIZE = 100;
    private final DamageNumber[] pool;

    public DamageNumberSystem() {
        pool = new DamageNumber[POOL_SIZE];
        for (int i = 0; i < POOL_SIZE; i++) {
            pool[i] = new DamageNumber();
        }
    }

    public void spawn(float x, float y, int damage) {
        for (DamageNumber dn : pool) {
            if (!dn.isActive()) {
                // Slight random offset so overlapping hits don't stack
                float offsetX = (float)(Math.random() * 20 - 10);
                dn.init(x + offsetX, y, damage);
                return;
            }
        }
    }

    public void update(float delta) {
        for (DamageNumber dn : pool) {
            if (dn.isActive()) dn.update(delta);
        }
    }

    public void render(TextureBatch batch) {
        for (DamageNumber dn : pool) {
            if (dn.isActive()) dn.render(batch);
        }
    }
}
