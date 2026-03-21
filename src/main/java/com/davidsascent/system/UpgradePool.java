package com.davidsascent.system;

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
        // --- Player blessings (always available) ---
        baseUpgrades.add(new Upgrade("Psalm of Speed", "Movement speed +30",
            () -> player.setSpeed(player.getSpeed() + 30f)));

        baseUpgrades.add(new Upgrade("Stone Skin", "Max health +25",
            () -> player.increaseMaxHealth(25)));

        baseUpgrades.add(new Upgrade("Shepherd's Resolve", "Heal 30 HP",
            () -> player.heal(30)));

        baseUpgrades.add(new Upgrade("Divine Swiftness", "Movement speed +50",
            () -> player.setSpeed(player.getSpeed() + 50f)));
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
        }

        // Add upgrades for weapons the player already has
        SlingWeapon sling = weaponSystem.getWeapon(SlingWeapon.class);
        if (sling != null) {
            available.add(new Upgrade("Sharper Stones", "Sling damage +5",
                () -> sling.increaseDamage(5)));
            available.add(new Upgrade("Quick Hands", "Sling fire rate +0.5/s",
                () -> sling.increaseFireRate(0.5f)));
            available.add(new Upgrade("Eagle Eye", "Sling range +50",
                () -> sling.increaseRange(50f)));
        }

        StaffWeapon staff = weaponSystem.getWeapon(StaffWeapon.class);
        if (staff != null) {
            available.add(new Upgrade("Wider Sweep", "Staff radius +15",
                () -> staff.increaseRadius(15f)));
            available.add(new Upgrade("Heavy Strike", "Staff damage +8",
                () -> staff.increaseDamage(8)));
            available.add(new Upgrade("Mighty Knockback", "Staff knockback +80",
                () -> staff.increaseKnockback(80f)));
        }

        ThrowingStonesWeapon stones = weaponSystem.getWeapon(ThrowingStonesWeapon.class);
        if (stones != null) {
            available.add(new Upgrade("More Stones", "Throwing Stones +2 per volley",
                () -> stones.increaseStoneCount(2)));
            available.add(new Upgrade("Sharpened Stones", "Throwing Stones damage +4",
                () -> stones.increaseDamage(4)));
            available.add(new Upgrade("Rapid Volley", "Throwing Stones fire rate +0.3/s",
                () -> stones.increaseFireRate(0.3f)));
        }

        Collections.shuffle(available);
        return available.subList(0, Math.min(count, available.size()));
    }
}
