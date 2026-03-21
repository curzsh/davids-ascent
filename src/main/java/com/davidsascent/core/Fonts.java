package com.davidsascent.core;

import valthorne.graphics.Color;
import valthorne.graphics.font.Font;
import valthorne.graphics.texture.TextureBatch;

/**
 * Central font manager. Loads fonts once and provides them globally.
 */
public final class Fonts {

    private static Font small;   // 8px — HUD labels, small text
    private static Font medium;  // 12px — card descriptions, dialogue
    private static Font large;   // 16px — card titles, stage names

    private Fonts() {}

    public static void init() {
        small = new Font("assets/fonts/PressStart2P.ttf", 8);
        medium = new Font("assets/fonts/PressStart2P.ttf", 12);
        large = new Font("assets/fonts/PressStart2P.ttf", 16);
    }

    public static Font small() { return small; }
    public static Font medium() { return medium; }
    public static Font large() { return large; }

    /** Helper to draw centered text. */
    public static void drawCentered(TextureBatch batch, Font font, String text,
                                    float centerX, float y, Color color) {
        float width = font.getWidth(text);
        font.draw(batch, text, centerX - width / 2f, y, color);
    }

    public static void dispose() {
        if (small != null) small.dispose();
        if (medium != null) medium.dispose();
        if (large != null) large.dispose();
    }
}
