package com.davidsascent.stage;

import valthorne.graphics.Color;

/**
 * Defines the data for a single stage — enemy types, wave composition,
 * duration, and narrative text.
 */
public class StageData {

    private final int stageNumber;
    private final String name;
    private final String preDialogue;
    private final String scripture;
    private final String postDialogue;
    private final EnemyWave[] waves;
    private final Color arenaColor;

    public StageData(int stageNumber, String name,
                     String preDialogue, String scripture, String postDialogue,
                     EnemyWave[] waves, Color arenaColor) {
        this.stageNumber = stageNumber;
        this.name = name;
        this.preDialogue = preDialogue;
        this.scripture = scripture;
        this.postDialogue = postDialogue;
        this.waves = waves;
        this.arenaColor = arenaColor;
    }

    public int getStageNumber() { return stageNumber; }
    public String getName() { return name; }
    public String getPreDialogue() { return preDialogue; }
    public String getScripture() { return scripture; }
    public String getPostDialogue() { return postDialogue; }
    public EnemyWave[] getWaves() { return waves; }
    public Color getArenaColor() { return arenaColor; }

    /**
     * Defines a single wave within a stage.
     */
    public static class EnemyWave {
        public final float startTime;   // seconds into the stage this wave triggers
        public final int count;          // number of enemies to spawn
        public final int health;
        public final float speed;
        public final int damage;
        public final int xpValue;
        public final float size;
        public final Color color;
        public final float spawnInterval; // seconds between each enemy in this wave

        public EnemyWave(float startTime, int count, int health, float speed,
                         int damage, int xpValue, float size, Color color,
                         float spawnInterval) {
            this.startTime = startTime;
            this.count = count;
            this.health = health;
            this.speed = speed;
            this.damage = damage;
            this.xpValue = xpValue;
            this.size = size;
            this.color = color;
            this.spawnInterval = spawnInterval;
        }
    }
}
