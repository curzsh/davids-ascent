package com.davidsascent.ui;

import com.davidsascent.core.Fonts;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * A floating damage number that pops up and fades out.
 */
public class DamageNumber {

    private float x, y;
    private int value;
    private float age;
    private boolean active;

    private static final float LIFETIME = 0.8f;
    private static final float FLOAT_SPEED = 60f; // pixels per second upward
    private static final Color DMG_COLOR = Color.WHITE;
    private static final Color CRIT_COLOR = Color.YELLOW;

    public DamageNumber() {
        this.active = false;
    }

    public void init(float x, float y, int value) {
        this.x = x;
        this.y = y;
        this.value = value;
        this.age = 0;
        this.active = true;
    }

    public void update(float delta) {
        if (!active) return;
        age += delta;
        y += FLOAT_SPEED * delta;
        if (age >= LIFETIME) active = false;
    }

    public void render(TextureBatch batch) {
        if (!active) return;

        // Fade out over lifetime
        float alpha = 1f - (age / LIFETIME);
        if (alpha <= 0) return;

        // Use yellow for big hits (20+), white for normal
        Color color = value >= 20 ? CRIT_COLOR : DMG_COLOR;
        String text = String.valueOf(value);

        Fonts.small().draw(batch, text, x - Fonts.small().getWidth(text) / 2f, y, color);
    }

    public boolean isActive() { return active; }
}
