package com.davidsascent.core;

import valthorne.graphics.Color;
import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureBatch;
import valthorne.graphics.texture.TextureData;

import java.nio.ByteBuffer;

/**
 * Provides a 1x1 white pixel texture for drawing colored rectangles
 * as placeholder graphics until pixel art is ready.
 *
 * Usage:
 *   PlaceholderGraphics.drawRect(batch, x, y, w, h, Color.BLUE);
 */
public final class PlaceholderGraphics {

    private static Texture whitePixel;
    private static int refCount = 0;

    private PlaceholderGraphics() {}

    /**
     * Initialize the 1x1 white pixel texture. Safe to call multiple times.
     */
    public static void init() {
        refCount++;
        if (whitePixel != null) return;
        ByteBuffer buf = ByteBuffer.allocateDirect(4);
        buf.put((byte) 0xFF).put((byte) 0xFF).put((byte) 0xFF).put((byte) 0xFF);
        buf.flip();
        TextureData data = new TextureData(buf, (short) 1, (short) 1);
        whitePixel = new Texture(data);
    }

    /**
     * Draw a colored rectangle at the given position and size.
     * This is a placeholder for sprites — swap to real textures when art is ready.
     */
    public static void drawRect(TextureBatch batch, float x, float y,
                                float width, float height, Color color) {
        batch.draw(whitePixel, x, y, width, height, color);
    }

    /**
     * Get the white pixel texture (for use with Sprite objects if needed).
     */
    public static Texture getWhitePixel() {
        return whitePixel;
    }

    public static void dispose() {
        refCount--;
        if (refCount > 0) return;
        if (whitePixel != null) {
            whitePixel.dispose();
            whitePixel = null;
        }
    }
}
