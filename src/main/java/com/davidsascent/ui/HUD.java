package com.davidsascent.ui;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Player;
import com.davidsascent.system.XpSystem;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Heads-up display showing health bar, XP bar, level, and stage info.
 */
public class HUD {

    private static final float BAR_HEIGHT = 12f;
    private static final float BAR_MARGIN = 10f;
    private static final float BAR_WIDTH = 200f;

    private String stageLabel = "";

    public void setStageLabel(String label) {
        this.stageLabel = label;
    }

    public void render(TextureBatch batch, Player player, XpSystem xpSystem) {
        // --- Health Bar (top-left) ---
        float hpBarX = BAR_MARGIN;
        float hpBarY = Game.WORLD_HEIGHT - BAR_MARGIN - BAR_HEIGHT;
        float healthPercent = (float) player.getHealth() / player.getMaxHealth();
        Color hpColor = healthPercent > 0.5f ? Color.GREEN :
                        healthPercent > 0.25f ? Color.YELLOW : Color.RED;

        PlaceholderGraphics.drawRect(batch, hpBarX, hpBarY, BAR_WIDTH, BAR_HEIGHT, Color.DARK_GRAY);
        PlaceholderGraphics.drawRect(batch, hpBarX, hpBarY, BAR_WIDTH * healthPercent, BAR_HEIGHT, hpColor);
        Fonts.small().draw(batch, "HP", hpBarX + BAR_WIDTH + 5, hpBarY + 2, Color.WHITE);

        // --- XP Bar (bottom-left) ---
        float xpBarX = BAR_MARGIN;
        float xpBarY = BAR_MARGIN;

        PlaceholderGraphics.drawRect(batch, xpBarX, xpBarY, BAR_WIDTH, BAR_HEIGHT, Color.DARK_GRAY);
        PlaceholderGraphics.drawRect(batch, xpBarX, xpBarY, BAR_WIDTH * xpSystem.getXpPercent(), BAR_HEIGHT, Color.CYAN);

        // Level indicator
        String lvlText = "Lv." + xpSystem.getCurrentLevel();
        Fonts.small().draw(batch, lvlText, xpBarX + BAR_WIDTH + 5, xpBarY + 2, Color.GOLD);

        // --- Stage label (top-right) ---
        if (!stageLabel.isEmpty()) {
            float labelWidth = Fonts.small().getWidth(stageLabel);
            Fonts.small().draw(batch, stageLabel,
                Game.WORLD_WIDTH - BAR_MARGIN - labelWidth,
                Game.WORLD_HEIGHT - BAR_MARGIN - 8, Color.LIGHT_GRAY);
        }
    }
}
