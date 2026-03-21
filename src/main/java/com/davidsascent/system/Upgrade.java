package com.davidsascent.system;

/**
 * Represents a single upgrade choice shown during level-up.
 * Each upgrade has a name, description, and an apply action.
 */
public class Upgrade {

    private final String name;
    private final String description;
    private final Runnable applyEffect;

    public Upgrade(String name, String description, Runnable applyEffect) {
        this.name = name;
        this.description = description;
        this.applyEffect = applyEffect;
    }

    public void apply() {
        applyEffect.run();
    }

    public String getName() { return name; }
    public String getDescription() { return description; }
}
