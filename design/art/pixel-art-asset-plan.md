# Pixel Art Asset Plan: David's Ascent

*Created: 2026-03-22*
*Author: Art Director*
*Status: Draft — v1.0*
*Engine: Valthorne 1.3.0 (32x32 sprite base, bottom-left coordinate origin)*

---

## Table of Contents

1. [Art Style Guide](#1-art-style-guide)
2. [Character Sprites](#2-character-sprites)
3. [Enemy Sprites](#3-enemy-sprites)
4. [Projectile and Weapon Sprites](#4-projectile-and-weapon-sprites)
5. [Environment and Tile Sprites](#5-environment-and-tile-sprites)
6. [UI Sprites](#6-ui-sprites)
7. [VFX Sprites](#7-vfx-sprites)
8. [Animation Specifications](#8-animation-specifications)
9. [Asset Naming Convention](#9-asset-naming-convention)
10. [Priority Order](#10-priority-order)

---

## 1. Art Style Guide

### 1.1 Core Visual Identity

**David's Ascent** reads as a warm, hand-crafted biblical fable rendered in pixel art.
The aesthetic draws on ancient Near Eastern visual motifs — sandstone, bronze, ochre,
and linen — filtered through the cheerful accessibility of classic SNES-era sprite work.
Nothing here should feel grim or violent in a way that discomfits a 10-year-old or
their parent. Death is stylized: enemies dissolve into light or tumble cartoonishly.

The game should feel like a beloved children's illustrated Bible — vivid, warm, and
reverent without being stiff or preachy.

**One-line art direction**: "Sun-baked lands of ancient Israel, rendered with SNES warmth
and Sunday school color."

### 1.2 Palette Constraints

All game art uses a single restricted palette. Every sprite, tile, and UI element must
be drawn using colors from this palette only (or a defined subset of it). This ensures
visual unity across all art created by different hands or at different times.

#### Master Palette — "The Holy Land" (32 colors)

| Slot | Hex | Name | Primary Use |
|------|-----|------|-------------|
| 01 | `#1A0A00` | Void Black | Outlines, deepest shadows |
| 02 | `#3D1F00` | Dark Umber | Deep shadow on characters |
| 03 | `#6B3A1F` | Terracotta Shadow | Mid-shadow, ground recesses |
| 04 | `#A05C2C` | Desert Sienna | Skin shadow, rock mid-tone |
| 05 | `#C8843C` | Sandy Brown | Primary skin tone, sand ground |
| 06 | `#E8B46A` | Warm Tan | Skin highlight, pale sand |
| 07 | `#F5D898` | Sunlit Linen | Highest skin highlight, cloth light |
| 08 | `#FFF0C0` | Parchment White | UI text backgrounds, brightest highlights |
| 09 | `#5C3A1A` | Worn Leather | Sling leather, staff dark |
| 10 | `#8C5A28` | Staff Brown | Wood tones, shepherd staff |
| 11 | `#D4A050` | Straw Gold | Dry grass, robe patterns |
| 12 | `#F0C840` | Harvest Yellow | XP gems, divine glow accents |
| 13 | `#B87820` | Aged Brass | Bronze armor mid-tone |
| 14 | `#E8A820` | Polished Bronze | Armor highlights, Goliath's gear |
| 15 | `#6B4020` | Rough Flax | David's robe shadow |
| 16 | `#B08040` | Flax Weave | David's robe mid-tone |
| 17 | `#D4B878` | Bleached Linen | David's robe highlight |
| 18 | `#2A4A1A` | Deep Olive | Dark foliage, shrub shadow |
| 19 | `#4A7A2A` | Meadow Green | Foliage, grass areas |
| 20 | `#80B040` | Sage Light | Foliage highlight |
| 21 | `#A8C870` | Pale Sage | Brightest foliage, sparse highland grass |
| 22 | `#1A3050` | Night Blue | Sky darks, water shadow (Stage 1 night) |
| 23 | `#2860A0` | Sky Blue | Midday sky, divine projectile core |
| 24 | `#60A0D8` | Pale Sky | Horizon sky, light divine glow |
| 25 | `#A0C8F0` | Heaven Haze | Background sky wash |
| 26 | `#6A3040` | Blood Shadow | Enemy hit flash shadow |
| 27 | `#C04040` | Danger Red | Enemy hit flash, health bar low |
| 28 | `#F06060` | Bright Red | Hurt VFX accent |
| 29 | `#204020` | Forest Dark | Dense woodland (Stage 2) |
| 30 | `#F0F0F0` | Stone White | Rock highlights, scroll UI |
| 31 | `#B0B0B0` | Slate Grey | Philistine stone, shadow rocks |
| 32 | `#FFFFFF` | Pure White | Sparkle highlights, divine flash center |

#### Palette Usage Rules

- **Maximum colors per sprite**: 12 (including transparency/outline)
- **Outline rule**: All characters and enemies use `#1A0A00` (Void Black) outlines,
  1 pixel wide. Environment tiles use outlines only on edges that face the player;
  interior tiling has no outline.
- **Transparency**: Index 0 (fully transparent). Never use near-transparent pixels;
  pixels are either fully opaque or fully transparent.
- **No dithering**: Clean, flat color fills with a maximum of 2-3 shading steps.
  Dithering is not appropriate for the clean, readable style at 32x32 resolution.
- **No gradients**: All shading is done with flat palette swaps, not gradients.

### 1.3 Outline Style

- **Style**: Hard pixel outline (1 pixel), solid `#1A0A00`
- **Method**: Outline wraps the exterior of the sprite. No inner outlines except
  to separate major body regions (e.g., belt from robe).
- **Enemies**: Same outline style as player for consistency.
- **Projectiles and VFX**: No outline. VFX are glow-based — bright center, stepping
  out to transparent via 2-3 palette colors.
- **UI elements**: Outline in `#3D1F00` (Dark Umber), 1 pixel. Softer than character
  outlines to create visual separation between gameplay layer and UI layer.

### 1.4 Shading Approach

- **Style**: Flat cel shading — 3 tones maximum per color region (shadow, mid, highlight).
- **Light source**: Overhead-angled light from upper-left at roughly 10 o'clock.
  This is consistent across all sprites, tiles, and UI.
- **Shadow placement**: Shadow falls to the lower-right of forms.
- **Specular**: Single 1-pixel white (`#FFFFFF`) specular dot on shiny surfaces
  (bronze armor, sling stone). Never larger than 2x2 pixels.
- **Skin tones**: David is "ruddy" per 1 Samuel 16:12 — warm reddish-brown skin,
  not pale. Use `#C8843C` as David's base skin tone.

### 1.5 Proportions and Pixel Density

- **Base sprite size**: 32x32 pixels for all characters and enemies (standard unit).
- **Goliath exception**: 48x64 pixels — approximately 2x tall to convey his enormous
  stature. This is the only exception to the 32x32 rule for characters.
- **Pixel density**: 1 pixel = 1 game unit at native resolution. No sub-pixel positioning.
- **Anatomy style**: Slightly chibi — heads are proportionally large (roughly 1/3 of
  total height), bodies compact. This reads well at small sizes and suits the youth
  audience. Reference: classic Zelda: A Link to the Past overworld sprites.
- **Character heads**: Occupy roughly 10x10 pixels of the 32x32 canvas.

### 1.6 Animation Philosophy

- **Frame economy**: Use the minimum frames to read clearly. A 4-frame walk cycle
  reads fine at 32x32. Do not over-animate for the jam scope.
- **Hold frames**: Use longer hold on key poses (attack impact, hurt) for punch.
- **Squash and stretch**: Subtle 1-pixel squash/stretch on jumps and attacks.
  Do not over-exaggerate — keep readable at small sizes.

### 1.7 Violence and Content Guidelines

This game targets ages 8-16 and church youth audiences. All art must comply:

- **No blood**: Death effects use light bursts, dissolve sparkles, or a simple
  tumble-and-disappear animation. No red splatter.
- **No gore**: Goliath's death is a dramatic fall — he collapses facedown
  (matching the scripture "fell facedown") in a cloud of dust and divine light.
- **Enemy death**: Small enemies pop into a brief sparkle/dust cloud and vanish.
  Philistine soldiers tumble and dissolve. Nothing lingers grotesquely.
- **Weapons**: The sling is clearly a sling. Staff is a shepherd's crook. Nothing
  resembles modern weaponry. Avoid anything that reads as gratuitous.

---

## 2. Character Sprites

### 2.1 David (Player Character)

**Biblical basis**: Youngest son of Jesse. Shepherd boy. "Ruddy, with fine appearance"
(1 Sam 16:12). Anointed by Samuel. Ran toward Goliath.

**Visual description**:
- Young boy, roughly 14-16 years old in appearance (relatable to the target audience)
- Warm reddish-brown skin (`#C8843C` base)
- Simple shepherd's linen robe — off-white/flax tones with a leather belt
- Sandals (simple brown straps visible at base)
- Sling hanging from belt or held in hand depending on state
- Shepherd's bag (pouch) on his hip
- Short dark hair, visible under no headwear — David explicitly refused Saul's armor
- Small and slight — visually smaller than all enemy units to communicate "underdog"

**Canvas size**: 32x32 pixels

**Animations required**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `char_david_idle` | 4 frames | Gentle breathing bob, 1px up/down on frames 2-3 |
| Walk | `char_david_walk` | 4 frames | Side-to-side arm swing; single direction (see below) |
| Hurt | `char_david_hurt` | 2 frames | Flinch backward 1-2px, flash white frame 1 |
| Death | `char_david_death` | 6 frames | Falls to knees, then fades to white — NOT a gory fall |

**Direction handling**: David is a top-down character in a bullet heaven. Primary
sprite faces the player (front-facing, slight 3/4 view toward upper-left). Walk
animation uses this same sprite; movement direction is conveyed by sprite mirroring
in code (left = horizontally flipped). No 4-directional sprite set needed.

**Hurt flash**: The engine should flash the sprite white (replace palette) for 2
frames on hit. The `char_david_hurt` animation handles the pose change; the white
flash is a render-layer effect, not a separate sprite.

**Existing asset**: `assets/sprites/david.png` and `david.aseprite` already exist.
Review these against the style guide before creating additional frames. If the
existing sprite matches the palette and proportion guidelines, use it as the
idle/walk base.

---

### 2.2 Goliath (Final Boss)

**Biblical basis**: Champion of Gath. ~9 feet 9 inches tall. Bronze helmet, scale
armor (125 lbs), bronze greaves, javelin on back, enormous spear. Shield-bearer
walked ahead of him. (1 Sam 17:4-7)

**Visual description**:
- Massive warrior — visually imposing, takes up a large portion of screen
- Bronze scale armor covering torso (tiled scale pattern, `#B87820` / `#E8A820`)
- Bronze helmet with plume or crest
- Enormous spear held in right hand, shaft as thick as a weaver's beam
- Bronze greaves on legs
- Philistine-style armor (distinct from Israelite design — more ornate, metallic)
- Skin: darker Mediterranean olive tone
- Expression: contemptuous, mockingly confident

**Canvas size**: 48x64 pixels (exception to 32x32 standard — Goliath must tower)

**Animations required**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `char_goliath_idle` | 4 frames | Slow, weighty breathing; armor shifts |
| Walk | `char_goliath_walk` | 4 frames | Heavy stomp cadence, slight screen shake implied |
| Attack Stomp | `char_goliath_attack_stomp` | 6 frames | Raises spear, slams ground — shockwave origin |
| Attack Throw | `char_goliath_attack_throw` | 6 frames | Wind-up, release, follow-through |
| Hurt | `char_goliath_hurt` | 3 frames | Minimal flinch — Goliath barely reacts until low HP |
| Death | `char_goliath_death` | 8 frames | Staggers, clutches forehead, falls facedown — the climax moment |

**Special visual states**:
- **Phase 2** (below 50% HP): Armor shows visible cracks (`#3D1F00` lines appear on
  bronze), expression shifts from contemptuous to enraged. This is achieved with a
  separate sprite sheet variant, not a shader.
- **Death fall**: Must visually convey "facedown" per scripture. The sprite should
  rotate/fall and the final frame shows him prone.

---

## 3. Enemy Sprites

All enemies use 32x32 canvas unless noted. All share the same outline standard as
David (`#1A0A00`, 1px). Enemy palette is a subset of the master palette.

### Stage 1 Enemies — The Lion (Wilderness / Pasture)

---

#### 3.1 Lion

**Biblical basis**: David killed a lion that attacked his flock (1 Sam 17:34-35).

**Visual description**:
- Stocky, four-legged big cat silhouette
- Sandy tawny coat (`#C8843C` / `#E8B46A`), darker mane on adult variants
- Visible teeth in snarling attack pose
- Tail raised and curved — signals aggression
- Paws oversized for readability at small resolution

**Canvas size**: 32x32

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_lion_idle` | 2 frames | Subtle tail sway |
| Walk | `enemy_lion_walk` | 4 frames | Prowling low-body gait |
| Attack | `enemy_lion_attack` | 4 frames | Pounce lunge toward player |
| Hurt | `enemy_lion_hurt` | 2 frames | Rears back, flash |
| Death | `enemy_lion_death` | 4 frames | Tumbles, sparkle dissolve |

---

#### 3.2 Wolf

**Visual description**:
- Leaner than the lion, greyer coat (`#B0B0B0` / `#818181`)
- Hunched, low-running posture — fast and aggressive
- Pointed ears, narrow snout
- Travels in packs — sprites will be many on screen simultaneously, so silhouette
  must read clearly even when overlapping

**Canvas size**: 32x32

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_wolf_idle` | 2 frames | Ears flick |
| Walk | `enemy_wolf_walk` | 4 frames | Fast trot — legs cycle quickly |
| Hurt | `enemy_wolf_hurt` | 2 frames | Flinch flash |
| Death | `enemy_wolf_death` | 4 frames | Collapse and sparkle |

*(No separate attack animation — wolf attack is contact-based, handled by
proximity. Walk animation plays through contact.)*

---

#### 3.3 Snake

**Visual description**:
- Sinuous S-curve body, moves by gliding/undulating
- Desert coloring: `#A05C2C` base with `#D4A050` diamond pattern on back
- Forked tongue, visible on idle frames
- Smallest enemy in the game — reads as a nuisance enemy rather than a threat

**Canvas size**: 32x32 (body fits within canvas in S-curve pose)

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_snake_idle` | 3 frames | Tongue flicks in and out |
| Move | `enemy_snake_move` | 4 frames | Undulating S-curve progression |
| Hurt | `enemy_snake_hurt` | 2 frames | Recoil, flash |
| Death | `enemy_snake_death` | 3 frames | Coils and dissolves |

---

### Stage 2 Enemies — The Bear (Rocky Hills)

---

#### 3.4 Bear

**Biblical basis**: David also killed a bear (1 Sam 17:34-35).

**Visual description**:
- Large, heavy-set — the bulkiest regular enemy in the game
- Dark brown (`#3D1F00` / `#6B3A1F`) shaggy coat with lighter muzzle area
- Bipedal when attacking (rears up on hind legs), quadrupedal when moving
- Claws visible and prominent

**Canvas size**: 32x32 (fits tightly — the sprite should feel cramped in the canvas,
conveying bulk)

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_bear_idle` | 3 frames | Slow sway, sniffing motion |
| Walk | `enemy_bear_walk` | 4 frames | Slow, lumbering gait |
| Attack | `enemy_bear_attack` | 5 frames | Rears up on hind legs, swipes downward |
| Hurt | `enemy_bear_hurt` | 2 frames | Flinch, roar pose |
| Death | `enemy_bear_death` | 5 frames | Staggers, falls sideways, dissolves |

---

#### 3.5 Wild Boar

**Visual description**:
- Medium-sized pig-type creature, grey-brown bristly fur
- Prominent tusks
- Low to the ground, charges in straight lines
- Serves as the "dasher" enemy archetype — builds then charges

**Canvas size**: 32x32

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_boar_idle` | 2 frames | Snorts, ground-sniffing |
| Walk | `enemy_boar_walk` | 4 frames | Normal trot |
| Charge | `enemy_boar_charge` | 4 frames | Low speed, legs blur, sparks at hooves |
| Hurt | `enemy_boar_hurt` | 2 frames | Flash |
| Death | `enemy_boar_death` | 4 frames | Tumble and dissolve |

---

### Stage 3 Enemies — The Scouts (Philistine Border)

---

#### 3.6 Philistine Scout

**Visual description**:
- Lightly armored human enemy — leather jerkin, simple bronze cap helmet
- Philistine visual identity: Feathered headdress (the Sea Peoples' characteristic
  feature, historically documented) — even a small fan of feathers on the helmet
  distinguishes them from Israelites immediately
- Medium skin tone, dark eyes, athletic build
- Carries a short javelin or spear (held, not thrown — melee contact enemy)
- Philistine palette draws on slate grey and bronze to contrast with David's warm
  earth tones

**Canvas size**: 32x32

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_scout_idle` | 3 frames | Shield taps, looks around |
| Walk | `enemy_scout_walk` | 4 frames | Alert, crouched run |
| Attack | `enemy_scout_attack` | 4 frames | Jab with short spear |
| Hurt | `enemy_scout_hurt` | 2 frames | Staggers |
| Death | `enemy_scout_death` | 4 frames | Tumbles, sparkle dissolve |

---

#### 3.7 Philistine Archer

**Visual description**:
- Similar Philistine aesthetic to Scout but no shield — holds a short bow
- Lighter armor, more visible tunic
- Positioned to shoot ranged projectiles at player
- Distinctive: stays at range, attempts to maintain distance

**Canvas size**: 32x32

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_archer_idle` | 3 frames | Bow at ready, eyes the player |
| Walk | `enemy_archer_walk` | 4 frames | Backs away while watching |
| Attack Draw | `enemy_archer_attack` | 5 frames | Draw → hold → release |
| Hurt | `enemy_archer_hurt` | 2 frames | Drops bow briefly, staggers |
| Death | `enemy_archer_death` | 4 frames | Falls and dissolves |

---

### Stage 4 Enemies — The Army (Battlefield)

---

#### 3.8 Philistine Soldier

**Visual description**:
- Heavier armor than the Scout — bronze breastplate, full helmet with Philistine
  feathered crest
- Carries round shield and long spear
- Physically imposing — conveys "professional soldier" vs David's shepherd

**Canvas size**: 32x32

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_soldier_idle` | 3 frames | Shield held, weight shifts |
| Walk | `enemy_soldier_walk` | 4 frames | Disciplined march |
| Attack | `enemy_soldier_attack` | 5 frames | Shield bash + spear thrust combo |
| Hurt | `enemy_soldier_hurt` | 2 frames | Staggers back |
| Death | `enemy_soldier_death` | 4 frames | Collapse and dissolve |

---

#### 3.9 Philistine Shieldbearer

**Biblical basis**: Goliath had a personal shield-bearer (1 Sam 17:7, 17:41).
In the army stage, shieldbearers appear as a distinct enemy type.

**Visual description**:
- Visually the most armored regular enemy — nearly full-body shield (rectangular,
  painted with a Philistine emblem — a simple stylized ship or bird symbol)
- Slow but extremely durable (high HP enemy archetype)
- Shield faces the player, making it hard to hit — a gameplay-readable visual
- Thick leather and bronze layering

**Canvas size**: 32x32

**Special visual state**: When at low HP, cracks appear on shield sprite (alternate
low-HP sprite sheet row).

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Idle | `enemy_shieldbearer_idle` | 2 frames | Minimal — stoic, planted |
| Walk | `enemy_shieldbearer_walk` | 4 frames | Slow, shield-forward approach |
| Attack | `enemy_shieldbearer_attack` | 4 frames | Shield slam — short range, high knockback |
| Hurt | `enemy_shieldbearer_hurt` | 2 frames | Barely reacts |
| Death | `enemy_shieldbearer_death` | 5 frames | Shield falls first, then soldier collapses |
| Hurt (Low HP) | `enemy_shieldbearer_hurt_damaged` | 2 frames | Cracked shield variant |

---

#### 3.10 War Chariot

**Visual description**:
- Two-horse chariot with a Philistine soldier driver
- The sprite represents the whole unit (horses + chariot + driver) as one entity
- Horses: dark bay color (`#3D1F00` base) with bronze chariot hardware
- Moves in a fixed horizontal or vertical direction across the arena — not a
  homing enemy. Functions as a lane-clearing hazard.
- Larger than standard enemies — this is the "elite" Stage 4 enemy

**Canvas size**: 48x32 (wider than tall — the chariot extends horizontally)

**Animations**:

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| Move | `enemy_chariot_move` | 4 frames | Wheel rotation, horse legs cycle |
| Hurt | `enemy_chariot_hurt` | 2 frames | Flash — chariot wobbles |
| Death | `enemy_chariot_death` | 6 frames | Wheel breaks, chariot tips, dissolves in dust |

---

### Stage 5 Enemies — Goliath Fight

---

#### 3.11 Goliath's Shield-Bearer (Stage 5 Minion)

**Biblical basis**: Directly from 1 Sam 17:41 — "his shield-bearer went ahead of him."

**Visual description**:
- Smaller soldier than Goliath but more ornate armor than Stage 4 shieldbearers —
  he is Goliath's personal attendant
- Embossed shield with a Philistine sunburst design
- Serves as a bodyguard mini-enemy during the Goliath boss fight

**Canvas size**: 32x32

**Animations**: Reuse `enemy_shieldbearer` animations with a distinct color variant
(richer bronze palette). Palettefile suffix: `_elite`.

---

## 4. Projectile and Weapon Sprites

Projectiles are small and fast. At 32x32 character scale, projectiles range from
8x8 to 16x16. They must read instantly — the player needs to understand what is
incoming or outgoing at a glance.

### 4.1 Sling Stone (David's starter weapon)

**Biblical basis**: "Five smooth stones from the stream" (1 Sam 17:40).

**Visual description**:
- Small, rounded river stone — warm grey with light specular dot
- In flight: slight motion blur trail (1-2 pixels of lighter color behind it)

**Canvas size**: 8x8

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| In flight | `proj_slingstone_fly` | 2 frames | Alternates between two rotation positions, simulating spin |

**Upgrade variants**:
- **Multi-shot / Homing**: Same base sprite, add `#F0C840` (Harvest Yellow) glow
  aura — 1 pixel ring around the stone. File: `proj_slingstone_fly_divine`

---

### 4.2 Shepherd's Staff (Melee sweep weapon)

The staff itself is not a projectile — it is a melee swing VFX (see Section 7).
The weapon icon is needed for the HUD and upgrade cards.

**Canvas size**: 16x16 (icon only — used in UI, not gameplay layer)

| Sprite | File Slug | Notes |
|--------|-----------|-------|
| Icon | `ui_icon_weapon_staff` | Shepherd's crook shape, warm wood tones |

---

### 4.3 Throwing Stone (Spread shot — Stage 3+)

**Visual description**:
- Slightly larger and more jagged than the sling stone — a raw rock, not a smooth
  river stone
- Dark grey (`#B0B0B0` / `#818181`) with rough, angular silhouette

**Canvas size**: 8x8

| Animation | File Slug | Frames | Notes |
|-----------|-----------|--------|-------|
| In flight | `proj_throwstone_fly` | 2 frames | Tumbling spin rotation |

---

### 4.4 Divine Fire (Area of effect — Stage 4+)

**Visual description**:
- A descending column of golden-white fire from above, or a circular burst
- Core: `#FFFFFF` → `#F0C840` → `#E8A820` → transparent
- Visually distinct from any enemy projectile — enemies never use gold/white fire

**Canvas size**: 32x32 for the burst effect (see VFX section)

| Sprite | File Slug | Notes |
|--------|-----------|-------|
| Icon | `ui_icon_weapon_divinefire` | Stylized flame in gold/white |

---

### 4.5 Enemy Projectiles

Enemy projectiles must be visually distinct from player projectiles. Player
projectiles are warm (earth tones, gold). Enemy projectiles are cool (slate grey,
dark bronze).

| Projectile | File Slug | Canvas | Frames | Description |
|------------|-----------|--------|--------|-------------|
| Archer arrow | `proj_arrow_fly` | 16x8 | 1 | Long thin horizontal sprite, arrowhead visible |
| Goliath javelin | `proj_javelin_fly` | 32x8 | 2 | Larger than arrow, bronze tip, slight wobble in flight |

---

## 5. Environment and Tile Sprites

Tile size: 32x32. All tiles are designed to tile seamlessly (left/right/up/down
edge pixels must match adjacent tile edges). The game is a top-down survivor-like;
the ground tiles form the play arena floor.

### 5.1 Stage 1 — The Lion (Wilderness / Pasture)

**Setting**: Open grassy pasture land, patches of dry earth, scattered rocks.
Warm midday light. Israel's hill country.

**Palette notes**: Greens (`#4A7A2A`, `#80B040`) for grass; `#C8843C` / `#A05C2C`
for earth patches; `#B0B0B0` / `#F0F0F0` for limestone rocks.

**Required tiles**:

| Tile | File Slug | Notes |
|------|-----------|-------|
| Grass (plain) | `env_tile_grass_plain` | Primary ground tile, repeats heavily |
| Grass (variation A) | `env_tile_grass_vara` | Small wildflower or darker patch |
| Grass (variation B) | `env_tile_grass_varb` | Thin dry grass patch |
| Dry earth | `env_tile_earth_dry` | Sandy/ochre ground for open areas |
| Rock (small) | `env_tile_rock_small` | Decorative obstacle, non-blocking |
| Rock (large) | `env_tile_rock_large` | Blocking obstacle tile |
| Bush (small) | `env_tile_bush_small` | Decorative scrub brush |
| Flock sheep | `env_deco_sheep` | Background decoration, non-interactive |

---

### 5.2 Stage 2 — The Bear (Rocky Hills)

**Setting**: Hillier terrain, more rock and less grass. Darker, shadier — the hills
are more forested. Morning light with longer shadows.

**Palette notes**: More `#29401A` (Forest Dark) and `#3D1F00` (Dark Umber) shadows.
Rocky outcroppings prominent.

**Required tiles**:

| Tile | File Slug | Notes |
|------|-----------|-------|
| Rocky earth | `env_tile_rockyearth_plain` | Darker ground base |
| Rock face | `env_tile_rockface_light` | Light grey rock surface |
| Rock face (dark) | `env_tile_rockface_dark` | Shadow-side rock face |
| Dense bush | `env_tile_bush_dense` | Thicker foliage than Stage 1 |
| Cave entrance | `env_tile_cave_entrance` | Decorative — bear lair visual |
| Cliff edge | `env_tile_cliff_edge` | Arena border tile, darker |

---

### 5.3 Stage 3 — The Scouts (Philistine Border)

**Setting**: Transition zone between Israelite hill country and Philistine flatlands.
Drier, more arid. Military camp elements at the edges.

**Required tiles**:

| Tile | File Slug | Notes |
|------|-----------|-------|
| Dusty ground | `env_tile_dust_plain` | Arid flat ground |
| Dusty ground (worn path) | `env_tile_dust_path` | More worn, patrol routes |
| Philistine banner post | `env_deco_banner_philistine` | Decorative post with cloth banner |
| Campfire | `env_deco_campfire` | 2-frame animation: flame flicker |
| Scattered supply crates | `env_deco_crates` | Decorative military camp debris |
| Olive tree | `env_tile_olivetree` | Biblical Near East landmark tree |

---

### 5.4 Stage 4 — The Army (Battlefield)

**Setting**: Open battlefield, Valley of Elah. Two armies have clashed. Dramatic.

**Required tiles**:

| Tile | File Slug | Notes |
|------|-----------|-------|
| Battlefield earth | `env_tile_battlefield_plain` | Churned, battle-worn ground |
| Battlefield (blood-free torn earth) | `env_tile_battlefield_torn` | Disrupted soil — no blood |
| Discarded shield | `env_deco_shield_dropped` | Decorative defeat indicator |
| Broken spear | `env_deco_spear_broken` | Decorative |
| Israelite banner | `env_deco_banner_israel` | Israelite faction color (blue/white) |
| Valley stream | `env_tile_stream_water` | The brook where David chose his stones |
| Stream edge | `env_tile_stream_edge` | Transition tile |

---

### 5.5 Stage 5 — Goliath (Valley of Elah — Boss Arena)

**Setting**: The most dramatic stage. The Valley of Elah floor, with the two
opposing hillsides implied by the arena borders. The sky backdrop should feel
larger and more epic.

**Required tiles**:

| Tile | File Slug | Notes |
|------|-----------|-------|
| Valley floor | `env_tile_valley_floor` | Base arena tile |
| Valley floor (stone river bed) | `env_tile_valley_riverbed` | The brook of 1 Sam 17:40 |
| Mountain base edge | `env_tile_mountain_edge` | Arena border suggestion of hillsides |
| Goliath footprint | `env_deco_goliath_footprint` | Decorative — large boot print in earth |

---

## 6. UI Sprites

UI sprites sit above the gameplay layer. They use the same master palette but are
designed to read against any background color. Outlines on UI elements use
`#3D1F00` (Dark Umber) to feel warmer than gameplay outlines.

### 6.1 HUD Elements

| Sprite | File Slug | Canvas | Notes |
|--------|-----------|--------|-------|
| Health orb (full) | `ui_health_orb_full` | 16x16 | Warm golden glow, filled center |
| Health orb (empty) | `ui_health_orb_empty` | 16x16 | Greyed out, cracked appearance |
| Health orb (half) | `ui_health_orb_half` | 16x16 | Half-filled |
| XP bar fill | `ui_xpbar_fill` | 8x8 tile | Repeating fill for XP bar |
| XP bar bg | `ui_xpbar_bg` | 8x8 tile | Empty bar background |
| XP bar end caps | `ui_xpbar_caps` | 16x8 | Left and right end caps |
| Level number | Using `PressStart2P.ttf` | — | Existing font asset |
| Weapon slot frame | `ui_weaponslot_frame` | 40x40 | Border frame for weapon icon in HUD |
| Weapon slot empty | `ui_weaponslot_empty` | 32x32 | Empty slot fill |
| Boss health bar frame | `ui_bossbar_frame` | 256x20 | Ornate border for Goliath HP |
| Boss health bar fill | `ui_bossbar_fill` | 8x16 tile | Repeating fill — red/bronze gradient implied by palette steps |
| Boss health bar bg | `ui_bossbar_bg` | 8x16 tile | Empty bar background |

---

### 6.2 XP Gems

XP gems are the primary collection item dropped by enemies. They must be
immediately readable as "collect me" and feel rewarding to gather.

| Sprite | File Slug | Canvas | Notes |
|--------|-----------|--------|-------|
| Gem (small) | `ui_xpgem_small` | 8x8 | Warm yellow-gold, simple diamond shape, 2-frame sparkle |
| Gem (medium) | `ui_xpgem_medium` | 12x12 | Larger — dropped by tougher enemies |
| Gem (large) | `ui_xpgem_large` | 16x16 | Boss drop — visually more elaborate |

**Gem animation**: 2-frame sparkle loop. Frame 1: base gem color. Frame 2: specular
dot shifts, slight brightness increase. Conveys "I am here, collect me."

---

### 6.3 Upgrade Card UI

Upgrade cards appear during level-up selection. Three cards are shown simultaneously.
Each card needs a consistent frame, icon, and is populated with text from the font.

| Sprite | File Slug | Canvas | Notes |
|--------|-----------|--------|-------|
| Card frame (normal) | `ui_card_frame_normal` | 80x120 | Nine-patch compatible; parchment texture |
| Card frame (hover) | `ui_card_frame_hover` | 80x120 | Same frame with golden edge highlight |
| Card frame (new weapon) | `ui_card_frame_newweapon` | 80x120 | Distinct color — more elaborate border |
| Card frame (blessing) | `ui_card_frame_blessing` | 80x120 | Softer color — dove or light motif |
| Divider line | `ui_card_divider` | 72x4 | Thin ornamental line between icon and text |

**Weapon icons for upgrade cards** (32x32 each):

| Icon | File Slug | Notes |
|------|-----------|-------|
| Sling | `ui_icon_weapon_sling` | Sling in throwing pose |
| Staff | `ui_icon_weapon_staff` | Shepherd's crook |
| Throwing Stones | `ui_icon_weapon_throwstones` | Arc of three stones |
| Divine Fire | `ui_icon_weapon_divinefire` | Golden flame column |

**Blessing icons** (32x32 each):

| Icon | File Slug | Notes |
|------|-----------|-------|
| Feet Like a Deer | `ui_icon_blessing_speed` | Simple deer silhouette with motion lines |
| Shield of Faith | `ui_icon_blessing_shield` | Round shield with cross/star motif |
| Shepherd's Resolve | `ui_icon_blessing_heal` | Green leaf / water drop |
| Stone Skin | `ui_icon_blessing_armor` | Stone texture swatch |
| Anointing Oil | `ui_icon_blessing_xp` | Oil flask with drip |

---

### 6.4 Dialogue / Scripture Screen UI

| Sprite | File Slug | Canvas | Notes |
|--------|-----------|--------|-------|
| Dialogue box frame | `ui_dialogbox_frame` | Nine-patch | Parchment scroll style, rolled edges at top/bottom |
| Scripture accent | `ui_scripture_accent` | 32x16 | Ornamental divider — olive branch or simple vine |
| Portrait frame (David) | `ui_portrait_frame_david` | 48x48 | Frame holding a larger David bust portrait |
| Portrait frame (Goliath) | `ui_portrait_frame_goliath` | 48x48 | Darker, more imposing frame |
| Portrait (David) | `ui_portrait_david` | 40x40 | Larger bust of David — expressive face, fits in portrait frame |
| Portrait (Goliath) | `ui_portrait_goliath` | 40x40 | Imposing bust |

---

### 6.5 Screen Overlays and Feedback

| Sprite | File Slug | Canvas | Notes |
|--------|-----------|--------|-------|
| Level-up banner | `ui_levelup_banner` | 128x32 | "LEVEL UP!" text graphic in gold — animated pulse |
| Stage clear banner | `ui_stageclear_banner` | 160x32 | "Stage Complete" style text graphic |
| Game over frame | `ui_gameover_frame` | 256x144 | Full overlay frame, faded parchment |
| Victory frame | `ui_victory_frame` | 256x144 | Gold-bordered victory overlay |

---

## 7. VFX Sprites

VFX sprites are animated sprite sheets used for one-shot effects. They play once
and are pooled. No outlines — VFX are glow-based or particle-based.

### 7.1 Hit Effects

| Effect | File Slug | Canvas | Frames | Notes |
|--------|-----------|--------|--------|-------|
| Stone impact (small) | `vfx_hit_stone_small` | 16x16 | 4 | Puff of dust/debris, `#F5D898` / `#C8843C` |
| Stone impact (large) | `vfx_hit_stone_large` | 32x32 | 5 | Bigger burst, more debris |
| Staff sweep arc | `vfx_hit_staff_sweep` | 48x32 | 4 | Wide arc of white-gold light |
| Divine fire burst | `vfx_hit_fire_burst` | 32x32 | 6 | Golden-white explosion, expanding ring |
| Arrow impact | `vfx_hit_arrow` | 16x16 | 3 | Small debris puff |
| Enemy hit flash | `vfx_hit_enemy_flash` | 32x32 | 2 | White flash overlay — rendered over enemy sprite |

---

### 7.2 Death Effects

| Effect | File Slug | Canvas | Frames | Notes |
|--------|-----------|--------|--------|-------|
| Small enemy death | `vfx_death_small` | 32x32 | 6 | Sparkle burst — yellow/white particles scatter |
| Large enemy death | `vfx_death_large` | 48x48 | 8 | More elaborate sparkle cloud |
| Goliath death impact | `vfx_death_goliath` | 96x96 | 10 | Massive dust cloud + divine light column |

---

### 7.3 Player Feedback Effects

| Effect | File Slug | Canvas | Frames | Notes |
|--------|-----------|--------|--------|-------|
| Level-up flash | `vfx_levelup_flash` | 64x64 | 8 | Golden expanding ring emanating from David |
| XP gem collect | `vfx_gem_collect` | 16x16 | 4 | Small sparkle on collection |
| Blessing activate | `vfx_blessing_activate` | 48x48 | 6 | Warm white glow pulse around David |
| Shield of Faith pop | `vfx_shield_pop` | 48x48 | 5 | A shield ripple that absorbs a hit |

---

### 7.4 Weapon VFX

| Effect | File Slug | Canvas | Frames | Notes |
|--------|-----------|--------|--------|-------|
| Sling whirl | `vfx_weapon_slingwhirl` | 32x32 | 4 | Circular motion blur around David during attack wind-up |
| Staff sweep | `vfx_weapon_staffsweep` | 64x32 | 5 | Arc of golden-white light, plays over staff hitbox area |
| Divine fire pillar | `vfx_weapon_divinefire_pillar` | 32x64 | 6 | Column of golden-white fire descending from top of screen |
| Divine fire ground | `vfx_weapon_divinefire_ground` | 48x48 | 6 | Expanding ring at impact point |

---

### 7.5 Stage Transition Effects

| Effect | File Slug | Canvas | Frames | Notes |
|--------|-----------|--------|--------|-------|
| Stage complete burst | `vfx_stage_complete` | 96x96 | 8 | Golden radial burst across full screen center |
| Stage start shimmer | `vfx_stage_start` | 96x96 | 6 | Warm light wipe in from top |

---

## 8. Animation Specifications

### 8.1 Frame Rate Standard

All game animations run at **8 FPS** by default unless noted otherwise.
This means 1 animation frame = 125ms.

The game engine renders at 60 FPS; animation frame advancement is handled
by an accumulator timer, not per-render-frame.

Exceptions are explicitly noted per animation below.

---

### 8.2 Walk Cycle — 4 Frames at 8 FPS

Standard 4-frame walk cycle. Frame sequence: Contact → Down → Passing → Up.

```
Frame 1 (Contact):   Lead foot forward, arms at rear
Frame 2 (Down):      Body at lowest, weight on lead foot
Frame 3 (Passing):   Feet together, body slightly higher
Frame 4 (Up):        Trail foot forward, body at highest
```

- Total cycle duration: 500ms (0.5 seconds for one full walk loop)
- At 8 FPS: this is a comfortable pace for a young boy's jog
- Goliath walk plays at **6 FPS** (longer hold = heavier, slower feel)

---

### 8.3 Idle Animation — 4 Frames at 6 FPS

A breathing bob: character gently rises and falls 1 pixel.

```
Frame 1: Base position
Frame 2: 1px up shift
Frame 3: 1px up shift (hold)
Frame 4: Base position (return)
```

- Total cycle: ~667ms loop
- Adds life without distracting from gameplay

---

### 8.4 Attack Animations

Different weapons have different attack timings:

| Weapon | Total Frames | FPS | Hold Frame | Notes |
|--------|-------------|-----|------------|-------|
| Sling (wind-up) | 4 | 12 | Frame 3 | Fast release; hold is the aim frame |
| Staff sweep | 6 | 10 | Frame 4 | Impact frame held for 2 ticks for punch |
| Throwing stone | 3 | 12 | Frame 2 | Quick throw, minimal wind-up |
| Divine fire | 6 | 8 | Frames 3-4 | Dramatic build-up before release |

---

### 8.5 Hurt Animation — 2 Frames at 12 FPS

```
Frame 1: White flash (palette replace — render layer)
Frame 2: Recoil pose (1-2px displacement in direction opposite to hit source)
```

Duration: ~167ms. Short — does not significantly interrupt player movement feedback.

**Invincibility frames**: Player is invincible for 60 frames (1 second) after hurt.
The sprite flickers (visible/invisible alternates every 6 frames) during iframes.
This is a rendering effect, not a separate sprite.

---

### 8.6 Death Animations

| Character | Frames | FPS | Notes |
|-----------|--------|-----|-------|
| Small enemies (wolf, snake) | 4 | 10 | Quick dissolve — fast pace maintained |
| Medium enemies (lion, scout, soldier) | 5 | 8 | Slightly longer dramatic beat |
| Large enemies (bear, shieldbearer) | 6 | 8 | Full collapse |
| Goliath | 8 | 6 | The climax moment — must feel weighty and final |

---

### 8.7 VFX Animation Timing

VFX play once and despawn. They do not loop.

| VFX Type | Frames | FPS | Total Duration |
|----------|--------|-----|----------------|
| Hit sparks (small) | 4 | 16 | 250ms |
| Hit sparks (large) | 6 | 12 | 500ms |
| Death burst | 6-8 | 10 | 600-800ms |
| Level-up flash | 8 | 8 | 1000ms |
| Divine fire | 6 | 8 | 750ms |
| Goliath death | 10 | 6 | 1667ms — the longest effect in the game |

---

## 9. Asset Naming Convention

All assets follow the convention: `[category]_[name]_[variant]_[size].[ext]`

### Category Prefixes

| Prefix | Category | Examples |
|--------|----------|---------|
| `char` | Player characters | `char_david_walk_01.png` |
| `enemy` | Enemy sprites | `enemy_lion_attack_01.png` |
| `proj` | Projectiles | `proj_slingstone_fly_01.png` |
| `env` | Environment tiles | `env_tile_grass_plain.png` |
| `env_deco` | Environment decorations | `env_deco_sheep.png` |
| `ui` | All UI elements | `ui_health_orb_full.png` |
| `vfx` | Visual effects | `vfx_hit_stone_small.png` |
| `portrait` | Dialogue portraits | `portrait_david_neutral.png` |

### File Format

- **Sprites**: PNG, indexed color (palette-locked), 8-bit
- **Animation sheets**: Single row sprite sheets — all frames in one PNG file,
  left to right, equal frame widths
- **Color profile**: sRGB
- **Transparency**: Alpha channel (PNG-8 with transparency, or PNG-32 for VFX
  with soft alpha edges)

### Directory Structure

```
assets/sprites/
├── characters/
│   ├── char_david_idle.png
│   ├── char_david_walk.png
│   ├── char_david_hurt.png
│   ├── char_david_death.png
│   ├── char_goliath_idle.png
│   └── ... (all Goliath animations)
├── enemies/
│   ├── env1_lion/
│   │   ├── enemy_lion_idle.png
│   │   └── ...
│   ├── env1_wolf/
│   ├── env1_snake/
│   ├── env2_bear/
│   ├── env2_boar/
│   ├── env3_scout/
│   ├── env3_archer/
│   ├── env4_soldier/
│   ├── env4_shieldbearer/
│   ├── env4_chariot/
│   └── env5_shieldbearer_elite/
├── projectiles/
│   ├── proj_slingstone_fly.png
│   ├── proj_throwstone_fly.png
│   ├── proj_arrow_fly.png
│   └── proj_javelin_fly.png
├── environment/
│   ├── stage1_wilderness/
│   ├── stage2_hills/
│   ├── stage3_border/
│   ├── stage4_battlefield/
│   └── stage5_valley/
├── ui/
│   ├── hud/
│   ├── cards/
│   ├── dialogue/
│   └── overlays/
└── vfx/
    ├── hits/
    ├── deaths/
    ├── player/
    └── weapons/
```

---

## 10. Priority Order

This section defines the order in which assets should be created, tightly
aligned to the development milestone plan from the game concept.

### Tier 1 — Prototype (Week 1, first half)

The absolute minimum to have a moving, shooting, killable game loop running.
Everything else can be a colored rectangle placeholder.

| Priority | Asset | Rationale |
|----------|-------|-----------|
| 1 | `char_david_walk` (4 frames) | Player must move visually — core feedback |
| 2 | `char_david_idle` (4 frames) | Rest state needed when not moving |
| 3 | `char_david_hurt` (2 frames) | Player feedback — critical for feel |
| 4 | `enemy_lion_walk` (4 frames) | Stage 1 prototype requires one enemy |
| 5 | `proj_slingstone_fly` (2 frames) | Sling is the starter weapon |
| 6 | `vfx_hit_stone_small` (4 frames) | Hit feedback makes combat feel real |
| 7 | `vfx_death_small` (6 frames) | Enemy death confirmation |
| 8 | `ui_xpgem_small` (2 frames) | XP collection must work |
| 9 | `env_tile_grass_plain` | Stage 1 floor tile — prevents white void |
| 10 | `ui_health_orb_full/empty` | Health state must be visible |

---

### Tier 2 — MVP Completion (Week 1, second half)

Enough art to demo a complete Stage 1 → Stage 2 loop with all systems functional.

| Priority | Asset | Rationale |
|----------|-------|-----------|
| 11 | `enemy_lion_idle`, `enemy_lion_death` | Complete lion state machine |
| 12 | `enemy_wolf_walk`, `enemy_wolf_death` | Stage 1 enemy variety |
| 13 | `enemy_snake_move`, `enemy_snake_death` | Stage 1 enemy variety |
| 14 | `enemy_bear_walk`, `enemy_bear_attack`, `enemy_bear_death` | Stage 2 |
| 15 | `enemy_boar_walk`, `enemy_boar_charge`, `enemy_boar_death` | Stage 2 |
| 16 | `vfx_weapon_staffsweep` | Staff melee weapon needs a VFX |
| 17 | `ui_card_frame_normal` + all weapon/blessing icons | Upgrade system unusable without cards |
| 18 | `ui_xpbar_fill`, `ui_xpbar_bg`, `ui_xpbar_caps` | XP bar |
| 19 | `ui_weaponslot_frame` | HUD weapon display |
| 20 | `ui_dialogbox_frame`, `portrait_david` | Dialogue system requires these |
| 21 | `env_tile_rockyearth_plain` | Stage 2 floor |
| 22 | `char_david_death` | Player death must be handled |

---

### Tier 3 — Target Build (Week 2, first half)

Stage 3-4 content and Goliath boss.

| Priority | Asset | Rationale |
|----------|-------|-----------|
| 23 | `enemy_scout_*` (all animations) | Stage 3 |
| 24 | `enemy_archer_*` (all animations) | Stage 3 |
| 25 | `proj_arrow_fly` | Archer projectile |
| 26 | `proj_throwstone_fly` | Stage 3 player weapon |
| 27 | `enemy_soldier_*` (all animations) | Stage 4 |
| 28 | `enemy_shieldbearer_*` (all animations) | Stage 4 |
| 29 | `enemy_chariot_*` (all animations) | Stage 4 elite |
| 30 | `vfx_weapon_divinefire_pillar`, `vfx_weapon_divinefire_ground` | Stage 4 weapon |
| 31 | `vfx_hit_fire_burst` | Divine fire hit |
| 32 | `char_goliath_idle`, `char_goliath_walk` | Boss base states |
| 33 | `char_goliath_attack_stomp`, `char_goliath_attack_throw` | Boss attacks |
| 34 | `char_goliath_hurt`, `char_goliath_death` | Boss resolution |
| 35 | `proj_javelin_fly` | Goliath attack projectile |
| 36 | `vfx_death_goliath` | The climactic moment |
| 37 | `ui_bossbar_*` | Boss health bar |
| 38 | `portrait_goliath` | Boss dialogue screen |
| 39 | `env_tile_dust_plain` | Stage 3 floor |
| 40 | `env_tile_battlefield_plain` | Stage 4 floor |
| 41 | `env_tile_valley_floor` | Stage 5 floor |

---

### Tier 4 — Polish (Week 2, second half, if time allows)

Everything that elevates the game from functional to memorable.

| Priority | Asset | Rationale |
|----------|-------|-----------|
| 42 | All remaining environment decoration tiles | Visual richness |
| 43 | `vfx_levelup_flash` | Level-up moment must feel great |
| 44 | `vfx_stage_complete` | Stage clear celebration |
| 45 | `vfx_blessing_activate`, `vfx_shield_pop` | Blessing feedback |
| 46 | `ui_levelup_banner`, `ui_stageclear_banner` | Text graphics |
| 47 | `ui_victory_frame`, `ui_gameover_frame` | Screen states |
| 48 | Stage 1-5 decoration tiles (sheep, banners, campfire etc.) | Atmosphere |
| 49 | `char_goliath_*` Phase 2 variants | Boss phase shift visual |
| 50 | `enemy_shieldbearer_hurt_damaged` | Low-HP shield state |
| 51 | `ui_card_frame_newweapon`, `ui_card_frame_blessing` | Card visual variety |

---

### Placeholder Strategy

For any Tier 2-4 asset not yet created, use these placeholder conventions:

| Asset Type | Placeholder |
|------------|-------------|
| Enemy | Colored 32x32 square: Stage 1=green, Stage 2=brown, Stage 3-4=grey, Stage 5=dark red |
| Projectile | 8x8 white pixel |
| Environment tile | 32x32 solid color: grass=`#4A7A2A`, rock=`#B0B0B0`, dust=`#C8843C` |
| UI icon | 32x32 question mark rendered in `PressStart2P.ttf` |
| VFX | Skip entirely — silence is preferable to broken VFX |

This ensures the game is always playable and testable even as art is added
incrementally. The existing `david.png` and `david.aseprite` assets should
be reviewed and verified against this style guide before they are used as
the production character sprite.

---

*End of Document*

*Art Director note: This plan targets a solo artist (the developer) creating
art in Aseprite over a 2-week jam. The Tier 1 and Tier 2 assets are the
non-negotiables. If the full 50-item list feels overwhelming, ship Tiers 1-2
with colored placeholders for everything else. A finished game with placeholder
art beats an unfinished game with polished art.*
