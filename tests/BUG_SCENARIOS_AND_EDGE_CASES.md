# David's Ascent — Bug Scenarios & Edge Case Testing Guide

**Purpose**: Identify common failure modes, crash conditions, and balance exploits
**Target**: QA engineers running stress tests and edge case validation
**Last Updated**: 2026-03-22

---

## 1. CRASH & MEMORY SCENARIOS

### 1.1 Resource Pool Exhaustion (Potential Crashes)

**Scenario 1.1.1: XP Gem Pool Overflow**
- **Trigger**: Spawn more than 400 XP gems simultaneously
- **How**:
  1. Use debug tool (if available) to set `gemPoolSize = 100` temporarily
  2. Defeat 150 enemies in rapid succession (modify WaveSpawner to spawn rapidly)
  3. Observe XP gem pool behavior
- **Expected**: Older gems deactivate gracefully; no crashes
- **Risk**: ArrayIndexOutOfBoundsException if pool manager doesn't check bounds
- **Actual**: [Record result]
- **Severity**: S2 (gameplay impact)

**Scenario 1.1.2: Damage Number Pool Overflow**
- **Trigger**: Damage 150 enemies simultaneously (e.g., 5 Divine Fire rings active)
- **How**:
  1. Equip Divine Fire + Staff + Sling
  2. Spawn 50 enemies at once
  3. Walk through groups triggering multiple simultaneous hits
- **Expected**: Damage number pool gracefully recycles; oldest disappear
- **Risk**: Pool runs out, crashes allocating new DamageNumber objects
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 1.1.3: Projectile Overflow**
- **Trigger**: Fire 200+ projectiles in 5 seconds
- **How**:
  1. Equip Sling + Throwing Stones
  2. Face a large enemy group
  3. Observe projectile count (if visible in debug mode)
- **Expected**: Projectiles despawn after lifetime without exception
- **Risk**: Memory leak if projectiles aren't pooled; eventual crash
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 1.1.4: Enemy Wave Overlap Stress**
- **Trigger**: Multiple waves spawn with zero spacing
- **How**:
  1. Edit StageDatabase to spawn waves at identical times
  2. Run Stage 1 with 5 waves all at t=0
  3. Monitor frame rate and entity count
- **Expected**: 50+ enemies render without crash; frame rate may dip
- **Risk**: Rendering loop crashes if entity list grows unbounded
- **Actual**: [Record result]
- **Severity**: S2

---

### 1.2 Null Pointer & Uninitialized State Crashes

**Scenario 1.2.1: Null Weapon In WeaponSystem**
- **Trigger**: Access weapon that was never acquired
- **How**:
  1. Check if `getWeapon(SlingWeapon.class)` returns null
  2. Call methods on null weapon
- **Expected**: Returns null gracefully; code checks for null before use
- **Risk**: NullPointerException if calling method on null weapon
- **Actual**: [Record result]
- **Severity**: S1

**Scenario 1.2.2: Enemy Update Called on Deceased Enemy**
- **Trigger**: Call update() on enemy after isDead() = true
- **How**:
  1. Take note of enemy reference after it dies
  2. Verify update() returns early (line 18 in Enemy.java: `if (!alive) return;`)
- **Expected**: Early return, no null access
- **Risk**: If alive check missing, access dead state variables
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 1.2.3: Goliath SpearCallback Not Set**
- **Trigger**: Goliath tries to throw spear without callback
- **How**:
  1. Verify PlayingScene sets spear callback (search for `setSpearCallback()`)
  2. If missing, Goliath throws attack at THROW phase with null callback
- **Expected**: Callback always set; spear spawns
- **Risk**: If callback not set, spear throw does nothing (bug, not crash)
- **Actual**: [Record result]
- **Severity**: S3 (no crash, but broken attack)

---

### 1.3 Configuration Loading Errors

**Scenario 1.3.1: Missing balance.properties File**
- **Trigger**: Delete assets/data/balance.properties
- **How**:
  1. Delete or rename balance.properties
  2. Launch game
- **Expected**: BalanceConfig.load() catches IOException, uses defaults
- **Risk**: If exception not caught, game crashes on startup
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 1.3.2: Malformed balance.properties**
- **Trigger**: Edit balance.properties with invalid values
- **How**:
  1. Edit balance.properties: change `player.speed=210` to `player.speed=abc`
  2. Launch game
- **Expected**: NumberFormatException caught, defaults used
- **Risk**: Exception crashes game if not caught
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 1.3.3: Negative Config Values**
- **Trigger**: Set `player.speed=-100` in balance.properties
- **How**:
  1. Edit balance.properties
  2. Launch game, try to move
- **Expected**: Player moves backward (or handled as edge case)
- **Risk**: Unexpected movement behavior
- **Actual**: [Record result]
- **Severity**: S4 (edge case, low impact)

---

## 2. PLAYER INTERACTION EXPLOITS & BUGS

### 2.1 Movement Exploits

**Scenario 2.1.1: Diagonal Speed Advantage (If Not Normalized)**
- **Trigger**: Move diagonally (W+D)
- **How**:
  1. Measure time to cross arena diagonally vs. horizontally
  2. Check if diagonal is faster than single-axis movement
- **Expected**: Same speed (normalized by dividing by sqrt(2))
- **Actual**: [Record result]
- **Severity**: S3 (balance impact)

**Scenario 2.1.2: Off-Screen Player Glitch**
- **Trigger**: Push player outside bounds via enemy knockback
- **How**:
  1. Equip Staff weapon
  2. Have enemy at edge of screen
  3. Staff knockback enemy away
  4. Verify player is never pushed off-screen
- **Expected**: Player clamped to bounds (see Player.handleInput() lines 59-60)
- **Actual**: [Record result]
- **Severity**: S2

---

### 2.2 Health & Damage Exploits

**Scenario 2.2.1: Infinite Health Loop**
- **Trigger**: Rapid heal + max health upgrades
- **How**:
  1. Level up twice, picking Stone Skin (+30 HP) and Shepherd's Resolve (+40 heal)
  2. Take damage
  3. Pick resolve immediately — check if heal is capped to maxHealth
- **Expected**: heal() method caps health to maxHealth (line 107 in Player.java)
- **Actual**: [Record result]
- **Severity**: S3 (balance)

**Scenario 2.2.2: Negative Health Handling**
- **Trigger**: Take massive damage (1000 HP from one hit)
- **How**:
  1. takeDamage(1000) with 120 max health
  2. Check if health = 0 (not -880)
- **Expected**: Health clamped to 0 (line 103 in Player.java: `Math.max(0, ...)`)
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 2.2.3: Zero Damage Taking (Edge Case)**
- **Trigger**: takeDamage(0) or negative damage
- **How**:
  1. Manually call `player.takeDamage(0)`
  2. Verify health unchanged
  3. Call `player.takeDamage(-10)` and verify no healing
- **Expected**: Damage <= 0 has no effect
- **Actual**: [Record result]
- **Severity**: S4

---

## 3. WEAPON SYSTEM EXPLOITS

### 3.1 Fire Rate Exploits

**Scenario 3.1.1: Infinite Ammo / Rapid Fire**
- **Trigger**: Weapon timer not incrementing or resetting incorrectly
- **How**:
  1. Equip Sling weapon
  2. Record projectile count per second
  3. Compare to expected fire rate (1 shot per 1.4s = 0.71 shots/sec)
- **Expected**: ~1 projectile every 1.4 seconds
- **Risk**: If timer always resets, infinite fire
- **Actual**: [Record result]
- **Severity**: S2 (balance-breaking)

**Scenario 3.1.2: Cooldown Underflow (Negative Timer)**
- **Trigger**: Weapon cooldown goes negative
- **How**:
  1. Check weapon implementation (e.g., SlingWeapon.java)
  2. Verify cooldown is clamped or comparison checks `cooldownTimer > 0`
- **Expected**: Cooldown always >= 0
- **Risk**: Negative timer could cause unexpected fire rate
- **Actual**: [Record result]
- **Severity**: S2

### 3.2 Damage & Range Exploits

**Scenario 3.2.1: Range Overflow (Targeting Infinite Distance)**
- **Trigger**: Weapon targets enemy beyond range
- **How**:
  1. Sling weapon has range=260px
  2. Verify enemies at 500px distance are NOT targeted
  3. Check distance calculation for overflow/NaN
- **Expected**: Only enemies within 260px targeted
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 3.2.2: Zero Distance Division (Same Position)**
- **Trigger**: Player and enemy at exact same location
- **How**:
  1. Force player and enemy to (400, 300)
  2. Check if weapon fires without NaN velocity
- **Expected**: Safe division by distance (check d > 1f)
- **Risk**: If division by zero, NaN velocity crashes physics
- **Actual**: [Record result]
- **Severity**: S1

**Scenario 3.2.3: Damage Stacking Overflow**
- **Trigger**: Multiple weapons hit same enemy in same frame
- **How**:
  1. Equip Staff + Sling + Divine Fire
  2. Walk into group of 10 enemies
  3. Check if damage accumulates properly without integer overflow
- **Expected**: Damage = (staff 18) + (sling 12) + (divine fire 10) = 40 per frame
- **Risk**: If no cap, damage could overflow integer
- **Actual**: [Record result]
- **Severity**: S3 (unlikely in Java, but worth checking)

### 3.3 Weapon Slot Exploits

**Scenario 3.3.1: Fifth Weapon Acquisition**
- **Trigger**: Try to add 5th weapon when max = 4
- **How**:
  1. Acquire 4 weapons (Sling + 3 upgrades)
  2. On 5th level-up, select 4th weapon acquisition again
  3. Verify rejection logic (line 19 in WeaponSystem.java: `if (weapons.size() < MAX_WEAPONS)`)
- **Expected**: 5th weapon rejected silently
- **Risk**: If not checked, IndexOutOfBoundsException
- **Actual**: [Record result]
- **Severity**: S2

---

## 4. ENEMY SYSTEM BUGS & EXPLOITS

### 4.1 ChaserEnemy Movement Bugs

**Scenario 4.1.1: Pathfinding Oscillation (Zigzag)**
- **Trigger**: Player moves rapidly
- **How**:
  1. Spawn ChaserEnemy at (100, 300)
  2. Player at (400, 300), moving in circles
  3. Observe if enemy zigzags or takes erratic path
- **Expected**: Smooth direct path to player's current position
- **Risk**: If targeting is off, enemy may oscillate
- **Actual**: [Record result]
- **Severity**: S4

**Scenario 4.1.2: Zero Distance Check (Stuck at Target)**
- **Trigger**: Enemy reaches exact player position
- **How**:
  1. ChaserEnemy at (400.0, 300.0), player at (400.0, 300.0)
  2. Check distance calculation: `if (dist > 1f)` (line 26 in ChaserEnemy.java)
- **Expected**: Enemy stops moving when dist <= 1
- **Actual**: [Record result]
- **Severity**: S4

### 4.2 ShieldEnemy Block Bugs

**Scenario 4.2.1: Damage Reduction Rounding Error**
- **Trigger**: ShieldEnemy blocking, odd damage values
- **How**:
  1. ShieldEnemy blocking, takes 15 damage
  2. 50% reduction: 15 * 0.5 = 7.5, cast to int = 7
  3. Verify actual damage = 7 (not 8 or 6)
- **Expected**: Consistent rounding (integer cast truncates)
- **Actual**: [Record result]
- **Severity**: S4

**Scenario 4.2.2: Block Phase Desync (Timer Reset)**
- **Trigger**: ShieldEnemy block timer doesn't reset properly
- **How**:
  1. Watch ShieldEnemy block/march cycle
  2. Verify durations stay consistent over 5 cycles
- **Expected**: 2.0s march, 1.2s block, repeat
- **Risk**: If timer not reset, enemy could block indefinitely
- **Actual**: [Record result]
- **Severity**: S2

### 4.3 DashEnemy Bugs

**Scenario 4.3.1: Dash Direction Lock Failure**
- **Trigger**: Player moves during DashEnemy windup
- **How**:
  1. DashEnemy enters WINDUP state targeting you at (400, 300)
  2. During 0.4s windup, you move to (200, 300)
  3. Verify dash goes to original direction (not updated)
- **Expected**: Dash direction locked at windup entry (line 88 in DashEnemy.java)
- **Actual**: [Record result]
- **Severity**: S3 (if broken, enemy becomes too predictable)

**Scenario 4.3.2: Dash Speed Multiplier Overflow**
- **Trigger**: Dash speed multiplier chain (3.5x * enemy speed * delta)
- **How**:
  1. DashEnemy base speed = 85 px/s
  2. At 60 FPS, delta = 0.016s
  3. Per frame: 85 * 3.5 * 0.016 = 4.76 px
  4. Verify enemy doesn't teleport (reasonable velocity)
- **Expected**: Smooth dash without clipping
- **Actual**: [Record result]
- **Severity**: S4

### 4.4 General Enemy Bugs

**Scenario 4.4.1: Hit Cooldown Exploit (Machine Gun)**
- **Trigger**: Rapid successive hits to same enemy
- **How**:
  1. Projectile hits ShieldEnemy, trigger cooldown = 0.1s
  2. Fire another projectile at t=0.05s (still in cooldown)
  3. Verify damage NOT applied (takeDamage returns false)
- **Expected**: Line 70 in Enemy.java: `if (hitCooldown > 0) return false;`
- **Actual**: [Record result]
- **Severity**: S2 (balance-critical)

**Scenario 4.4.2: Death State Persistence**
- **Trigger**: Enemy dies but continues to render or damage player
- **How**:
  1. Kill enemy (health = 0)
  2. Verify isDead() = true (line 116 in Player.java)
  3. Verify render() returns early if !alive (line 56 in Enemy.java)
- **Expected**: Dead enemies don't render or collide
- **Risk**: Dead enemy still deals damage to player
- **Actual**: [Record result]
- **Severity**: S1

**Scenario 4.4.3: XP Gem Drop From Boss**
- **Trigger**: Goliath dies
- **How**:
  1. Defeat Goliath
  2. Verify XP gem spawned (350 XP value)
  3. Collect gem and verify level-up calculation
- **Expected**: Goliath drops 100 XP (per StageDatabase)
- **Risk**: If boss death doesn't spawn gem, soft-lock (no XP)
- **Actual**: [Record result]
- **Severity**: S2

---

## 5. XP & LEVELING EXPLOITS

### 5.1 XP Farming

**Scenario 5.1.1: Infinite Level-Up Loop**
- **Trigger**: XP >= 2 level thresholds simultaneously
- **How**:
  1. At Lv3 with 20/45 XP, collect 50 XP (total = 70)
  2. Verify both Lv4 and Lv5 level-ups don't both trigger
  3. Check consumeLevelUp() (line 80-89 in XpSystem.java)
- **Expected**: One level-up per frame; queue second for next frame
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 5.1.2: Gem Magnet Radius Exploit**
- **Trigger**: Pickup radius larger than intended
- **How**:
  1. Set XP gem at (400, 300), player at (430, 300) = 30px away
  2. Verify pickup happens (radius = 30px)
  3. Verify gem at (431, 300) does NOT pickup (31px away)
- **Expected**: Collection exactly at pickupRadius boundary
- **Actual**: [Record result]
- **Severity**: S4

### 5.2 Scale Factor Exploits

**Scenario 5.2.1: XP Scale Factor Overflow**
- **Trigger**: Level up 20+ times (exponential scaling)
- **How**:
  1. XP to Lv2: 18
  2. XP to Lv3: 18 * 1.25 = 22.5 → 22
  3. XP to Lv4: 22 * 1.25 = 27.5 → 27
  4. ...
  5. Continue to Lv20+
  6. Check if values become extremely large (overflow int?)
- **Expected**: Large but manageable (exponential growth)
- **Risk**: If scale factor continues forever, XP requirements become unreachable
- **Actual**: [Record result]
- **Severity**: S3 (late-game issue)

---

## 6. GOLIATH BOSS EXPLOITS

### 6.1 Attack Phase Bugs

**Scenario 6.1.1: Charge Attack Doesn't Trigger**
- **Trigger**: Goliath at 150 HP (Phase 3), should charge
- **How**:
  1. Defeat guards, Goliath spawns
  2. Damage Goliath to 150 HP
  3. Wait for charge attack
  4. Verify isWindingUp() returns true for 0.5s
- **Expected**: Yellow flash, then charge at 3x speed
- **Risk**: If attack never triggers, boss becomes harmless
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 6.1.2: Slam Damage Area Mismatch**
- **Trigger**: Player at edge of slam radius
- **How**:
  1. Goliath at (400, 300), slam radius = 100px
  2. Player at (500, 300) = 100px away
  3. Verify player takes slam damage OR is slightly outside radius
- **Expected**: Slam damages all within 100px
- **Risk**: If radius doesn't match visual, unfair hit
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 6.1.3: Spear Spawn Location**
- **Trigger**: Goliath throws spear from wrong position
- **How**:
  1. Goliath at (400, 300), throws spear
  2. Verify spear spawns at boss center (not offset)
  3. Verify trajectory toward player is smooth
- **Expected**: Spear starts at Goliath center, flies toward player
- **Actual**: [Record result]
- **Severity**: S3

### 6.2 Phase Transition Bugs

**Scenario 6.2.1: Phase Transition at Threshold**
- **Trigger**: Goliath health = exactly 210 HP (60% of 350)
- **How**:
  1. Damage Goliath to 211 HP (Phase 1)
  2. Deal 1 damage to reach 210 HP
  3. Check if phase changes to 2
  4. Verify attack cooldown updates to 1.8s
- **Expected**: `int phase = hpPercent > 0.6f ? 1 : hpPercent > 0.3f ? 2 : 3;` (line 88)
- **Actual**: [Record result]
- **Severity**: S3

**Scenario 6.2.2: Phase 3 Enrage Color Change**
- **Trigger**: Goliath enters Phase 3 (< 105 HP)
- **How**:
  1. Damage Goliath to 104 HP
  2. Verify color changes to red/orange (ENRAGED_COLOR in GoliathBoss.java)
- **Expected**: Visual feedback that boss is enraged
- **Actual**: [Record result]
- **Severity**: S4

### 6.3 Boss Death Bugs

**Scenario 6.3.1: Goliath Double Death**
- **Trigger**: Deal damage after boss is already dead
- **How**:
  1. Defeat Goliath (health = 0)
  2. Weapon still fires at boss position
  3. Verify no exception thrown
- **Expected**: takeDamage() on dead enemy returns false; isAlive() = false
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 6.3.2: Victory Dialogue Not Triggering**
- **Trigger**: Goliath dies but no victory screen appears
- **How**:
  1. Defeat Goliath
  2. Verify PlayingScene detects boss death and triggers victory
  3. Check if post-dialogue appears within 1 second
- **Expected**: Victory dialogue displays
- **Risk**: If not triggered, player stuck in frozen gameplay
- **Actual**: [Record result]
- **Severity**: S1

---

## 7. DIALOGUE & SCENE TRANSITIONS

### 7.1 Dialogue System Bugs

**Scenario 7.1.1: Dialogue Text Corruption**
- **Trigger**: Multi-line dialogue with special characters
- **How**:
  1. Play Stage 1, read all dialogue (includes newlines, quotes)
  2. Verify text renders correctly without overlaps
- **Expected**: Proper word wrapping, readable fonts
- **Actual**: [Record result]
- **Severity**: S3

**Scenario 7.1.2: Rapid Dismiss (SPACE Spam)**
- **Trigger**: Mash SPACE during dialogue
- **How**:
  1. At pre-dialogue, press SPACE 10 times in rapid succession
  2. Verify dialogue dismisses once (not twice)
  3. Verify gameplay doesn't double-trigger
- **Expected**: Only one dismiss per dialogue
- **Risk**: If not debounced, could skip 2 stages
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 7.1.3: Dialogue During Gameplay**
- **Trigger**: Dialogue appears while player is taking damage
- **How**:
  1. During stage playback (not dialogue phase), try to trigger dialogue
  2. Verify player can still move and fight
- **Expected**: Dialogue blocks input OR is not shown during gameplay
- **Actual**: [Record result]
- **Severity**: S2

### 7.2 Scene Transition Bugs

**Scenario 7.2.1: Stage Skip (Back-to-Back Dismiss)**
- **Trigger**: Complete Stage 1, dismiss post-dialogue, start Stage 2 pre-dialogue
- **How**:
  1. Finish Stage 1
  2. Post-dialogue appears
  3. Press SPACE
  4. Verify Stage 2 pre-dialogue appears (not gameplay directly)
- **Expected**: Stage 2 PRE_DIALOGUE, then gameplay after dismiss
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 7.2.2: Victory Screen Loop**
- **Trigger**: Defeat Goliath, reach victory screen
- **How**:
  1. Complete all 5 stages and boss
  2. Verify victory screen appears
  3. Press SPACE to return to title
  4. Verify return to TitleScene
- **Expected**: Smooth transition back to title, game restarts cleanly
- **Actual**: [Record result]
- **Severity**: S2

---

## 8. COLLISION & HITBOX BUGS

### 8.1 Player-Enemy Collision

**Scenario 8.1.1: Enemy Overlap Stacking**
- **Trigger**: Multiple enemies at exact same position
- **How**:
  1. Spawn 5 enemies at (400, 300)
  2. Let them approach player
  3. Verify collision detection doesn't double-count damage
- **Expected**: Each enemy deals damage independently
- **Actual**: [Record result]
- **Severity**: S3

**Scenario 8.1.2: Collision at Screen Edge**
- **Trigger**: Enemy pushed to bounds, then player enters bounds
- **How**:
  1. Enemy at (798, 300) at arena edge
  2. Player at (700, 300)
  3. Player moves toward enemy
  4. Verify collision happens despite boundary
- **Expected**: Collision checks distance, not bounds
- **Actual**: [Record result]
- **Severity**: S4

### 8.2 Projectile Collision

**Scenario 8.2.1: Projectile Passes Through Enemy**
- **Trigger**: Fast projectile skips over enemy due to delta time
- **How**:
  1. At low FPS (simulate 15 FPS, delta = 0.067s)
  2. Fire Sling at nearby enemy
  3. Verify hit detection works despite large delta
- **Expected**: Collision checks account for movement
- **Risk**: If not swept, fast projectiles miss
- **Actual**: [Record result]
- **Severity**: S2

**Scenario 8.2.2: Projectile Self-Collision (Player Hit)**
- **Trigger**: Projectile damages player who fired it
- **How**:
  1. Fire Sling projectile
  2. Verify projectile does NOT damage player
- **Expected**: Projectiles ignore owner
- **Actual**: [Record result]
- **Severity**: S2

---

## 9. BALANCE & DIFFICULTY EXPLOITS

### 9.1 Overpowered Weapon Synergies

**Scenario 9.1.1: Divine Fire + Staff Loop**
- **Trigger**: Equip Divine Fire + Staff, stand in enemy group
- **How**:
  1. Walk into group of 10 enemies
  2. Divine Fire + Staff both deal damage every 0.3s (staff fires every 0.9s, so ~3 procs)
  3. Measure time to clear group
- **Expected**: Reasonable skill-based difficulty
- **Risk**: If too powerful, game becomes trivial
- **Actual**: [Record result]
- **Severity**: S3

**Scenario 9.1.2: Upgrade Stacking (Fleet Foot Loop)**
- **Trigger**: Pick Fleet Foot upgrade 5+ times
- **How**:
  1. At Lv6+, only pick Fleet Foot upgrades
  2. Speed = 210 + (45 * 5) = 435 px/s (2x baseline)
  3. Verify you can kite all enemies forever
- **Expected**: Still killable with weapons
- **Risk**: Speed + distance makes game unwinnable (can't reach player)
- **Actual**: [Record result]
- **Severity**: S3

### 9.2 Underpowered Weapons

**Scenario 9.2.1: Sling Damage at Stage 4**
- **Trigger**: Stage 4 with only Sling, no upgrades
- **How**:
  1. Reach Stage 4 with only Sling (12 damage)
  2. Face Shieldbearers (health = 60-65)
  3. Measure time to kill one (60 / 12 = 5 shots, ~7 seconds)
- **Expected**: Challenging but possible
- **Risk**: If too slow, game feels grindy
- **Actual**: [Record result]
- **Severity**: S3

---

## 10. PERFORMANCE & FRAMERATE

### 10.1 Frame Rate Drops

**Scenario 10.1.1: Wave Spawn FPS Drop**
- **Trigger**: Large wave spawns
- **How**:
  1. Monitor FPS using JGL profiling (if available)
  2. Measure FPS at wave 1 (5 enemies), wave 5 (3 enemies)
  3. Note any frame drops
- **Expected**: Consistent 60 FPS
- **Risk**: FPS drop to 30-40 makes game unplayable
- **Actual**: [Record result]
- **Severity**: S2 (performance)

**Scenario 10.1.2: Boss Fight FPS**
- **Trigger**: Goliath + guards + projectiles + damage numbers
- **How**:
  1. Enter boss fight with full setup (4 weapons, 20+ enemies, spears flying)
  2. Monitor FPS for 30 seconds
- **Expected**: Stable 50+ FPS (60 target, slight dips acceptable)
- **Actual**: [Record result]
- **Severity**: S2

### 10.2 Memory Leaks

**Scenario 10.2.1: Projectile Memory Leak**
- **Trigger**: Play for 10 minutes, fire 1000s of projectiles
- **How**:
  1. Use Java profiler (e.g., JProfiler, YourKit)
  2. Record heap usage every 30 seconds
  3. Verify heap doesn't grow unbounded
- **Expected**: Heap stable (pooled objects reused)
- **Risk**: Unbounded growth → OutOfMemoryException after 30 min
- **Actual**: [Record result]
- **Severity**: S2

---

## 11. AUDIO/VISUAL BUGS (If Applicable)

### 11.1 Sound Effect Issues

**Scenario 11.1.1: Audio Distortion on Rapid Fire**
- **Trigger**: Fire 10 projectiles in 1 second
- **How**:
  1. Equip Throwing Stones (fires 5 stones every 0.6s)
  2. Fire 2 salvos in quick succession
  3. Listen for audio stacking/clipping
- **Expected**: Clear, distinct sounds
- **Actual**: [Record result]
- **Severity**: S4

### 11.2 Visual Bugs

**Scenario 11.2.1: Z-Order Rendering (Layering)**
- **Trigger**: Enemy behind projectile (or vice versa)
- **How**:
  1. Fire projectile that passes in front of enemy
  2. Verify projectile renders in front, enemy behind
- **Expected**: Correct depth order
- **Actual**: [Record result]
- **Severity**: S3

**Scenario 11.2.2: Text Overlap (HUD)**
- **Trigger**: Multiple UI elements compete for space
- **How**:
  1. Level up and check if "Level Up" text overlaps health bar
  2. Check if weapon icons overlap damage numbers
- **Expected**: No overlaps; UI is clean
- **Actual**: [Record result]
- **Severity**: S3

---

## 12. TARGETED STRESS TESTS

### 12.1 Extreme Difficulty Run

**Setup**:
- Spawn 50 enemies simultaneously
- All types mixed (Chasers, Shields, Dashers)
- No weapon upgrades
- No stat upgrades

**Test**:
1. Launch Stage 1 with extreme spawn
2. Survive for 60 seconds
3. Verify no crashes
4. Note framerate and difficulty perception

**Expected**: Game survives; difficult but fair
**Severity**: S2 (stress test)

### 12.2 Ultra-Long Playthrough

**Setup**: Play from Stage 1 through Victory without stopping
**Duration**: ~45 minutes continuous

**Test**:
1. Record any lag spikes
2. Verify no memory leaks
3. Check if dialogue glitches after repeated triggers
4. Note total enemy kills, XP earned, upgrades taken

**Expected**: Stable, no degradation
**Severity**: S2 (endurance)

---

## 13. COMMON BUG SIGNATURES (Quick Lookup)

**Use this section to quickly identify known issues**:

| Bug Name | Signature | Fix Attempt | Status |
|----------|-----------|------------|--------|
| Projectile clip-through | Enemy takes no damage when hit | Use distance-based collision, not position-based | |
| Enemy stuck at wall | Enemy can't reach player | Add push-away from boundaries | |
| Infinite fire loop | Weapon fires constantly | Check cooldown timer > 0 before firing | |
| Dead enemy ghost | Killed enemy still damages player | Check !alive before collision | |
| Dialogue double-dismiss | Skips 2 stages | Debounce SPACE key input | |
| XP overflow | Level-ups stack incorrectly | Queue level-ups, one per frame | |
| Shield damage bypass | Blocking doesn't reduce damage | Cast to int after * 0.5 | |

---

## 14. TEST EXECUTION CHECKLIST

**Before reporting a bug, verify all of the following**:

- [ ] Able to reproduce 100% of the time (or note "intermittent")
- [ ] Tested on target platform (Windows 11 Pro)
- [ ] Latest game build tested
- [ ] BalanceConfig reloaded (no old values cached)
- [ ] No conflicting mods or debug code active
- [ ] Steps to reproduce are clear and minimal
- [ ] Screenshot or video captured (if visual bug)
- [ ] Console/error logs checked for exceptions

---

## 15. BUG REPORT TEMPLATE

For each bug found, use this template:

```
## Bug ID: [Auto-assigned]
- **Title**: [Short, one-line summary]
- **Severity**: S1 (crash) / S2 (broken feature) / S3 (balance/UI issue) / S4 (cosmetic)
- **Frequency**: Always / Often / Sometimes / Rare
- **Build**: [Date/commit]
- **Platform**: Windows 11 Pro

### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Root Cause Analysis
[Technical explanation, if known]

### Fix Suggestion
[If obvious]

### Attachments
[Screenshot, log file, video URL]
```

---

## 16. APPROVAL & TRACKING

- **Scenario Document Owner**: QA Lead
- **Last Updated**: 2026-03-22
- **Next Review**: Post Day-8 implementation
- **Tracked In**: GitHub Issues / Jira (specify)

