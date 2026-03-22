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
 * Victory screen shown after defeating Goliath.
 * Displays the final scripture and stats with a celebratory tone.
 */
public class VictoryScene extends Scene {

    private final int finalLevel;
    private float timer = 0f;
    private boolean waitingForRelease = true;

    private static final Color BG = new Color(0.02f, 0.04f, 0.08f, 1f);
    private static final Color GOLD_BRIGHT = new Color(1f, 0.85f, 0.3f, 1f);
    private static final Color GOLD_DIM = new Color(0.8f, 0.65f, 0.2f, 1f);

    public VictoryScene(int finalLevel) {
        this.finalLevel = finalLevel;
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

        if (timer < 2.0f) return; // let them read it

        if (Mouse.isButtonDown(Mouse.LEFT) ||
            Keyboard.isKeyDown(Keyboard.SPACE) ||
            Keyboard.isKeyDown(Keyboard.ENTER)) {
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
        float topY = Game.WORLD_HEIGHT - 80;

        // Title
        Fonts.drawCentered(batch, Fonts.large(), "THE GIANT HAS FALLEN",
            cx, topY, GOLD_BRIGHT);

        // Scripture
        Fonts.drawCentered(batch, Fonts.small(),
            "\"So David triumphed over the",
            cx, topY - 60, Color.WHITE);
        Fonts.drawCentered(batch, Fonts.small(),
            "Philistine with a sling and a stone;",
            cx, topY - 80, Color.WHITE);
        Fonts.drawCentered(batch, Fonts.small(),
            "without a sword in his hand he",
            cx, topY - 100, Color.WHITE);
        Fonts.drawCentered(batch, Fonts.small(),
            "struck down the Philistine",
            cx, topY - 120, Color.WHITE);
        Fonts.drawCentered(batch, Fonts.small(),
            "and killed him.\"",
            cx, topY - 140, Color.WHITE);
        Fonts.drawCentered(batch, Fonts.small(),
            "- 1 Samuel 17:50",
            cx, topY - 170, GOLD_DIM);

        // Stats
        Fonts.drawCentered(batch, Fonts.medium(), "Final Level: " + finalLevel,
            cx, topY - 230, GOLD_DIM);

        Fonts.drawCentered(batch, Fonts.medium(), "All 5 stages complete!",
            cx, topY - 260, Color.GREEN);

        // Stars decoration (simple rectangles as sparkles)
        float sparkle = (float) Math.sin(timer * 3f) * 0.5f + 0.5f;
        Color sparkleColor = new Color(1f, 1f, sparkle, sparkle * 0.8f);
        for (int i = 0; i < 8; i++) {
            float angle = (float)(i * Math.PI * 2 / 8 + timer * 0.5f);
            float sx = cx + (float) Math.cos(angle) * 180f;
            float sy = topY - 140 + (float) Math.sin(angle) * 80f;
            PlaceholderGraphics.drawRect(batch, sx - 2, sy - 2, 4, 4, sparkleColor);
        }

        // Play again prompt
        if (timer > 2.0f && ((int)(timer * 2)) % 2 == 0) {
            Fonts.drawCentered(batch, Fonts.small(), "Click to play again",
                cx, 40, Color.GRAY);
        }

        // Credits
        Fonts.drawCentered(batch, Fonts.small(), "David's Ascent",
            cx, 80, new Color(0.4f, 0.4f, 0.5f, 1f));
    }

    @Override
    public void dispose() {}
}
