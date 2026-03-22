package com.davidsascent.entity;

import com.davidsascent.core.SpriteSheet;
import valthorne.graphics.Color;

/**
 * Basic enemy that walks directly toward the player.
 * Used for lions, wolves, bears, and basic Philistine soldiers.
 */
public class ChaserEnemy extends Enemy {

    public ChaserEnemy(float x, float y, int health, float speed,
                       int damage, int xpValue, float size, Color color) {
        super(x, y, health, speed, damage, xpValue, size, color);
    }

    /**
     * Set the animated sprite sheet for this enemy.
     */
    public void setSpriteSheet(SpriteSheet sheet) {
        this.spriteSheet = sheet;
    }

    @Override
    public void update(float delta, float playerX, float playerY) {
        if (!alive) return;
        updateCooldowns(delta);

        // Update sprite animation
        if (spriteSheet != null) {
            spriteSheet.update(delta);
        }

        // Move toward player
        float dx = playerX - x;
        float dy = playerY - y;
        float dist = (float) Math.sqrt(dx * dx + dy * dy);

        if (dist > 1f) {
            x += (dx / dist) * speed * delta;
            y += (dy / dist) * speed * delta;
        }
    }
}
