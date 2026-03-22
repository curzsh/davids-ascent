package com.davidsascent.entity;

import com.davidsascent.core.PlaceholderGraphics;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Dash enemy — approaches the player normally, then winds up and
 * charges in a straight line at high speed. Used for scouts and
 * chariot-style attackers.
 *
 * Cycle: APPROACH -> WINDUP (brief pause) -> DASH -> cooldown -> repeat
 */
public class DashEnemy extends Enemy {

    private enum State { APPROACH, WINDUP, DASH, COOLDOWN }

    private static final float APPROACH_DURATION = 2.5f;
    private static final float WINDUP_DURATION = 0.4f;
    private static final float DASH_DURATION = 0.5f;
    private static final float COOLDOWN_DURATION = 1.0f;
    private static final float DASH_SPEED_MULT = 3.5f;

    private static final Color WINDUP_COLOR = Color.WHITE;

    private State state = State.APPROACH;
    private float stateTimer = 0f;
    private float dashDirX, dashDirY;

    public DashEnemy(float x, float y, int health, float speed,
                     int damage, int xpValue, float size, Color color) {
        super(x, y, health, speed, damage, xpValue, size, color);
    }

    @Override
    public void update(float delta, float playerX, float playerY) {
        if (!alive) return;
        updateCooldowns(delta);

        stateTimer += delta;

        switch (state) {
            case APPROACH -> {
                // Walk toward player
                moveToward(delta, playerX, playerY, speed);
                if (stateTimer >= APPROACH_DURATION) {
                    enterWindup(playerX, playerY);
                }
            }
            case WINDUP -> {
                // Brief pause — telegraph the dash
                if (stateTimer >= WINDUP_DURATION) {
                    state = State.DASH;
                    stateTimer = 0f;
                }
            }
            case DASH -> {
                // Charge in the locked direction
                x += dashDirX * speed * DASH_SPEED_MULT * delta;
                y += dashDirY * speed * DASH_SPEED_MULT * delta;
                if (stateTimer >= DASH_DURATION) {
                    state = State.COOLDOWN;
                    stateTimer = 0f;
                }
            }
            case COOLDOWN -> {
                // Brief rest after dashing
                if (stateTimer >= COOLDOWN_DURATION) {
                    state = State.APPROACH;
                    stateTimer = 0f;
                }
            }
        }
    }

    private void enterWindup(float playerX, float playerY) {
        // Lock dash direction toward player's current position
        float dx = playerX - x;
        float dy = playerY - y;
        float dist = (float) Math.sqrt(dx * dx + dy * dy);
        if (dist > 1f) {
            dashDirX = dx / dist;
            dashDirY = dy / dist;
        } else {
            dashDirX = 0;
            dashDirY = 1;
        }
        state = State.WINDUP;
        stateTimer = 0f;
    }

    private void moveToward(float delta, float targetX, float targetY, float spd) {
        float dx = targetX - x;
        float dy = targetY - y;
        float dist = (float) Math.sqrt(dx * dx + dy * dy);
        if (dist > 1f) {
            x += (dx / dist) * spd * delta;
            y += (dy / dist) * spd * delta;
        }
    }

    @Override
    public void render(TextureBatch batch) {
        if (!alive) return;

        if (state == State.WINDUP) {
            // Flash white to telegraph the dash
            PlaceholderGraphics.drawRect(batch, x - width / 2f, y - height / 2f,
                                         width, height, WINDUP_COLOR);
        } else if (state == State.DASH) {
            // Stretch in dash direction for speed feel
            float stretchW = width * (Math.abs(dashDirX) > 0.5f ? 1.4f : 0.8f);
            float stretchH = height * (Math.abs(dashDirY) > 0.5f ? 1.4f : 0.8f);
            PlaceholderGraphics.drawRect(batch, x - stretchW / 2f, y - stretchH / 2f,
                                         stretchW, stretchH, color);
        } else {
            PlaceholderGraphics.drawRect(batch, x - width / 2f, y - height / 2f,
                                         width, height, color);
        }
    }
}
