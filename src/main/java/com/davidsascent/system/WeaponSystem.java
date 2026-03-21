package com.davidsascent.system;

import com.davidsascent.entity.Enemy;
import valthorne.graphics.texture.TextureBatch;

import java.util.ArrayList;
import java.util.List;

/**
 * Manages all of David's active weapons.
 * Weapons are acquired through upgrades. Max 4 weapon slots.
 */
public class WeaponSystem {

    public static final int MAX_WEAPONS = 4;
    private final List<Weapon> weapons = new ArrayList<>();

    public void addWeapon(Weapon weapon) {
        if (weapons.size() < MAX_WEAPONS) {
            weapons.add(weapon);
        }
    }

    public boolean hasWeapon(Class<? extends Weapon> type) {
        for (Weapon w : weapons) {
            if (type.isInstance(w)) return true;
        }
        return false;
    }

    @SuppressWarnings("unchecked")
    public <T extends Weapon> T getWeapon(Class<T> type) {
        for (Weapon w : weapons) {
            if (type.isInstance(w)) return (T) w;
        }
        return null;
    }

    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles) {
        for (Weapon w : weapons) {
            w.update(delta, playerX, playerY, enemies, projectiles);
        }
    }

    public void render(TextureBatch batch, float playerX, float playerY) {
        for (Weapon w : weapons) {
            w.render(batch, playerX, playerY);
        }
    }

    public int getWeaponCount() { return weapons.size(); }
    public boolean isFull() { return weapons.size() >= MAX_WEAPONS; }
    public List<Weapon> getWeapons() { return weapons; }
}
