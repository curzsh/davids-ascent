package com.davidsascent.scene;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import valthorne.Keyboard;
import valthorne.Mouse;
import valthorne.SwapInterval;
import valthorne.Window;
import valthorne.camera.OrthographicCamera;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;
import valthorne.scene.Scene;
import valthorne.viewport.FitViewport;

/**
 * Title screen — the first thing the player sees.
 * Displays the game title, a scripture verse, and start prompt.
 */
public class TitleScene extends Scene {

    private float timer = 0f;

    // Holy Land palette
    private static final Color BG = new Color(0.04f, 0.02f, 0.01f, 1f);
    private static final Color TITLE_COLOR = new Color(0.94f, 0.78f, 0.25f, 1f);
    private static final Color SUBTITLE_COLOR = new Color(0.63f, 0.50f, 0.20f, 1f);
    private static final Color VERSE_COLOR = new Color(1f, 0.94f, 0.75f, 0.7f);
    private static final Color STAR_COLOR = new Color(1f, 0.95f, 0.7f, 0.5f);
    private static final Color HINT_COLOR = new Color(0.50f, 0.38f, 0.20f, 1f);

    // Decorative stars
    private final float[] starX = new float[30];
    private final float[] starY = new float[30];
    private final float[] starSpeed = new float[30];
    private final float[] starSize = new float[30];

    @Override
    public void init() {
        OrthographicCamera camera = new OrthographicCamera();
        camera.setCenter(Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f);
        FitViewport viewport = new FitViewport(Game.WORLD_WIDTH, Game.WORLD_HEIGHT);
        viewport.setCamera(camera);
        viewport.update(Window.getWidth(), Window.getHeight());
        setCamera(camera);
        setViewport(viewport);

        Window.setSwapInterval(SwapInterval.VSYNC);
        Window.setResizable(false);
        PlaceholderGraphics.init();
        Fonts.init();

        // Random star positions (small 2x2 or 3x3 pixel stars)
        for (int i = 0; i < starX.length; i++) {
            starX[i] = (float) (Math.random() * Game.WORLD_WIDTH);
            starY[i] = (float) (Math.random() * Game.WORLD_HEIGHT);
            starSpeed[i] = (float) (Math.random() * 2 + 1);
            starSize[i] = (float) (Math.random() > 0.5 ? 2 : 3);
        }
    }

    @Override
    public void update(float delta) {
        timer += delta;

        if (timer > 0.5f) {
            if (Mouse.isButtonDown(Mouse.LEFT) ||
                Keyboard.isKeyDown(Keyboard.SPACE) ||
                Keyboard.isKeyDown(Keyboard.ENTER)) {
                Game.getGameScreen().setScene(new PlayingScene());
            }
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

        // Twinkling stars (tiny 2x2 or 3x3 pixel points)
        for (int i = 0; i < starX.length; i++) {
            float twinkle = (float) Math.sin(timer * starSpeed[i] + i) * 0.5f + 0.5f;
            if (twinkle > 0.3f) {
                float s = starSize[i];
                Color sc = new Color(1f, 0.95f, 0.7f, twinkle * 0.6f);
                PlaceholderGraphics.drawRect(batch, starX[i], starY[i], s, s, sc);
            }
        }

        // Title
        Fonts.drawCentered(batch, Fonts.large(), "DAVID'S ASCENT",
            cx, Game.WORLD_HEIGHT - 160, TITLE_COLOR);

        // Subtitle
        Fonts.drawCentered(batch, Fonts.medium(), "A Bullet Heaven",
            cx, Game.WORLD_HEIGHT - 200, SUBTITLE_COLOR);

        // Decorative line under title
        float lineW = 200f;
        PlaceholderGraphics.drawRect(batch, cx - lineW / 2f, Game.WORLD_HEIGHT - 215,
            lineW, 1f, SUBTITLE_COLOR);

        // Scripture — the verse that frames David's entire story
        Fonts.drawCentered(batch, Fonts.small(),
            "\"The Lord does not look at the",
            cx, Game.WORLD_HEIGHT - 260, VERSE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(),
            "things people look at.",
            cx, Game.WORLD_HEIGHT - 278, VERSE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(),
            "People look at the outward",
            cx, Game.WORLD_HEIGHT - 296, VERSE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(),
            "appearance, but the Lord",
            cx, Game.WORLD_HEIGHT - 314, VERSE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(),
            "looks at the heart.\"",
            cx, Game.WORLD_HEIGHT - 332, VERSE_COLOR);
        Fonts.drawCentered(batch, Fonts.small(),
            "- 1 Samuel 16:7",
            cx, Game.WORLD_HEIGHT - 358, SUBTITLE_COLOR);

        // Sling illustration (simple arc with small 3x3 squares)
        float slingCx = cx;
        float slingCy = 180f;
        for (int i = 0; i < 12; i++) {
            float angle = (float)(i * Math.PI / 11 - Math.PI / 2 + timer * 0.3f);
            float r = 40f;
            float sx = slingCx + (float) Math.cos(angle) * r;
            float sy = slingCy + (float) Math.sin(angle) * r * 0.5f;
            PlaceholderGraphics.drawRect(batch, sx - 1, sy - 1, 3, 3, SUBTITLE_COLOR);
        }
        // Stone
        float stoneAngle = timer * 0.3f;
        float stoneX = slingCx + (float) Math.cos(stoneAngle - (float)Math.PI / 2) * 44f;
        float stoneY = slingCy + (float) Math.sin(stoneAngle - (float)Math.PI / 2) * 22f;
        PlaceholderGraphics.drawRect(batch, stoneX - 3, stoneY - 3, 6, 6, new Color(0.8f, 0.75f, 0.6f, 1f));

        // Start prompt (blinking)
        if (timer > 0.5f && ((int)(timer * 2)) % 2 == 0) {
            Fonts.drawCentered(batch, Fonts.medium(), "Click to Begin",
                cx, 80, new Color(1f, 0.94f, 0.75f, 1f));
        }

        // Controls hint
        Fonts.drawCentered(batch, Fonts.small(), "WASD to move - Weapons fire automatically",
            cx, 40, HINT_COLOR);
    }

    @Override
    public void dispose() {
        // Shared resources (Fonts, PlaceholderGraphics) persist across scenes
    }
}
