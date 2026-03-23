# David's Ascent — Balance Test Cases & Regression Suite

**Purpose**: Verify gameplay balance, progression pacing, and difficulty curves
**Target Audience**: QA engineers, game designers, balance testers
**Last Updated**: 2026-03-22
**Reviewed By**: QA Lead

---

## 1. CORE BALANCE METRICS

### 1.1 Player Survivability Baseline (No Upgrades)

**Setup**: Stage 1, fresh player, Sling weapon only (12 damage, 1.4s fire rate)

| Metric | Target | Actual | Pass | Notes |
|--------|--------|--------|------|-------|
| **Wave 1 Survival** (5 snakes) | 30+ seconds without damage | | | Should learn controls |
| **Health at Wave 2 Start** | ≥ 100 HP (83% remaining) | | | If < 80%, too aggressive |
| **Health at Wave 5 Finish** | ≥ 50 HP (42% remaining) | | | If < 30%, unfair |
| **First Level-Up Time** | 2-3 minutes | | | Progression feels natural |
| **Escape Time** (clear arena of all enemies) | < 5 sec after last kill | | | Gem collection feels smooth |

**Acceptance Criteria**:
- Player can survive all of Stage 1 without upgrades (challenge, not impossible)
- Takes 2-3 level-ups to feel significantly stronger
- No single wave kills player instantly

**Bug Risk**: If Wave 1 kills player, Stage 1 is unpassable for weak players

---

### 1.2 Sling Weapon DPS Check

**Formula**: Damage per second = (Weapon Damage / Fire Rate)

| Weapon State | Fire Rate | Damage | Expected DPS | Actual DPS | Pass |
|--------------|-----------|--------|--------------|------------|------|
| Base Sling | 1.4s | 12 | 8.57 | | |
| +1 Damage Upgrade | 1.4s | 18 | 12.86 | | |
| +1 Fire Rate Upgrade | 0.9s | 12 | 13.33 | | |
| +2 Upgrades (both) | 0.9s | 18 | 20.00 | | |
| Max Upgraded (5 tiers) | 0.4s | 42 | 105.00 | | |

**Acceptance Criteria**:
- Base DPS (~8.57) is weak but functional
- Upgraded DPS scales reasonably over 15+ levels
- No single upgrade path overpowers others

---

### 1.3 Staff Weapon Melee Balance

**Formula**: DPS = (Damage × Proc Rate) where Proc Rate = hits per second

| State | Radius | Damage | Fire Rate | Expected Targets/Proc | Expected DPS | Actual | Pass |
|-------|--------|--------|-----------|----------------------|--------------|--------|------|
| Base | 65px | 18 | 0.9s | 2 enemies | 40 | | |
| Upgraded 1x | 83px | 28 | 0.9s | 3 enemies | 93.3 | | |
| Upgraded 3x | 119px | 48 | 0.9s | 5 enemies | 266.7 | | |

**Acceptance Criteria**:
- Staff is high-damage but requires close proximity (risk/reward)
- Knockback (160+) keeps enemies at distance
- Radius grows but doesn't become screen-covering

**Testing**:
1. Equip Staff only, face 5 enemies in circle
2. Count actual hits per swing (compare to "Expected Targets")
3. Measure time to kill group vs Sling-only run

---

### 1.4 Throwing Stones Spread Shot

| State | Count | Damage | Fire Rate | Expected DPS | Actual | Pass |
|-------|-------|--------|-----------|--------------|--------|------|
| Base | 5 | 14 | 0.6s | 116.7 | | |
| +1 Count | 7 | 14 | 0.6s | 163.3 | | |
| +2 Upgrades | 7 | 19 | 0.3s | 442.3 | | |

**Acceptance Criteria**:
- Base DPS competitive with Sling (higher, but spread pattern)
- Good for crowd control, less focused than Sling
- Fire rate upgrade makes rapid-fire feel noticeable

**Testing**:
1. Face 10 enemies in a line
2. Measure kill time with Throwing Stones vs Sling alone
3. Verify stones fan out in 5-stone cone (not all same direction)

---

### 1.5 Divine Fire Ring Continuous Damage

**Formula**: DPS = Damage × (1 / Damage Interval)

| State | Radius | Damage | Interval | Expected DPS (per enemy) | Actual | Pass |
|-------|--------|--------|----------|--------------------------|--------|------|
| Base | 85px | 10 | 0.25s | 40 | | |
| Upgraded | 107px | 17 | 0.05s | 340 | | |

**Acceptance Criteria**:
- Always-on passive defense (low DPS but consistent)
- Upgraded version becomes powerful area control
- Synergizes with other weapons (doesn't need fire rate)

**Testing**:
1. Equip Divine Fire only, stand in group of 5
2. Time to kill each enemy with ring only
3. Verify damage pulses at expected intervals

---

## 2. ENEMY BALANCE

### 2.1 Enemy Threat Assessment

**Scoring**: Threat Level = (Damage × Speed × Health) / Difficulty Multiplier

| Enemy Type | Health | Speed | Damage | Expected Threat | Actual | Difficulty |
|------------|--------|-------|--------|-----------------|--------|------------|
| Snake (Stage 1) | 20 | 60 | 8 | Trivial | | 1/10 |
| Wolf | 25 | 70 | 10 | Easy | | 2/10 |
| Lion | 40 | 55 | 15 | Moderate | | 4/10 |
| Bear | 70 | 45 | 20 | Hard | | 6/10 |
| Soldier | 40 | 80 | 12 | Moderate-Fast | | 5/10 |
| Scout (Dasher) | 35 | 85 | 12 | Dangerous (unpredictable) | | 7/10 |
| Shielder | 60-65 | 42-85 | 16 | Tanky (50% reduction) | | 6/10 |
| Goliath | 350 | 38 | 25 | Boss | | 9/10 |

**Acceptance Criteria**:
- Early-stage enemies (Snakes, Wolves) don't one-shot player (120 HP)
- Mid-stage enemies require strategy (shields, dashes)
- Boss is challenging but not unfair

**Test Procedure**:
1. Spawn single enemy type with player at 120 HP
2. Let enemy attack 5 times (no player action)
3. Record health after 5 hits
4. Verify player survives (HP > 0)

---

### 2.2 Enemy Spawn Rate vs Difficulty

| Stage | Wave | Enemies | Enemy Type | Spawn Interval | Duration | Expected "Business" |
|-------|------|---------|-----------|----------------|----------|---------------------|
| 1 | 1 | 5 | Snake | 0.8s | 0.8×5 = 4s | Relaxed |
| 1 | 5 | 3 | Lion | 0.8s | 0.8×3 = 2.4s | Intense |
| 3 | 6 | 6 | Scout | 0.3s | 0.3×6 = 1.8s | Very Busy |
| 4 | 7 | 10 | Soldier | 0.2s | 0.2×10 = 2s | Overwhelming |
| 5 | Boss | Varies | All | Variable | ~40s | Relentless |

**Acceptance Criteria**:
- Early stages (1-2) feel manageable with pauses between waves
- Mid stages (3-4) build tension without overwhelming
- Boss stage is constant pressure but not impossible

**Test Procedure**:
1. Play each stage, count time between last enemy death and next wave start
2. Rate subjective difficulty (1-10 scale)
3. Verify curve is upward, not spikey

---

### 2.3 ShieldEnemy Damage Reduction Fairness

**Scenario**: ShieldEnemy with 60 health, blocking state active

| Attack Type | Raw Damage | With Blocking | Expected Shots to Kill | Actual | Notes |
|-------------|-----------|---------------|------------------------|--------|-------|
| Sling (base) | 12 | 6 | 10 shots | | Fair (requires focus) |
| Staff | 18 | 9 | 6-7 sweeps | | Melee can break shield faster |
| Throwing Stones | 14 | 7 | 8-9 stones | | Spread slows kill time |
| Divine Fire | 10/pulse | 5/pulse | 12 pulses (3s) | | Passive acceptable |

**Acceptance Criteria**:
- Shielded enemies are tanky but killable
- Staff (melee) is slightly better against shields (reward for risk)
- Sling can still eventually break them

**Test Procedure**:
1. Spawn ShieldEnemy, let them enter blocking phase
2. Attack with each weapon type
3. Count actual hits to kill vs expected
4. If variance > 20%, rebalance damage or block reduction

---

## 3. PROGRESSION & DIFFICULTY CURVE

### 3.1 Stage Difficulty Ramp

**Metric**: Estimated time for average player to complete stage (with 1-2 leveling pauses)

| Stage | Expected Time | Difficulty Delta | Pacing Notes |
|-------|---------------|------------------|--------------|
| 1: Lion | 5-7 min | +0 (baseline) | Introduction, learn controls |
| 2: Bear | 6-8 min | +1 (harder) | Tanky enemies |
| 3: Scouts | 7-10 min | +2 (much harder) | Dash attacks require skill |
| 4: Army | 8-12 min | +1.5 (hard but manageable) | Shields encourage weapon mixing |
| 5: Goliath | 10-15 min | +3 (boss gauntlet) | Guards + Boss = ultimate test |

**Acceptance Criteria**:
- Each stage noticeably harder than last
- No sudden spike (Stage 2 > Stage 3 should be gradual)
- Boss stage feels climactic but winnable

**Test Procedure**:
1. Fresh run, no replays, pick random upgrades
2. Record time to complete each stage
3. If any stage < expected range or > +20%, flag for rebalancing

---

### 3.2 Level-Up Pacing

**Scenario**: Player collects all XP from killed enemies (no skipped gems)

| Level | XP Required (cumulative) | Est. Enemies Killed | Est. Time | Expected "Milestone" |
|-------|-------------------------|---------------------|-----------|---------------------|
| 1 → 2 | 18 | 4-6 | 30-45s | First power spike |
| 2 → 3 | 18+22=40 | 8-12 | 2 min | Starting to feel strong |
| 3 → 4 | 40+27=67 | 12-18 | 4 min | Mid-game comfy |
| 4 → 5 | 67+34=101 | 18-25 | 6 min | Approaching endgame |
| 5 → 6 | 101+42=143 | 25-35 | 8 min | High level, powerful |

**Acceptance Criteria**:
- Level-ups feel rewarding (noticeable stat increase)
- Not too frequent (breaks gameplay with UI screen)
- Not too rare (player feels stuck)

**Test Procedure**:
1. Play Stage 1, count seconds between level-ups
2. At Lv2, note subjective power increase
3. If first level-up takes > 2 min, XP values are too high

---

### 3.3 Upgrade Choices (Weighted Fairness)

**Scenario**: Play 10 runs, track upgrade frequency

| Upgrade Type | Expected Pick Rate | Actual Pick Rate | Balance Notes |
|--------------|-------------------|------------------|---------------|
| Stat upgrades (Fleet Foot, Stone Skin) | ~30% | | Should be appealing early |
| Weapon attack (new weapon) | ~40% | | Main progression path |
| Weapon enhancement | ~30% | | Upgrades to existing weapons |

**Acceptance Criteria**:
- No single upgrade dominates (> 50% pick rate)
- New weapons spread across levels
- Variety encourages build diversity

**Test Procedure**:
1. Play 5-10 fresh runs
2. Record every upgrade chosen at each level
3. Count frequency per category
4. If any > 50%, reweight UpgradePool randomization

---

## 4. GOLIATH BOSS BALANCE

### 4.1 Boss Health vs. Expected Fight Duration

**Formula**: Expected Duration = (Boss Health / Average DPS) + (Reaction Time × Number of Attacks)

| Scenario | Avg DPS | Expected Duration | Difficulty |
|----------|---------|-------------------|------------|
| Fresh player, Sling only | 8.57 | 40.8 sec | Easy |
| Lv5, Sling + 2 upgrades | 20 | 17.5 sec | Medium |
| Lv10, All 4 weapons upgraded | 80 | 4.4 sec | Hard (risky) |

**Acceptance Criteria**:
- Boss takes 30-60 seconds to kill (reasonable engagement)
- Fresh player can defeat with effort
- Upgraded player defeats quickly (reward for progression)

**Test Procedure**:
1. Enter boss fight with various load-outs
2. Measure actual time to kill
3. Compare to expected
4. If < 10s, boss is underpowered; if > 2 min, overpowered

---

### 4.2 Boss Attack Pattern Difficulty

| Attack | Phase | Danger Level | Expected Player Reaction |
|--------|-------|--------------|------------------------|
| Charge | 1+ | Medium | Dodge to side (0.5s telegraph) |
| Slam | 2+ | High | Keep distance or circle strafe |
| Spear Throw | 1+ | Low | Walk away from projectile path |

**Acceptance Criteria**:
- Each attack is telegraphed (player has time to react)
- Attacks are not instantaneous or unavoidable
- Skilled players can dodge all attacks (0 damage taken)

**Test Procedure**:
1. Stand still and let boss attack (no dodging)
2. Measure expected damage from full attack pattern
3. Test if all attacks can be avoided by moving
4. Verify windup timing is at least 0.4-0.6 seconds

---

### 4.3 Boss Phase Transitions

| Phase | HP Range | Expected Cooldown | Expected Attack Pattern | Difficulty |
|-------|----------|-------------------|----------------------|------------|
| 1 (100-60%) | 350-210 | 2.5s | Slow chase + spear throws | Intro |
| 2 (60-30%) | 210-105 | 1.8s | Medium chase + slam attacks | Intermediate |
| 3 (30-0%) | 105-0 | 1.2s | Enraged: all attacks, fast | Climax |

**Acceptance Criteria**:
- Phase transitions feel like difficulty escalation
- Attacks don't become impossible in Phase 3
- Boss feels progressively more desperate

**Test Procedure**:
1. Reach each phase and measure actual cooldown timing
2. Count attack types used in each phase
3. Verify color change in Phase 3 (visual feedback)

---

## 5. DIFFICULTY PRESETS (If Applicable)

### 5.1 Difficulty Tiers (Suggested Future Feature)

**Current**: Single difficulty (Medium by design)

**Potential Future Tiers**:

| Preset | Player Health | Enemy Health | Fire Rate | Upgrade Frequency |
|--------|--------------|---------------|-----------|------------------|
| Easy | 150 (+25%) | -20% | -0.3s | Every 2 min |
| Normal | 120 (baseline) | 0% | 0 | Every 3 min |
| Hard | 100 (-17%) | +20% | +0.2s | Every 4 min |
| Nightmare | 80 (-33%) | +50% | +0.5s | Every 5+ min |

**Testing**: (Not applicable to current build, but document for future)

---

## 6. BALANCE REGRESSION SUITE

**Use this section after each balance patch to verify no unintended side effects**

### 6.1 Critical Balance Tests

| Test | Description | Expected | Actual | Pass |
|------|-------------|----------|--------|------|
| **Stage 1 Survivability** | Complete Stage 1 with no upgrades | Possible, challenging | | |
| **Sling DPS** | Measure sling damage output vs enemies | 8.57 DPS baseline | | |
| **Staff Knockback** | Enemy pushed away by reasonable distance | 160 units (config) | | |
| **Shield Reduction** | ShieldEnemy takes 50% damage when blocking | Verified | | |
| **XP Scaling** | Level costs scale by 1.25x factor | Lv2=18, Lv3=22.5→22 | | |
| **Boss Health** | Goliath has 350 HP across all phases | Verified | | |
| **Phase 3 Cooldown** | Goliath attacks every 1.2s in Phase 3 | Verified | | |

### 6.2 Post-Patch Testing Workflow

1. **Before Patch**: Record baseline metrics (frame times, kill times, DPS)
2. **Apply Patch**: Deploy config changes or code fixes
3. **Run Tests**: Execute regression suite (critical tests above)
4. **Compare Results**: DPS within 10% tolerance?
5. **Sign-Off**: QA lead approves balance patch

---

## 7. BALANCE TUNING KNOBS (Configuration Parameters)

**Located in**: `assets/data/balance.properties`

### 7.1 Player Tuning

```properties
player.speed=210                    # Pixels per second
player.maxHealth=120               # Starting HP
```

**Impact**: Speed affects survivability (dodge enemy damage); HP affects forgiveness

**Tuning Range**: Speed 150-300 (avoid < 150 as unresponsive, > 300 as OP)

### 7.2 Weapon Tuning

```properties
sling.fireRate=1.4                 # Seconds between shots
sling.damage=12                    # Damage per shot
sling.range=260                    # Pixels (target distance)

staff.fireRate=0.9
staff.damage=18
staff.radius=65                    # Melee sweep radius

stones.fireRate=0.6
stones.damage=14
stones.stoneCount=5

fire.radius=85
fire.damage=10
fire.damageInterval=0.25           # Seconds between pulses
```

**Tuning Strategy**:
- If weapon feels weak: increase damage +1-3 or fireRate -0.1s
- If weapon dominates: decrease damage -1-3 or fireRate +0.1s
- If melee too dangerous: increase radius to reduce need for close range

### 7.3 Upgrade Tuning

```properties
upgrade.sling.damage=6             # +6 damage per upgrade
upgrade.sling.fireRate=0.5         # -0.5s cooldown per upgrade

upgrade.staff.radius=18            # +18px radius per upgrade
upgrade.staff.damage=10            # +10 damage per upgrade

upgrade.stones.count=2             # +2 stones per upgrade
upgrade.stones.damage=5            # +5 damage per upgrade

upgrade.fire.radius=22             # +22px radius per upgrade
upgrade.fire.damage=7              # +7 damage per upgrade
```

**Tuning Strategy**: Ensure each upgrade tier noticeably improves weapon without becoming overpowered

---

## 8. BALANCE AUDIT REPORT TEMPLATE

**After each major test phase, fill this out**:

```
## Balance Audit Report
**Date**: [Date]
**Tester**: [QA Agent]
**Build**: [Version/Commit]

### Metrics Tested
- [ ] Player Survivability (Stage 1, no upgrades)
- [ ] Weapon DPS (baseline + upgrades)
- [ ] Enemy Threat Assessment (health/speed/damage)
- [ ] Progression Pacing (level-up frequency)
- [ ] Boss Difficulty (30-60s engagement expected)
- [ ] Difficulty Curve (ramp smoothness)

### Key Findings
1. [Metric name]: Expected [value], Actual [value] — [Acceptable/Flag]
2. [Metric name]: ...

### Recommendations
- [ ] No changes needed
- [ ] Minor tuning: [Specific value to change]
- [ ] Major rebalance needed: [Which system]

### Approved By
QA Lead: ________  Date: ________
```

---

## 9. REFERENCE: Balance Config Formulas

### 9.1 Player Health Bar Color

```java
if (healthPercent > 0.5f) GREEN;      // > 60 HP
else if (healthPercent > 0.25f) YELLOW; // 30-60 HP
else RED;                              // < 30 HP
```

### 9.2 XP Required (Level-Up)

```
xpToLevel[1] = 18
xpToLevel[n] = floor(xpToLevel[n-1] * 1.25)

Example:
Lv1→2:  18
Lv2→3:  22.5 → 22
Lv3→4:  27.5 → 27
Lv4→5:  33.75 → 33
```

### 9.3 Boss Phase (Based on Health %)

```
hpPercent = health / 350

Phase 1: hpPercent > 0.6  (> 210 HP)
Phase 2: hpPercent > 0.3  (105-210 HP)
Phase 3: hpPercent ≤ 0.3  (0-105 HP)
```

---

## 10. KNOWN BALANCE ISSUES & PATCHES

| Issue | Status | Patch | Notes |
|-------|--------|-------|-------|
| (None recorded yet) | Pending | — | First test run |
| | | | |

---

## 11. SIGN-OFF

- **Balance Tester**: [QA Agent]
- **Date Completed**: 2026-03-22
- **Build Tested**: David's Ascent Day 7 MVP
- **Overall Assessment**: [ ] BALANCED  [ ] NEEDS TUNING  [ ] BROKEN
- **Critical Issues**: [List any S1/S2 severity balance problems]
- **Approved By**: [QA Lead]

