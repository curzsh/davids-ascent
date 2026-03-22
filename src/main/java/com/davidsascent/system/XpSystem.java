package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.entity.Player;
import com.davidsascent.entity.XpGem;
import valthorne.graphics.texture.TextureBatch;

/**
 * Manages XP gems, collection, leveling, and the XP bar.
 * Pools gems to avoid allocations during gameplay.
 */
public class XpSystem {

    private static final int GEM_POOL_SIZE = 400;
    private final XpGem[] gems;

    private int currentXp = 0;
    private int currentLevel = 1;
    private int xpToNextLevel = 20;
    private boolean levelUpReady = false;

    /** XP scaling: each level requires more XP. */
    private static final float XP_SCALE_FACTOR = 1.3f;

    /** Collection radius — slightly larger than magnet to ensure pickup. */
    private static final float PICKUP_RADIUS = 20f;

    public XpSystem() {
        gems = new XpGem[GEM_POOL_SIZE];
        for (int i = 0; i < GEM_POOL_SIZE; i++) {
            gems[i] = new XpGem();
        }
    }

    /**
     * Spawn an XP gem at the given position.
     */
    public void spawnGem(float x, float y, int value) {
        for (XpGem gem : gems) {
            if (!gem.isActive()) {
                gem.init(x, y, value);
                return;
            }
        }
        // Pool exhausted — gem is lost (acceptable for jam)
    }

    public void update(float delta, Player player) {
        if (levelUpReady) return; // freeze gems while level-up screen is active

        float px = player.getCenterX();
        float py = player.getCenterY();

        for (XpGem gem : gems) {
            if (!gem.isActive()) continue;

            gem.update(delta, px, py);

            // Check collection
            if (Collision.distanceSquared(px, py, gem.getX(), gem.getY())
                    < PICKUP_RADIUS * PICKUP_RADIUS) {
                currentXp += gem.getValue();
                gem.deactivate();

                // Check level up
                if (currentXp >= xpToNextLevel) {
                    levelUpReady = true;
                }
            }
        }
    }

    /**
     * Called when the player picks an upgrade and the level-up is consumed.
     */
    public void consumeLevelUp() {
        currentXp -= xpToNextLevel;
        currentLevel++;
        xpToNextLevel = (int) (xpToNextLevel * XP_SCALE_FACTOR);
        levelUpReady = false;

        // Check if we have enough for another immediate level-up
        if (currentXp >= xpToNextLevel) {
            levelUpReady = true;
        }
    }

    public void render(TextureBatch batch) {
        for (XpGem gem : gems) {
            if (gem.isActive()) {
                gem.render(batch);
            }
        }
    }

    public boolean isLevelUpReady() { return levelUpReady; }
    public int getCurrentXp() { return currentXp; }
    public int getXpToNextLevel() { return xpToNextLevel; }
    public int getCurrentLevel() { return currentLevel; }
    public float getXpPercent() { return (float) currentXp / xpToNextLevel; }
}
