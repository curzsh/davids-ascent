package com.davidsascent.stage;

import com.davidsascent.Game;
import com.davidsascent.entity.ChaserEnemy;
import com.davidsascent.entity.DashEnemy;
import com.davidsascent.entity.Enemy;
import com.davidsascent.entity.ShieldEnemy;
import com.davidsascent.system.EnemySystem;

import java.util.Random;

/**
 * Manages wave spawning for a single stage. Reads wave data from StageData
 * and spawns enemies at the right times from screen edges.
 */
public class WaveSpawner {

    private final Random random = new Random();
    private StageData.EnemyWave[] waves;
    private float stageTimer = 0f;

    // Per-wave tracking
    private int[] spawned;       // how many enemies spawned per wave
    private float[] spawnTimers; // time since last spawn per wave
    private boolean stageComplete = false;

    public void startStage(StageData stage) {
        this.waves = stage.getWaves();
        this.stageTimer = 0f;
        this.stageComplete = false;
        this.spawned = new int[waves.length];
        this.spawnTimers = new float[waves.length];
    }

    public void update(float delta, EnemySystem enemySystem) {
        if (stageComplete || waves == null) return;

        stageTimer += delta;

        boolean allWavesDone = true;

        for (int i = 0; i < waves.length; i++) {
            StageData.EnemyWave wave = waves[i];

            // Wave hasn't started yet
            if (stageTimer < wave.startTime) {
                allWavesDone = false;
                continue;
            }

            // Wave is fully spawned
            if (spawned[i] >= wave.count) {
                continue;
            }

            allWavesDone = false;
            spawnTimers[i] += delta;

            // Spawn next enemy in this wave
            if (spawnTimers[i] >= wave.spawnInterval) {
                spawnEnemy(wave, enemySystem);
                spawned[i]++;
                spawnTimers[i] = 0f;
            }
        }

        // Stage complete when all waves are done AND all enemies are dead
        if (allWavesDone && enemySystem.getCount() == 0) {
            stageComplete = true;
        }
    }

    private void spawnEnemy(StageData.EnemyWave wave, EnemySystem enemySystem) {
        float x, y;
        int edge = random.nextInt(4);
        float margin = 30f;
        switch (edge) {
            case 0 -> { x = random.nextFloat() * Game.WORLD_WIDTH; y = Game.WORLD_HEIGHT + margin; }
            case 1 -> { x = random.nextFloat() * Game.WORLD_WIDTH; y = -margin; }
            case 2 -> { x = -margin; y = random.nextFloat() * Game.WORLD_HEIGHT; }
            default -> { x = Game.WORLD_WIDTH + margin; y = random.nextFloat() * Game.WORLD_HEIGHT; }
        }

        Enemy enemy = switch (wave.type) {
            case SHIELD -> new ShieldEnemy(
                x, y, wave.health, wave.speed, wave.damage,
                wave.xpValue, wave.size, wave.color);
            case DASHER -> new DashEnemy(
                x, y, wave.health, wave.speed, wave.damage,
                wave.xpValue, wave.size, wave.color);
            default -> new ChaserEnemy(
                x, y, wave.health, wave.speed, wave.damage,
                wave.xpValue, wave.size, wave.color);
        };
        enemySystem.addEnemy(enemy);
    }

    public boolean isStageComplete() { return stageComplete; }
    public float getStageTimer() { return stageTimer; }
}
