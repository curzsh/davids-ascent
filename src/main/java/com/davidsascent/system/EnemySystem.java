package com.davidsascent.system;

import com.davidsascent.core.Collision;
import com.davidsascent.entity.Enemy;
import com.davidsascent.entity.Player;
import valthorne.graphics.texture.TextureBatch;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Manages all active enemies. Handles updating, rendering,
 * collision with the player (contact damage), and cleanup of dead enemies.
 */
public class EnemySystem {

    private final List<Enemy> enemies = new ArrayList<>();

    /** Contact damage tick rate — player takes damage every X seconds while touching. */
    private float contactDamageCooldown = 0f;
    private static final float CONTACT_DAMAGE_INTERVAL = 0.5f;

    public void addEnemy(Enemy enemy) {
        enemies.add(enemy);
    }

    public void update(float delta, Player player) {
        if (contactDamageCooldown > 0) {
            contactDamageCooldown -= delta;
        }

        boolean touchingPlayer = false;

        Iterator<Enemy> it = enemies.iterator();
        while (it.hasNext()) {
            Enemy e = it.next();
            if (!e.isAlive()) {
                it.remove();
                continue;
            }
            e.update(delta, player.getCenterX(), player.getCenterY());

            // Check contact with player
            if (Collision.circlesOverlap(
                    e.getX(), e.getY(), e.getRadius(),
                    player.getCenterX(), player.getCenterY(), Player.WIDTH * 0.3f)) {
                touchingPlayer = true;
                if (contactDamageCooldown <= 0) {
                    player.takeDamage(e.getDamage());
                }
            }
        }

        // Reset cooldown only when damage is dealt
        if (touchingPlayer && contactDamageCooldown <= 0) {
            contactDamageCooldown = CONTACT_DAMAGE_INTERVAL;
        }
    }

    public void render(TextureBatch batch) {
        for (Enemy e : enemies) {
            e.render(batch);
        }
    }

    public List<Enemy> getEnemies() {
        return enemies;
    }

    public int getCount() {
        return enemies.size();
    }

    public void clear() {
        enemies.clear();
    }
}
