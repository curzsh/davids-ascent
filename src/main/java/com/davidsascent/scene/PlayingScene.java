package com.davidsascent.scene;

import com.davidsascent.Game;
import com.davidsascent.core.Fonts;
import com.davidsascent.core.PlaceholderGraphics;
import com.davidsascent.entity.Enemy;
import com.davidsascent.entity.Player;
import com.davidsascent.stage.StageData;
import com.davidsascent.stage.StageManager;
import com.davidsascent.stage.WaveSpawner;
import com.davidsascent.system.EnemySystem;
import com.davidsascent.system.ProjectileSystem;
import com.davidsascent.system.SlingWeapon;
import com.davidsascent.system.Upgrade;
import com.davidsascent.system.UpgradePool;
import com.davidsascent.system.WeaponSystem;
import com.davidsascent.system.XpSystem;
import com.davidsascent.ui.DialogueUI;
import com.davidsascent.ui.HUD;
import com.davidsascent.ui.LevelUpUI;
import org.lwjgl.opengl.GL11;
import valthorne.SwapInterval;
import valthorne.Window;
import valthorne.camera.OrthographicCamera;
import valthorne.graphics.Color;
import valthorne.graphics.texture.TextureBatch;
import valthorne.scene.Scene;
import valthorne.viewport.FitViewport;

import java.util.List;

/**
 * The main gameplay scene — David fights through 5 biblical stages.
 */
public class PlayingScene extends Scene {

    private Player player;
    private EnemySystem enemySystem;
    private ProjectileSystem projectileSystem;
    private WeaponSystem weaponSystem;
    private XpSystem xpSystem;
    private UpgradePool upgradePool;
    private LevelUpUI levelUpUI;
    private DialogueUI dialogueUI;
    private HUD hud;

    private StageManager stageManager;
    private WaveSpawner waveSpawner;

    private boolean inLevelUp = false;
    private Color currentBgColor = Color.BLACK;

    @Override
    public void init() {
        OrthographicCamera camera = new OrthographicCamera();
        camera.setCenter(Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f);

        FitViewport viewport = new FitViewport(Game.WORLD_WIDTH, Game.WORLD_HEIGHT);
        viewport.setCamera(camera);
        viewport.update(Window.getWidth(), Window.getHeight());

        setCamera(camera);
        setViewport(viewport);

        Window.setSwapInterval(SwapInterval.VSYNC);
        PlaceholderGraphics.init();
        Fonts.init();

        player = new Player(Game.WORLD_WIDTH / 2f, Game.WORLD_HEIGHT / 2f);
        enemySystem = new EnemySystem();
        projectileSystem = new ProjectileSystem();
        weaponSystem = new WeaponSystem();
        weaponSystem.addWeapon(new SlingWeapon()); // starter weapon
        xpSystem = new XpSystem();
        upgradePool = new UpgradePool(player, weaponSystem);
        levelUpUI = new LevelUpUI();
        dialogueUI = new DialogueUI();
        hud = new HUD();

        stageManager = new StageManager();
        waveSpawner = new WaveSpawner();

        // Start with the first stage's pre-dialogue
        showStageDialogue(true);
    }

    @Override
    public void update(float delta) {
        if (isPaused()) return;

        StageManager.Phase phase = stageManager.getCurrentPhase();

        switch (phase) {
            case PRE_DIALOGUE, POST_DIALOGUE -> updateDialogue(delta);
            case PLAYING -> updatePlaying(delta);
            case VICTORY -> updateVictory(delta);
        }
    }

    private void updateDialogue(float delta) {
        if (dialogueUI.update(delta)) {
            // Dialogue dismissed
            if (stageManager.getCurrentPhase() == StageManager.Phase.PRE_DIALOGUE) {
                // Start the stage
                startCurrentStage();
            } else {
                // Post-dialogue done — advance to next stage
                if (!stageManager.advanceStage()) {
                    // No more stages — victory!
                    showVictoryDialogue();
                } else {
                    showStageDialogue(true);
                }
            }
        }
    }

    private void updatePlaying(float delta) {
        // Level-up screen
        if (inLevelUp) {
            Upgrade chosen = levelUpUI.update(getViewport());
            if (chosen != null) {
                chosen.apply();
                xpSystem.consumeLevelUp();
                inLevelUp = false;
                if (xpSystem.isLevelUpReady()) {
                    triggerLevelUp();
                }
            }
            return;
        }

        // Check player death — transition to game over
        if (player.isDead()) {
            Game.getGameScreen().setScene(new GameOverScene(
                xpSystem.getCurrentLevel(),
                stageManager.getCurrentStageNumber()
            ));
            return;
        }

        // Player
        player.handleInput(delta);
        player.update(delta);

        // Weapon auto-fire (all active weapons)
        weaponSystem.update(delta, player.getCenterX(), player.getCenterY(),
                           enemySystem.getEnemies(), projectileSystem);

        // Projectiles
        projectileSystem.update(delta);

        // Enemies
        enemySystem.update(delta, player);

        // Projectile-enemy collisions
        List<Enemy> killed = projectileSystem.checkCollisions(enemySystem.getEnemies());
        for (Enemy e : killed) {
            xpSystem.spawnGem(e.getX(), e.getY(), e.getXpValue());
        }

        // XP collection
        xpSystem.update(delta, player);
        if (xpSystem.isLevelUpReady() && !inLevelUp) {
            triggerLevelUp();
        }

        // Wave spawner
        waveSpawner.update(delta, enemySystem);

        // Check stage completion
        if (waveSpawner.isStageComplete()) {
            stageManager.setPhase(StageManager.Phase.POST_DIALOGUE);
            showStageDialogue(false);
        }
    }

    private void updateVictory(float delta) {
        if (dialogueUI.isActive()) {
            dialogueUI.update(delta);
        }
        // Game complete — just sit on the victory screen
    }

    /**
     * Override drawScene to clear the screen BEFORE the batch begins.
     * The default Scene.drawScene() does: viewport.bind -> batch.begin -> draw -> batch.end -> viewport.unbind
     * We need Window.clear() to happen before batch.begin() to avoid artifacts.
     */
    @Override
    protected void drawScene() {
        // Clear the full window (including letterbox areas) before viewport is set
        GL11.glClearColor(currentBgColor.getRed() / 255f, currentBgColor.getGreen() / 255f,
                          currentBgColor.getBlue() / 255f, 1f);
        GL11.glClear(GL11.GL_COLOR_BUFFER_BIT);
        super.drawScene();
    }

    @Override
    public void draw(TextureBatch batch) {
        StageManager.Phase phase = stageManager.getCurrentPhase();

        if (phase == StageManager.Phase.PLAYING) {
            player.render(batch);
            weaponSystem.render(batch, player.getCenterX(), player.getCenterY());
            enemySystem.render(batch);
            projectileSystem.render(batch);
            xpSystem.render(batch);
            hud.render(batch, player, xpSystem);

            if (inLevelUp) {
                levelUpUI.render(batch);
            }
        }

        if (dialogueUI.isActive()) {
            dialogueUI.render(batch);
        }
    }

    @Override
    public void dispose() {
        PlaceholderGraphics.dispose();
        Fonts.dispose();
    }

    // --- Stage lifecycle helpers ---

    private void showStageDialogue(boolean isPre) {
        StageData stage = stageManager.getCurrentStage();
        if (stage == null) return;

        if (isPre) {
            String text = stage.getScripture() + "\n\n" + stage.getPreDialogue();
            dialogueUI.show("Stage " + stage.getStageNumber() + ": " + stage.getName(), text);
        } else {
            dialogueUI.show(stage.getName() + " — Complete!", stage.getPostDialogue());
        }
    }

    private void showVictoryDialogue() {
        dialogueUI.show("Victory!",
            "The giant has fallen!\nDavid's faith has triumphed\nover impossible odds.\n\nThank you for playing!");
    }

    private void startCurrentStage() {
        StageData stage = stageManager.getCurrentStage();
        if (stage == null) return;

        stageManager.setPhase(StageManager.Phase.PLAYING);
        currentBgColor = stage.getArenaColor();
        enemySystem.clear();
        waveSpawner.startStage(stage);
        hud.setStageLabel("Stage " + stage.getStageNumber() + ": " + stage.getName());
    }

    private void triggerLevelUp() {
        inLevelUp = true;
        List<Upgrade> choices = upgradePool.getRandomChoices(3);
        levelUpUI.show(choices);
    }
}
