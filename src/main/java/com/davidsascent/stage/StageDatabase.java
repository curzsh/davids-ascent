package com.davidsascent.stage;

import com.davidsascent.stage.StageData.EnemyWave;
import valthorne.graphics.Color;

/**
 * All 5 stages of David's Ascent, fully defined with waves and dialogue.
 */
public final class StageDatabase {

    private StageDatabase() {}

    private static final Color WILDERNESS_BG = new Color(0.05f, 0.08f, 0.03f, 1f);
    private static final Color ROCKY_BG = new Color(0.08f, 0.06f, 0.04f, 1f);
    private static final Color BORDER_BG = new Color(0.06f, 0.04f, 0.08f, 1f);
    private static final Color BATTLEFIELD_BG = new Color(0.08f, 0.03f, 0.03f, 1f);
    private static final Color VALLEY_BG = new Color(0.04f, 0.04f, 0.06f, 1f);

    // Enemy colors by type
    private static final Color LION = Color.ORANGE;
    private static final Color WOLF = Color.GRAY;
    private static final Color SNAKE = Color.GREEN;
    private static final Color BEAR = Color.BROWN;
    private static final Color BEAST = new Color(0.6f, 0.4f, 0.2f, 1f);
    private static final Color SCOUT = Color.PURPLE;
    private static final Color ARCHER = Color.MAGENTA;
    private static final Color SOLDIER = Color.RED;
    private static final Color SHIELD = Color.CRIMSON;

    public static StageData[] getAllStages() {
        return new StageData[] {
            stage1_Lion(),
            stage2_Bear(),
            stage3_Scouts(),
            stage4_Army(),
            stage5_Goliath()
        };
    }

    private static StageData stage1_Lion() {
        return new StageData(1, "The Lion",
            "Young David tends his father's sheep in the wilderness.\nBut danger lurks in the tall grass...",
            "\"The Lord is my shepherd, I shall not want.\"\n— Psalm 23:1",
            "The flock is safe. But darker trials await.",
            new EnemyWave[] {
                //          startTime, count, hp,  speed, dmg, xp, size, color,     interval
                new EnemyWave(1f,     5,     20,  60f,   8,   5,  20f,  SNAKE,     0.8f),
                new EnemyWave(8f,     6,     25,  70f,   10,  8,  22f,  WOLF,      0.7f),
                new EnemyWave(18f,    4,     40,  55f,   15,  12, 28f,  LION,      1.0f),
                new EnemyWave(28f,    8,     25,  75f,   10,  8,  22f,  WOLF,      0.5f),
                new EnemyWave(35f,    3,     50,  50f,   18,  15, 30f,  LION,      0.8f),
            },
            WILDERNESS_BG
        );
    }

    private static StageData stage2_Bear() {
        return new StageData(2, "The Bear",
            "David ventures into the rocky hills.\nThe beasts here are fiercer than any lion.",
            "\"He delivered me from the paw of the lion\nand the paw of the bear.\"\n— 1 Samuel 17:37",
            "David's courage grows with each trial.",
            new EnemyWave[] {
                new EnemyWave(1f,     6,     30,  65f,   10,  8,  22f,  WOLF,      0.6f),
                new EnemyWave(10f,    4,     50,  50f,   15,  12, 30f,  BEAST,     0.8f),
                new EnemyWave(18f,    3,     70,  45f,   20,  18, 34f,  BEAR,      1.0f),
                new EnemyWave(26f,    8,     30,  80f,   10,  8,  22f,  WOLF,      0.4f),
                new EnemyWave(32f,    5,     70,  50f,   20,  18, 34f,  BEAR,      0.7f),
                new EnemyWave(40f,    2,     90,  40f,   25,  25, 38f,  BEAR,      1.0f),
            },
            ROCKY_BG
        );
    }

    private static StageData stage3_Scouts() {
        return new StageData(3, "The Scouts",
            "David reaches the Philistine border.\nEnemy scouts patrol the land.",
            "\"The battle is the Lord's, and He will\ngive all of you into our hands.\"\n— 1 Samuel 17:47",
            "The scouts have fallen. But their army draws near.",
            new EnemyWave[] {
                new EnemyWave(1f,     6,     35,  80f,   12,  10, 22f,  SCOUT,     0.6f),
                new EnemyWave(10f,    4,     40,  70f,   15,  12, 24f,  ARCHER,    0.7f),
                new EnemyWave(18f,    8,     35,  85f,   12,  10, 22f,  SCOUT,     0.4f),
                new EnemyWave(25f,    6,     40,  75f,   15,  12, 24f,  ARCHER,    0.5f),
                new EnemyWave(32f,    10,    35,  90f,   12,  10, 22f,  SCOUT,     0.3f),
                new EnemyWave(38f,    6,     50,  70f,   18,  15, 26f,  ARCHER,    0.5f),
            },
            BORDER_BG
        );
    }

    private static StageData stage4_Army() {
        return new StageData(4, "The Army",
            "The full Philistine army stands before David.\nThis is no longer a skirmish — this is war.",
            "\"David grew stronger and stronger,\nwhile the house of Saul grew weaker.\"\n— 2 Samuel 3:1",
            "The army is broken. Only one remains...",
            new EnemyWave[] {
                new EnemyWave(1f,     8,     40,  75f,   12,  10, 24f,  SOLDIER,   0.4f),
                new EnemyWave(8f,     4,     60,  50f,   18,  15, 30f,  SHIELD,    0.6f),
                new EnemyWave(16f,    10,    40,  80f,   12,  10, 24f,  SOLDIER,   0.3f),
                new EnemyWave(22f,    6,     60,  55f,   18,  15, 30f,  SHIELD,    0.5f),
                new EnemyWave(28f,    12,    45,  85f,   15,  12, 24f,  SOLDIER,   0.25f),
                new EnemyWave(35f,    8,     60,  60f,   18,  15, 30f,  SHIELD,    0.4f),
                new EnemyWave(42f,    15,    40,  90f,   12,  10, 24f,  SOLDIER,   0.2f),
            },
            BATTLEFIELD_BG
        );
    }

    private static StageData stage5_Goliath() {
        return new StageData(5, "Goliath",
            "The Valley of Elah.\nGoliath towers over the battlefield.\nThis is the moment David was born for.",
            "\"You come against me with sword and spear,\nbut I come against you in the name\nof the Lord Almighty.\"\n— 1 Samuel 17:45",
            "The giant has fallen!\nDavid's faith has triumphed over impossible odds.",
            new EnemyWave[] {
                // Goliath fight: guards + the boss (boss will be special later)
                new EnemyWave(1f,     6,     40,  70f,   12,  10, 24f,  SOLDIER,   0.5f),
                new EnemyWave(10f,    8,     40,  80f,   12,  10, 24f,  SOLDIER,   0.4f),
                new EnemyWave(20f,    10,    45,  85f,   15,  12, 24f,  SOLDIER,   0.3f),
                new EnemyWave(30f,    12,    45,  90f,   15,  12, 24f,  SOLDIER,   0.25f),
                // TODO: Add Goliath as a boss entity in this stage
            },
            VALLEY_BG
        );
    }
}
