package com.davidsascent.entity;

import com.davidsascent.core.PlaceholderGraphics;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * XP gem dropped by enemies on death.
 * Floats briefly, then can be collected by the player on proximity.
 */
public class XpGem {

    private float x, y;
    private int value;
    private boolean active;
    private float size = 10f;

    /** Magnet range — player auto-collects gems within this distance. */
    public static final float COLLECT_RADIUS = 50f;

    /** Gems drift toward player when within magnet range. */
    private static final float MAGNET_SPEED = 300f;

    private static final Color GEM_COLOR = Color.CYAN;

    public XpGem() {
        this.active = false;
    }

    public void init(float x, float y, int value) {
        this.x = x;
        this.y = y;
        this.value = value;
        this.active = true;
    }

    public void update(float delta, float playerX, float playerY) {
        if (!active) return;

        // Drift toward player if within magnet range
        float dx = playerX - x;
        float dy = playerY - y;
        float dist = (float) Math.sqrt(dx * dx + dy * dy);

        if (dist < COLLECT_RADIUS && dist > 1f) {
            x += (dx / dist) * MAGNET_SPEED * delta;
            y += (dy / dist) * MAGNET_SPEED * delta;
        }
    }

    public void render(TextureBatch batch) {
        if (!active) return;
        PlaceholderGraphics.drawRect(batch, x - size / 2f, y - size / 2f,
                                     size, size, GEM_COLOR);
    }

    public void deactivate() { active = false; }
    public boolean isActive() { return active; }
    public float getX() { return x; }
    public float getY() { return y; }
    public int getValue() { return value; }
}
