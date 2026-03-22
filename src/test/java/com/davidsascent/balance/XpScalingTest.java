package com.davidsascent.balance;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests the XP scaling formula to ensure the leveling curve is sensible.
 * Formula: xpToNextLevel = floor(previous * scaleFactor)
 * With base=20, factor=1.3:
 *   L1->L2: 20, L2->L3: 26, L3->L4: 33, ..., L10->L11: 211
 */
class XpScalingTest {

    private static final int BASE_XP = 20;
    private static final float SCALE_FACTOR = 1.3f;

    private int xpForLevel(int level) {
        int xp = BASE_XP;
        for (int i = 1; i < level; i++) {
            xp = (int) (xp * SCALE_FACTOR);
        }
        return xp;
    }

    @Test
    void firstLevelRequires20Xp() {
        assertEquals(20, xpForLevel(1));
    }

    @Test
    void xpRequirementIncreases() {
        int prev = xpForLevel(1);
        for (int i = 2; i <= 15; i++) {
            int next = xpForLevel(i);
            assertTrue(next > prev, "Level " + i + " should require more XP than level " + (i - 1));
            prev = next;
        }
    }

    @Test
    void scalingNeverExplodesToUnreasonableValues() {
        // By level 20, XP should still be reachable (< 5000)
        int xpAt20 = xpForLevel(20);
        assertTrue(xpAt20 < 5000, "XP at level 20 should be < 5000 but was " + xpAt20);
        assertTrue(xpAt20 > 100, "XP at level 20 should be > 100 but was " + xpAt20);
    }

    @Test
    void level10RequirementIsReasonable() {
        // At 1.3x scaling from 20, level 10 should need ~211 XP
        int xp = xpForLevel(10);
        assertTrue(xp >= 150 && xp <= 300,
            "Level 10 XP should be 150-300 but was " + xp);
    }
}
