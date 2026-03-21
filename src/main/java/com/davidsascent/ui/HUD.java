package com.davidsascent.ui;

import com.davidsascent.Game;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Player;
import com.davidsascent.system.XpSystem;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Heads-up display showing health bar, XP bar, and level indicator.
 * Rendered at screen-space coordinates (bottom of screen).
 */
public class HUD {

    private static final float BAR_HEIGHT = 12f;
    private static final float BAR_MARGIN = 10f;
    private static final float BAR_WIDTH = 200f;

    public void render(TextureBatch batch, Player player, XpSystem xpSystem) {
        // --- XP Bar (bottom of screen) ---
        float xpBarX = BAR_MARGIN;
        float xpBarY = BAR_MARGIN;

        // Background
        PlaceholderGraphics.drawRect(batch, xpBarX, xpBarY,
            BAR_WIDTH, BAR_HEIGHT, Color.DARK_GRAY);
        // Fill
        PlaceholderGraphics.drawRect(batch, xpBarX, xpBarY,
            BAR_WIDTH * xpSystem.getXpPercent(), BAR_HEIGHT, Color.CYAN);

        // --- Level indicator (right of XP bar) ---
        float levelBoxSize = BAR_HEIGHT;
        PlaceholderGraphics.drawRect(batch, xpBarX + BAR_WIDTH + 5, xpBarY,
            levelBoxSize * 2, levelBoxSize, Color.GOLD);

        // --- Health Bar (top-left) ---
        float hpBarX = BAR_MARGIN;
        float hpBarY = Game.WORLD_HEIGHT - BAR_MARGIN - BAR_HEIGHT;
        float healthPercent = (float) player.getHealth() / player.getMaxHealth();
        Color hpColor = healthPercent > 0.5f ? Color.GREEN :
                        healthPercent > 0.25f ? Color.YELLOW : Color.RED;

        // Background
        PlaceholderGraphics.drawRect(batch, hpBarX, hpBarY,
            BAR_WIDTH, BAR_HEIGHT, Color.DARK_GRAY);
        // Fill
        PlaceholderGraphics.drawRect(batch, hpBarX, hpBarY,
            BAR_WIDTH * healthPercent, BAR_HEIGHT, hpColor);

        // --- Enemy count (top-right, small box for debug) ---
        // TODO: add kill counter or wave indicator
    }
}
