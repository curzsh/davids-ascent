package com.davidsascent.core;

/**
 * Simple circle-circle collision detection.
 * All game entities use circle hitboxes for fast, rotation-independent checks.
 */
public final class Collision {

    private Collision() {}

    /**
     * Check if two circles overlap.
     * @return true if the distance between centers is less than the sum of radii
     */
    public static boolean circlesOverlap(float x1, float y1, float r1,
                                         float x2, float y2, float r2) {
        float dx = x2 - x1;
        float dy = y2 - y1;
        float sumRadii = r1 + r2;
        return dx * dx + dy * dy < sumRadii * sumRadii;
    }

    /**
     * Get the squared distance between two points (avoids sqrt).
     */
    public static float distanceSquared(float x1, float y1, float x2, float y2) {
        float dx = x2 - x1;
        float dy = y2 - y1;
        return dx * dx + dy * dy;
    }

    /**
     * Get the distance between two points.
     */
    public static float distance(float x1, float y1, float x2, float y2) {
        return (float) Math.sqrt(distanceSquared(x1, y1, x2, y2));
    }
}
