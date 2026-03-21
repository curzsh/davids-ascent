# Systems Index: David's Ascent

> **Status**: Draft
> **Created**: 2026-03-21
> **Last Updated**: 2026-03-21
> **Source Concept**: design/gdd/game-concept.md

---

## Overview

David's Ascent is a bullet heaven with 5 curated stages and a boss fight. The
mechanical scope is tight: player movement, auto-attacking weapons, enemy waves,
XP/level-up progression, and dialogue between stages. There is no physics engine,
no networking, and no procedural generation beyond wave spawning patterns.

The biggest technical challenge is the custom collision system — Valthorne provides
no built-in physics, so we must implement efficient collision detection for
potentially hundreds of on-screen entities (projectiles + enemies + pickups).

---

## Systems Enumeration

| # | System Name | Category | Priority | Status | Design Doc | Depends On |
|---|-------------|----------|----------|--------|------------|------------|
| 1 | Game State Machine | Core | MVP | Not Started | — | (none) |
| 2 | Collision System | Core | MVP | Not Started | — | (none) |
| 3 | Camera/Viewport | Core | MVP | Not Started | — | (none) |
| 4 | Player Controller | Core | MVP | Not Started | — | Game State Machine, Collision |
| 5 | Damage/Health System | Gameplay | MVP | Not Started | — | Collision |
| 6 | Projectile System | Gameplay | MVP | Not Started | — | Collision, Camera/Viewport |
| 7 | Enemy System | Gameplay | MVP | Not Started | — | Damage/Health, Collision, Camera/Viewport |
| 8 | Weapon System | Gameplay | MVP | Not Started | — | Player Controller, Projectile, Damage/Health |
| 9 | XP & Level-Up System | Progression | MVP | Not Started | — | Player Controller, Enemy System |
| 10 | Stage Progression | Progression | MVP | Not Started | — | Game State Machine, Wave Spawner (event) |
| 11 | Wave Spawner | Gameplay | MVP | Not Started | — | Enemy System, Stage Progression (data) |
| 12 | Upgrade/Blessing System | Progression | MVP | Not Started | — | Weapon System, XP & Level-Up |
| 13 | Dialogue System | Narrative | MVP | Not Started | — | Game State Machine, Stage Progression |
| 14 | Boss System | Gameplay | MVP | Not Started | — | Enemy System, Damage/Health, Stage Progression |
| 15 | HUD | UI | MVP | Not Started | — | Player Controller, XP & Level-Up, Weapon System |
| 16 | Level-Up UI | UI | MVP | Not Started | — | XP & Level-Up, Upgrade/Blessing |
| 17 | Boss Health Bar | UI | MVP | Not Started | — | Boss System |
| 18 | Audio Manager | Audio | Stretch | Not Started | — | Game State Machine |
| 19 | Main Menu | Meta | Stretch | Not Started | — | Game State Machine |

---

## Categories

| Category | Description |
|----------|-------------|
| **Core** | Foundation systems everything depends on — state management, collision, rendering |
| **Gameplay** | Systems that create the moment-to-moment fun — combat, enemies, weapons |
| **Progression** | How the player grows — XP, upgrades, stage advancement |
| **Narrative** | Story delivery — dialogue screens, scripture display |
| **UI** | Player-facing information — HUD, menus, selection screens |
| **Audio** | Sound and music (stretch goal for jam) |
| **Meta** | Systems outside core loop — main menu (stretch goal for jam) |

---

## Priority Tiers

| Tier | Definition | Target Milestone |
|------|------------|------------------|
| **MVP** | Required for the core loop to function (17 systems) | Week 1 |
| **Stretch** | Polish and completeness features (2 systems) | If time allows |

---

## Dependency Map

### Foundation Layer (no dependencies)

1. **Game State Machine** — Everything needs to know current state (playing, dialogue, level-up, game over)
2. **Collision System** — 5+ systems depend on collision detection. #1 bottleneck.
3. **Camera/Viewport** — Must exist before anything renders correctly

### Core Layer (depends on foundation)

4. **Player Controller** — depends on: Game State Machine, Collision System
5. **Damage/Health System** — depends on: Collision System
6. **Projectile System** — depends on: Collision System, Camera/Viewport

### Feature Layer (depends on core)

7. **Weapon System** — depends on: Player Controller, Projectile System, Damage/Health
8. **Enemy System** — depends on: Damage/Health, Collision System, Camera/Viewport
9. **XP & Level-Up System** — depends on: Player Controller, Enemy System
10. **Stage Progression** — depends on: Game State Machine, Wave Spawner (via event)
11. **Wave Spawner** — depends on: Enemy System, Stage Progression (reads stage data)
12. **Upgrade/Blessing System** — depends on: Weapon System, XP & Level-Up
13. **Boss System** — depends on: Enemy System, Damage/Health, Stage Progression
14. **Dialogue System** — depends on: Game State Machine, Stage Progression

### Presentation Layer (wraps features)

15. **HUD** — depends on: Player Controller, XP & Level-Up, Weapon System
16. **Level-Up UI** — depends on: XP & Level-Up, Upgrade/Blessing System
17. **Boss Health Bar** — depends on: Boss System

### Polish Layer (stretch)

18. **Audio Manager** — depends on: Game State Machine
19. **Main Menu** — depends on: Game State Machine

---

## Recommended Design Order

| Order | System | Priority | Layer | Est. Effort |
|-------|--------|----------|-------|-------------|
| 1 | Game State Machine | MVP | Foundation | S |
| 2 | Collision System | MVP | Foundation | M |
| 3 | Camera/Viewport | MVP | Foundation | S |
| 4 | Player Controller | MVP | Core | S |
| 5 | Damage/Health System | MVP | Core | S |
| 6 | Projectile System | MVP | Core | S |
| 7 | Enemy System | MVP | Feature | M |
| 8 | Weapon System | MVP | Feature | M |
| 9 | XP & Level-Up System | MVP | Feature | S |
| 10 | Stage Progression | MVP | Feature | S |
| 11 | Wave Spawner | MVP | Feature | S |
| 12 | Upgrade/Blessing System | MVP | Feature | S |
| 13 | Dialogue System | MVP | Feature | S |
| 14 | Boss System | MVP | Feature | M |
| 15 | HUD | MVP | Presentation | S |
| 16 | Level-Up UI | MVP | Presentation | S |
| 17 | Boss Health Bar | MVP | Presentation | S |
| 18 | Audio Manager | Stretch | Polish | S |
| 19 | Main Menu | Stretch | Polish | S |

*Effort: S = 1 session, M = 2-3 sessions*

---

## Circular Dependencies

- **Wave Spawner <-> Stage Progression**: Wave Spawner needs stage data to know
  what to spawn. Stage Progression needs to know when waves are complete.
  **Resolution**: Stage Progression owns stage data and passes it to Wave Spawner.
  Wave Spawner fires a `WavesCompleteEvent` that Stage Progression listens to.
  One-way data flow, event-based notification.

---

## High-Risk Systems

| System | Risk Type | Risk Description | Mitigation |
|--------|-----------|-----------------|------------|
| Collision System | Technical | No built-in physics. Must handle 100s of entities efficiently. Performance unknown. | Prototype early. Use spatial partitioning (grid) if needed. Circle collisions only (cheapest). |
| Projectile System | Technical | Many simultaneous projectiles + collision checks could bottleneck. | Object pooling. Simple movement (no physics). Profile during prototype. |
| Boss System | Design | Goliath must feel mechanically distinct from regular waves or the climax falls flat. | Design unique attack patterns. Prototype the boss fight early to validate feel. |
| Dialogue System | Design | Too much text breaks flow; too little loses the narrative hook. Must be right for kids 8-16. | Keep to 2-4 lines per screen. Playtest pacing with target audience. |

---

## Progress Tracker

| Metric | Count |
|--------|-------|
| Total systems identified | 19 |
| MVP systems | 17 |
| Stretch systems | 2 |
| Design docs started | 0 |
| Design docs reviewed | 0 |
| Design docs approved | 0 |
| MVP systems designed | 0/17 |

---

## Next Steps

- [ ] Design MVP-tier systems (use `/design-system [system-name]`)
- [ ] Start with Foundation layer: Game State Machine, Collision System, Camera/Viewport
- [ ] Prototype the core loop early to validate collision performance
- [ ] Run `/design-review` on each completed GDD
- [ ] Plan the 2-week sprint with `/sprint-plan new`
