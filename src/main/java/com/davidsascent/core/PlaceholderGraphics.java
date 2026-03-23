package com.davidsascent.core;

import valthorne.graphics.Color;
import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureBatch;
import valthorne.graphics.texture.TextureData;

import java.nio.ByteBuffer;

/**
 * Provides a 1x1 white pixel texture for drawing colored rectangles
 * as placeholder graphics until pixel art is ready.
 * Shared across all scenes — only disposed on app shutdown.
 */
public final class PlaceholderGraphics {

    private static Texture whitePixel;

    private PlaceholderGraphics() {}

    /**
     * Initialize the 1x1 white pixel texture. Safe to call from multiple scenes.
     */
    public static void init() {
        if (whitePixel != null) return; // already loaded
        ByteBuffer buf = ByteBuffer.allocateDirect(4);
        buf.put((byte) 0xFF).put((byte) 0xFF).put((byte) 0xFF).put((byte) 0xFF);
        buf.flip();
        TextureData data = new TextureData(buf, (short) 1, (short) 1);
        whitePixel = new Texture(data);
    }

    /**
     * Draw a colored rectangle at the given position and size.
     */
    public static void drawRect(TextureBatch batch, float x, float y,
                                float width, float height, Color color) {
        batch.draw(whitePixel, x, y, width, height, color);
    }

    /**
     * Get the white pixel texture.
     */
    public static Texture getWhitePixel() {
        return whitePixel;
    }

    /**
     * Dispose. Only call on app shutdown, not on scene transitions.
     */
    public static void dispose() {
        if (whitePixel != null) {
            whitePixel.dispose();
            whitePixel = null;
        }
    }
}
