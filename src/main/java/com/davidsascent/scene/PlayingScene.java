package com.davidsascent.scene;

import com.davidsascent.Game;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.ChaserEnemy;
import com.davidsascent.entity.Enemy;
import com.davidsascent.entity.Player;
import com.davidsascent.system.EnemySystem;
import com.davidsascent.system.ProjectileSystem;
import com.davidsascent.system.SlingWeapon;
import com.davidsascent.system.Upgrade;
import com.davidsascent.system.UpgradePool;
import com.davidsascent.system.XpSystem;
import com.davidsascent.ui.HUD;
import com.davidsascent.ui.LevelUpUI;
import valthorne.Window;
import valthorne.camera.OrthographicCamera;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;
import valthorne.scene.Scene;
import valthorne.viewport.FitViewport;

import java.util.List;
import java.util.Random;

/**
 * The main gameplay scene — David fights enemies across stages.
 * Handles player, enemies, projectiles, weapons, XP, upgrades, and UI.
 */
public class PlayingScene extends Scene {

    private Player player;
    private EnemySystem enemySystem;
    private ProjectileSystem projectileSystem;
    private SlingWeapon sling;
    private XpSystem xpSystem;
    private UpgradePool upgradePool;
    private LevelUpUI levelUpUI;
    private HUD hud;

    // Simple test spawner — will be replaced by WaveSpawner system
    private final Random random = new Random();
    private float spawnTimer = 0f;
    private float spawnInterval = 1.5f;

    // Track if we're in level-up mode
    private boolean inLevelUp = false;

    @Override
    public void init() {
        OrthographicCamera camera = new OrthographicCamera();
        camera.setCenter(Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f);

        FitViewport viewport = new FitViewport(Game.WORLD_WIDTH, Game.WORLD_HEIGHT);
        viewport.setCamera(camera);
        viewport.update(Window.getWidth(), Window.getHeight());

        setCamera(camera);
        setViewport(viewport);

        PlaceholderGraphics.init();

        player = new Player(Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f);
        enemySystem = new EnemySystem();
        projectileSystem = new ProjectileSystem();
        sling = new SlingWeapon();
        xpSystem = new XpSystem();
        upgradePool = new UpgradePool(player, sling);
        levelUpUI = new LevelUpUI();
        hud = new HUD();
    }

    @Override
    public void update(float delta) {
        if (isPaused()) return;

        // Level-up screen — freeze gameplay, handle selection
        if (inLevelUp) {
            Upgrade chosen = levelUpUI.update(getViewport());
            if (chosen != null) {
                chosen.apply();
                xpSystem.consumeLevelUp();
                inLevelUp = false;

                // Check for another immediate level-up
                if (xpSystem.isLevelUpReady()) {
                    triggerLevelUp();
                }
            }
            return; // don't update gameplay while in level-up
        }

        // Player
        player.handleInput(delta);
        player.update(delta);

        // Weapon auto-fire
        sling.update(delta, player.getCenterX(), player.getCenterY(),
                     enemySystem.getEnemies(), projectileSystem);

        // Projectiles
        projectileSystem.update(delta);

        // Enemies (movement + contact damage)
        enemySystem.update(delta, player);

        // Projectile-enemy collisions
        List<Enemy> killed = projectileSystem.checkCollisions(enemySystem.getEnemies());
        for (Enemy e : killed) {
            xpSystem.spawnGem(e.getX(), e.getY(), e.getXpValue());
        }

        // Check player death — stop everything
        if (player.isDead()) {
            // TODO: transition to game over scene
            return;
        }

        // XP collection + level-up check
        xpSystem.update(delta, player);
        if (xpSystem.isLevelUpReady() && !inLevelUp) {
            triggerLevelUp();
        }

        // Enemy spawner
        spawnTimer += delta;
        if (spawnTimer >= spawnInterval) {
            spawnTestEnemy();
            spawnTimer = 0f;
        }
    }

    @Override
    public void draw(TextureBatch batch) {
        Window.clear(Color.BLACK);

        // Game world
        player.render(batch);
        enemySystem.render(batch);
        projectileSystem.render(batch);
        xpSystem.render(batch);

        // UI on top
        hud.render(batch, player, xpSystem);

        // Level-up overlay (on top of everything)
        if (inLevelUp) {
            levelUpUI.render(batch);
        }
    }

    @Override
    public void dispose() {
        PlaceholderGraphics.dispose();
    }

    private void triggerLevelUp() {
        inLevelUp = true;
        List<Upgrade> choices = upgradePool.getRandomChoices(3);
        levelUpUI.show(choices);
    }

    /**
     * Spawns a test chaser enemy from a random screen edge.
     */
    private void spawnTestEnemy() {
        float x, y;
        int edge = random.nextInt(4);
        switch (edge) {
            case 0 -> { x = random.nextFloat() * Game.WORLD_WIDTH; y = Game.WORLD_HEIGHT + 20; }
            case 1 -> { x = random.nextFloat() * Game.WORLD_WIDTH; y = -20; }
            case 2 -> { x = -20; y = random.nextFloat() * Game.WORLD_HEIGHT; }
            default -> { x = Game.WORLD_WIDTH + 20; y = random.nextFloat() * Game.WORLD_HEIGHT; }
        }

        enemySystem.addEnemy(new ChaserEnemy(
            x, y,
            10,           // health
            80f,          // speed
            10,           // contact damage
            15,           // XP value
            24f,          // size
            Color.RED
        ));
    }
}
