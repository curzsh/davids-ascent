# Game Concept: David's Ascent

*Created: 2026-03-21*
*Status: Draft*

---

## Elevator Pitch

> It's a bullet heaven where you play as David, surviving waves of biblical
> enemies across 5 curated stages — from lions in the wilderness to the
> ultimate showdown with Goliath. Short scripture and dialogue between stages
> bring the story to life for a church/youth audience.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Bullet Heaven / Survivor-like |
| **Platform** | PC (Java / Valthorne engine) |
| **Target Audience** | Church youth groups, kids 8-16, casual gamers who enjoy VS-likes |
| **Player Count** | Single-player |
| **Session Length** | 20-25 minutes (full run) |
| **Monetization** | Free (game jam entry) |
| **Estimated Scope** | Small (2 weeks, solo developer) |
| **Comparable Titles** | Vampire Survivors, Brotato, HoloCure |

---

## Core Fantasy

You are David — a shepherd boy nobody believes in. Armed with nothing but a
sling and faith, you face impossible odds. With each trial you overcome, your
arsenal of divine weapons grows until you stand before Goliath himself, a
screen full of holy projectiles raining down, proving that the underdog with
God on his side cannot be stopped.

The core fantasy is the biblical underdog power trip: starting from nothing
and becoming unstoppable through perseverance and faith.

---

## Unique Hook

Like Vampire Survivors, AND ALSO a curated 5-stage biblical narrative where
each level is a trial from David's life, with scripture and dialogue woven
between stages — making it both a compelling game AND a meaningful experience
for church youth audiences.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 2 | Screen-filling projectiles, satisfying hit feedback, enemy death effects |
| **Fantasy** (make-believe, role-playing) | 1 | BE David. Live the biblical journey from shepherd to giant-slayer |
| **Narrative** (drama, story arc) | 3 | Scripture quotes, pre/post-stage dialogue, escalating stakes to Goliath |
| **Challenge** (obstacle course, mastery) | 4 | Each stage harder than the last, Goliath as the ultimate test |
| **Fellowship** (social connection) | N/A | Single-player |
| **Discovery** (exploration, secrets) | 5 | Weapon combinations, upgrade synergies |
| **Expression** (self-expression, creativity) | 6 | Build variety through weapon/blessing choices |
| **Submission** (relaxation, comfort zone) | 7 | Auto-attack nature is inherently low-stress |

### Key Dynamics (Emergent player behaviors)

- Players will experiment with weapon combinations to find synergies
- Players will replay to try different upgrade paths
- Players will share the Goliath fight moment with friends
- Players will connect gameplay moments to the biblical source material

### Core Mechanics (Systems we build)

1. **Auto-attack combat** — Weapons fire automatically, player focuses on movement and positioning
2. **Wave survival** — Enemies spawn in escalating waves within each stage
3. **Level-up upgrade selection** — XP gems → level up → pick 1 of 3 upgrades
4. **Stage progression** — 5 fixed stages with unique enemies, each harder than the last
5. **Dialogue/scripture system** — Brief narrative screens between stages

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | Weapon/blessing choices shape your build each run | Supporting |
| **Competence** (mastery, skill growth) | Dodging gets harder, builds get stronger, Goliath is the final exam | Core |
| **Relatedness** (connection, belonging) | Biblical story creates shared cultural touchpoint for church groups | Supporting |

### Player Type Appeal (Bartle Taxonomy)

- [x] **Achievers** (goal completion, collection, progression) — Beat all 5 stages, defeat Goliath, try all weapons
- [x] **Explorers** (discovery, understanding systems, finding secrets) — Discover weapon synergies, find optimal builds
- [ ] **Socializers** (relationships, cooperation, community) — Not directly served (single-player)
- [ ] **Killers/Competitors** (domination, PvP, leaderboards) — Not directly served

### Flow State Design

- **Onboarding curve**: Stage 1 (Lion) is gentle — few enemy types, slow spawns. Teaches movement + auto-attack naturally.
- **Difficulty scaling**: Each stage adds enemy variety, speed, and density. Weapon upgrades keep pace with difficulty.
- **Feedback clarity**: XP gems, level-up fanfare, weapon evolution visuals, damage numbers (optional), kill count.
- **Recovery from failure**: Death restarts the current stage (not the whole run). Low punishment keeps it accessible for kids.

---

## Core Loop

### Moment-to-Moment (30 seconds)
Move David to dodge enemies and projectiles. Weapons auto-fire at nearby
targets. Enemies die and drop XP gems. Collect gems to fill the level-up bar.
The satisfaction is watching your projectiles fill the screen as waves get
denser.

### Short-Term (3-5 minutes per stage)
Each stage has escalating waves of themed enemies. Every level-up offers a
choice of 3 upgrades (new weapon, upgrade existing, or blessing). The stage
climaxes with a tougher wave or mini-boss moment. Completing the stage
triggers a dialogue/scripture screen before advancing.

### Session-Level (20-25 minutes full run)
5 stages played in order: Lion → Bear → Scouts → Army → Goliath. Your build
accumulates across all stages. The Goliath fight is the climactic final
test. A complete run is short enough to replay with different build choices.

### Long-Term Progression
For the jam version, replayability comes from trying different weapon
combinations. Meta-progression (persistent unlocks between runs) is a
stretch goal, not core scope.

### Retention Hooks
- **Curiosity**: "What weapon will I get next stage?" / "Can I beat Goliath with only sling upgrades?"
- **Investment**: Build identity — "my run, my choices"
- **Mastery**: Can I beat it without taking damage? Can I beat it faster?
- **Sharing**: "Watch me fight Goliath!" — shareable moment for youth groups

---

## Game Pillars

### Pillar 1: Every Stage Tells a Story
Each of the 5 stages has distinct enemies, a signature weapon, AND a narrative
moment. Brief dialogue or scripture before/after stages grounds the action in
David's biblical journey.

*Design test*: "Should we skip the dialogue to save dev time?" → No, the
story moments are what make this more than a generic bullet heaven.

### Pillar 2: Underdog Power Fantasy
David starts weak with just a sling. By Goliath, the screen should be chaos —
divine fire, holy stones, angelic projectiles everywhere. The joy is in the
escalation from shepherd boy to unstoppable force.

*Design test*: "Should we start the player with strong abilities?" → No, the
growth from nothing IS the fantasy.

### Pillar 3: Jam-Scoped Simplicity
If a feature can't be implemented in a day or less, cut it. Polish the core
loop and the Goliath fight. Everything else is secondary.

*Design test*: "Should we add a complex dialogue tree?" → No, keep it to
short curated text between stages.

### Anti-Pillars (What This Game Is NOT)

- **NOT a roguelike**: No permadeath, no procedural generation. Stages are handcrafted and ordered. The fixed arc IS the experience.
- **NOT a text-heavy visual novel**: Dialogue is short, punchy, and scripture-rooted. Think 2-4 lines between stages, not walls of text.
- **NOT balanced for competitive play**: It's okay if some builds are broken. Power fantasy > balance.

---

## Stage Design Overview

| Stage | Trial | Setting | Enemies | Signature Weapon | Scripture Theme |
| ---- | ---- | ---- | ---- | ---- | ---- |
| 1 | The Lion | Wilderness/pasture | Lions, wolves, snakes | Sling (starter) | "The Lord is my shepherd" (Psalm 23) |
| 2 | The Bear | Rocky hills | Bears, wild beasts | Shepherd's Staff (melee sweep) | "He delivered me from the paw of the lion and the bear" (1 Sam 17:37) |
| 3 | The Scouts | Philistine border | Philistine scouts, archers | Throwing Stones (spread shot) | "The battle is the Lord's" (1 Sam 17:47) |
| 4 | The Army | Battlefield | Philistine soldiers, shieldbearers, chariots | Divine Fire (area damage) | "David grew stronger and stronger" (2 Sam 3:1) |
| 5 | Goliath | Valley of Elah | Goliath (boss) + Philistine guards | All weapons combined | "I come against you in the name of the Lord" (1 Sam 17:45) |

---

## Weapon & Upgrade System

### Weapon Slots: 3-4 maximum per run

Each stage introduces a new weapon. Players choose which to keep/upgrade.

| Weapon | Type | Stage Introduced | Upgrade Path |
| ---- | ---- | ---- | ---- |
| **Sling** | Single-target ranged | Stage 1 (start) | Faster fire → Multi-shot → Homing stones |
| **Shepherd's Staff** | Melee sweep | Stage 2 | Wider arc → Knockback → Shockwave on hit |
| **Throwing Stones** | Spread shot | Stage 3 | More projectiles → Piercing → Ricochet |
| **Divine Fire** | Area of effect | Stage 4 | Larger radius → Burn DoT → Pillar of Fire |

### Blessings (Passive Upgrades)
Blessings appear alongside weapons in level-up choices:
- **Psalm of Speed** — Movement speed increase
- **Shield of Faith** — Absorb one hit (cooldown)
- **Anointing Oil** — Bonus XP gain
- **Stone Skin** — Damage reduction
- **Shepherd's Resolve** — Auto-heal over time

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Vampire Survivors | Auto-attack loop, XP gems, level-up weapon choices | Curated stages instead of endless runs; biblical narrative layer | Validates the core loop — VS proved this formula is addictive |
| Bible (1 Samuel 16-17) | David's journey, specific trials, scripture quotes | Interactive retelling through gameplay, not passive reading | Provides authentic source material for the target audience |
| Veggie Tales | Faith-based entertainment that's fun first, educational second | Game medium instead of animation; older audience (8-16 vs 3-8) | Proves biblical themes work in entertainment when done with sincerity |

**Non-game inspirations**: The Book of Samuel, church youth group energy, the universal "underdog vs giant" archetype.

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 8-16 (primary), all ages (secondary) |
| **Gaming experience** | Casual to mid-core |
| **Time availability** | 20-30 minute sessions (youth group activity, after school) |
| **Platform preference** | PC |
| **Current games they play** | Vampire Survivors, Brotato, Minecraft, simple arcade games |
| **What they're looking for** | Fun action game with biblical themes that doesn't feel "preachy" |
| **What would turn them away** | Excessive difficulty, boring sermons disguised as gameplay, poor game feel |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Engine** | Valthorne (Java, LWJGL-based 2D engine) |
| **Key Technical Challenges** | Collision detection (no built-in physics), enemy spawning/wave management, screen-filling projectile performance |
| **Art Style** | Simple 2D sprites — pixel art or clean vector style (solo dev friendly) |
| **Art Pipeline Complexity** | Low — simple sprites, minimal animation frames |
| **Audio Needs** | Moderate — satisfying hit SFX, background music per stage, level-up jingle |
| **Networking** | None |
| **Content Volume** | 5 stages, 4 weapons, ~5 blessings, ~8 enemy types, 1 boss, 10-15 dialogue screens |
| **Procedural Systems** | Enemy wave spawning (semi-random within authored patterns) |

---

## Risks and Open Questions

### Design Risks
- Core auto-attack loop may feel shallow without enough weapon variety
- Goliath boss fight needs to feel mechanically distinct from regular waves or it'll be anticlimactic
- Dialogue pacing — too much breaks flow, too little loses the narrative hook

### Technical Risks
- Valthorne has no built-in collision system — rolling our own for hundreds of projectiles + enemies could be a performance bottleneck
- First game dev project — unknowns around game loop architecture, state management, sprite management at scale
- No existing bullet heaven reference code for Valthorne

### Market Risks
- Game jam entry — market risk is low/irrelevant
- Church audience may have varied comfort levels with "violence" even in cartoon form

### Scope Risks
- 5 stages + boss + dialogue + 4 weapons + blessings is ambitious for 2 weeks solo
- Art creation could become the bottleneck (programmer art is fine for jam)

### Open Questions
- How many enemies can Valthorne handle on screen before performance degrades? → Prototype stress test needed
- What's the right difficulty curve for 8-16 year olds? → Playtest with target audience
- Should death restart the stage or the entire run? → Prototype and test (currently: restart stage)

---

## MVP Definition

**Core hypothesis**: "Players find the auto-attack survival loop fun AND the biblical narrative adds meaningful flavor rather than feeling forced."

**Required for MVP**:
1. David moves with WASD/arrow keys, auto-attacks nearby enemies
2. Enemies spawn in waves, drop XP gems
3. Level-up system with weapon/blessing choices (3-4 slots)
4. At least 3 stages with distinct enemy types
5. Goliath boss fight (Stage 5)
6. Dialogue/scripture screens between stages

**Explicitly NOT in MVP** (stretch goals):
- Meta-progression / persistent unlocks between runs
- More than 4 weapon types
- Sound effects and music (can ship silent for jam if needed)
- Screen shake and visual juice effects
- Main menu and settings screen

### Scope Tiers (if time runs out)

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 3 stages + Goliath | Core loop + basic upgrades + dialogue | Week 1 |
| **Target** | 5 stages + Goliath | Full weapon set + blessings + dialogue | End of Week 2 |
| **Polish** | 5 stages + Goliath | + SFX, music, screen effects, menu | If time allows |
| **Stretch** | 5 stages + Goliath + extras | + meta-progression, extra weapons, leaderboard | Post-jam |

---

## Next Steps

- [ ] Configure Valthorne as engine (`/setup-engine`)
- [ ] Decompose concept into systems (`/map-systems`)
- [ ] Prototype core loop — David moving + sling auto-attack + enemy waves (`/prototype`)
- [ ] Stress test Valthorne with many sprites on screen
- [ ] Author per-system GDDs (`/design-system`)
- [ ] Plan the 2-week jam sprint (`/sprint-plan new`)
