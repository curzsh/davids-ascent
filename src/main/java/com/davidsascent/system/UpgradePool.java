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

        baseUpgrades.add(new Upgrade("Fleet Foot", "Movement speed +" + (int) fleetFootSpeed,
            () -> player.setSpeed(player.getSpeed() + fleetFootSpeed)));

        baseUpgrades.add(new Upgrade("Stone Skin", "Max health +" + stoneSkinHp,
            () -> player.increaseMaxHealth(stoneSkinHp)));

        baseUpgrades.add(new Upgrade("Shepherd's Resolve", "Heal " + resolveHeal + " HP",
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
                available.add(new Upgrade("Shepherd's Staff", "NEW WEAPON: Melee sweep with knockback",
                    () -> weaponSystem.addWeapon(new StaffWeapon())));
            }
            if (!weaponSystem.hasWeapon(ThrowingStonesWeapon.class)) {
                available.add(new Upgrade("Throwing Stones", "NEW WEAPON: Spread shot in all directions",
                    () -> weaponSystem.addWeapon(new ThrowingStonesWeapon())));
            }
            if (!weaponSystem.hasWeapon(DivineFireWeapon.class)) {
                available.add(new Upgrade("Divine Fire", "NEW WEAPON: Ring of fire damages nearby enemies",
                    () -> weaponSystem.addWeapon(new DivineFireWeapon())));
            }
        }

        // Add upgrades for weapons the player already has
        SlingWeapon sling = weaponSystem.getWeapon(SlingWeapon.class);
        if (sling != null) {
            int slingDmg = BalanceConfig.getInt("upgrade.sling.damage", 5);
            float slingFr = BalanceConfig.getFloat("upgrade.sling.fireRate", 0.5f);
            float slingRng = BalanceConfig.getFloat("upgrade.sling.range", 50f);
            available.add(new Upgrade("Sharper Stones", "Sling damage +" + slingDmg,
                () -> sling.increaseDamage(slingDmg)));
            available.add(new Upgrade("Quick Hands", "Sling fire rate +" + slingFr + "/s",
                () -> sling.increaseFireRate(slingFr)));
            available.add(new Upgrade("Eagle Eye", "Sling range +" + (int) slingRng,
                () -> sling.increaseRange(slingRng)));
        }

        StaffWeapon staff = weaponSystem.getWeapon(StaffWeapon.class);
        if (staff != null) {
            float staffRad = BalanceConfig.getFloat("upgrade.staff.radius", 15f);
            int staffDmg = BalanceConfig.getInt("upgrade.staff.damage", 8);
            float staffKb = BalanceConfig.getFloat("upgrade.staff.knockback", 80f);
            float staffFr = BalanceConfig.getFloat("upgrade.staff.fireRate", 0.3f);
            available.add(new Upgrade("Wider Sweep", "Staff radius +" + (int) staffRad,
                () -> staff.increaseRadius(staffRad)));
            available.add(new Upgrade("Heavy Strike", "Staff damage +" + staffDmg,
                () -> staff.increaseDamage(staffDmg)));
            available.add(new Upgrade("Mighty Knockback", "Staff knockback +" + (int) staffKb,
                () -> staff.increaseKnockback(staffKb)));
            available.add(new Upgrade("Swift Staff", "Staff attack speed +" + staffFr + "/s",
                () -> staff.increaseFireRate(staffFr)));
        }

        ThrowingStonesWeapon stonesW = weaponSystem.getWeapon(ThrowingStonesWeapon.class);
        if (stonesW != null) {
            int stCnt = BalanceConfig.getInt("upgrade.stones.count", 2);
            int stDmg = BalanceConfig.getInt("upgrade.stones.damage", 4);
            float stFr = BalanceConfig.getFloat("upgrade.stones.fireRate", 0.3f);
            available.add(new Upgrade("More Stones", "Throwing Stones +" + stCnt + " per volley",
                () -> stonesW.increaseStoneCount(stCnt)));
            available.add(new Upgrade("Sharpened Stones", "Throwing Stones damage +" + stDmg,
                () -> stonesW.increaseDamage(stDmg)));
            available.add(new Upgrade("Rapid Volley", "Throwing Stones fire rate +" + stFr + "/s",
                () -> stonesW.increaseFireRate(stFr)));
        }

        DivineFireWeapon fireW = weaponSystem.getWeapon(DivineFireWeapon.class);
        if (fireW != null) {
            float frRad = BalanceConfig.getFloat("upgrade.fire.radius", 20f);
            int frDmg = BalanceConfig.getInt("upgrade.fire.damage", 6);
            float frFr = BalanceConfig.getFloat("upgrade.fire.fireRate", 0.2f);
            available.add(new Upgrade("Wider Flames", "Divine Fire radius +" + (int) frRad,
                () -> fireW.increaseRadius(frRad)));
            available.add(new Upgrade("Holy Blaze", "Divine Fire damage +" + frDmg,
                () -> fireW.increaseDamage(frDmg)));
            available.add(new Upgrade("Rapid Burn", "Divine Fire rate +" + frFr + "/s",
                () -> fireW.increaseFireRate(frFr)));
        }

        Collections.shuffle(available);
        return available.subList(0, Math.min(count, available.size()));
    }
}
