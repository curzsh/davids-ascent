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

        Fonts.drawCentered(batch, Fonts.large(), "YOU HAVE FALLEN",
            cx, Game.WORLD_HEIGHT / 2f + 80, Color.RED);

        Fonts.drawCentered(batch, Fonts.medium(), "Stage " + stageReached,
            cx, Game.WORLD_HEIGHT / 2f + 30, Color.LIGHT_GRAY);

        Fonts.drawCentered(batch, Fonts.small(), "Level " + finalLevel,
            cx, Game.WORLD_HEIGHT / 2f + 5, Color.GOLD);

        Fonts.drawCentered(batch, Fonts.small(), "\"Be strong and courageous.\"",
            cx, Game.WORLD_HEIGHT / 2f - 30, new Color(0.6f, 0.5f, 0.3f, 1f));
        Fonts.drawCentered(batch, Fonts.small(), "- Joshua 1:9",
            cx, Game.WORLD_HEIGHT / 2f - 50, new Color(0.5f, 0.4f, 0.2f, 1f));

        // Blinking prompt
        if (timer > 1.0f && ((int)(timer * 2)) % 2 == 0) {
            Fonts.drawCentered(batch, Fonts.small(), "Click to try again",
                cx, Game.WORLD_HEIGHT / 2f - 60, Color.GRAY);
        }
    }

    @Override
    public void dispose() {}
}
