package com.davidsascent.core;

import valthorne.graphics.Color;
import valthorne.graphics.font.Font;
import valthorne.graphics.font.FontData;
import valthorne.graphics.texture.TextureBatch;
import valthorne.io.file.ValthorneFiles;

/**
 * Central font manager. Loads fonts once and provides them globally.
 * Uses ValthorneFiles.readBytes for classpath-safe loading (works inside JARs).
 */
public final class Fonts {

    private static Font small;   // 8px — HUD labels, small text
    private static Font medium;  // 12px — card descriptions, dialogue
    private static Font large;   // 16px — card titles, stage names

    /** Default character range: ASCII printable (32-126), 95 characters. */
    private static final int FIRST_CHAR = 32;
    private static final int CHAR_COUNT = 95;

    private Fonts() {}

    public static void init() {
        byte[] fontBytes = ValthorneFiles.readBytes("fonts/PressStart2P.ttf");
        small = new Font(FontData.load(fontBytes, 8, FIRST_CHAR, CHAR_COUNT));
        medium = new Font(FontData.load(fontBytes, 12, FIRST_CHAR, CHAR_COUNT));
        large = new Font(FontData.load(fontBytes, 16, FIRST_CHAR, CHAR_COUNT));
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
