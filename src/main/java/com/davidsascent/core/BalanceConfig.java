package com.davidsascent.core;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Loads and provides access to all gameplay balance values from
 * assets/data/balance.properties. Values are loaded once at startup
 * and accessed via typed getters.
 */
public final class BalanceConfig {

    private static final Properties props = new Properties();
    private static boolean loaded = false;

    private BalanceConfig() {}

    /**
     * Load balance config from the classpath. Call once at startup.
     * Falls back to defaults if file is missing (so tests work without file).
     */
    public static void load() {
        if (loaded) return;
        try (InputStream in = BalanceConfig.class.getClassLoader()
                .getResourceAsStream("data/balance.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (IOException e) {
            System.err.println("Warning: Could not load balance.properties, using defaults");
        }
        loaded = true;
    }

    /** Get a float value, returning the default if missing. */
    public static float getFloat(String key, float defaultValue) {
        String val = props.getProperty(key);
        if (val == null) return defaultValue;
        return Float.parseFloat(val.trim());
    }

    /** Get an int value, returning the default if missing. */
    public static int getInt(String key, int defaultValue) {
        String val = props.getProperty(key);
        if (val == null) return defaultValue;
        return Integer.parseInt(val.trim());
    }

    /** Check if a key exists. */
    public static boolean has(String key) {
        return props.containsKey(key);
    }

    /**
     * For testing: load properties from a given Properties object.
     */
    public static void loadFrom(Properties testProps) {
        props.clear();
        props.putAll(testProps);
        loaded = true;
    }

    /** For testing: reset to unloaded state. */
    public static void reset() {
        props.clear();
        loaded = false;
    }
}
