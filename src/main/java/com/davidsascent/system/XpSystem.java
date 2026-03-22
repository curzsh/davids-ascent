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

    private final int gemPoolSize;
    private final XpGem[] gems;

    private int currentXp = 0;
    private int currentLevel = 1;
    private int xpToNextLevel;
    private boolean levelUpReady = false;

    /** XP scaling: each level requires more XP. */
    private final float xpScaleFactor;

    /** Collection radius — slightly larger than magnet to ensure pickup. */
    private final float pickupRadius;

    public XpSystem() {
        this.gemPoolSize = com.davidsascent.core.BalanceConfig.getInt("xp.gemPoolSize", 400);
        this.xpToNextLevel = com.davidsascent.core.BalanceConfig.getInt("xp.baseToLevel", 20);
        this.xpScaleFactor = com.davidsascent.core.BalanceConfig.getFloat("xp.scaleFactor", 1.3f);
        this.pickupRadius = com.davidsascent.core.BalanceConfig.getFloat("xp.gemPickupRadius", 20f);
        gems = new XpGem[gemPoolSize];
        for (int i = 0; i < gemPoolSize; i++) {
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
                    < pickupRadius * pickupRadius) {
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
        xpToNextLevel = (int) (xpToNextLevel * xpScaleFactor);
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
