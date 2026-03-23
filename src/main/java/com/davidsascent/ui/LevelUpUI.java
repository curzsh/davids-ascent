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
 * Shows 3 upgrade cards styled as parchment with Holy Land palette colors.
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

    // Holy Land palette — parchment card colors
    private static final Color CARD_COLOR = new Color(0.36f, 0.23f, 0.1f, 1f);
    private static final Color CARD_HIGHLIGHT = new Color(0.45f, 0.30f, 0.14f, 1f);
    private static final Color CARD_INNER = new Color(0.30f, 0.18f, 0.07f, 1f);
    private static final Color CARD_INNER_HIGHLIGHT = new Color(0.38f, 0.24f, 0.10f, 1f);
    private static final Color OVERLAY_COLOR = new Color(0f, 0f, 0f, 0.6f);
    private static final Color CARD_BORDER = new Color(0.24f, 0.12f, 0f, 1f);
    private static final Color CARD_BORDER_HOVER = new Color(0.94f, 0.78f, 0.25f, 1f);
    private static final Color CARD_INNER_BORDER = new Color(0.50f, 0.33f, 0.15f, 1f);
    private static final Color WARM_GOLD = new Color(0.94f, 0.78f, 0.25f, 1f);
    private static final Color PARCHMENT = new Color(1f, 0.94f, 0.75f, 1f);
    private static final Color PARCHMENT_DIM = new Color(0.85f, 0.78f, 0.58f, 1f);

    private static final Color[] CARD_ACCENT = {
        new Color(0.63f, 0.36f, 0.17f, 1f),
        new Color(0.16f, 0.38f, 0.63f, 1f),
        new Color(0.94f, 0.78f, 0.25f, 1f)
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
            Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f + CARD_HEIGHT / 2f + 20, WARM_GOLD);

        // Cards
        float totalWidth = choices.size() * CARD_WIDTH + (choices.size() - 1) * CARD_GAP;
        float startX = (Game.WORLD_WIDTH - totalWidth) / 2f;

        for (int i = 0; i < choices.size(); i++) {
            float cardX = startX + i * (CARD_WIDTH + CARD_GAP);
            boolean hovered = (i == hoveredIndex);
            Upgrade upgrade = choices.get(i);

            // Outer dark border (umber frame)
            float borderSize = hovered ? 3f : 2f;
            PlaceholderGraphics.drawRect(batch, cardX - borderSize, CARD_Y - borderSize,
                CARD_WIDTH + borderSize * 2, CARD_HEIGHT + borderSize * 2,
                hovered ? CARD_BORDER_HOVER : CARD_BORDER);

            // Card background (worn leather tone)
            PlaceholderGraphics.drawRect(batch, cardX, CARD_Y,
                CARD_WIDTH, CARD_HEIGHT, hovered ? CARD_HIGHLIGHT : CARD_COLOR);

            // Inner lighter border (1px, parchment feel)
            float inset = 3f;
            PlaceholderGraphics.drawRect(batch, cardX + inset, CARD_Y + inset,
                CARD_WIDTH - inset * 2, 1f, CARD_INNER_BORDER);
            PlaceholderGraphics.drawRect(batch, cardX + inset, CARD_Y + CARD_HEIGHT - inset - 1,
                CARD_WIDTH - inset * 2, 1f, CARD_INNER_BORDER);
            PlaceholderGraphics.drawRect(batch, cardX + inset, CARD_Y + inset,
                1f, CARD_HEIGHT - inset * 2, CARD_INNER_BORDER);
            PlaceholderGraphics.drawRect(batch, cardX + CARD_WIDTH - inset - 1, CARD_Y + inset,
                1f, CARD_HEIGHT - inset * 2, CARD_INNER_BORDER);

            // Inner panel
            PlaceholderGraphics.drawRect(batch, cardX + inset + 1, CARD_Y + inset + 1,
                CARD_WIDTH - (inset + 1) * 2, CARD_HEIGHT - (inset + 1) * 2,
                hovered ? CARD_INNER_HIGHLIGHT : CARD_INNER);

            // Accent stripe at top (earth tones)
            PlaceholderGraphics.drawRect(batch, cardX + inset + 1, CARD_Y + CARD_HEIGHT - inset - 7,
                CARD_WIDTH - (inset + 1) * 2, 5, CARD_ACCENT[i]);

            // Upgrade name (top area)
            float nameY = CARD_Y + CARD_HEIGHT - 30;
            Fonts.drawCentered(batch, Fonts.small(), upgrade.getName(),
                cardX + CARD_WIDTH / 2f, nameY, PARCHMENT);

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
                        cardX + CARD_WIDTH / 2f, lineY, PARCHMENT_DIM);
                    lineY -= 14;
                    line = new StringBuilder(word);
                } else {
                    line = new StringBuilder(test);
                }
            }
            if (!line.isEmpty()) {
                Fonts.drawCentered(batch, Fonts.small(), line.toString(),
                    cardX + CARD_WIDTH / 2f, lineY, PARCHMENT_DIM);
            }

            // Key hint at bottom
            String keyHint = "[" + (i + 1) + "]";
            Fonts.drawCentered(batch, Fonts.small(), keyHint,
                cardX + CARD_WIDTH / 2f, CARD_Y + 12, new Color(0.63f, 0.50f, 0.30f, 1f));
        }
    }

    public boolean isActive() { return active; }
}
