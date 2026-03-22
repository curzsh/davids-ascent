package com.davidsascent.ui;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Player;
import com.davidsascent.system.DivineFireWeapon;
import com.davidsascent.system.SlingWeapon;
import com.davidsascent.system.StaffWeapon;
import com.davidsascent.system.ThrowingStonesWeapon;
import com.davidsascent.system.Weapon;
import com.davidsascent.system.WeaponSystem;
import com.davidsascent.system.XpSystem;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * Heads-up display showing health bar, XP bar, level, stage info,
 * and equipped weapon icons.
 */
public class HUD {

    private static final float BAR_HEIGHT = 12f;
    private static final float BAR_MARGIN = 10f;
    private static final float BAR_WIDTH = 200f;

    private static final float ICON_SIZE = 20f;
    private static final float ICON_GAP = 4f;
    private static final Color ICON_BG = new Color(0.15f, 0.15f, 0.2f, 0.8f);
    private static final Color ICON_BORDER = new Color(0.4f, 0.4f, 0.5f, 1f);

    // Weapon icon colors
    private static final Color SLING_COLOR = Color.LIGHT_GRAY;
    private static final Color STAFF_COLOR = Color.BROWN;
    private static final Color STONES_COLOR = Color.GOLD;
    private static final Color FIRE_COLOR = new Color(1f, 0.4f, 0f, 1f);

    private String stageLabel = "";
    private WeaponSystem weaponSystem;

    public void setStageLabel(String label) {
        this.stageLabel = label;
    }

    public void setWeaponSystem(WeaponSystem ws) {
        this.weaponSystem = ws;
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

        // --- Weapon Icons (below health bar) ---
        if (weaponSystem != null) {
            float iconX = BAR_MARGIN;
            float iconY = hpBarY - ICON_SIZE - 6f;
            List<Weapon> weapons = weaponSystem.getWeapons();

            for (int i = 0; i < WeaponSystem.MAX_WEAPONS; i++) {
                float ix = iconX + i * (ICON_SIZE + ICON_GAP);

                // Slot background
                PlaceholderGraphics.drawRect(batch, ix, iconY, ICON_SIZE, ICON_SIZE, ICON_BG);
                PlaceholderGraphics.drawRect(batch, ix - 1, iconY - 1,
                    ICON_SIZE + 2, ICON_SIZE + 2, ICON_BORDER);

                if (i < weapons.size()) {
                    // Draw weapon icon as a colored square with initial
                    Color iconColor = getWeaponColor(weapons.get(i));
                    float padding = 3f;
                    PlaceholderGraphics.drawRect(batch, ix + padding, iconY + padding,
                        ICON_SIZE - padding * 2, ICON_SIZE - padding * 2, iconColor);

                    // Weapon initial letter
                    String initial = weapons.get(i).getName().substring(0, 1);
                    Fonts.small().draw(batch, initial, ix + 5, iconY + 5, Color.WHITE);
                }
            }
        }

        // --- Stage label (top-right) ---
        if (!stageLabel.isEmpty()) {
            float labelWidth = Fonts.small().getWidth(stageLabel);
            Fonts.small().draw(batch, stageLabel,
                Game.WORLD_WIDTH - BAR_MARGIN - labelWidth,
                Game.WORLD_HEIGHT - BAR_MARGIN - 8, Color.LIGHT_GRAY);
        }
    }

    private Color getWeaponColor(Weapon weapon) {
        if (weapon instanceof SlingWeapon) return SLING_COLOR;
        if (weapon instanceof StaffWeapon) return STAFF_COLOR;
        if (weapon instanceof ThrowingStonesWeapon) return STONES_COLOR;
        if (weapon instanceof DivineFireWeapon) return FIRE_COLOR;
        return Color.WHITE;
    }
}
