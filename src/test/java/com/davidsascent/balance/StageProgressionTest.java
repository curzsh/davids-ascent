package com.davidsascent.balance;

import com.davidsascent.stage.StageData;
import com.davidsascent.stage.StageData.EnemyWave;
import com.davidsascent.stage.StageDatabase;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests that stage difficulty progresses in a reasonable curve.
 * Checks enemy HP, damage, and speed trends across the 5 stages.
 */
class StageProgressionTest {

    private static StageData[] stages;

    @BeforeAll
    static void loadStages() {
        stages = StageDatabase.getAllStages();
    }

    @Test
    void allFiveStagesExist() {
        assertEquals(5, stages.length, "Should have exactly 5 stages");
    }

    @Test
    void stageNumbersAreSequential() {
        for (int i = 0; i < stages.length; i++) {
            assertEquals(i + 1, stages[i].getStageNumber(),
                "Stage " + (i + 1) + " should have stageNumber=" + (i + 1));
        }
    }

    @Test
    void everyStageHasWaves() {
        for (StageData stage : stages) {
            assertTrue(stage.getWaves().length > 0,
                "Stage " + stage.getStageNumber() + " (" + stage.getName() + ") has no waves");
        }
    }

    @Test
    void everyStageHasDialogue() {
        for (StageData stage : stages) {
            assertNotNull(stage.getPreDialogue(), "Stage " + stage.getStageNumber() + " needs preDialogue");
            assertNotNull(stage.getScripture(), "Stage " + stage.getStageNumber() + " needs scripture");
            assertNotNull(stage.getPostDialogue(), "Stage " + stage.getStageNumber() + " needs postDialogue");
            assertFalse(stage.getPreDialogue().isEmpty(), "Stage " + stage.getStageNumber() + " preDialogue is empty");
            assertFalse(stage.getScripture().isEmpty(), "Stage " + stage.getStageNumber() + " scripture is empty");
        }
    }

    @Test
    void laterStagesHarderThanEarly() {
        // Overall trend: stages 3-4 should be harder than stage 1
        // Stage 5 (Goliath) may be different (boss stage with soldier mobs)
        float stage1Hp = averageWaveStat(stages[0], w -> w.health);
        float stage4Hp = averageWaveStat(stages[3], w -> w.health);
        assertTrue(stage4Hp > stage1Hp,
            "Stage 4 avg HP (" + stage4Hp + ") should exceed stage 1 (" + stage1Hp + ")");
    }

    @Test
    void laterStagesMoreDamageThanEarly() {
        float stage1Dmg = averageWaveStat(stages[0], w -> w.damage);
        float stage4Dmg = averageWaveStat(stages[3], w -> w.damage);
        assertTrue(stage4Dmg > stage1Dmg,
            "Stage 4 avg damage (" + stage4Dmg + ") should exceed stage 1 (" + stage1Dmg + ")");
    }

    @Test
    void noEnemyHasZeroHp() {
        for (StageData stage : stages) {
            for (EnemyWave wave : stage.getWaves()) {
                assertTrue(wave.health > 0,
                    "Stage " + stage.getStageNumber() + " has a wave with 0 HP");
            }
        }
    }

    @Test
    void noEnemyHasZeroXp() {
        for (StageData stage : stages) {
            for (EnemyWave wave : stage.getWaves()) {
                assertTrue(wave.xpValue > 0,
                    "Stage " + stage.getStageNumber() + " has a wave with 0 XP");
            }
        }
    }

    @Test
    void laterStagesHaveMoreEnemiesThanEarly() {
        int stage1Count = totalEnemies(stages[0]);
        int stage4Count = totalEnemies(stages[3]);
        assertTrue(stage4Count > stage1Count,
            "Stage 4 total enemies (" + stage4Count + ") should exceed stage 1 (" + stage1Count + ")");
    }

    private int totalEnemies(StageData stage) {
        int total = 0;
        for (EnemyWave wave : stage.getWaves()) {
            total += wave.count;
        }
        return total;
    }

    // --- Helper ---

    @FunctionalInterface
    interface WaveStat {
        float get(EnemyWave wave);
    }

    private float averageWaveStat(StageData stage, WaveStat stat) {
        float sum = 0;
        for (EnemyWave wave : stage.getWaves()) {
            sum += stat.get(wave);
        }
        return sum / stage.getWaves().length;
    }
}
