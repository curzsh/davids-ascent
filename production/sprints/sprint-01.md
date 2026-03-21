# Sprint 1 -- Game Jam: David's Ascent

> **Goal**: Ship a complete David's Ascent bullet heaven with 5 stages, 4 weapons, Goliath boss fight, and biblical dialogue.
> **Duration**: 2 weeks (14 days)
> **Start**: TBD (when dev begins)
> **Type**: Game jam sprint — daily milestones, no carryover

---

## Capacity

- Total days: 14
- Buffer: Days 7 and 13 include explicit buffer/polish time
- Stretch goals: Audio Manager, Main Menu (cut first if behind)
- Fallback scope: 3 stages + Goliath (MVP tier) if behind by Day 10

---

## Week 1: Core Loop (Days 1-7)

### Day 1 — Project Setup + Foundation
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 1.1 | Set up Gradle project with Valthorne 1.3.0 dependency | 2h | Project compiles, window opens |
| 1.2 | Implement Game State Machine (Menu, Playing, Dialogue, LevelUp, GameOver, Victory) | 2h | States transition correctly via events |
| 1.3 | Set up Camera/Viewport (OrthographicCamera2D + FitViewport) | 1h | Consistent rendering at target resolution |
| 1.4 | Create main Application class with game loop structure | 1h | Game loop runs at 60fps, delta time works |

### Day 2 — Player + Movement
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 2.1 | Player Controller: WASD/arrow key movement with configurable speed | 2h | David moves in 4/8 directions smoothly |
| 2.2 | Player sprite rendering (placeholder art OK) | 1h | David visible on screen, centered in camera |
| 2.3 | Collision System: circle-circle detection, spatial efficiency | 2h | Collision detected between two entities reliably |
| 2.4 | Screen/arena bounds enforcement | 1h | David cannot leave the play area |

### Day 3 — Combat Core
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 3.1 | Projectile System: spawning, movement, lifetime, pooling | 2h | Projectiles move, expire, and get recycled |
| 3.2 | Sling weapon: auto-fire at nearest enemy within range | 2h | Sling fires stones at closest enemy automatically |
| 3.3 | Damage/Health System: deal damage, take damage, death | 1h | Enemies die when HP reaches 0, David can take hits |
| 3.4 | First enemy type: basic chaser (walks toward David) | 1h | Enemy spawns, chases David, deals contact damage |

### Day 4 — XP + Upgrades
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 4.1 | XP gems: drop from enemies, collect on proximity | 2h | Gems drop, David auto-collects nearby gems |
| 4.2 | Level-up bar + level-up trigger | 1h | Bar fills with XP, triggers level-up at threshold |
| 4.3 | Level-up screen: show 3 random upgrades, pick 1 | 2h | Game pauses, 3 choices shown, selection applies |
| 4.4 | Upgrade/Blessing system: stat modifications work | 1h | Picking "Psalm of Speed" actually makes David faster |

### Day 5 — Wave Spawner + Stage 1
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 5.1 | Wave Spawner: timed waves with escalating enemy count/speed | 2h | Waves spawn on schedule, get harder over time |
| 5.2 | Stage 1 (Lion) data: enemy types, wave composition, duration | 2h | Stage 1 plays from start to completion trigger |
| 5.3 | Stage completion condition + transition trigger | 1h | Stage ends after final wave, triggers next stage |
| 5.4 | 2-3 enemy variants for Stage 1 (lion, wolf, snake) | 1h | Visually and behaviorally distinct enemies |

### Day 6 — Multi-Stage + Dialogue
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 6.1 | Stage Progression: 5-stage sequence with transitions | 1h | Game progresses through stages in order |
| 6.2 | Dialogue System: text screen between stages, advance with input | 2h | Scripture/dialogue displays, player advances with key press |
| 6.3 | Stage 2 (Bear) + Stage 3 (Scouts) enemy types | 2h | Each stage has distinct enemy behaviors |
| 6.4 | Shepherd's Staff weapon (melee sweep) + Throwing Stones (spread) | 1h | Both weapons functional, available as upgrade choices |

### Day 7 — MVP Checkpoint
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 7.1 | Bug fix pass on all Week 1 features | 2h | No crashes during a full 3-stage playthrough |
| 7.2 | Balance pass: enemy HP/damage, weapon scaling, XP curve | 2h | 3-stage run feels challenging but fair |
| 7.3 | Playtest: complete 3-stage run start to finish | 1h | Core loop is fun. "One more run" feeling present. |
| 7.4 | Assess scope: on track for full vision or fall back to MVP? | 1h | Decision documented, Week 2 plan confirmed |

**Week 1 Exit Criteria**: 3 stages playable end-to-end with weapons, upgrades, enemies, and dialogue. Core loop validated as fun.

---

## Week 2: Content + Boss + Polish (Days 8-14)

### Day 8 — Stages 4-5 Content
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 8.1 | Stage 4 (Army) enemies: soldiers, shieldbearers, chariots | 2h | Distinct enemy types with unique behaviors |
| 8.2 | Divine Fire weapon (area of effect) | 1h | AoE damage around David, available as upgrade |
| 8.3 | All weapon upgrade tiers implemented (3 tiers each) | 2h | Each weapon has 3 meaningful upgrades |
| 8.4 | Stage 5 (Goliath) arena setup | 1h | Arena for boss fight loads correctly |

### Day 9 — Goliath Boss
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 9.1 | Boss System: Goliath with large sprite, high HP, unique attacks | 3h | Goliath feels massive and threatening |
| 9.2 | Boss attack patterns: charge, ground slam, projectile throw | 2h | Attacks are readable and dodgeable |
| 9.3 | Victory condition + victory screen | 1h | Beating Goliath ends the game with celebration |

### Day 10 — HUD + UI
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 10.1 | HUD: health bar, XP bar, weapon icons, stage indicator | 2h | All game state visible at a glance |
| 10.2 | Level-Up UI polish: card-style selection with descriptions | 2h | Upgrades are clear and visually appealing |
| 10.3 | Boss health bar (large, screen-top) | 1h | Goliath's health clearly visible during fight |
| 10.4 | Game Over screen with retry option | 1h | Death leads to game over, can restart stage |

### Day 11 — Dialogue Content + Narrative
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 11.1 | Write all pre-stage scripture/dialogue (5 stages) | 2h | Each stage has a meaningful biblical intro |
| 11.2 | Write all post-stage dialogue (4 transitions + victory) | 1h | Story progresses between stages naturally |
| 11.3 | Polish dialogue screen visuals (background, font, formatting) | 2h | Dialogue screens look intentional, not placeholder |
| 11.4 | Goliath confrontation dialogue (the iconic scene) | 1h | Pre-boss dialogue captures the biblical moment |

### Day 12 — Balance + Difficulty
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 12.1 | Full balance pass: enemy HP/damage curves across 5 stages | 2h | Difficulty ramps smoothly from Stage 1 to Goliath |
| 12.2 | Weapon scaling balance: all weapons viable, upgrades meaningful | 1h | No weapon is useless, upgrades feel impactful |
| 12.3 | Wave timing and density per stage | 1h | Each stage has right pacing — not too fast, not boring |
| 12.4 | Full playthrough test (age 8-16 appropriate difficulty) | 2h | Beatable but challenging, no frustration spikes |

### Day 13 — Polish + Stretch Goals
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 13.1 | Visual feedback: enemy death effects, hit flash, XP pickup glow | 2h | Every action has satisfying visual feedback |
| 13.2 | (Stretch) Audio: SFX for hits, deaths, level-ups, stage transitions | 2h | Sound adds to the experience |
| 13.3 | (Stretch) Background music per stage | 1h | Music sets the tone for each trial |
| 13.4 | (Stretch) Main menu with title and start button | 1h | Professional first impression |

### Day 14 — Ship Day
| ID | Task | Est. | Acceptance Criteria |
|----|------|------|---------------------|
| 14.1 | Final bug fix pass | 2h | Zero crashes in 3 consecutive full playthroughs |
| 14.2 | Final full playthrough test | 1h | Complete game experience start to finish |
| 14.3 | Build packaging (runnable JAR or equivalent) | 1h | Game runs on a clean machine |
| 14.4 | Jam submission | 1h | Submitted with description, screenshots, controls |

**Week 2 Exit Criteria**: Complete game with 5 stages, Goliath boss, dialogue, polished UI. Ready for jam submission.

---

## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Collision performance with many entities | Medium | High | Circle collisions only. Spatial grid if >200 entities. Profile Day 3. |
| Art bottleneck (solo dev, no artist) | High | Medium | Programmer art / colored shapes. Consistent style > pretty sprites. |
| Goliath fight feels flat | Medium | High | Dedicate full Day 9. Unique attack patterns mandatory. |
| Scope creep | Medium | High | Pillar 3 enforced. If >1 day, cut it. |
| Valthorne engine unknowns | Medium | Medium | API reference docs created. Day 1 is pure setup/learning. |
| Week 1 overrun | Medium | High | Day 7 checkpoint. Fall back to 3 stages if behind by Day 10. |

---

## Definition of Done

- [ ] All 5 stages playable with distinct enemies
- [ ] All 4 weapons with 3 upgrade tiers each
- [ ] 5 blessings (passive upgrades) functional
- [ ] Goliath boss fight with unique mechanics
- [ ] Dialogue/scripture between all stages
- [ ] HUD showing health, XP, weapons, stage
- [ ] Level-up UI with card selection
- [ ] Game Over + Victory screens
- [ ] Full run completable in 20-25 minutes
- [ ] No crashes during normal play
- [ ] Packaged and submitted to jam
