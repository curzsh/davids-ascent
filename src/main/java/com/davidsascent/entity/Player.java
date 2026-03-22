package com.davidsascent.entity;

import com.davidsascent.Game;
import com.davidsascent.core.PlaceholderGraphics;
import valthorne.Keyboard;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * David — the player character.
 * Handles movement via WASD/arrow keys. Rendered as a colored rectangle placeholder
 * until pixel art is ready.
 */
public class Player {

    /** Player dimensions (32x32 sprite size). */
    public static final float WIDTH = 32;
    public static final float HEIGHT = 32;

    private float x;
    private float y;
    private float speed;
    private int maxHealth;
    private int health;

    public Player(float x, float y) {
        this.speed = com.davidsascent.core.BalanceConfig.getFloat("player.speed", 200f);
        this.maxHealth = com.davidsascent.core.BalanceConfig.getInt("player.maxHealth", 100);
        this.x = x - WIDTH / 2f;
        this.y = y - HEIGHT / 2f;
        this.health = maxHealth;
    }

    /**
     * Handle WASD and arrow key input for movement.
     */
    public void handleInput(float delta) {
        if (isDead()) return;

        float dx = 0;
        float dy = 0;

        if (Keyboard.isKeyDown(Keyboard.W) || Keyboard.isKeyDown(Keyboard.UP)) dy += 1;
        if (Keyboard.isKeyDown(Keyboard.S) || Keyboard.isKeyDown(Keyboard.DOWN)) dy -= 1;
        if (Keyboard.isKeyDown(Keyboard.A) || Keyboard.isKeyDown(Keyboard.LEFT)) dx -= 1;
        if (Keyboard.isKeyDown(Keyboard.D) || Keyboard.isKeyDown(Keyboard.RIGHT)) dx += 1;

        // Normalize diagonal movement
        if (dx != 0 && dy != 0) {
            float inv = 1f / (float) Math.sqrt(dx * dx + dy * dy);
            dx *= inv;
            dy *= inv;
        }

        x += dx * speed * delta;
        y += dy * speed * delta;

        // Clamp to arena bounds
        x = Math.max(0, Math.min(x, Game.WORLD_WIDTH - WIDTH));
        y = Math.max(0, Math.min(y, Game.WORLD_HEIGHT - HEIGHT));
    }

    public void update(float delta) {
        // Reserved for status effects, etc.
    }

    /**
     * Render the player.
     */
    public void render(TextureBatch batch) {
        PlaceholderGraphics.drawRect(batch, x, y, WIDTH, HEIGHT, Color.BLUE);
    }

    /**
     * Render the health bar above the player.
     */
    public void renderHealthBar(TextureBatch batch) {
        float barWidth = 40f;
        float barHeight = 4f;
        float barX = x + WIDTH / 2f - barWidth / 2f;
        float barY = y + HEIGHT + 4f;

        // Background (dark red)
        PlaceholderGraphics.drawRect(batch, barX, barY, barWidth, barHeight, Color.MAROON);
        // Foreground (green, proportional to health)
        float healthPercent = (float) health / maxHealth;
        Color barColor = healthPercent > 0.5f ? Color.GREEN :
                         healthPercent > 0.25f ? Color.YELLOW : Color.RED;
        PlaceholderGraphics.drawRect(batch, barX, barY,
                                     barWidth * healthPercent, barHeight, barColor);
    }

    public float getX() { return x; }
    public float getY() { return y; }
    public float getCenterX() { return x + WIDTH / 2f; }
    public float getCenterY() { return y + HEIGHT / 2f; }
    public int getHealth() { return health; }
    public int getMaxHealth() { return maxHealth; }
    public float getSpeed() { return speed; }
    public void setSpeed(float speed) { this.speed = speed; }

    public void takeDamage(int amount) {
        health = Math.max(0, health - amount);
    }

    public void heal(int amount) {
        health = Math.min(maxHealth, health + amount);
    }

    public void increaseMaxHealth(int amount) {
        maxHealth += amount;
        health += amount; // also heal by the amount gained
    }

    public boolean isDead() {
        return health <= 0;
    }
}
