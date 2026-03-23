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

    // Holy Land palette
    private static final Color BG = new Color(0.04f, 0.02f, 0.01f, 1f);
    private static final Color GOLD_BRIGHT = new Color(0.94f, 0.78f, 0.25f, 1f);
    private static final Color GOLD_DIM = new Color(0.63f, 0.50f, 0.20f, 1f);
    private static final Color PARCHMENT = new Color(1f, 0.94f, 0.75f, 1f);
    private final Color sparkleColor = new Color(1f, 1f, 1f, 1f);

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
            cx, topY - 55, PARCHMENT);
        Fonts.drawCentered(batch, Fonts.small(),
            "Philistine with a sling and a stone.",
            cx, topY - 73, PARCHMENT);
        Fonts.drawCentered(batch, Fonts.small(),
            "Without a sword in his hand,",
            cx, topY - 91, PARCHMENT);
        Fonts.drawCentered(batch, Fonts.small(),
            "he struck down the Philistine",
            cx, topY - 109, PARCHMENT);
        Fonts.drawCentered(batch, Fonts.small(),
            "and killed him.\"",
            cx, topY - 127, PARCHMENT);
        Fonts.drawCentered(batch, Fonts.small(),
            "- 1 Samuel 17:50",
            cx, topY - 155, GOLD_DIM);

        // Narrative coda
        Fonts.drawCentered(batch, Fonts.small(),
            "The shepherd who was overlooked",
            cx, topY - 195, GOLD_DIM);
        Fonts.drawCentered(batch, Fonts.small(),
            "became the champion Israel never",
            cx, topY - 213, GOLD_DIM);
        Fonts.drawCentered(batch, Fonts.small(),
            "knew it had.",
            cx, topY - 231, GOLD_DIM);

        // Stats
        Fonts.drawCentered(batch, Fonts.medium(), "Final Level: " + finalLevel,
            cx, topY - 280, GOLD_DIM);

        Fonts.drawCentered(batch, Fonts.medium(), "All 5 stages complete!",
            cx, topY - 310, new Color(0.45f, 0.70f, 0.30f, 1f));

        // Sparkle decorations (tiny 2x2 pixel sparkles)
        float sparkle = (float) Math.sin(timer * 3f) * 0.5f + 0.5f;
        sparkleColor.set(0.94f, 0.85f, sparkle * 0.5f + 0.3f, sparkle * 0.8f);
        for (int i = 0; i < 8; i++) {
            float angle = (float)(i * Math.PI * 2 / 8 + timer * 0.5f);
            float sx = cx + (float) Math.cos(angle) * 180f;
            float sy = topY - 140 + (float) Math.sin(angle) * 80f;
            PlaceholderGraphics.drawRect(batch, sx - 1, sy - 1, 2, 2, sparkleColor);
        }

        // Play again prompt
        if (timer > 2.0f && ((int)(timer * 2)) % 2 == 0) {
            Fonts.drawCentered(batch, Fonts.small(), "Click to play again",
                cx, 40, GOLD_DIM);
        }

        // Credits
        Fonts.drawCentered(batch, Fonts.small(), "David's Ascent",
            cx, 80, new Color(0.50f, 0.38f, 0.20f, 1f));
    }

    @Override
    public void dispose() {
        // Shared resources (Fonts, PlaceholderGraphics) persist across scenes
    }
}
