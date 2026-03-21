package com.davidsascent.stage;

/**
 * Manages progression through the 5 stages.
 * Tracks current stage and handles transitions.
 */
public class StageManager {

    private final StageData[] allStages;
    private int currentStageIndex = 0;

    /** Stage lifecycle: PRE_DIALOGUE -> PLAYING -> POST_DIALOGUE -> advance */
    public enum Phase {
        PRE_DIALOGUE,
        PLAYING,
        POST_DIALOGUE,
        VICTORY
    }

    private Phase currentPhase = Phase.PRE_DIALOGUE;

    public StageManager() {
        this.allStages = StageDatabase.getAllStages();
    }

    public StageData getCurrentStage() {
        if (currentStageIndex >= allStages.length) return null;
        return allStages[currentStageIndex];
    }

    public Phase getCurrentPhase() {
        return currentPhase;
    }

    public void setPhase(Phase phase) {
        this.currentPhase = phase;
    }

    /**
     * Advance to the next stage. Returns true if there are more stages.
     */
    public boolean advanceStage() {
        currentStageIndex++;
        if (currentStageIndex >= allStages.length) {
            currentPhase = Phase.VICTORY;
            return false;
        }
        currentPhase = Phase.PRE_DIALOGUE;
        return true;
    }

    public int getCurrentStageNumber() {
        return currentStageIndex + 1;
    }

    public int getTotalStages() {
        return allStages.length;
    }

    public boolean isLastStage() {
        return currentStageIndex >= allStages.length - 1;
    }
}
