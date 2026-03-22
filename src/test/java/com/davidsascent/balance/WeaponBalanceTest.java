package com.davidsascent.balance;

import com.davidsascent.core.BalanceConfig;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests weapon balance values loaded from balance.properties.
 * Ensures no weapon is obviously overpowered/underpowered and
 * all values are within sane ranges.
 */
class WeaponBalanceTest {

    @BeforeAll
    static void loadConfig() throws IOException {
        Properties props = new Properties();
        try (InputStream in = WeaponBalanceTest.class.getClassLoader()
                .getResourceAsStream("data/balance.properties")) {
            assertNotNull(in, "balance.properties must exist on classpath");
            props.load(in);
        }
        BalanceConfig.loadFrom(props);
    }

    // --- Sling (starter weapon — should be balanced for early game) ---

    @Test
    void slingDamageInRange() {
        int dmg = BalanceConfig.getInt("sling.damage", -1);
        assertTrue(dmg >= 5 && dmg <= 25, "Sling damage should be 5-25 but was " + dmg);
    }

    @Test
    void slingFireRateInRange() {
        float fr = BalanceConfig.getFloat("sling.fireRate", -1);
        assertTrue(fr >= 0.5f && fr <= 3f, "Sling fire rate should be 0.5-3.0 but was " + fr);
    }

    @Test
    void slingRangeExceedsMinRange() {
        float range = BalanceConfig.getFloat("sling.range", -1);
        float minRange = BalanceConfig.getFloat("sling.minRange", -1);
        assertTrue(range > minRange, "Sling range must exceed minRange");
    }

    // --- Staff (melee — higher damage, lower rate) ---

    @Test
    void staffDamageHigherThanSling() {
        int slingDmg = BalanceConfig.getInt("sling.damage", -1);
        int staffDmg = BalanceConfig.getInt("staff.damage", -1);
        assertTrue(staffDmg > slingDmg,
            "Staff (melee) should hit harder than Sling (ranged): " + staffDmg + " vs " + slingDmg);
    }

    @Test
    void staffFireRateSlowerThanSling() {
        float slingFr = BalanceConfig.getFloat("sling.fireRate", -1);
        float staffFr = BalanceConfig.getFloat("staff.fireRate", -1);
        assertTrue(staffFr < slingFr,
            "Staff should attack slower than Sling: " + staffFr + " vs " + slingFr);
    }

    // --- Throwing Stones (spread — lower per-hit but multi-target) ---

    @Test
    void stonesDpsVsSlingDps() {
        // Stones: damage * stoneCount * fireRate = total DPS
        // Should be higher total DPS than sling to compensate for less accuracy
        int stDmg = BalanceConfig.getInt("stones.damage", -1);
        int stCnt = BalanceConfig.getInt("stones.stoneCount", -1);
        float stFr = BalanceConfig.getFloat("stones.fireRate", -1);
        float stonesDps = stDmg * stCnt * stFr;

        int slDmg = BalanceConfig.getInt("sling.damage", -1);
        float slFr = BalanceConfig.getFloat("sling.fireRate", -1);
        float slingDps = slDmg * slFr;

        assertTrue(stonesDps > slingDps,
            "Stones total DPS (" + stonesDps + ") should exceed Sling DPS (" + slingDps + ")");
    }

    // --- Divine Fire (AoE — lowest per-hit, constant damage) ---

    @Test
    void fireDamageLowerThanDirectWeapons() {
        int fireDmg = BalanceConfig.getInt("fire.damage", -1);
        int slingDmg = BalanceConfig.getInt("sling.damage", -1);
        assertTrue(fireDmg < slingDmg,
            "Fire per-tick damage (" + fireDmg + ") should be < Sling (" + slingDmg + ")");
    }

    @Test
    void fireDamageIntervalPositive() {
        float interval = BalanceConfig.getFloat("fire.damageInterval", -1);
        assertTrue(interval > 0.05f && interval < 2f,
            "Fire damage interval should be 0.05-2.0s but was " + interval);
    }

    // --- All weapons have positive values ---

    @Test
    void allWeaponValuesPositive() {
        assertAll(
            () -> assertTrue(BalanceConfig.getInt("sling.damage", 0) > 0, "sling.damage"),
            () -> assertTrue(BalanceConfig.getFloat("sling.fireRate", 0) > 0, "sling.fireRate"),
            () -> assertTrue(BalanceConfig.getFloat("sling.range", 0) > 0, "sling.range"),
            () -> assertTrue(BalanceConfig.getInt("staff.damage", 0) > 0, "staff.damage"),
            () -> assertTrue(BalanceConfig.getFloat("staff.fireRate", 0) > 0, "staff.fireRate"),
            () -> assertTrue(BalanceConfig.getFloat("staff.radius", 0) > 0, "staff.radius"),
            () -> assertTrue(BalanceConfig.getInt("stones.damage", 0) > 0, "stones.damage"),
            () -> assertTrue(BalanceConfig.getFloat("stones.fireRate", 0) > 0, "stones.fireRate"),
            () -> assertTrue(BalanceConfig.getInt("stones.stoneCount", 0) > 0, "stones.stoneCount"),
            () -> assertTrue(BalanceConfig.getInt("fire.damage", 0) > 0, "fire.damage"),
            () -> assertTrue(BalanceConfig.getFloat("fire.radius", 0) > 0, "fire.radius")
        );
    }

    // --- Upgrade amounts are meaningful but not game-breaking ---

    @Test
    void upgradeAmountsAreSane() {
        // Each upgrade should be noticeable (>10% of base) but not doubling the stat
        int slingBaseDmg = BalanceConfig.getInt("sling.damage", 10);
        int slingUpgDmg = BalanceConfig.getInt("upgrade.sling.damage", 5);
        float ratio = (float) slingUpgDmg / slingBaseDmg;
        assertTrue(ratio >= 0.1f && ratio <= 1.0f,
            "Sling damage upgrade ratio should be 10-100% of base: " + ratio);
    }
}
