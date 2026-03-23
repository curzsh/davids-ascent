# David's Ascent — Comprehensive QA Test Checklist

**Target Audience**: Church youth ages 8-16
**Build**: Day 7 MVP (Valthorne 1.3.0)
**Test Scope**: All core systems, 5 biblical stages, 4 weapons, boss fight, dialogue, upgrades
**Duration**: ~45 minutes per full playthrough

---

## 1. SMOKE TEST (Quick Verification — 15 minutes)

### 1.1 Game Startup & Title Screen
- [ ] Game launches without crashing
- [ ] Title screen displays correctly
- [ ] "Press SPACE to start" message is visible
- [ ] Pressing SPACE transitions to Stage 1 PRE_DIALOGUE
- [ ] ESC key closes the game cleanly

### 1.2 Dialogue System (Stage 1 Entry)
- [ ] Pre-dialogue text displays without overlaps or corruption
- [ ] Text is readable (font size, color contrast adequate)
- [ ] Pressing SPACE/ENTER dismisses dialogue and starts stage gameplay
- [ ] Dialogue UI does not block player input during gameplay

### 1.3 Player Movement
- [ ] WASD keys move player up/down/left/right
- [ ] Arrow keys also move player in all 4 directions
- [ ] Player cannot move outside screen bounds
- [ ] Player position updates smoothly (no stuttering)
- [ ] Diagonal movement is normalized (no speed advantage when moving NW, NE, etc.)

### 1.4 Player Health & Combat
- [ ] Player health bar displays above player sprite
- [ ] Health bar color: green (>50%), yellow (25-50%), red (<25%)
- [ ] Health bar width corresponds to actual health percentage
- [ ] Sling weapon fires automatically
- [ ] Sling projectiles hit enemies and deal damage
- [ ] Player takes damage when touched by enemy
- [ ] Health decreases visibly when hit

### 1.5 XP & Leveling
- [ ] XP gems spawn when enemies die
- [ ] XP gems auto-collect when near player (pickup radius ~30px)
- [ ] XP bar fills as gems are collected
- [ ] Level-up UI appears when XP bar fills
- [ ] 3 random upgrade choices are displayed
- [ ] Selecting upgrade applies it and dismisses level-up screen

### 1.6 Stage Transition & Victory
- [ ] Stage 1 waves spawn and complete
- [ ] Post-dialogue appears after final wave
- [ ] Dialogue correctly dismisses
- [ ] Stage 2 PRE_DIALOGUE appears
- [ ] Fast-forward 5 stages to verify Victory screen displays
- [ ] Victory screen shows "You have triumphed!" or similar

---

## 2. PLAYER SYSTEM TESTS

### 2.1 Movement & Bounds Checking
**Precondition**: Stage 1 playing, player at center
**Test Cases**:
| Test | Input | Expected | Actual | Pass |
|------|-------|----------|--------|------|
| Move left to bounds | Hold A for 10s | Player stops at x=0, sprite still visible | | |
| Move right to bounds | Hold D for 10s | Player stops at x=768 (800-32), sprite visible | | |
| Move up to bounds | Hold W for 10s | Player stops at y=568 (600-32), sprite visible | | |
| Move down to bounds | Hold S for 10s | Player stops at y=0, sprite visible | | |
| Diagonal approach NW corner | Hold W+A | Player reaches corner smoothly, no snapping | | |
| Diagonal speed (W+A vs W alone) | Measure 1 second | Speed should be same (normalized) | | |

### 2.2 Health Management
**Precondition**: Player at full health (120 HP)
**Test Cases**:
| Test | Action | Expected | Actual | Pass |
|------|--------|----------|--------|------|
| Take 20 damage | Enemy hits player | HP = 100, bar reflects change | | |
| Take 0 damage cap | takeDamage(-10) | HP remains at 100 (no heal) | | |
| Heal to max | increaseMaxHealth(30) | maxHealth = 150, health = 150 | | |
| Zero health state | takeDamage(120) | Player.isDead() = true, game ends | | |
| Negative health cap | takeDamage(1000) | HP = 0 (not -880) | | |

### 2.3 Speed Modification (Upgrades)
**Precondition**: Player base speed = 210 px/s
**Test Cases**:
| Test | Upgrade | Expected Speed | Time to Cross (800px) | Actual | Pass |
|------|---------|-----------------|----------------------|--------|------|
| Fleet Foot Lv1 | +45 speed | 255 px/s | 3.14s | | |
| Fleet Foot Lv2 | +45 speed again | 300 px/s | 2.67s | | |
| Speed scale over time | 2-3 upgrades | Noticeable but not OP | | | |

---

## 3. WEAPON SYSTEM TESTS

### 3.1 Sling Weapon (Starter)
**Balance Values**: fireRate=1.4s, damage=12, range=260, projectileSpeed=420
**Test Cases**:
| Test | Precondition | Expected | Actual | Pass |
|------|--------------|----------|--------|------|
| Auto-fire | Game playing | Fires automatically every 1.4s | | |
| Projectile spawn | Player at (400, 300) | Projectile spawns at nearest enemy or radius | | |
| Projectile lifetime | Fire projectile | Despawns after 2.0s | | |
| Hit detection | Projectile hits enemy | Enemy takes 12 damage, hit flash shows | | |
| Multiple targets | 3+ enemies onscreen | Sling fires at one per cycle | | |
| Upgrade: +damage | Take sling damage upgrade | Next shots deal 12+6=18 | | |
| Upgrade: +fire rate | Take fire rate upgrade | Fires every 0.9s (1.4-0.5) | | |
| Upgrade: +range | Take range upgrade | Target radius increases 310 | | |

### 3.2 Shepherd's Staff (Melee)
**Balance Values**: fireRate=0.9s, damage=18, radius=65, knockback=160
**Precondition**: Acquire Staff from upgrade pool (at least 2 weapons)
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Activation trigger | Fires when enemy enters 65px radius | | |
| Arc animation | Staff sweeps around player | | |
| Hit detection | All enemies in radius take 18 damage | | |
| Knockback | Enemy pushed away by ~160 units | | |
| Fire rate | Re-fires every 0.9s | | |
| Upgrade: +radius | Radius increases to 83px | | |
| Upgrade: +damage | Damage increases to 28 | | |
| Upgrade: +knockback | Knockback increases to 250 | | |
| Multiple enemies | Staff hits 3 enemies at once without penalty | | |
| Overlap with sling | Both weapons active, both fire independently | | |

### 3.3 Throwing Stones (Spread)
**Balance Values**: fireRate=0.6s, damage=14, stoneCount=5, projectileSpeed=320
**Precondition**: Acquire Throwing Stones from upgrade
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Fire pattern | 5 stones fan out in cone | | |
| Individual projectiles | Each stone is separate, can hit different enemies | | |
| Damage per stone | Each stone deals 14 damage | | |
| Fire rate | Fires every 0.6s | | |
| Lifetime | Stones despawn after 1.5s | | |
| Upgrade: +count | 5+2 = 7 stones per shot | | |
| Upgrade: +damage | Each stone deals 19 damage | | |
| Upgrade: +fire rate | Fires every 0.3s (0.6-0.3) | | |

### 3.4 Divine Fire (Ring AoE)
**Balance Values**: radius=85, ringThickness=14, damage=10, damageInterval=0.25s
**Precondition**: Acquire Divine Fire from upgrade
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Ring visibility | Ring of fire around player, radius 85px | | |
| Continuous damage | Enemies in ring take 10 damage every 0.25s | | |
| Pulse frequency | Pulse every 0.25s (4 pulses per second) | | |
| Ring movement | Ring follows player as they move | | |
| Hit flash | Enemy in ring flashes white on each hit | | |
| Upgrade: +radius | Radius increases to 107px | | |
| Upgrade: +damage | Each pulse deals 17 damage | | |
| Upgrade: +fire rate | Damage interval becomes 0.05s (5 pulses/sec) | | |

### 3.5 Weapon Slot Management
**Precondition**: Max 4 weapons
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| 4 weapons acquired | All 4 weapons fire simultaneously | | |
| 5th weapon rejected | Attempting to add 5th weapon is denied | | |
| Weapon active count | HUD shows 4 weapon icons | | |
| Full slot behavior | "Weapon slots full" message (if applicable) | | |

---

## 4. ENEMY SYSTEM TESTS

### 4.1 ChaserEnemy (Lions, Wolves, Bears, Basic Soldiers)
**Behavior**: Walks directly toward player
**Precondition**: Stage 1 with Chaser enemies
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Movement toward player | Enemy walks directly to player | | |
| Hit cooldown | Enemy takes damage, flashes white, can't be hit for 0.1s | | |
| Death trigger | Health reaches 0, enemy disappears | | |
| XP drop | Dead enemy spawns XP gem with correct value | | |
| Color rendering | Enemy renders as defined color (snake=green, etc.) | | |

### 4.2 ShieldEnemy (Shieldbearers)
**Behavior**: Alternates march (2.0s) / block (1.2s). Blocking = 50% damage reduction + 50% speed
**Precondition**: Stage 4 with shield enemies
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Marching phase | Moves at normal speed toward player | | |
| Blocking phase | Stops with blue shield overlay, moves at 50% speed | | |
| Damage reduction | Blocking: 20 damage → 10 applied | | |
| Damage while marching | Marching: 20 damage → 20 applied | | |
| Phase transition | Smooth transition between march/block every 2.0s / 1.2s | | |
| Shield visual | Shield flash is visible during block | | |

### 4.3 DashEnemy (Scouts)
**Behavior**: Approach (2.5s) → Windup (0.4s) → Dash (0.5s) → Cooldown (1.0s)
**Precondition**: Stage 3 with dash enemies
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Approach phase | Walks toward player at normal speed | | |
| Windup telegraph | Flashes white before dashing | | |
| Dash execution | Moves at 3.5x speed in locked direction | | |
| Dash direction | Direction locked when entering windup, not updated mid-dash | | |
| Cooldown behavior | Brief pause after dash before restart | | |
| Stretch animation | Enemy appears stretched during dash | | |
| Total cycle time | Full cycle ≈ 2.5 + 0.4 + 0.5 + 1.0 = 4.4s | | |

### 4.4 Enemy Spawning & Waves
**Precondition**: Stage 1 with WaveSpawner
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Wave 1 spawns | 5 snakes spawn at 1s mark, spawn rate 0.8s apart | | |
| Wave 2 spawns | At 8s, 6 wolves spawn with 0.7s interval | | |
| Overlap handling | Multiple waves exist simultaneously | | |
| Enemy limit | (Check if cap exists; if not, note in findings) | | |
| Spawn location | Enemies spawn off-screen (e.g., edges) or specific zones | | |

---

## 5. DAMAGE & COLLISION TESTS

### 5.1 Player Damage Taken
**Precondition**: Player at 120 HP, enemy deals 15 damage
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Enemy touch damage | Player health drops by 15 | | |
| Multiple enemy hits | Each enemy deals damage independently | | |
| Invincibility frame | (Check if any post-hit immunity exists) | | |
| Goliath slam damage | Goliath slam deals 25 damage to all in radius | | |
| Goliath spear damage | Spear projectile deals 20 damage on hit | | |

### 5.2 Enemy Damage Taken
**Precondition**: Stage 1, Sling + Staff equipped
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Sling hit enemy | Enemy takes 12 damage, white flash | | |
| Staff hit enemy | Enemy takes 18 damage, pushed away | | |
| Divine Fire pulse | Enemy in ring takes 10 damage per 0.25s pulse | | |
| Damage stacking | Multiple weapons hit same enemy independently | | |
| Shield block reduction | ShieldEnemy during block: 20 → 10 | | |

### 5.3 Damage Numbers (Floating Text)
**Precondition**: Enemies taking damage, DamageNumberSystem active
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Damage spawn | Number appears at hit location when damage dealt | | |
| Float animation | Number floats upward while fading | | |
| Duration | Text visible for ~0.8s then disappears | | |
| Pool management | 100 damage numbers exist; no crashes at limit | | |
| Random offset | Multiple hits don't stack exactly on top | | |

### 5.4 Hit Flash Effects
**Precondition**: Enemy health > 0, takes damage
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| White overlay | Enemy flashes white for 0.12s when hit | | |
| Flash disappears | Flash fades after duration | | |
| Multiple hits | Each hit triggers new flash (hit cooldown prevents abuse) | | |

---

## 6. XP & LEVELING SYSTEM TESTS

### 6.1 XP Gem Spawning
**Precondition**: Enemies dying
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Gem spawn | Enemy death spawns XP gem at location | | |
| Gem value | Small enemy (5 XP) vs large (15 XP) reflected correctly | | |
| Gem pool exhaustion | 400 gems max; if limit reached, older gems deactivate | | |
| Multiple gems | Multiple enemy deaths spawn multiple gems simultaneously | | |

### 6.2 XP Gem Collection
**Precondition**: Stage 1, enemy dead, XP gem spawned
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Auto-magnet | Gem moves toward player when within 30px | | |
| Collection radius | Gem collected when player center within 30px | | |
| Health decay | (Check if gems have lifetime; if yes, test decay) | | |
| Multiple collections | Collecting 5 gems = sum of all gem values | | |

### 6.3 Level-Up Progression
**Precondition**: Stage 1, starting at Lv1 (needs 18 XP to reach Lv2)
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| XP bar at 0% | Start of game, 0/18 XP | | |
| XP bar at 50% | After collecting 9 XP, bar is at 50% | | |
| Level up trigger | At 18 XP, level-up screen appears | | |
| XP reset after level | Consume level-up, XP = 0/29 (18 * 1.25) | | |
| Level 2 cost | Lv2 requires 29 XP (18 * 1.25 scale factor) | | |
| Level 3 cost | Lv3 requires 36 XP (29 * 1.25) | | |
| Multiple level-ups | If XP >= 2 thresholds, second level-up queues | | |

### 6.4 Level-Up UI
**Precondition**: Level-up triggered
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| 3 options shown | 3 random upgrades displayed | | |
| Different options | Subsequent level-ups show different (or weighted) upgrades | | |
| Selection highlight | Hovering/selecting an option visually highlights it | | |
| Apply upgrade | Clicking upgrade applies it to player/weapons | | |
| UI dismiss | Level-up screen closes after selection | | |
| Game pause | Enemies do not move/attack during level-up screen | | |

---

## 7. UPGRADE SYSTEM TESTS

### 7.1 Stat Upgrades
**Test Cases**:
| Upgrade | Base Value | Increase | New Value | Test Result |
|---------|------------|----------|-----------|-------------|
| Fleet Foot | 210 speed | +45 | 255 | Player visibly faster |
| Stone Skin | 120 maxHealth | +30 | 150 | Health bar extends higher |
| Shepherd's Resolve | — | Heal +40 | — | Player health increases to max+40 |

### 7.2 Weapon Upgrades
**Test Cases**:
| Weapon | Stat | Value | Upgrade | New Value | Effect |
|--------|------|-------|---------|-----------|--------|
| Sling | Damage | 12 | +6 | 18 | Visibly faster enemy kills |
| Sling | Fire Rate | 1.4s | -0.5s | 0.9s | Fires more frequently |
| Sling | Range | 260 | +50 | 310 | Targets farther enemies |
| Staff | Radius | 65 | +18 | 83 | Larger sweep area |
| Staff | Knockback | 160 | +90 | 250 | Enemies pushed farther |
| Stones | Count | 5 | +2 | 7 | 7 stones per shot |
| Fire | Radius | 85 | +22 | 107 | Ring extends larger |

### 7.3 Upgrade Pool Diversity
**Precondition**: Multiple level-ups throughout a run
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| No duplicates | Same upgrade not offered in same level-up | | |
| Weighted variety | Stat and weapon upgrades mix | | |
| Weapons not offered | If weapon already owned, don't offer again (verify behavior) | | |

---

## 8. STAGE & DIALOGUE SYSTEM TESTS

### 8.1 Stage Progression
**Precondition**: Start new game
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Stage 1 label | HUD shows "Stage 1: The Lion" | | |
| Stage 2 label | After completing stage 1: "Stage 2: The Bear" | | |
| Stage 3-5 labels | Verify each stage label updates | | |
| Stage count | "X/5 Stages Completed" or similar (if shown) | | |

### 8.2 Pre-Dialogue (Introduction)
**Precondition**: Stage 1 starts
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Pre-dialogue appears | Before gameplay, narrative text displays | | |
| Text content | Stage 1: mentions "shepherd," "wilderness," "lion" | | |
| Dismissal | Pressing SPACE starts gameplay | | |
| No overlap | Dialogue does not block player view after dismiss | | |

### 8.3 Post-Dialogue (Conclusion)
**Precondition**: Stage 1 enemies all defeated
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Post-dialogue trigger | After final enemy dies, dialogue appears | | |
| Text content | Reflects stage completion ("The flock is safe...") | | |
| Transition | Dismissing post-dialogue advances to next stage | | |

### 8.4 Stage 1: The Lion
**Wave Timing & Composition**:
| Wave | Time | Count | Enemy Type | Speed | Health | Expected Difficulty |
|------|------|-------|-----------|-------|--------|---------------------|
| 1 | 1s | 5 | Snake | 60 | 20 | Warm-up |
| 2 | 8s | 6 | Wolf | 70 | 25 | Moderate |
| 3 | 18s | 4 | Lion | 55 | 40 | Tanky |
| 4 | 28s | 8 | Wolf | 75 | 25 | Dense |
| 5 | 35s | 3 | Lion | 50 | 50 | Boss-like |

**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Wave 1 timing | 5 snakes spawn around 1s mark | | |
| Wave spacing | No overlapping spawn locations | | |
| Total duration | Stage playable in ~45-60s | | |
| Difficulty curve | Progressive, not overwhelming | | |

### 8.5 Stage 4: The Army (Shield Enemies)
**Precondition**: Progress to Stage 4
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Shield enemy presence | Shieldbearers appear in waves 2, 4, 6 | | |
| Shield blocking | Shieldbearers block 50% damage as described | | |
| Damage strategy | Multiple hits required; encourages skill | | |
| Dialogue hint | Pre-dialogue mentions "Shieldbearers block!" | | |

### 8.6 Stage 5: Goliath (Boss Stage)
**Precondition**: Progress to Stage 5
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Boss intro | Pre-dialogue epic narrative with Goliath description | | |
| Guard spawning | Waves of mixed enemies (soldiers, shields, scouts) spawn | | |
| Goliath spawning | Boss appears after guard waves or on timer | | |
| Boss presence | HUD or dialogue confirms fighting Goliath | | |

---

## 9. GOLIATH BOSS FIGHT TESTS

### 9.1 Boss Initialization
**Precondition**: Stage 5, guards defeated or time elapsed
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Boss health | Goliath spawns with 350 HP | | |
| Boss positioning | Boss centered or at arena center | | |
| Boss visibility | Large 64x80 sprite with armor overlay | | |
| Boss label | "GOLIATH" text renders above boss | | |
| Health bar | Wide health bar displays, color: green (100%) | | |

### 9.2 Boss Attack Patterns

#### Phase 1 (100%-60% HP)
**Expected Behavior**: Slow chase + occasional spear throws
**Attack Cooldown**: 2.5s

| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Chase speed | Slow movement toward player at base speed | | |
| Spear throw cooldown | First attack ~2.5s into phase | | |
| Spear trajectory | Spear flies toward player at 350 px/s | | |
| Spear damage | Spear hit deals 20 damage | | |
| Phase duration | Lasts until boss reaches 210 HP (60%) | | |

#### Phase 2 (60%-30% HP)
**Expected Behavior**: Faster movement + adds ground slam
**Attack Cooldown**: 1.8s

| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Movement speed | Boss moves faster toward player | | |
| Slam windup | Growing red cross indicator appears | | |
| Slam area | Circular AoE with 100px radius | | |
| Slam damage | Enemies/player in radius take 25 damage | | |
| Slam indicator | Visual telegraph shows where slam will hit | | |
| Cooldown reduction | Attacks occur every 1.8s (faster than Phase 1) | | |
| HP threshold | Phase ends at 105 HP (30%) | | |

#### Phase 3 (30%-0% HP — Enraged)
**Expected Behavior**: All attacks, faster cooldown, color change to red
**Attack Cooldown**: 1.2s

| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Color change | Boss turns red (enraged visual) | | |
| All attack types | Charges, slams, and throws all available | | |
| Cooldown extreme | Attacks every 1.2s (rapid aggression) | | |
| Difficulty spike | Noticeably harder than Phase 2 | | |
| Death trigger | At 0 HP, boss dies and victory dialogue appears | | |

### 9.3 Boss Movement
**Precondition**: Boss alive in any phase
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Toward player | Boss slowly walks toward player between attacks | | |
| Boundary clamping | Boss stays within arena (with margin) | | |
| Smooth pathfinding | No jittering or erratic movement | | |

### 9.4 Charge Attack
**Precondition**: Boss enters charge state
**Mechanics**: 0.5s windup + 0.8s charge at 3x speed

| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Windup telegraph | Boss flashes (yellow highlight) for 0.5s | | |
| Direction locking | Charge direction set at windup start | | |
| Charge execution | Boss moves at 3x speed for 0.8s | | |
| Charge damage | Collision with player deals 25 damage (or touching) | | |
| Charge collision | Player cannot stop charge; must evade | | |
| Recovery cooldown | Boss re-enters attack selection after charge | | |

### 9.5 Ground Slam Attack
**Precondition**: Phase 2+ boss, close range to player
**Mechanics**: 0.6s windup + 0.3s active slam

| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Windup visual | Growing red cross appears, expanding to 100px radius | | |
| Player warning | Visual is clear enough to evade | | |
| Slam activation | Slam deals 25 damage to all in 100px radius | | |
| Multiple hits | Player takes damage once if in radius | | |
| Flash indicator | Slam area flashes orange during active frame | | |

### 9.6 Spear Throw Attack
**Precondition**: Phase 1+, long range from player
**Mechanics**: 0.4s windup + spear projectile

| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Windup telegraph | Boss flashes yellow | | |
| Spear spawn | Spear appears at boss center | | |
| Spear trajectory | Flies toward player at 350 px/s | | |
| Spear damage | Hit deals 20 damage | | |
| Spear lifetime | Despawns after ~2s (off-screen) | | |
| Multiple spears | Multiple throws create independent projectiles | | |

### 9.7 Boss Death
**Precondition**: Goliath health = 0
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Boss disappears | Sprite no longer renders | | |
| Victory dialogue | Post-fight dialogue triggers | | |
| Victory screen | Transitions to victory screen or credits | | |
| Final score | (If applicable, display final stats) | | |

---

## 10. USER INTERFACE TESTS

### 10.1 HUD Elements
**Precondition**: Game playing
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Player health bar | Above player, updates when damaged | | |
| XP bar | Fills as gems collected, shows progress to level-up | | |
| Level display | Current level visible (e.g., "Lv. 2") | | |
| Weapon icons | 4 weapon slots shown, filled as weapons acquired | | |
| Stage label | "Stage 1/5: The Lion" or similar visible | | |
| All fonts readable | Text size, contrast adequate for 8-16 age group | | |

### 10.2 Fonts & Rendering
**Precondition**: Multiple scenes/UI elements visible
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Font initialization | No crashes during font.init() | | |
| Dialogue text | Large, readable font (14-18pt) | | |
| HUD text | Smaller font for numbers/labels (10-12pt) | | |
| Damage numbers | Float text visible and readable | | |
| Boss label | "GOLIATH" renders clearly above boss | | |
| Color contrast | White text on dark background (good contrast) | | |

### 10.3 Placeholder Graphics Rendering
**Precondition**: All sprites in PlaceholderGraphics
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Player rect | Blue rectangle (32x32) | | |
| Enemy rects | Colors per type (orange=lion, gray=wolf, etc.) | | |
| Projectiles | Small colored squares/circles | | |
| Health bars | Red background, green/yellow/red fill | | |
| No missing textures | No pink/magenta "missing asset" indicators | | |

### 10.4 Title & Game Over Screens
**Precondition**: Game flow from start to death
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Title screen | "David's Ascent" title, "Press SPACE to start" | | |
| Game Over screen | Appears when player health = 0 | | |
| Retry option | "Press SPACE to retry" visible | | |
| Retry functionality | Clicking starts new game from Stage 1 | | |
| Death message | "You have fallen..." or similar | | |

### 10.5 Victory Screen
**Precondition**: All 5 stages completed, Goliath defeated
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Victory message | Epic message (e.g., "The giant has fallen!") | | |
| Stats display | Final level, kills, time survived (if tracked) | | |
| Credits scroll | Acknowledgments to Valthorne, Claude, etc. | | |
| Exit option | "Press SPACE to return to title" or "ESC to quit" | | |

---

## 11. EDGE CASES & CRASH SCENARIOS

### 11.1 Memory & Resource Limits
**Test Cases**:
| Test | Scenario | Expected | Actual | Pass |
|------|----------|----------|--------|------|
| Gem pool exhaustion | Spawn 400+ XP gems simultaneously | Oldest deactivate, no crash | | |
| Projectile overflow | Fire 100+ projectiles at once | Pooled, no crash | | |
| Enemy overflow | Spawn 50+ enemies simultaneously | Rendered correctly, no lag spike | | |
| Damage number pool | Spawn 150 damage numbers | Falls back gracefully, no crash | | |
| Level-up spam | Gain 5+ levels in one frame | Queue handled, no crash | | |

### 11.2 Boundary & Physics Edge Cases
**Test Cases**:
| Test | Scenario | Expected | Actual | Pass |
|------|----------|----------|--------|------|
| Player at corner | Player at (0, 0) moving diagonally | Clamped correctly, not off-screen | | |
| Enemy at edge | Enemy pushed to boundary by knockback | Clamped, stays in play zone | | |
| Projectile off-screen | Projectile exits arena | Despawns after lifetime | | |
| Boss at boundary | Goliath pushed to edge by attacks | Reclamped, continues fight | | |
| Zero distance division | Player and enemy at exact same position | No NaN, handled gracefully | | |

### 11.3 Input Edge Cases
**Test Cases**:
| Test | Scenario | Expected | Actual | Pass |
|------|----------|----------|--------|------|
| Held key overflow | Hold W+A+S+D simultaneously | Normalized diagonal movement | | |
| Rapid key press | Press/release SPACE 10x rapidly | No double-trigger | | |
| No input | Let game run 60s without input | Game continues normally | | |

### 11.4 Balance Configuration Errors
**Test Cases**:
| Test | Scenario | Expected | Actual | Pass |
|------|----------|----------|--------|------|
| Missing balance.properties | File deleted/not in assets | Fallback defaults used | | |
| Corrupted config value | balance.properties has malformed number | Parse exception caught, default used | | |
| Negative config value | speed = -100 | Handled gracefully (no inverted movement) | | |

### 11.5 Dialogue & Scene Transitions
**Test Cases**:
| Test | Scenario | Expected | Actual | Pass |
|------|----------|----------|--------|------|
| Rapid SPACE press | Mash SPACE during dialogue | Dialogue dismisses once | | |
| Scene transition | Moving from TitleScene to PlayingScene | Seamless, no flicker | | |
| Back-to-back scenes | Completing stage 1 immediately goes to stage 2 | No gap or freeze | | |

### 11.6 Weapon & Enemy Interaction
**Test Cases**:
| Test | Scenario | Expected | Actual | Pass |
|------|----------|----------|--------|------|
| No enemies alive | All enemies dead, waiting for next wave | No exceptions, game waits | | |
| Hit cooldown abuse | Rapid projectile hits to same enemy | Hit cooldown (0.1s) prevents spam | | |
| Shield on last enemy | Last enemy is ShieldEnemy in block | Can be damaged, dies normally | | |
| Goliath at 1 HP | Boss near death | Handles low health phase correctly | | |

---

## 12. AUDIO/VISUAL POLISH (If Implemented)

### 12.1 Sound Effects
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Weapon fire sound | Sling fires with audio cue | | |
| Enemy death sound | Enemy dies with audio effect | | |
| Level-up sound | Ascending chime on level-up | | |
| Boss attack sound | Goliath roars during charge/slam | | |

### 12.2 Particle Effects
**Test Cases**:
| Test | Expected | Actual | Pass |
|------|----------|--------|------|
| Enemy death particles | Colored particles burst on death | | |
| Weapon hit flash | Brief flash on enemy hit | | |
| Damage number spawn | Float with fade-out animation | | |

---

## 13. BALANCE & DIFFICULTY TUNING

### 13.1 Player Survivability
**Precondition**: Standard difficulty (no upgrades), Stage 1
**Test Cases**:
| Test | Metric | Expected | Actual | Pass |
|------|--------|----------|--------|------|
| Survival time | Beat wave 1 without damage | 30-45s possible | | |
| Upgrade frequency | Reach Lv2 within 2-3 minutes | Reasonable pacing | | |
| Healing availability | Stone Skin/Resolve upgrades available | Can sustain runs | | |

### 13.2 Enemy Difficulty Curve
**Test Cases**:
| Stage | Waves | Difficulty Trend | Survivable | Notes |
|-------|-------|------------------|-----------|-------|
| 1 | 5 | Gentle ramp-up | Yes | Introduction |
| 2 | 6 | Moderate increase | Yes | Bears are tanky |
| 3 | 6 | Scout dashes challenge | Moderate | Requires skill |
| 4 | 7 | Shield bearers tank | Moderate | Weapon upgrade necessary |
| 5 | 6 + Goliath | Boss fight | Hard | Final challenge |

### 13.3 Weapon Balance
**Test Cases**:
| Weapon | DPS (base) | Expected Role | Actual Performance | Pass |
|--------|------------|----------------|--------------------|------|
| Sling | 8.6 | Starter, reliable | Consistent damage | | |
| Staff | 20 | Melee, close AoE | Good vs groups | | |
| Stones | 11.7 | Spread, area control | Good coverage | | |
| Divine Fire | 40/s | Passive defense ring | Always-on protection | | |

### 13.4 Upgrade Impact
**Test Cases**:
| Upgrade | Impact | Noticeable | Overpowered | Pass |
|---------|--------|-----------|-------------|------|
| Fleet Foot +45 | ~21% speed boost | Yes | No |  |
| Stone Skin +30 | +25% max health | Yes | No | |
| Weapon upgrades | +20-50% stat boost | Yes | No (builds over time) | |

---

## 14. REGRESSION CHECKLIST (Post-Bugfix)

**Use this section after each bug fix to ensure no regressions**:

| Bug ID | Issue | Fix Applied | Test Method | Result | Pass |
|--------|-------|-------------|-------------|--------|------|
| | | | | | |
| | | | | | |

---

## 15. CRITICAL PATH (Smoke Test Flow)

**Run this sequence quickly to verify core functionality**:

```
1. Launch game                               [1 min]
2. Play Stage 1 to completion               [3 min]
3. Pass level-up screen (choose upgrade)    [10 sec]
4. Start Stage 2                             [2 min]
5. Attempt to reach Stage 5                  [5 min]
6. Boss fight intro (brief test)            [2 min]
7. Game Over / Victory screen               [1 min]
   ——————————————————————————————————————————
   Total: ~15 minutes
```

---

## 16. KNOWN ISSUES & LIMITATIONS

**Document any known issues here**:

| ID | Issue | Severity | Status | Workaround |
|----|-------|----------|--------|-----------|
| | | | | |
| | | | | |

---

## 17. TEST ENVIRONMENT

- **Platform**: Windows 11 Pro
- **Java Version**: [Check project config]
- **Build System**: Gradle
- **Engine**: Valthorne 1.3.0
- **Resolution**: 800x600
- **Target FPS**: 60
- **Framerate Monitoring**: (Use JGL performance metrics)

---

## 18. APPROVAL & SIGN-OFF

**Tester**: [QA Agent]
**Date**: 2026-03-22
**Build Tested**: David's Ascent Day 7 MVP
**Test Duration**: [Record actual]
**Pass/Fail**: [ ] PASS  [ ] FAIL
**Blockers**: [List any critical failures]

---

## Sign-Off Checklist

- [ ] Smoke test completed (Section 1)
- [ ] All core systems tested (Sections 2-10)
- [ ] Edge cases explored (Section 11)
- [ ] No critical crashes encountered
- [ ] All 5 stages playable to completion
- [ ] Boss fight is challenging but fair
- [ ] UI is readable for age group 8-16
- [ ] Build is ready for next sprint

