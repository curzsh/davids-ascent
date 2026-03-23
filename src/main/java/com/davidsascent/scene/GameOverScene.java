package com.davidsascent.scene;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import valthorne.Keyboard;
import valthorne.Mouse;
import valthorne.Window;
import valthorne.camera.OrthographicCamera;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;
import valthorne.scene.Scene;
import valthorne.viewport.FitViewport;

/**
 * Game Over screen shown when David dies.
 * Shows final stats and allows restart.
 */
public class GameOverScene extends Scene {

    private final int finalLevel;
    private final int stageReached;
    private boolean waitingForRelease = true;
    private float timer = 0f;

    private static final Color BG = new Color(0.1f, 0.02f, 0.02f, 1f);
    private static final Color SCRIPTURE_COLOR = new Color(0.6f, 0.5f, 0.3f, 1f);
    private static final Color SCRIPTURE_DIM = new Color(0.5f, 0.4f, 0.2f, 1f);

    public GameOverScene(int finalLevel, int stageReached) {
        this.finalLevel = finalLevel;
        this.stageReached = stageReached;
    }

    @Override
    public void init() {
        OrthographicCamera camera = new OrthographicCamera();
        camera.setCenter(Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f);
        FitViewport viewport = new FitViewport(Game.WORLD_WIDTH, Game.WORLD_HEIGHT);
        viewport.setCamera(camera);
        viewport.update(Window.getWidth(), Window.getHeight());
        setCamera(camera);
        setViewport(viewport);

        PlaceholderGraphics.init();
        Fonts.init();
    }

    @Override
    public void update(float delta) {
        timer += delta;

        if (waitingForRelease) {
            if (!Mouse.isButtonDown(Mouse.LEFT) &&
                !Keyboard.isKeyDown(Keyboard.SPACE) &&
                !Keyboard.isKeyDown(Keyboard.ENTER)) {
                waitingForRelease = false;
            }
            return;
        }

        if (timer < 1.0f) return; // minimum display time

        if (Mouse.isButtonDown(Mouse.LEFT) ||
            Keyboard.isKeyDown(Keyboard.SPACE) ||
            Keyboard.isKeyDown(Keyboard.ENTER)) {
            // Restart the game
            Game.getGameScreen().setScene(new PlayingScene());
        }
    }

    @Override
    protected void drawScene() {
        Window.clear(BG);
        super.drawScene();
    }

    @Override
    public void draw(TextureBatch batch) {
        float cx = Game.WORLD_WIDTH / 2f;

        Fonts.drawCentered(batch, Fonts.large(), "DO NOT LOSE HEART",
            cx, Game.WORLD_HEIGHT / 2f + 100, SCRIPTURE_COLOR);

        Fonts.drawCentered(batch, Fonts.medium(), "Stage " + stageReached + " — Level " + finalLevel,
            cx, Game.WORLD_HEIGHT / 2f + 55, Color.LIGHT_GRAY);

        Fonts.drawCentered(batch, Fonts.small(), "\"Be strong and courageous.",
            cx, Game.WORLD_HEIGHT / 2f + 15, SCRIPTURE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(), "Do not be afraid;",
            cx, Game.WORLD_HEIGHT / 2f - 1, SCRIPTURE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(), "do not be discouraged,",
            cx, Game.WORLD_HEIGHT / 2f - 17, SCRIPTURE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(), "for the Lord your God will be",
            cx, Game.WORLD_HEIGHT / 2f - 33, SCRIPTURE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(), "with you wherever you go.\"",
            cx, Game.WORLD_HEIGHT / 2f - 49, SCRIPTURE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(), "- Joshua 1:9",
            cx, Game.WORLD_HEIGHT / 2f - 72, SCRIPTURE_DIM);

        Fonts.drawCentered(batch, Fonts.small(), "David faced the giant in his heart",
            cx, Game.WORLD_HEIGHT / 2f - 105, SCRIPTURE_DIM);
        Fonts.drawCentered(batch, Fonts.small(), "before he ever faced him in the valley.",
            cx, Game.WORLD_HEIGHT / 2f - 121, SCRIPTURE_DIM);

        // Blinking prompt
        if (timer > 1.0f && ((int)(timer * 2)) % 2 == 0) {
            Fonts.drawCentered(batch, Fonts.small(), "Click to try again",
                cx, Game.WORLD_HEIGHT / 2f - 155, Color.GRAY);
        }
    }

    @Override
    public void dispose() {
        // Shared resources (Fonts, PlaceholderGraphics) persist across scenes
    }
}
