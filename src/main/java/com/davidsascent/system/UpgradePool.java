package com.davidsascent.system;

import com.davidsascent.entity.Player;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Pool of all available upgrades. When the player levels up,
 * 3 random upgrades are drawn from this pool.
 */
public class UpgradePool {

    private final List<Upgrade> allUpgrades = new ArrayList<>();

    public UpgradePool(Player player, SlingWeapon sling) {
        // --- Sling upgrades ---
        allUpgrades.add(new Upgrade(
            "Sharper Stones",
            "Sling damage +5",
            () -> sling.increaseDamage(5)
        ));
        allUpgrades.add(new Upgrade(
            "Quick Hands",
            "Sling fire rate +0.5/s",
            () -> sling.increaseFireRate(0.5f)
        ));
        allUpgrades.add(new Upgrade(
            "Eagle Eye",
            "Sling range +50",
            () -> sling.increaseRange(50f)
        ));

        // --- Player blessings ---
        allUpgrades.add(new Upgrade(
            "Psalm of Speed",
            "Movement speed +30",
            () -> player.setSpeed(player.getSpeed() + 30f)
        ));
        allUpgrades.add(new Upgrade(
            "Stone Skin",
            "Max health +25",
            () -> player.increaseMaxHealth(25)
        ));
        allUpgrades.add(new Upgrade(
            "Shepherd's Resolve",
            "Heal 30 HP",
            () -> player.heal(30)
        ));
        allUpgrades.add(new Upgrade(
            "Anointing Oil",
            "XP magnet range increased",
            () -> {} // TODO: increase magnet range when XpGem supports it
        ));
        allUpgrades.add(new Upgrade(
            "Mighty Throw",
            "Sling damage +10",
            () -> sling.increaseDamage(10)
        ));
        allUpgrades.add(new Upgrade(
            "Rapid Sling",
            "Sling fire rate +1/s",
            () -> sling.increaseFireRate(1.0f)
        ));
        allUpgrades.add(new Upgrade(
            "Divine Swiftness",
            "Movement speed +50",
            () -> player.setSpeed(player.getSpeed() + 50f)
        ));
    }

    /**
     * Get 3 random unique upgrades for the level-up screen.
     */
    public List<Upgrade> getRandomChoices(int count) {
        List<Upgrade> shuffled = new ArrayList<>(allUpgrades);
        Collections.shuffle(shuffled);
        return shuffled.subList(0, Math.min(count, shuffled.size()));
    }
}
