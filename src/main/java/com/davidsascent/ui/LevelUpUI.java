package com.davidsascent.ui;

import com.davidsascent.Game;
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
 * Shows 3 upgrade cards the player picks from by clicking or pressing 1/2/3.
 */
public class LevelUpUI {

    private List<Upgrade> choices;
    private boolean active = false;
    private int hoveredIndex = -1;

    /** Debounce — prevent instant re-selection if mouse is already down. */
    private boolean waitingForClick = false;

    /** Card layout constants. */
    private static final float CARD_WIDTH = 160f;
    private static final float CARD_HEIGHT = 200f;
    private static final float CARD_GAP = 30f;
    private static final float CARD_Y = (Game.WORLD_HEIGHT - CARD_HEIGHT) / 2f;

    private static final Color CARD_COLOR = new Color(0.2f, 0.2f, 0.4f, 1f);
    private static final Color CARD_HIGHLIGHT = new Color(0.3f, 0.3f, 0.6f, 1f);
    private static final Color OVERLAY_COLOR = new Color(0f, 0f, 0f, 0.5f);
    private static final Color CARD_BORDER = Color.GOLD;
    private static final Color CARD_BORDER_HOVER = Color.WHITE;

    // Distinct colors for each card
    private static final Color[] CARD_ACCENT = {
        Color.CYAN, Color.GREEN, Color.ORANGE
    };

    public void show(List<Upgrade> choices) {
        this.choices = choices;
        this.active = true;
        this.hoveredIndex = -1;
        this.waitingForClick = true; // wait for mouse to be released first
    }

    /**
     * Handle input. Returns the selected upgrade or null if none selected yet.
     */
    public Upgrade update(Viewport viewport) {
        if (!active || choices == null) return null;

        // Debounce: wait for mouse release before accepting clicks
        if (waitingForClick) {
            if (!Mouse.isButtonDown(Mouse.LEFT)) {
                waitingForClick = false;
            }
            // Still allow keyboard while waiting
        }

        // Convert mouse screen coords to world coords
        Vector2f worldMouse = viewport.screenToWorld(Mouse.getX(), Mouse.getY());
        float mx = worldMouse.getX();
        float my = worldMouse.getY();

        // Check which card the mouse is hovering
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

        // Mouse click selection
        if (!waitingForClick && Mouse.isButtonDown(Mouse.LEFT) &&
                hoveredIndex >= 0 && hoveredIndex < choices.size()) {
            Upgrade chosen = choices.get(hoveredIndex);
            active = false;
            return chosen;
        }

        // Keyboard selection (still works)
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

        // Dark overlay behind cards
        PlaceholderGraphics.drawRect(batch, 0, 0,
            Game.WORLD_WIDTH, Game.WORLD_HEIGHT, OVERLAY_COLOR);

        // Draw 3 cards side by side
        float totalWidth = choices.size() * CARD_WIDTH + (choices.size() - 1) * CARD_GAP;
        float startX = (Game.WORLD_WIDTH - totalWidth) / 2f;

        for (int i = 0; i < choices.size(); i++) {
            float cardX = startX + i * (CARD_WIDTH + CARD_GAP);
            boolean hovered = (i == hoveredIndex);

            // Card border (highlight on hover)
            Color borderColor = hovered ? CARD_BORDER_HOVER : CARD_BORDER;
            float borderSize = hovered ? 3f : 2f;
            PlaceholderGraphics.drawRect(batch, cardX - borderSize, CARD_Y - borderSize,
                CARD_WIDTH + borderSize * 2, CARD_HEIGHT + borderSize * 2, borderColor);

            // Card background (lighter on hover)
            PlaceholderGraphics.drawRect(batch, cardX, CARD_Y,
                CARD_WIDTH, CARD_HEIGHT, hovered ? CARD_HIGHLIGHT : CARD_COLOR);

            // Card accent stripe at top
            PlaceholderGraphics.drawRect(batch, cardX, CARD_Y + CARD_HEIGHT - 30,
                CARD_WIDTH, 30, CARD_ACCENT[i]);

            // Number indicator at bottom
            float numSize = 24f;
            float numX = cardX + CARD_WIDTH / 2f - numSize / 2f;
            PlaceholderGraphics.drawRect(batch, numX, CARD_Y + 10,
                numSize, numSize, CARD_ACCENT[i]);
        }
    }

    public boolean isActive() { return active; }
}
