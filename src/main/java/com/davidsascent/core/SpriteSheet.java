package com.davidsascent.core;

import org.lwjgl.stb.STBImage;
import org.lwjgl.system.MemoryStack;
import org.lwjgl.system.MemoryUtil;
import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureData;
import valthorne.graphics.texture.TextureFilter;
import valthorne.graphics.texture.TextureRegion;
import valthorne.graphics.texture.TextureBatch;
import valthorne.io.file.ValthorneFiles;

import java.nio.ByteBuffer;
import java.nio.IntBuffer;

/**
 * A horizontal sprite sheet split into equal-width frames.
 * Loads from classpath resources so it works inside JARs.
 */
public class SpriteSheet {

    private final Texture texture;
    private final TextureRegion[] frames;
    private final int frameWidth;
    private final int frameHeight;
    private final int frameCount;
    private final float frameDuration;

    private float stateTime = 0f;
    private boolean looping = true;

    /**
     * Load a horizontal sprite sheet PNG from classpath.
     * @param path classpath resource path (e.g. "sprites/characters/char_david_idle.png")
     * @param frameWidth width of each frame in pixels
     * @param frameHeight height of each frame in pixels
     * @param fps animation speed in frames per second
     */
    public SpriteSheet(String path, int frameWidth, int frameHeight, float fps) {
        this.texture = loadTextureFromClasspath(path);
        this.texture.setFilter(TextureFilter.NEAREST);
        this.frameWidth = frameWidth;
        this.frameHeight = frameHeight;
        this.frameDuration = 1f / fps;

        int totalWidth = texture.getWidth();
        this.frameCount = totalWidth / frameWidth;
        this.frames = new TextureRegion[frameCount];

        for (int i = 0; i < frameCount; i++) {
            frames[i] = new TextureRegion(texture, i * frameWidth, 0, frameWidth, frameHeight);
        }
    }

    /**
     * Load a single static sprite (1 frame) from classpath.
     */
    public SpriteSheet(String path, int width, int height) {
        this(path, width, height, 1f);
    }

    /**
     * Load a PNG texture from classpath resources using STB Image.
     * Flips vertically for OpenGL's bottom-left coordinate system.
     */
    static Texture loadTextureFromClasspath(String path) {
        byte[] fileBytes = ValthorneFiles.readBytes(path);
        ByteBuffer fileBuffer = MemoryUtil.memAlloc(fileBytes.length);
        fileBuffer.put(fileBytes).flip();

        try (MemoryStack stack = MemoryStack.stackPush()) {
            IntBuffer widthBuf = stack.mallocInt(1);
            IntBuffer heightBuf = stack.mallocInt(1);
            IntBuffer channelsBuf = stack.mallocInt(1);

            // Flip vertically so sprites render right-side-up in OpenGL
            STBImage.stbi_set_flip_vertically_on_load(true);

            // Decode PNG to RGBA pixels
            ByteBuffer pixels = STBImage.stbi_load_from_memory(
                fileBuffer, widthBuf, heightBuf, channelsBuf, 4);
            if (pixels == null) {
                throw new RuntimeException("Failed to decode image: " + path
                    + " — " + STBImage.stbi_failure_reason());
            }

            int w = widthBuf.get(0);
            int h = heightBuf.get(0);

            TextureData data = new TextureData(pixels, (short) w, (short) h);
            Texture tex = new Texture(data);

            STBImage.stbi_image_free(pixels);
            return tex;
        } finally {
            MemoryUtil.memFree(fileBuffer);
        }
    }

    /**
     * Advance the animation timer.
     */
    public void update(float delta) {
        stateTime += delta;
    }

    /**
     * Reset animation to frame 0.
     */
    public void reset() {
        stateTime = 0f;
    }

    /**
     * Get the current frame's texture region based on elapsed time.
     */
    public TextureRegion getCurrentFrame() {
        int index;
        if (looping) {
            index = (int) (stateTime / frameDuration) % frameCount;
        } else {
            index = Math.min((int) (stateTime / frameDuration), frameCount - 1);
        }
        return frames[index];
    }

    /**
     * Get a specific frame by index.
     */
    public TextureRegion getFrame(int index) {
        return frames[Math.min(index, frameCount - 1)];
    }

    /**
     * Draw the current animation frame at the given position and size.
     */
    public void draw(TextureBatch batch, float x, float y, float width, float height) {
        batch.drawRegion(getCurrentFrame(), x, y, width, height);
    }

    /**
     * Check if a non-looping animation has finished playing.
     */
    public boolean isFinished() {
        return !looping && stateTime >= frameDuration * frameCount;
    }

    public void setLooping(boolean looping) {
        this.looping = looping;
    }

    public int getFrameCount() {
        return frameCount;
    }

    public int getFrameWidth() {
        return frameWidth;
    }

    public int getFrameHeight() {
        return frameHeight;
    }

    public void dispose() {
        texture.dispose();
    }
}
