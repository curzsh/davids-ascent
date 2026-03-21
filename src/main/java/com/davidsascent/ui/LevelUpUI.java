package com.davidsascent.ui;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.system.Upgrade;
import valthorne.Keyboard;
import valthorne.Mouse;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;
import valthorne.math.Vector2f;
import valthorne.viewport.Viewport;

import java.util.List;

/**
 * Level-up upgrade selection UI.
 * Shows 3 upgrade cards with names and descriptions.
 */
public class LevelUpUI {

    private List<Upgrade> choices;
    private boolean active = false;
    private int hoveredIndex = -1;
    private boolean waitingForRelease = false;

    private static final float CARD_WIDTH = 180f;
    private static final float CARD_HEIGHT = 220f;
    private static final float CARD_GAP = 20f;
    private static final float CARD_Y = (Game.WORLD_HEIGHT - CARD_HEIGHT) / 2f;

    private static final Color CARD_COLOR = new Color(0.15f, 0.12f, 0.25f, 1f);
    private static final Color CARD_HIGHLIGHT = new Color(0.25f, 0.2f, 0.4f, 1f);
    private static final Color OVERLAY_COLOR = new Color(0f, 0f, 0f, 0.6f);
    private static final Color CARD_BORDER = Color.GOLD;
    private static final Color CARD_BORDER_HOVER = Color.WHITE;

    private static final Color[] CARD_ACCENT = {
        Color.CYAN, Color.GREEN, Color.ORANGE
    };

    public void show(List<Upgrade> choices) {
        this.choices = choices;
        this.active = true;
        this.hoveredIndex = -1;
        this.waitingForRelease = true;
    }

    public Upgrade update(Viewport viewport) {
        if (!active || choices == null) return null;

        if (waitingForRelease) {
            if (!Mouse.isButtonDown(Mouse.LEFT)) {
                waitingForRelease = false;
            }
        }

        Vector2f worldMouse = viewport.screenToWorld(Mouse.getX(), Mouse.getY());
        float mx = worldMouse.getX();
        float my = worldMouse.getY();

        hoveredIndex = -1;
        float totalWidth = choices.size() * CARD_WIDTH + (choices.size() - 1) * CARD_GAP;
        float startX = (Game.WORLD_WIDTH - totalWidth) / 2f;

        for (int i = 0; i < choices.size(); i++) {
            float cardX = startX + i * (CARD_WIDTH + CARD_GAP);
            if (mx >= cardX && mx <= cardX + CARD_WIDTH &&
                my >= CARD_Y && my <= CARD_Y + CARD_HEIGHT) {
                hoveredIndex = i;
                break;
            }
        }

        if (!waitingForRelease && Mouse.isButtonDown(Mouse.LEFT) &&
                hoveredIndex >= 0 && hoveredIndex < choices.size()) {
            Upgrade chosen = choices.get(hoveredIndex);
            active = false;
            return chosen;
        }

        int keyIndex = -1;
        if (Keyboard.isKeyDown(Keyboard.KEY_1)) keyIndex = 0;
        else if (Keyboard.isKeyDown(Keyboard.KEY_2)) keyIndex = 1;
        else if (Keyboard.isKeyDown(Keyboard.KEY_3)) keyIndex = 2;

        if (keyIndex >= 0 && keyIndex < choices.size()) {
            Upgrade chosen = choices.get(keyIndex);
            active = false;
            return chosen;
        }

        return null;
    }

    public void render(TextureBatch batch) {
        if (!active || choices == null) return;

        // Dark overlay
        PlaceholderGraphics.drawRect(batch, 0, 0,
            Game.WORLD_WIDTH, Game.WORLD_HEIGHT, OVERLAY_COLOR);

        // "LEVEL UP!" title
        Fonts.drawCentered(batch, Fonts.large(), "LEVEL UP!",
            Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f + CARD_HEIGHT / 2f + 20, Color.GOLD);

        // Cards
        float totalWidth = choices.size() * CARD_WIDTH + (choices.size() - 1) * CARD_GAP;
        float startX = (Game.WORLD_WIDTH - totalWidth) / 2f;

        for (int i = 0; i < choices.size(); i++) {
            float cardX = startX + i * (CARD_WIDTH + CARD_GAP);
            boolean hovered = (i == hoveredIndex);
            Upgrade upgrade = choices.get(i);

            // Border
            Color borderColor = hovered ? CARD_BORDER_HOVER : CARD_BORDER;
            float borderSize = hovered ? 3f : 2f;
            PlaceholderGraphics.drawRect(batch, cardX - borderSize, CARD_Y - borderSize,
                CARD_WIDTH + borderSize * 2, CARD_HEIGHT + borderSize * 2, borderColor);

            // Background
            PlaceholderGraphics.drawRect(batch, cardX, CARD_Y,
                CARD_WIDTH, CARD_HEIGHT, hovered ? CARD_HIGHLIGHT : CARD_COLOR);

            // Accent stripe at top
            PlaceholderGraphics.drawRect(batch, cardX, CARD_Y + CARD_HEIGHT - 6,
                CARD_WIDTH, 6, CARD_ACCENT[i]);

            // Upgrade name (top area)
            float nameY = CARD_Y + CARD_HEIGHT - 30;
            Fonts.drawCentered(batch, Fonts.small(), upgrade.getName(),
                cardX + CARD_WIDTH / 2f, nameY, Color.WHITE);

            // Description (middle area, word-wrapped manually)
            String desc = upgrade.getDescription();
            float descY = CARD_Y + CARD_HEIGHT / 2f + 10;
            // Simple line splitting by length
            String[] words = desc.split(" ");
            StringBuilder line = new StringBuilder();
            float lineY = descY;
            for (String word : words) {
                String test = line.isEmpty() ? word : line + " " + word;
                if (Fonts.small().getWidth(test) > CARD_WIDTH - 20) {
                    Fonts.drawCentered(batch, Fonts.small(), line.toString(),
                        cardX + CARD_WIDTH / 2f, lineY, Color.LIGHT_GRAY);
                    lineY -= 14;
                    line = new StringBuilder(word);
                } else {
                    line = new StringBuilder(test);
                }
            }
            if (!line.isEmpty()) {
                Fonts.drawCentered(batch, Fonts.small(), line.toString(),
                    cardX + CARD_WIDTH / 2f, lineY, Color.LIGHT_GRAY);
            }

            // Key hint at bottom
            String keyHint = "[" + (i + 1) + "]";
            Fonts.drawCentered(batch, Fonts.small(), keyHint,
                cardX + CARD_WIDTH / 2f, CARD_Y + 12, Color.GRAY);
        }
    }

    public boolean isActive() { return active; }
}
