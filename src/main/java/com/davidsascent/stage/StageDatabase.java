package com.davidsascent.stage;

import com.davidsascent.stage.StageData.EnemyType;
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
            "Young David, son of Jesse, tends his\nfather's sheep in the wilderness.\n\nHe is the youngest of eight brothers,\noverlooked by all — but not by God.\n\nDanger stirs in the tall grass...",
            "\"The Lord is my shepherd,\nI shall not want.\nHe makes me lie down\nin green pastures.\"\n— Psalm 23:1-2",
            "The flock is safe.\nDavid's hands are steady,\nhis faith unshaken.\n\nBut darker trials await\nbeyond these hills.",
            new EnemyWave[] {
                //          startTime, count, hp,  speed, dmg, xp, size, color,     interval
                new EnemyWave(1f,     5,     20,  60f,   8,   3,  20f,  SNAKE,     0.8f),
                new EnemyWave(8f,     6,     25,  70f,   10,  5,  22f,  WOLF,      0.7f),
                new EnemyWave(18f,    4,     40,  55f,   15,  8,  28f,  LION,      1.0f),
                new EnemyWave(28f,    8,     25,  75f,   10,  5,  22f,  WOLF,      0.5f),
                new EnemyWave(35f,    3,     50,  50f,   18,  10, 30f,  LION,      0.8f),
            },
            WILDERNESS_BG
        );
    }

    private static StageData stage2_Bear() {
        return new StageData(2, "The Bear",
            "Word of David's courage reaches\nhis father Jesse.\n\n\"If you can face the lion, my son,\nperhaps you are ready for what\nlies in the rocky hills.\"\n\nThe beasts here are fiercer\nthan any lion.",
            "\"Your servant has killed both\nthe lion and the bear.\nThe Lord who delivered me from\nthe paw of the lion will deliver\nme from this Philistine.\"\n— 1 Samuel 17:37",
            "The wilderness is tamed.\nDavid feels a stirring in his spirit —\na calling to something greater.\n\nRumors of war reach the hills.",
            new EnemyWave[] {
                new EnemyWave(1f,     6,     30,  65f,   10,  5,  22f,  WOLF,      0.6f),
                new EnemyWave(10f,    4,     50,  50f,   15,  8,  30f,  BEAST,     0.8f),
                new EnemyWave(18f,    3,     70,  45f,   20,  12, 34f,  BEAR,      1.0f),
                new EnemyWave(26f,    8,     30,  80f,   10,  5,  22f,  WOLF,      0.4f),
                new EnemyWave(32f,    5,     70,  50f,   20,  12, 34f,  BEAR,      0.7f),
                new EnemyWave(40f,    2,     70,  40f,   25,  18, 38f,  BEAR,      1.0f),
            },
            ROCKY_BG
        );
    }

    private static StageData stage3_Scouts() {
        return new StageData(3, "The Scouts",
            "Jesse sends David to the Valley of\nElah with bread for his brothers.\n\nBut at the border, Philistine\nscouts block the way.\n\nThey are fast — watch for\ntheir charges!",
            "\"The battle is the Lord's,\nand He will give all of you\ninto our hands.\"\n— 1 Samuel 17:47",
            "The scouts have fallen,\nbut David hears a voice\nechoing across the valley —\n\nA giant's voice,\nmocking the armies of Israel.",
            new EnemyWave[] {
                //          startTime, count, hp,  speed, dmg, xp, size, color,   interval, type
                new EnemyWave(1f,     6,     35,  80f,   12,  10, 22f,  SCOUT,     0.6f, EnemyType.DASHER),
                new EnemyWave(10f,    4,     40,  70f,   15,  12, 24f,  ARCHER,    0.7f),
                new EnemyWave(18f,    8,     35,  85f,   12,  10, 22f,  SCOUT,     0.4f, EnemyType.DASHER),
                new EnemyWave(25f,    6,     40,  75f,   15,  12, 24f,  ARCHER,    0.5f),
                new EnemyWave(32f,    7,     35,  90f,   12,  10, 22f,  SCOUT,     0.3f, EnemyType.DASHER),
                new EnemyWave(38f,    6,     50,  70f,   18,  15, 26f,  ARCHER,    0.5f),
            },
            BORDER_BG
        );
    }

    private static StageData stage4_Army() {
        return new StageData(4, "The Army",
            "King Saul offers his armor to David.\nDavid tries it on, but it is too heavy.\n\n\"I cannot go in these,\" David says.\n\"I am not used to them.\"\n\nHe faces the army with only\nhis sling and his faith.\n\nShieldbearers block your attacks!",
            "\"David said to Saul,\n'Let no one lose heart\non account of this Philistine.\nYour servant will go\nand fight him.'\"\n— 1 Samuel 17:32",
            "The army is broken.\nSoldiers flee in every direction.\n\nOnly one remains —\nthe champion of Gath.\nThe giant called Goliath.",
            new EnemyWave[] {
                //          startTime, count, hp,  speed, dmg, xp, size, color,    interval, type
                new EnemyWave(1f,     8,     40,  75f,   12,  10, 24f,  SOLDIER,   0.4f),
                new EnemyWave(8f,     4,     60,  42f,   16,  15, 30f,  SHIELD,    0.6f, EnemyType.SHIELD),
                new EnemyWave(16f,    10,    40,  80f,   12,  10, 24f,  SOLDIER,   0.3f),
                new EnemyWave(22f,    6,     65,  45f,   16,  15, 30f,  SHIELD,    0.5f, EnemyType.SHIELD),
                new EnemyWave(28f,    12,    45,  85f,   15,  12, 24f,  SOLDIER,   0.25f),
                new EnemyWave(35f,    8,     65,  48f,   16,  15, 30f,  SHIELD,    0.4f, EnemyType.SHIELD),
                new EnemyWave(42f,    10,    40,  90f,   12,  10, 24f,  SOLDIER,   0.2f),
            },
            BATTLEFIELD_BG
        );
    }

    private static StageData stage5_Goliath() {
        return new StageData(5, "Goliath",
            "The Valley of Elah.\nTwo armies watch from the hillsides.\n\nGoliath steps forward — nine feet tall,\ncoated in bronze armor,\na spear like a weaver's beam.\n\n\"Am I a dog, that you come at me\nwith sticks?\" he roars.\n\nThis is the moment David\nwas born for.",
            "\"You come against me with sword\nand spear and javelin,\nbut I come against you in the\nname of the Lord Almighty,\nthe God of the armies of Israel,\nwhom you have defied.\"\n— 1 Samuel 17:45",
            "The giant has fallen!\n\nDavid, the shepherd boy,\nhas triumphed over impossible odds —\nnot by sword or spear,\nbut by faith alone.",
            new EnemyWave[] {
                // Goliath's guard: mix of all enemy types
                //          startTime, count, hp,  speed, dmg, xp, size, color,    interval, type
                new EnemyWave(1f,     6,     40,  70f,   12,  10, 24f,  SOLDIER,   0.5f),
                new EnemyWave(5f,     3,     60,  45f,   16,  15, 30f,  SHIELD,    0.8f, EnemyType.SHIELD),
                new EnemyWave(12f,    5,     35,  85f,   12,  10, 22f,  SCOUT,     0.4f, EnemyType.DASHER),
                new EnemyWave(18f,    8,     40,  80f,   12,  10, 24f,  SOLDIER,   0.3f),
                new EnemyWave(24f,    4,     70,  50f,   18,  18, 32f,  SHIELD,    0.6f, EnemyType.SHIELD),
                new EnemyWave(30f,    6,     35,  90f,   15,  12, 22f,  SCOUT,     0.3f, EnemyType.DASHER),
                // Goliath spawns as a boss entity — handled by GoliathBoss (Day 9)
            },
            VALLEY_BG
        );
    }
}
