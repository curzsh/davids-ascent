package com.davidsascent.entity;

import com.davidsascent.core.GameSprites;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * A projectile fired by one of David's weapons.
 * Moves in a straight line, deals damage on contact, and expires after a set lifetime.
 */
public class Projectile {

    private float x, y;
    private float velX, velY;
    private float radius;
    private float size;
    private int damage;
    private float lifetime;
    private float age;
    private boolean active;
    private Color color;

    public Projectile() {
        this.active = false;
    }

    /**
     * Initialize/reset a projectile for reuse (object pooling).
     */
    public void init(float x, float y, float velX, float velY,
                     int damage, float size, float lifetime, Color color) {
        this.x = x;
        this.y = y;
        this.velX = velX;
        this.velY = velY;
        this.damage = damage;
        this.size = size;
        this.radius = size / 2f;
        this.lifetime = lifetime;
        this.age = 0;
        this.color = color;
        this.active = true;
    }

    public void update(float delta) {
        if (!active) return;

        x += velX * delta;
        y += velY * delta;
        age += delta;

        if (age >= lifetime) {
            active = false;
        }
    }

    public void render(TextureBatch batch) {
        if (!active) return;
        if (GameSprites.slingStone == null) return; // Sprite not loaded — skip rendering
        GameSprites.slingStone.draw(batch, x - size / 2f, y - size / 2f, size, size);
    }

    public void deactivate() {
        active = false;
    }

    // --- Getters ---
    public float getX() { return x; }
    public float getY() { return y; }
    public float getRadius() { return radius; }
    public int getDamage() { return damage; }
    public boolean isActive() { return active; }
}
