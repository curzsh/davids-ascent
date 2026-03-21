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
    private static final Color ACCENT = Color.GOLD;

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

        // Full-screen dark background
        PlaceholderGraphics.drawRect(batch, 0, 0,
            Game.WORLD_WIDTH, Game.WORLD_HEIGHT, BG_COLOR);

        // Central text area
        float boxW = 550f;
        float boxH = 320f;
        float boxX = (Game.WORLD_WIDTH - boxW) / 2f;
        float boxY = (Game.WORLD_HEIGHT - boxH) / 2f;

        PlaceholderGraphics.drawRect(batch, boxX, boxY, boxW, boxH, TEXT_AREA);

        // Gold border
        float b = 2f;
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY - b, boxW + b * 2, b, ACCENT);           // bottom
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY + boxH, boxW + b * 2, b, ACCENT);        // top
        PlaceholderGraphics.drawRect(batch, boxX - b, boxY, b, boxH, ACCENT);                        // left
        PlaceholderGraphics.drawRect(batch, boxX + boxW, boxY, b, boxH, ACCENT);                     // right

        // Stage name at top
        if (stageName != null) {
            Fonts.drawCentered(batch, Fonts.large(), stageName,
                Game.WORLD_WIDTH / 2f, boxY + boxH - 30, ACCENT);
        }

        // Text lines
        float lineY = boxY + boxH - 70;
        for (int i = 0; i < lines.length && i < 8; i++) {
            Fonts.drawCentered(batch, Fonts.small(), lines[i],
                Game.WORLD_WIDTH / 2f, lineY, Color.WHITE);
            lineY -= 18;
        }

        // "Click to continue" prompt (blinking)
        if (displayTimer > 0.5f) {
            boolean blink = ((int)(displayTimer * 2)) % 2 == 0;
            if (blink) {
                Fonts.drawCentered(batch, Fonts.small(), "Click to continue",
                    Game.WORLD_WIDTH / 2f, boxY + 15, Color.GRAY);
            }
        }
    }

    public boolean isActive() { return active; }
}
