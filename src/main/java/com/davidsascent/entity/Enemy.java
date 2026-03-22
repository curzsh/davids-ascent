package com.davidsascent.entity;

import com.davidsascent.core.PlaceholderGraphics;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Base class for all enemies. Each enemy has position, health, speed,
 * a collision radius, and XP value dropped on death.
 */
public abstract class Enemy {

    protected float x, y;
    protected float speed;
    protected int health;
    protected int maxHealth;
    protected int damage;
    protected int xpValue;
    protected float radius;
    protected float width, height;
    protected Color color;
    protected boolean alive = true;

    /** Brief invincibility after being hit (prevents multi-hit from one projectile). */
    protected float hitCooldown = 0f;
    private static final float HIT_COOLDOWN_TIME = 0.1f;

    public Enemy(float x, float y, int health, float speed, int damage,
                 int xpValue, float size, Color color) {
        this.x = x;
        this.y = y;
        this.health = health;
        this.maxHealth = health;
        this.speed = speed;
        this.damage = damage;
        this.xpValue = xpValue;
        this.width = size;
        this.height = size;
        this.radius = size / 2f;
        this.color = color;
    }

    /**
     * Update enemy behavior. Override in subclasses for different AI.
     * @param playerX player center X
     * @param playerY player center Y
     */
    public abstract void update(float delta, float playerX, float playerY);

    public void render(TextureBatch batch) {
        if (!alive) return;
        PlaceholderGraphics.drawRect(batch, x - width / 2f, y - height / 2f,
                                     width, height, color);
    }

    public void takeDamage(int amount) {
        if (hitCooldown > 0) return;
        health -= amount;
        hitCooldown = HIT_COOLDOWN_TIME;
        if (health <= 0) {
            alive = false;
        }
    }

    protected void updateCooldowns(float delta) {
        if (hitCooldown > 0) hitCooldown -= delta;
    }

    /**
     * Push the enemy by a velocity impulse (used for knockback).
     * Clamped to arena bounds to prevent enemies going off-screen.
     */
    public void push(float pushX, float pushY) {
        x += pushX * 0.1f;
        y += pushY * 0.1f;
        // Clamp to arena with margin so they can still be reached
        x = Math.max(-50, Math.min(x, com.davidsascent.Game.WORLD_WIDTH + 50));
        y = Math.max(-50, Math.min(y, com.davidsascent.Game.WORLD_HEIGHT + 50));
    }

    // --- Getters ---
    public float getX() { return x; }
    public float getY() { return y; }
    public float getRadius() { return radius; }
    public int getDamage() { return damage; }
    public int getXpValue() { return xpValue; }
    public boolean isAlive() { return alive; }
}
