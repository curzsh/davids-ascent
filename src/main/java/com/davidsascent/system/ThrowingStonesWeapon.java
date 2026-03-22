package com.davidsascent.system;

import com.davidsascent.entity.Enemy;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;

import java.util.List;

/**
 * Throwing Stones — spread shot weapon.
 * Fires multiple stones in a spread pattern around David.
 * No targeting needed — stones fly outward in all directions.
 */
public class ThrowingStonesWeapon implements Weapon {

    private float fireRate;
    private float fireTimer = 0f;
    private int stoneCount;
    private int damage;
    private float projectileSpeed;
    private float projectileSize;
    private float projectileLifetime;
    private static final Color STONE_COLOR = Color.GOLD;

    public ThrowingStonesWeapon() {
        this.fireRate = com.davidsascent.core.BalanceConfig.getFloat("stones.fireRate", 0.5f);
        this.damage = com.davidsascent.core.BalanceConfig.getInt("stones.damage", 12);
        this.stoneCount = com.davidsascent.core.BalanceConfig.getInt("stones.stoneCount", 5);
        this.projectileSpeed = com.davidsascent.core.BalanceConfig.getFloat("stones.projectileSpeed", 300f);
        this.projectileSize = com.davidsascent.core.BalanceConfig.getFloat("stones.projectileSize", 6f);
        this.projectileLifetime = com.davidsascent.core.BalanceConfig.getFloat("stones.projectileLifetime", 1.5f);
    }

    @Override
    public void update(float delta, float playerX, float playerY,
                       List<Enemy> enemies, ProjectileSystem projectiles,
                       com.davidsascent.ui.DamageNumberSystem dmgNumbers) {
        fireTimer += delta;

        if (fireTimer >= 1f / fireRate) {
            fireSpread(playerX, playerY, projectiles);
            fireTimer = 0f;
        }
    }

    private void fireSpread(float px, float py, ProjectileSystem projectiles) {
        float angleStep = (float) (2 * Math.PI / stoneCount);

        for (int i = 0; i < stoneCount; i++) {
            float angle = angleStep * i;
            float velX = (float) Math.cos(angle) * projectileSpeed;
            float velY = (float) Math.sin(angle) * projectileSpeed;

            projectiles.spawn(px, py, velX, velY, damage,
                             projectileSize, projectileLifetime, STONE_COLOR);
        }
    }

    @Override
    public void render(TextureBatch batch, float playerX, float playerY) {
        // No special visual — just projectiles
    }

    @Override
    public String getName() { return "Throwing Stones"; }

    public void increaseDamage(int amount) { damage += amount; }
    public void increaseStoneCount(int amount) { stoneCount += amount; }
    public void increaseFireRate(float amount) { fireRate += amount; }
    public int getDamage() { return damage; }
    public int getStoneCount() { return stoneCount; }
}
