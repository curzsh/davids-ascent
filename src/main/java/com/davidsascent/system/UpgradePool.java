package com.davidsascent.system;

import com.davidsascent.core.BalanceConfig;
import com.davidsascent.entity.Player;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Pool of all available upgrades. When the player levels up,
 * 3 random upgrades are drawn from this pool.
 * Upgrades include new weapons and stat boosts for existing ones.
 */
public class UpgradePool {

    private final Player player;
    private final WeaponSystem weaponSystem;
    private final List<Upgrade> baseUpgrades = new ArrayList<>();

    public UpgradePool(Player player, WeaponSystem weaponSystem) {
        this.player = player;
        this.weaponSystem = weaponSystem;
        buildBaseUpgrades();
    }

    private void buildBaseUpgrades() {
        float fleetFootSpeed = BalanceConfig.getFloat("upgrade.fleetFoot.speed", 40f);
        int stoneSkinHp = BalanceConfig.getInt("upgrade.stoneSkin.maxHealth", 25);
        int resolveHeal = BalanceConfig.getInt("upgrade.shepherdsResolve.heal", 30);

        baseUpgrades.add(new Upgrade("Feet Like a Deer", "Speed +" + (int) fleetFootSpeed + " — Psalm 18:33",
            () -> player.setSpeed(player.getSpeed() + fleetFootSpeed)));

        baseUpgrades.add(new Upgrade("Shield of Faith", "Max HP +" + stoneSkinHp + " — Ephesians 6:16",
            () -> player.increaseMaxHealth(stoneSkinHp)));

        baseUpgrades.add(new Upgrade("Shepherd's Resolve", "Heal " + resolveHeal + " HP — Psalm 23",
            () -> player.heal(Math.min(resolveHeal, (int)(player.getMaxHealth() * 0.3f)))));
    }

    /**
     * Get 3 random upgrades, dynamically including weapon-specific upgrades
     * and new weapon options based on current loadout.
     */
    public List<Upgrade> getRandomChoices(int count) {
        List<Upgrade> available = new ArrayList<>(baseUpgrades);

        // Add new weapon options if slots are available
        if (!weaponSystem.isFull()) {
            if (!weaponSystem.hasWeapon(StaffWeapon.class)) {
                available.add(new Upgrade("Rod and Staff", "NEW: Melee sweep — Psalm 23:4",
                    () -> weaponSystem.addWeapon(new StaffWeapon())));
            }
            if (!weaponSystem.hasWeapon(ThrowingStonesWeapon.class)) {
                available.add(new Upgrade("Valley Stones", "NEW: Spread shot — 1 Sam 17:40",
                    () -> weaponSystem.addWeapon(new ThrowingStonesWeapon())));
            }
            if (!weaponSystem.hasWeapon(DivineFireWeapon.class)) {
                available.add(new Upgrade("Pillar of Fire", "NEW: Ring of fire — Deut 4:24",
                    () -> weaponSystem.addWeapon(new DivineFireWeapon())));
            }
        }

        // Add upgrades for weapons the player already has
        SlingWeapon sling = weaponSystem.getWeapon(SlingWeapon.class);
        if (sling != null) {
            int slingDmg = BalanceConfig.getInt("upgrade.sling.damage", 5);
            float slingFr = BalanceConfig.getFloat("upgrade.sling.fireRate", 0.5f);
            float slingRng = BalanceConfig.getFloat("upgrade.sling.range", 50f);
            available.add(new Upgrade("Sharpened Stones", "Sling damage +" + slingDmg,
                () -> sling.increaseDamage(slingDmg)));
            available.add(new Upgrade("Swift Hand", "Sling speed +" + slingFr + "/s",
                () -> sling.increaseFireRate(slingFr)));
            available.add(new Upgrade("Eagle's Eye", "Sling range +" + (int) slingRng,
                () -> sling.increaseRange(slingRng)));
        }

        StaffWeapon staff = weaponSystem.getWeapon(StaffWeapon.class);
        if (staff != null) {
            float staffRad = BalanceConfig.getFloat("upgrade.staff.radius", 15f);
            int staffDmg = BalanceConfig.getInt("upgrade.staff.damage", 8);
            float staffKb = BalanceConfig.getFloat("upgrade.staff.knockback", 80f);
            float staffFr = BalanceConfig.getFloat("upgrade.staff.fireRate", 0.3f);
            available.add(new Upgrade("Rod of Jesse", "Staff reach +" + (int) staffRad,
                () -> staff.increaseRadius(staffRad)));
            available.add(new Upgrade("Mighty Arm", "Staff damage +" + staffDmg,
                () -> staff.increaseDamage(staffDmg)));
            available.add(new Upgrade("Whirlwind", "Staff knockback +" + (int) staffKb,
                () -> staff.increaseKnockback(staffKb)));
            available.add(new Upgrade("Warrior's Tempo", "Staff speed +" + staffFr + "/s",
                () -> staff.increaseFireRate(staffFr)));
        }

        ThrowingStonesWeapon stonesW = weaponSystem.getWeapon(ThrowingStonesWeapon.class);
        if (stonesW != null) {
            int stCnt = BalanceConfig.getInt("upgrade.stones.count", 2);
            int stDmg = BalanceConfig.getInt("upgrade.stones.damage", 4);
            float stFr = BalanceConfig.getFloat("upgrade.stones.fireRate", 0.3f);
            available.add(new Upgrade("Five Smooth Stones", "Stones +" + stCnt + " per volley",
                () -> stonesW.increaseStoneCount(stCnt)));
            available.add(new Upgrade("Brook Stones", "Stones damage +" + stDmg,
                () -> stonesW.increaseDamage(stDmg)));
            available.add(new Upgrade("Rapid Volley", "Stones speed +" + stFr + "/s",
                () -> stonesW.increaseFireRate(stFr)));
        }

        DivineFireWeapon fireW = weaponSystem.getWeapon(DivineFireWeapon.class);
        if (fireW != null) {
            float frRad = BalanceConfig.getFloat("upgrade.fire.radius", 20f);
            int frDmg = BalanceConfig.getInt("upgrade.fire.damage", 6);
            float frFr = BalanceConfig.getFloat("upgrade.fire.fireRate", 0.2f);
            available.add(new Upgrade("Consuming Fire", "Fire radius +" + (int) frRad,
                () -> fireW.increaseRadius(frRad)));
            available.add(new Upgrade("Holy Blaze", "Fire damage +" + frDmg,
                () -> fireW.increaseDamage(frDmg)));
            available.add(new Upgrade("Burning Zeal", "Fire rate +" + frFr + "/s",
                () -> fireW.increaseFireRate(frFr)));
        }

        Collections.shuffle(available);
        return new ArrayList<>(available.subList(0, Math.min(count, available.size())));
    }
}
