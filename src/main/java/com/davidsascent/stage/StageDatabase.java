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
            "\"Jesse! Your youngest is still out there —\nthe one who keeps the sheep.\"\n\nDavid, the eighth son of Jesse\nof Bethlehem, tends his father's flock.\nSamuel has anointed him with oil.\nThe Spirit of the Lord is upon him.\n\nBut tonight, something stirs\nin the tall grass.\nThe flock needs a shepherd\nwho will not run.",
            "\"The Lord is my shepherd, I lack nothing.\nHe makes me lie down in green pastures,\nHe leads me beside quiet waters,\nHe refreshes my soul.\"\n— Psalm 23:1-3",
            "The lion lay still. The sheep were safe.\nDavid wiped his hands on his cloak\nand counted the flock —\nevery one accounted for.\n\nHis father Jesse heard what happened.\nHe looked at his youngest son differently\nthan he had before.\n\nDarker hills lay ahead.",
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
            "\"Your servant has been keeping\nhis father's sheep. When a lion\nor a bear came and carried off\na sheep from the flock, I went\nafter it, struck it, and rescued\nthe sheep from its mouth.\"\n— 1 Samuel 17:34-35\n\nThe rocky hills east of Bethlehem\nare no place for a boy.\nBut David is not merely a boy.",
            "\"The Lord who rescued me from\nthe paw of the lion and the paw\nof the bear will rescue me from\nthe hand of this Philistine.\"\n— 1 Samuel 17:37",
            "When he seized it by its hair\nand struck it — that was the moment\nDavid understood.\nHe had not fought alone.\n\nRumor traveled across the hills of Judah.\nA shepherd boy. A lion. A bear.\n\nBut war was coming to the valley,\nand Israel would need\na different kind of courage.",
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
            "Jesse said to his son David,\n\"Take this bread to your brothers\nat the Valley of Elah.\nSee how they are and bring back\nword from them.\"\n— 1 Samuel 17:17-18\n\nDavid rises before dawn and sets out.\nAt the border, Philistine scouts\nhave blocked the road to Elah.\nThey are fast — watch for their charges!",
            "\"Do not be afraid of them;\nthe Lord your God himself\nwill fight for you.\"\n— Deuteronomy 3:22",
            "David reached the Israelite camp.\nHe left the food with the supply keeper\nand ran to find his brothers.\n\nHis brother Eliab's anger burned.\n\"Why have you come here?\nWho is watching those few sheep?\nI know how conceited you are!\"\n\nDavid turned away. But across the valley,\na voice forty days old was still roaring —\na giant's voice that made the army tremble.",
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
            "King Saul dressed David in his armor —\na coat of bronze, a sword at his side.\n\n\"I cannot go in these,\" David said.\n\"God has not prepared me for armor.\nHe has prepared me for this.\"\n\nHe took them off. He picked up his staff.\nHis sling. He stopped at the brook\nand chose five smooth stones,\nputting them in his shepherd's pouch.\n\nShieldbearers protect the soldiers —\nwatch for the gaps between their shields.",
            "\"It is God who arms me with strength\nand keeps my way secure.\nHe makes my feet like the feet of a deer;\nHe causes me to stand on the heights.\"\n— Psalm 18:32-33",
            "The Philistine soldiers broke and ran.\nDavid stood in the valley, breathing hard,\nfive stones in his pouch — four of them\nstill smooth and cool to the touch.\n\nThe armies of Israel watched from the ridge.\nThe Philistines from the opposite hill.\nAnd from the shadow of their lines,\na shadow larger than any man\nstepped forward.",
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
            "Six cubits and a span. Nine feet tall.\nA coat of bronze — five thousand shekels.\nLegs armored in bronze.\nA javelin slung between his shoulders.\nHis spear shaft like a weaver's beam.\nHis iron point — six hundred shekels.\n\nA shield bearer went ahead of him.\n\nGoliath of Gath looked at David —\nthis ruddy, handsome boy —\nand despised him.\n\nThis is the moment.",
            "\"You come against me with sword\nand spear and javelin,\nbut I come against you in the\nname of the Lord Almighty,\nthe God of the armies of Israel,\nwhom you have defied.\"\n— 1 Samuel 17:45",
            "The stone sank into his forehead.\nGoliath fell facedown on the ground.\n\nDavid had no sword in his hand.\nHe ran and stood over Goliath,\ndrew the giant's own sword —\nand the Philistine army turned and ran.\n\nA shepherd boy had done\nwhat a king could not.\nNot by armor. Not by sword.\nBy five smooth stones, a sling,\nand the name of the Lord Almighty.",
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
