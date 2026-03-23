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

    private static final float BAR_HEIGHT = 3f;
    private static final float BAR_MARGIN = 10f;
    private static final float BAR_WIDTH = 200f;
    private static final float BORDER_SIZE = 1f;

    private static final float ICON_SIZE = 16f;
    private static final float ICON_GAP = 3f;

    // Holy Land palette colors
    private static final Color HP_BAR_BG = new Color(0.1f, 0.05f, 0.02f, 1f);
    private static final Color HP_FULL = new Color(0.94f, 0.78f, 0.25f, 1f);
    private static final Color HP_LOW = new Color(0.75f, 0.25f, 0.25f, 1f);
    private static final Color XP_FILL = new Color(0.16f, 0.38f, 0.63f, 1f);
    private static final Color BAR_BORDER = new Color(0.06f, 0.03f, 0.01f, 1f);
    private static final Color ICON_BG = new Color(0.12f, 0.06f, 0.02f, 0.9f);
    private static final Color ICON_BORDER = new Color(0.24f, 0.12f, 0f, 1f);
    private static final Color WARM_GOLD = new Color(0.94f, 0.78f, 0.25f, 1f);

    // Weapon icon colors
    private static final Color SLING_COLOR = Color.LIGHT_GRAY;
    private static final Color STAFF_COLOR = new Color(0.36f, 0.23f, 0.1f, 1f);
    private static final Color STONES_COLOR = new Color(0.94f, 0.78f, 0.25f, 1f);
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

        // Lerp HP color from warm gold (full) to danger red (low)
        float r = HP_FULL.getRed() + (HP_LOW.getRed() - HP_FULL.getRed()) * (1f - healthPercent);
        float g = HP_FULL.getGreen() + (HP_LOW.getGreen() - HP_FULL.getGreen()) * (1f - healthPercent);
        float b = HP_FULL.getBlue() + (HP_LOW.getBlue() - HP_FULL.getBlue()) * (1f - healthPercent);
        Color hpColor = new Color(r, g, b, 1f);

        // Dark border around HP bar
        PlaceholderGraphics.drawRect(batch, hpBarX - BORDER_SIZE, hpBarY - BORDER_SIZE,
            BAR_WIDTH + BORDER_SIZE * 2, BAR_HEIGHT + BORDER_SIZE * 2, BAR_BORDER);
        // HP background
        PlaceholderGraphics.drawRect(batch, hpBarX, hpBarY, BAR_WIDTH, BAR_HEIGHT, HP_BAR_BG);
        // HP fill
        PlaceholderGraphics.drawRect(batch, hpBarX, hpBarY, BAR_WIDTH * healthPercent, BAR_HEIGHT, hpColor);
        Fonts.small().draw(batch, "HP", hpBarX + BAR_WIDTH + 5, hpBarY - 1, new Color(1f, 0.94f, 0.75f, 1f));

        // --- XP Bar (bottom-left) ---
        float xpBarX = BAR_MARGIN;
        float xpBarY = BAR_MARGIN;

        // Dark border around XP bar
        PlaceholderGraphics.drawRect(batch, xpBarX - BORDER_SIZE, xpBarY - BORDER_SIZE,
            BAR_WIDTH + BORDER_SIZE * 2, BAR_HEIGHT + BORDER_SIZE * 2, BAR_BORDER);
        // XP background
        PlaceholderGraphics.drawRect(batch, xpBarX, xpBarY, BAR_WIDTH, BAR_HEIGHT, HP_BAR_BG);
        // XP fill (sky blue)
        PlaceholderGraphics.drawRect(batch, xpBarX, xpBarY, BAR_WIDTH * xpSystem.getXpPercent(), BAR_HEIGHT, XP_FILL);

        // Level indicator
        String lvlText = "Lv." + xpSystem.getCurrentLevel();
        Fonts.small().draw(batch, lvlText, xpBarX + BAR_WIDTH + 5, xpBarY - 1, WARM_GOLD);

        // --- Weapon Icons (below health bar) ---
        if (weaponSystem != null) {
            float iconX = BAR_MARGIN;
            float iconY = hpBarY - ICON_SIZE - 6f;
            List<Weapon> weapons = weaponSystem.getWeapons();

            for (int i = 0; i < WeaponSystem.MAX_WEAPONS; i++) {
                float ix = iconX + i * (ICON_SIZE + ICON_GAP);

                // Dark border frame
                PlaceholderGraphics.drawRect(batch, ix - 1, iconY - 1,
                    ICON_SIZE + 2, ICON_SIZE + 2, ICON_BORDER);
                // Slot background (smaller, darker)
                PlaceholderGraphics.drawRect(batch, ix, iconY, ICON_SIZE, ICON_SIZE, ICON_BG);

                if (i < weapons.size()) {
                    // Draw weapon icon as a colored square with initial
                    Color iconColor = getWeaponColor(weapons.get(i));
                    float padding = 3f;
                    PlaceholderGraphics.drawRect(batch, ix + padding, iconY + padding,
                        ICON_SIZE - padding * 2, ICON_SIZE - padding * 2, iconColor);

                    // Weapon initial letter
                    String initial = weapons.get(i).getName().substring(0, 1);
                    Fonts.small().draw(batch, initial, ix + 4, iconY + 4, Color.WHITE);
                }
            }
        }

        // --- Stage label (top-right) ---
        if (!stageLabel.isEmpty()) {
            float labelWidth = Fonts.small().getWidth(stageLabel);
            Fonts.small().draw(batch, stageLabel,
                Game.WORLD_WIDTH - BAR_MARGIN - labelWidth,
                Game.WORLD_HEIGHT - BAR_MARGIN - 8, new Color(1f, 0.94f, 0.75f, 0.7f));
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
