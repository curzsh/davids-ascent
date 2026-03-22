package com.davidsascent;

import com.davidsascent.scene.PlayingScene;
import valthorne.JGL;
import valthorne.scene.GameScreen;

/**
 * Main entry point for David's Ascent.
 * Uses Valthorne's built-in GameScreen/Scene system for state management.
 *
 * Each game state (playing, dialogue, level-up, game over, etc.) is a Scene.
 * GameScreen handles transitions between them.
 */
public class Game {

    /** World dimensions in pixels (the virtual resolution). */
    public static final int WORLD_WIDTH = 800;
    public static final int WORLD_HEIGHT = 600;

    /** Shared GameScreen instance — scenes use this to transition. */
    private static GameScreen gameScreen;

    public static GameScreen getGameScreen() {
        return gameScreen;
    }

    public static void main(String[] args) {
        com.davidsascent.core.BalanceConfig.load();
        gameScreen = new GameScreen(new PlayingScene());
        JGL.init(gameScreen, "David's Ascent", WORLD_WIDTH, WORLD_HEIGHT);
    }
}
