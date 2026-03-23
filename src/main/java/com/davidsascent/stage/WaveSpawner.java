package com.davidsascent.stage;

import com.davidsascent.Game;
import com.davidsascent.core.GameSprites;
import com.davidsascent.core.SpriteSheet;
import com.davidsascent.entity.ChaserEnemy;
import com.davidsascent.entity.DashEnemy;
import com.davidsascent.entity.Enemy;
import com.davidsascent.entity.ShieldEnemy;
import com.davidsascent.system.EnemySystem;
import valthorne.graphics.Color;

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
    private boolean paused = false;

    /** Pause/resume wave spawning (used for debug boss-only fights). */
    public void setPaused(boolean paused) { this.paused = paused; }

    public void startStage(StageData stage) {
        this.waves = stage.getWaves();
        this.stageTimer = 0f;
        this.stageComplete = false;
        this.spawned = new int[waves.length];
        this.spawnTimers = new float[waves.length];
    }

    public void update(float delta, EnemySystem enemySystem) {
        if (stageComplete || waves == null || paused) return;

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
        // Assign sprite based on enemy color (which maps to type)
        SpriteSheet sprite = getSpriteForColor(wave.color);
        if (sprite != null) {
            enemy.setSpriteSheet(sprite);
        }
        enemySystem.addEnemy(enemy);
    }

    /**
     * Map enemy color to sprite sheet by matching RGB values.
     * Uses approximate matching since Color instances from StageDatabase
     * may not be the same reference as Color constants.
     */
    private SpriteSheet getSpriteForColor(Color color) {
        int r = color.getRed();
        int g = color.getGreen();
        int b = color.getBlue();

        // Stage 1: animals
        if (colorsMatch(color, Color.ORANGE)) return GameSprites.lionWalk;
        if (colorsMatch(color, Color.GRAY)) return GameSprites.wolfWalk;
        if (colorsMatch(color, Color.GREEN)) return GameSprites.snakeMove;

        // Stage 2: large animals
        if (colorsMatch(color, Color.BROWN)) return GameSprites.bearWalk;
        // BEAST color (0.6, 0.4, 0.2) = boar
        if (r > 140 && r < 170 && g > 90 && g < 115 && b > 40 && b < 60) return GameSprites.boarWalk;

        // Stage 3: Philistine scouts
        if (colorsMatch(color, Color.PURPLE)) return GameSprites.scoutWalk;
        if (colorsMatch(color, Color.MAGENTA)) return GameSprites.archerWalk;

        // Stage 4-5: Philistine army
        if (colorsMatch(color, Color.RED)) return GameSprites.soldierWalk;
        if (colorsMatch(color, Color.CRIMSON)) return GameSprites.shieldbearerWalk;

        return null;
    }

    private boolean colorsMatch(Color a, Color b) {
        return Math.abs(a.getRed() - b.getRed()) < 5
            && Math.abs(a.getGreen() - b.getGreen()) < 5
            && Math.abs(a.getBlue() - b.getBlue()) < 5;
    }

    public boolean isStageComplete() { return stageComplete; }
    public float getStageTimer() { return stageTimer; }
}
