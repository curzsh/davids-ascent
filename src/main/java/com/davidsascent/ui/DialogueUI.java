package com.davidsascent.ui;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import valthorne.Keyboard;
import valthorne.Mouse;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

/**
 * Dialogue/scripture display between stages.
 * Shows stage name, text content, and a "click to continue" prompt.
 */
public class DialogueUI {

    private String[] lines;
    private String stageName;
    private boolean active = false;
    private boolean waitingForRelease = false;
    private float displayTimer = 0f;

    private static final Color BG_COLOR = new Color(0.05f, 0.03f, 0.08f, 1f);
    private static final Color TEXT_AREA = new Color(0.1f, 0.08f, 0.15f, 1f);
    private static final Color TEXT_AREA_INNER = new Color(0.08f, 0.06f, 0.12f, 1f);
    private static final Color ACCENT = Color.GOLD;
    private static final Color ACCENT_DIM = new Color(0.6f, 0.5f, 0.2f, 1f);
    private static final Color CROSS_COLOR = new Color(0.2f, 0.18f, 0.3f, 1f);

    public void show(String stageName, String text) {
        this.stageName = stageName;
        this.lines = text != null ? text.split("\n") : new String[0];
        this.active = true;
        this.waitingForRelease = true;
        this.displayTimer = 0f;
    }

    public boolean update(float delta) {
        if (!active) return false;

        displayTimer += delta;

        if (waitingForRelease) {
            if (!Mouse.isButtonDown(Mouse.LEFT) &&
                !Keyboard.isKeyDown(Keyboard.SPACE) &&
                !Keyboard.isKeyDown(Keyboard.ENTER)) {
                waitingForRelease = false;
            }
            return false;
        }

        if (displayTimer < 0.5f) return false;

        if (Mouse.isButtonDown(Mouse.LEFT) ||
            Keyboard.isKeyDown(Keyboard.SPACE) ||
            Keyboard.isKeyDown(Keyboard.ENTER)) {
            active = false;
            return true;
        }

        return false;
    }

    public void render(TextureBatch batch) {
        if (!active) return;

        float cx = Game.WORLD_WIDTH / 2f;
        float cy = Game.WORLD_HEIGHT / 2f;

        // Full-screen dark background
        PlaceholderGraphics.drawRect(batch, 0, 0,
            Game.WORLD_WIDTH, Game.WORLD_HEIGHT, BG_COLOR);

        // Background cross (subtle, behind text)
        float crossW = 6f;
        float crossH = 200f;
        PlaceholderGraphics.drawRect(batch, cx - crossW / 2f, cy - crossH / 2f,
            crossW, crossH, CROSS_COLOR);
        PlaceholderGraphics.drawRect(batch, cx - crossH * 0.35f, cy + crossH * 0.1f,
            crossH * 0.7f, crossW, CROSS_COLOR);

        // Central text area
        float boxW = 580f;
        float boxH = 350f;
        float boxX = (Game.WORLD_WIDTH - boxW) / 2f;
        float boxY = (Game.WORLD_HEIGHT - boxH) / 2f;

        PlaceholderGraphics.drawRect(batch, boxX, boxY, boxW, boxH, TEXT_AREA);

        // Inner panel for depth
        float inset = 6f;
        PlaceholderGraphics.drawRect(batch, boxX + inset, boxY + inset,
            boxW - inset * 2, boxH - inset * 2, TEXT_AREA_INNER);

        // Gold border (double line for elegance)
        float b = 2f;
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY - b, boxW + b * 2, b, ACCENT);
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY + boxH, boxW + b * 2, b, ACCENT);
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY, b, boxH, ACCENT);
        PlaceholderGraphics.drawRect(batch, boxX + boxW, boxY, b, boxH, ACCENT);

        // Dim outer border
        float b2 = 1f;
        PlaceholderGraphics.drawRect(batch, boxX - b - 3, boxY - b - 3, boxW + (b + 3) * 2, b2, ACCENT_DIM);
        PlaceholderGraphics.drawRect(batch, boxX - b - 3, boxY + boxH + b + 2, boxW + (b + 3) * 2, b2, ACCENT_DIM);
        PlaceholderGraphics.drawRect(batch, boxX - b - 3, boxY - b - 3, b2, boxH + (b + 3) * 2, ACCENT_DIM);
        PlaceholderGraphics.drawRect(batch, boxX + boxW + b + 2, boxY - b - 3, b2, boxH + (b + 3) * 2, ACCENT_DIM);

        // Decorative corner accents
        float cornerSize = 12f;
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY + boxH - cornerSize, cornerSize, b, ACCENT);
        PlaceholderGraphics.drawRect(batch, boxX + boxW - cornerSize + b, boxY + boxH - cornerSize, cornerSize, b, ACCENT);
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY + cornerSize, cornerSize, b, ACCENT);
        PlaceholderGraphics.drawRect(batch, boxX + boxW - cornerSize + b, boxY + cornerSize, cornerSize, b, ACCENT);

        // Stage name at top
        if (stageName != null) {
            Fonts.drawCentered(batch, Fonts.large(), stageName,
                cx, boxY + boxH - 30, ACCENT);

            // Underline
            float nameW = Fonts.large().getWidth(stageName);
            PlaceholderGraphics.drawRect(batch, cx - nameW / 2f, boxY + boxH - 38,
                nameW, 1f, ACCENT_DIM);
        }

        // Text lines (allow more lines with the taller box)
        float lineY = boxY + boxH - 70;
        for (int i = 0; i < lines.length && i < 12; i++) {
            Color lineColor = lines[i].startsWith("—") || lines[i].startsWith("-")
                ? ACCENT_DIM : Color.WHITE;
            Fonts.drawCentered(batch, Fonts.small(), lines[i],
                cx, lineY, lineColor);
            lineY -= 16;
        }

        // "Click to continue" prompt (blinking)
        if (displayTimer > 0.5f) {
            boolean blink = ((int)(displayTimer * 2)) % 2 == 0;
            if (blink) {
                Fonts.drawCentered(batch, Fonts.small(), "[ Click to continue ]",
                    cx, boxY + 15, Color.GRAY);
            }
        }
    }

    public boolean isActive() { return active; }
}
