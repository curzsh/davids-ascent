package com.davidsascent.entity;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Goliath — the final boss. A massive enemy with high HP and
 * three attack patterns: charge, ground slam, and spear throw.
 *
 * Phases based on HP thresholds:
 *   Phase 1 (100-60%): Slow chase + spear throw
 *   Phase 2 (60-30%):  Faster, adds ground slam
 *   Phase 3 (30-0%):   Enraged — all attacks, faster cooldowns
 */
public class GoliathBoss extends Enemy {

    private enum AttackState { IDLE, CHARGE, SLAM, THROW, COOLDOWN }

    // --- Size ---
    private static final float BOSS_WIDTH = 64f;
    private static final float BOSS_HEIGHT = 80f;

    // --- Timing ---
    private static final float ATTACK_COOLDOWN_P1 = 2.5f;
    private static final float ATTACK_COOLDOWN_P2 = 1.8f;
    private static final float ATTACK_COOLDOWN_P3 = 1.2f;

    // --- Charge attack ---
    private static final float CHARGE_SPEED_MULT = 3f;
    private static final float CHARGE_DURATION = 0.8f;
    private static final float CHARGE_WINDUP = 0.5f;

    // --- Slam attack ---
    private static final float SLAM_RADIUS = 100f;
    private static final int SLAM_DAMAGE = 25;
    private static final float SLAM_WINDUP = 0.6f;
    private static final float SLAM_DURATION = 0.3f;

    // --- Spear throw ---
    private static final float THROW_SPEED = 350f;
    private static final int THROW_DAMAGE = 20;
    private static final float THROW_WINDUP = 0.4f;

    // --- Colors ---
    private static final Color BODY_COLOR = new Color(0.5f, 0.3f, 0.2f, 1f);
    private static final Color ARMOR_COLOR = new Color(0.4f, 0.4f, 0.5f, 1f);
    private static final Color ENRAGED_COLOR = new Color(0.7f, 0.2f, 0.1f, 1f);
    private static final Color SLAM_COLOR = new Color(1f, 0.5f, 0f, 0.4f);
    private static final Color WINDUP_COLOR = new Color(1f, 1f, 0.5f, 0.5f);

    private AttackState attackState = AttackState.IDLE;
    private float attackTimer = 0f;
    private float cooldownTimer = 0f;
    private float chargeDirX, chargeDirY;
    private float slamFlashTimer = 0f;

    // Spear projectile callback
    private SpearCallback spearCallback;

    /** Callback interface so the boss can spawn spear projectiles. */
    @FunctionalInterface
    public interface SpearCallback {
        void throwSpear(float x, float y, float velX, float velY, int damage);
    }

    public GoliathBoss(float x, float y) {
        super(x, y, 350, 38f, 25, 100, BOSS_WIDTH, BODY_COLOR);
        this.width = BOSS_WIDTH;
        this.height = BOSS_HEIGHT;
        this.radius = BOSS_WIDTH / 2f;
    }

    /** Set callback for spear projectile creation. */
    public void setSpearCallback(SpearCallback callback) {
        this.spearCallback = callback;
    }

    @Override
    public void update(float delta, float playerX, float playerY) {
        if (!alive) return;
        updateCooldowns(delta);
        if (slamFlashTimer > 0) slamFlashTimer -= delta;

        float hpPercent = (float) health / maxHealth;
        int phase = hpPercent > 0.6f ? 1 : hpPercent > 0.3f ? 2 : 3;

        switch (attackState) {
            case IDLE -> updateIdle(delta, playerX, playerY, phase);
            case CHARGE -> updateCharge(delta, playerX, playerY);
            case SLAM -> updateSlam(delta, playerX, playerY);
            case THROW -> updateThrow(delta, playerX, playerY);
            case COOLDOWN -> updateCooldown(delta, playerX, playerY, phase);
        }
    }

    private void updateIdle(float delta, float px, float py, int phase) {
        // Slow walk toward player
        moveToward(delta, px, py, speed);
        cooldownTimer += delta;

        float cooldown = switch (phase) {
            case 1 -> ATTACK_COOLDOWN_P1;
            case 2 -> ATTACK_COOLDOWN_P2;
            default -> ATTACK_COOLDOWN_P3;
        };

        if (cooldownTimer >= cooldown) {
            chooseAttack(px, py, phase);
        }
    }

    private void chooseAttack(float px, float py, int phase) {
        float dist = distance(px, py);

        if (dist < SLAM_RADIUS && phase >= 2) {
            // Close range + phase 2+ = slam
            attackState = AttackState.SLAM;
            attackTimer = 0f;
        } else if (dist > 200f && spearCallback != null) {
            // Far range = throw spear
            attackState = AttackState.THROW;
            attackTimer = 0f;
        } else {
            // Default = charge
            float dx = px - x;
            float dy = py - y;
            float d = (float) Math.sqrt(dx * dx + dy * dy);
            if (d > 1f) {
                chargeDirX = dx / d;
                chargeDirY = dy / d;
            }
            attackState = AttackState.CHARGE;
            attackTimer = 0f;
        }
    }

    private void updateCharge(float delta, float px, float py) {
        attackTimer += delta;
        if (attackTimer < CHARGE_WINDUP) {
            // Windup — stand still, telegraph
            return;
        }
        if (attackTimer < CHARGE_WINDUP + CHARGE_DURATION) {
            // Charging
            x += chargeDirX * speed * CHARGE_SPEED_MULT * delta;
            y += chargeDirY * speed * CHARGE_SPEED_MULT * delta;
            clampToArena();
        } else {
            enterCooldown();
        }
    }

    private void updateSlam(float delta, float px, float py) {
        attackTimer += delta;
        if (attackTimer < SLAM_WINDUP) {
            // Windup — telegraph with growing indicator
            return;
        }
        if (attackTimer < SLAM_WINDUP + SLAM_DURATION) {
            // Slam active — damage dealt via PlayingScene checking slamActive()
            slamFlashTimer = SLAM_DURATION;
        } else {
            enterCooldown();
        }
    }

    private void updateThrow(float delta, float px, float py) {
        attackTimer += delta;
        if (attackTimer < THROW_WINDUP) {
            return;
        }
        // Fire spear
        if (spearCallback != null) {
            float dx = px - x;
            float dy = py - y;
            float d = (float) Math.sqrt(dx * dx + dy * dy);
            if (d > 1f) {
                spearCallback.throwSpear(x, y,
                    (dx / d) * THROW_SPEED, (dy / d) * THROW_SPEED, THROW_DAMAGE);
            }
        }
        enterCooldown();
    }

    private void updateCooldown(float delta, float px, float py, int phase) {
        cooldownTimer += delta;
        // Slowly walk toward player during cooldown
        moveToward(delta, px, py, speed * 0.5f);
        float cd = switch (phase) {
            case 1 -> ATTACK_COOLDOWN_P1;
            case 2 -> ATTACK_COOLDOWN_P2;
            default -> ATTACK_COOLDOWN_P3;
        };
        if (cooldownTimer >= cd * 0.5f) {
            attackState = AttackState.IDLE;
            cooldownTimer = 0f;
        }
    }

    private void enterCooldown() {
        attackState = AttackState.COOLDOWN;
        cooldownTimer = 0f;
        attackTimer = 0f;
    }

    private void moveToward(float delta, float tx, float ty, float spd) {
        float dx = tx - x;
        float dy = ty - y;
        float d = (float) Math.sqrt(dx * dx + dy * dy);
        if (d > 1f) {
            x += (dx / d) * spd * delta;
            y += (dy / d) * spd * delta;
        }
        clampToArena();
    }

    private void clampToArena() {
        x = Math.max(radius, Math.min(x, Game.WORLD_WIDTH - radius));
        y = Math.max(radius, Math.min(y, Game.WORLD_HEIGHT - radius));
    }

    private float distance(float px, float py) {
        float dx = px - x;
        float dy = py - y;
        return (float) Math.sqrt(dx * dx + dy * dy);
    }

    // --- Public state for PlayingScene ---

    /** True during the active frames of a ground slam. */
    public boolean isSlamActive() {
        return attackState == AttackState.SLAM
            && attackTimer >= SLAM_WINDUP
            && attackTimer < SLAM_WINDUP + SLAM_DURATION;
    }

    public float getSlamRadius() { return SLAM_RADIUS; }
    public int getSlamDamage() { return SLAM_DAMAGE; }

    /** True during charge windup (for visual telegraph). */
    public boolean isWindingUp() {
        return (attackState == AttackState.CHARGE && attackTimer < CHARGE_WINDUP)
            || (attackState == AttackState.SLAM && attackTimer < SLAM_WINDUP)
            || (attackState == AttackState.THROW && attackTimer < THROW_WINDUP);
    }

    public float getHealthPercent() {
        return (float) health / maxHealth;
    }

    @Override
    public void render(TextureBatch batch) {
        if (!alive) return;

        float hpPercent = getHealthPercent();
        Color bodyColor = hpPercent <= 0.3f ? ENRAGED_COLOR : BODY_COLOR;

        // Windup telegraph flash
        if (isWindingUp()) {
            PlaceholderGraphics.drawRect(batch, x - width / 2f - 4, y - height / 2f - 4,
                width + 8, height + 8, WINDUP_COLOR);
        }

        // Slam ground indicator
        if (attackState == AttackState.SLAM && attackTimer < SLAM_WINDUP) {
            float progress = attackTimer / SLAM_WINDUP;
            float indicatorRadius = SLAM_RADIUS * progress;
            // Draw as a cross pattern to indicate AoE
            PlaceholderGraphics.drawRect(batch,
                x - indicatorRadius, y - 3, indicatorRadius * 2, 6, SLAM_COLOR);
            PlaceholderGraphics.drawRect(batch,
                x - 3, y - indicatorRadius, 6, indicatorRadius * 2, SLAM_COLOR);
        }

        // Slam flash
        if (slamFlashTimer > 0) {
            PlaceholderGraphics.drawRect(batch,
                x - SLAM_RADIUS, y - SLAM_RADIUS,
                SLAM_RADIUS * 2, SLAM_RADIUS * 2, SLAM_COLOR);
        }

        // Main body (large rectangle)
        PlaceholderGraphics.drawRect(batch, x - width / 2f, y - height / 2f,
                                     width, height, bodyColor);

        // Armor overlay (smaller, centered)
        float armorW = width * 0.7f;
        float armorH = height * 0.5f;
        PlaceholderGraphics.drawRect(batch, x - armorW / 2f, y - armorH / 2f,
                                     armorW, armorH, ARMOR_COLOR);

        // Boss health bar (wide bar above Goliath)
        float barW = 80f;
        float barH = 6f;
        float barX = x - barW / 2f;
        float barY = y + height / 2f + 8f;
        PlaceholderGraphics.drawRect(batch, barX, barY, barW, barH, Color.MAROON);
        Color hpColor = hpPercent > 0.5f ? Color.GREEN :
                         hpPercent > 0.25f ? Color.YELLOW : Color.RED;
        PlaceholderGraphics.drawRect(batch, barX, barY, barW * hpPercent, barH, hpColor);

        // "GOLIATH" label
        Fonts.small().draw(batch, "GOLIATH", x - Fonts.small().getWidth("GOLIATH") / 2f,
                          barY + barH + 4f, Color.WHITE);
    }
}
