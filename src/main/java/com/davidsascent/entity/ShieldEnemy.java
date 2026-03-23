package com.davidsascent.entity;

import valthorne.graphics.Color;

/**
 * Shieldbearer — tanky enemy that periodically raises its shield.
 * While shielding, takes 50% reduced damage and moves at half speed.
 * Alternates between marching and blocking on a timer.
 */
public class ShieldEnemy extends Enemy {

    private static final float MARCH_DURATION = 2.0f;
    private static final float BLOCK_DURATION = 1.2f;
    private static final float DAMAGE_REDUCTION = 0.5f;
    private float phaseTimer = 0f;
    private boolean blocking = false;

    public ShieldEnemy(float x, float y, int health, float speed,
                       int damage, int xpValue, float size, Color color) {
        super(x, y, health, speed, damage, xpValue, size, color);
    }

    @Override
    public void update(float delta, float playerX, float playerY) {
        if (!alive) return;
        updateCooldowns(delta);

        phaseTimer += delta;

        if (blocking) {
            if (phaseTimer >= BLOCK_DURATION) {
                blocking = false;
                phaseTimer = 0f;
            }
        } else {
            if (phaseTimer >= MARCH_DURATION) {
                blocking = true;
                phaseTimer = 0f;
            }
        }

        // Move toward player (half speed when blocking)
        float dx = playerX - x;
        float dy = playerY - y;
        float dist = (float) Math.sqrt(dx * dx + dy * dy);

        if (dist > 1f) {
            float moveSpeed = blocking ? speed * 0.5f : speed;
            x += (dx / dist) * moveSpeed * delta;
            y += (dy / dist) * moveSpeed * delta;
        }
    }

    @Override
    public boolean takeDamage(int amount) {
        if (blocking) {
            return super.takeDamage((int) (amount * DAMAGE_REDUCTION));
        }
        return super.takeDamage(amount);
    }

    // Rendering handled by Enemy.render() — the shieldbearer sprite already
    // includes the shield visual. No custom render override needed.
}
