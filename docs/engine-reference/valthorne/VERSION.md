# Valthorne Engine — Version Reference

| Field | Value |
|-------|-------|
| **Engine Version** | Valthorne 1.3.0 |
| **Source** | https://github.com/tehnewb/Valthorne |
| **License** | Apache-2.0 |
| **Built On** | LWJGL (OpenGL + GLFW + OpenAL) |
| **Language** | Java |
| **Project Pinned** | 2026-03-21 |
| **Last Docs Verified** | 2026-03-21 |
| **Risk Level** | LOW — full API documented from wiki |

## Dependency

```gradle
// Gradle (Groovy)
implementation 'io.github.tehnewb:Valthorne:1.3.0'

// Gradle (Kotlin DSL)
implementation("io.github.tehnewb:Valthorne:1.3.0")
```

```xml
<!-- Maven -->
<dependency>
    <groupId>io.github.tehnewb</groupId>
    <artifactId>Valthorne</artifactId>
    <version>1.3.0</version>
</dependency>
```

## Engine Overview

Valthorne is a lightweight 2D Java game engine inspired by libGDX. It provides:
- Application lifecycle (init, update, render, dispose)
- Sprite rendering via TextureBatch (instanced, shader-driven)
- Keyboard and Mouse input (polling + event-driven)
- Audio playback (WAV, OGG, MP3 via OpenAL)
- Async asset loading with caching
- Camera system (Orthographic, Isometric, UI)
- Viewport management (Stretch, Screen, Fit, Fill)
- Particle system (CPU-based, pooled)
- Event publish/subscribe system
- Texture atlas and nine-patch support
- Font rendering
- UI system
- Plugin system

## What Valthorne Does NOT Provide

- Physics / collision detection — must be implemented in-project
- Entity Component System (ECS) — must be implemented or kept simple
- Scene/state management — must be implemented in-project
- Tilemaps — must be implemented in-project
- Pathfinding — must be implemented in-project

## Coordinate System

Bottom-left origin: (0,0) is screen bottom-left, X increases right, Y increases up.
Mouse coordinates are automatically flipped from GLFW's top-left convention.
