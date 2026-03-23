package com.davidsascent.core;

import valthorne.graphics.animation.Animation;
import valthorne.graphics.animation.AnimationFrame;
import valthorne.graphics.animation.PlaybackMode;
import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureData;
import valthorne.graphics.texture.TextureFilter;
import valthorne.graphics.texture.TextureRegion;
import valthorne.graphics.texture.TextureRegionDrawable;
import valthorne.graphics.texture.TextureBatch;
import valthorne.io.file.ValthorneFiles;

/**
 * A horizontal sprite sheet split into equal-width frames.
 * Uses Valthorne's built-in Animation and TextureRegionDrawable systems.
 */
public class SpriteSheet {

    private final Texture texture;
    private final Animation animation;
    private final int frameCount;

    /**
     * Load a horizontal sprite sheet PNG from classpath.
     * Uses Valthorne's TextureData.load for PNG decoding with vertical flip.
     *
     * @param path classpath resource path (e.g. "sprites/characters/char_david_idle.png")
     * @param frameWidth width of each frame in pixels
     * @param frameHeight height of each frame in pixels
     * @param fps animation speed in frames per second
     */
    public SpriteSheet(String path, int frameWidth, int frameHeight, float fps) {
        // Load texture from classpath using Valthorne's built-in decoder
        byte[] bytes = ValthorneFiles.readBytes(path);
        TextureData data = TextureData.load(bytes, true); // flip vertically for OpenGL
        this.texture = new Texture(data);
        this.texture.setFilter(TextureFilter.NEAREST);

        // Split into frame regions wrapped as Drawables
        int totalWidth = texture.getWidth();
        this.frameCount = totalWidth / frameWidth;

        float frameDuration = 1f / fps;
        AnimationFrame[] animFrames = new AnimationFrame[frameCount];

        for (int i = 0; i < frameCount; i++) {
            TextureRegion region = new TextureRegion(texture, i * frameWidth, 0, frameWidth, frameHeight);
            TextureRegionDrawable drawable = new TextureRegionDrawable(region);
            animFrames[i] = new AnimationFrame(drawable, frameDuration);
        }

        // Create Valthorne Animation
        this.animation = new Animation(PlaybackMode.FORWARD, animFrames);
        this.animation.setLooping(true);
        this.animation.play();
    }

    /**
     * Load a single static sprite (1 frame) from classpath.
     */
    public SpriteSheet(String path, int width, int height) {
        this(path, width, height, 1f);
    }

    /**
     * Advance the animation timer.
     */
    public void update(float delta) {
        animation.update(delta);
    }

    /**
     * Reset animation to frame 0.
     */
    public void reset() {
        animation.restart();
    }

    /**
     * Draw the current animation frame at the given position and size.
     */
    public void draw(TextureBatch batch, float x, float y, float width, float height) {
        animation.draw(batch, x, y, width, height);
    }

    /**
     * Check if a non-looping animation has finished playing.
     */
    public boolean isFinished() {
        return animation.isFinished();
    }

    public void setLooping(boolean looping) {
        animation.setLooping(looping);
    }

    public int getFrameCount() {
        return frameCount;
    }

    /**
     * Get the underlying texture (for static rendering without animation).
     */
    public Texture getTexture() {
        return texture;
    }

    /**
     * Load a static texture from classpath using Valthorne's TextureData.
     * For tiles, UI elements, etc. that don't animate.
     */
    public static Texture loadTextureFromClasspath(String path) {
        byte[] bytes = ValthorneFiles.readBytes(path);
        TextureData data = TextureData.load(bytes, true);
        Texture tex = new Texture(data);
        tex.setFilter(TextureFilter.NEAREST);
        return tex;
    }

    public void dispose() {
        texture.dispose();
    }
}
