# Sprite Redesign Brief: David's Ascent
*Version: 1.0 — 2026-03-22*
*Author: Art Director*
*Status: APPROVED FOR IMPLEMENTATION*

---

## How to Use This Document

Each sprite entry is a specification, not a suggestion. Every numbered detail is a
constraint that the Lua pixel-placement scripts must satisfy. Where pixel coordinates
are given, they are relative to the Aseprite canvas with (0,0) at the top-left, which
is the coordinate system Lua scripts use when calling `img:drawPixel(x, y, c)`.

**Coordinate note**: The engine uses bottom-left origin. The Lua scripts use top-left
origin (Aseprite's native coordinate system). All coordinates in this document are
top-left origin (Aseprite), consistent with the existing scripts in
`assets/sprites/`.

**Grid reference**: A "16x16 simplified grid" in the ASCII maps below means each cell
represents a 2x2 block of actual pixels. Column 0 = pixels 0-1, Column 1 = pixels 2-3,
etc. Row 0 = pixels 0-1 (top), Row 15 = pixels 30-31 (bottom).

**Palette aliases used throughout this document**:

| Alias | Hex | Palette Name |
|-------|-----|--------------|
| `BLK` | `#1A0A00` | VOID_BLACK — all outlines |
| `DUM` | `#3D1F00` | DARK_UMBER — deepest shadow |
| `TRC` | `#6B3A1F` | TERRACOTTA |
| `DSN` | `#A05C2C` | DESERT_SIENNA |
| `SBR` | `#C8843C` | SANDY_BROWN — David skin base |
| `WTN` | `#E8B46A` | WARM_TAN — skin highlight |
| `SLN` | `#F5D898` | SUNLIT_LINEN — brightest skin |
| `WLT` | `#5C3A1A` | WORN_LEATHER |
| `SBN` | `#8C5A28` | STAFF_BROWN |
| `STG` | `#D4A050` | STRAW_GOLD |
| `HYL` | `#F0C840` | HARVEST_YELLOW |
| `ABR` | `#B87820` | AGED_BRASS |
| `PBR` | `#E8A820` | POLISHED_BRONZE |
| `RFX` | `#6B4020` | ROUGH_FLAX — robe shadow |
| `FWV` | `#B08040` | FLAX_WEAVE — robe mid |
| `BLN` | `#D4B878` | BLEACHED_LINEN — robe highlight |
| `SGG` | `#B0B0B0` | SLATE_GREY |
| `NGT` | `#1A3050` | NIGHT_BLUE |
| `SKB` | `#2860A0` | SKY_BLUE |
| `STW` | `#F0F0F0` | STONE_WHITE |
| `PWH` | `#FFFFFF` | PURE_WHITE — 1px specular only |

---

## The Core Problem with the Current Scripts

Before the per-sprite briefs, these are the systemic errors in every existing script
that must be corrected in the redesigns:

1. **Single-color body fill**: The current `drawDavidBase` fills the entire torso
   with `FLAX_WEAVE` (`hline` from x=11 to x=21). The robe reads as a featureless
   rectangle. Real sprites at 32x32 must show the form inside the silhouette.

2. **Stick legs**: David's legs are 2 pixels wide (`p(14,23)` through `p(14,24)`).
   At 32x32, legs need to be at minimum 3-4 pixels wide at the thigh, tapering to
   2 at the ankle. A 2px leg is invisible against a busy background.

3. **Missing torso separation**: The belt at y=18 exists but the robe above and below
   it uses the same `FLAX_WEAVE` with no shape difference. The upper body needs a
   chest shadow on the right side, a collar shadow, and sleeve definition.

4. **Lion body blob**: `drawLion` fills y=11 through y=17 as a flat rectangle from
   x=9 to x=23. The underside needs lighter fur, the dorsal ridge needs a shade step,
   and the leg-to-body junction needs definition.

5. **Animation is only position offsets**: Every animation in every script is just
   `bodyY` offset (bounce). Real animation requires specific body parts to move
   independently — the arms swing, the legs alternate, the tail arcs. The redesigns
   must use per-region offsets, not a single global `bodyY`.

6. **No specular**: No existing sprite has the `PURE_WHITE` 1-pixel specular dot that
   the style guide requires on shiny surfaces (eyes, bronze, wet nose).

---

## Sprite 1: David (Player Character)

**Canvas**: 32x32
**File target**: `char_david_idle`, `char_david_walk`
**Current problem**: Flat robe rectangle, invisible 2px stick legs, no arm definition

### 1.1 Silhouette Description

David reads as a small, slight youth — the shortest and most narrowly built character
in the game. His silhouette has a large round head (nearly as wide as his shoulders)
sitting on a narrow torso that flares very slightly at the hips where the robe falls.
The staff held in the left hand extends above his head, creating a vertical line that
anchors the left edge of the sprite. His sling cord dangles from the right hip,
creating a small diagonal detail that breaks the right edge. Legs taper down from
narrow hips and end in wide flat sandals. The overall shape from above is:

```
narrow top (staff arm)
|
[round head, 10px wide]
[slightly narrower neck]
[chest, 10px wide]
[belt, full width]
[skirt flares to 12px]
[legs narrow to 6px total]
[sandals, 5px each, offset from center]
```

The silhouette must be immediately distinguishable from every enemy: no enemy is
this small with a round head plus a tall staff.

### 1.2 Key Readable Details (at 32x32)

These five features must survive at full game scale (32px rendered at 2x or 3x zoom):

1. **The staff** — a 1px-wide vertical line, color `SBN`, left of center (x=7),
   running from y=2 to y=28 with a slight horizontal crook at the top (the shepherd's
   hook). Without the staff, David reads as a generic villager.

2. **The sling** — a 2px diagonal cord `WLT` exiting the right hip at approximately
   (x=21, y=18) and trailing down-right to (x=23, y=21). The leather pouch sits at
   the end of it: a 2x2 cluster in `WLT` with one `DUM` pixel for shadow. This is
   David's defining weapon.

3. **The eyes** — two separate 1px dots with `SKB` iris, `STW` white adjacent,
   `DUM` pupil center. The gap between the eyes (at minimum 2px) confirms he is
   looking at the viewer and is animated/living, not a blob with a face painted on.

4. **Belt** — a 1px horizontal band in `WLT` at the waist separating upper robe from
   lower skirt. The belt must be 1px, not merged with the robe color.

5. **Sandal straps** — each foot should have a 2px-wide sandal in `SBN` with a 1px
   strap line in `WLT` crossing the foot horizontally. Without visible straps, the
   feet read as brown blobs.

### 1.3 Color Distribution

David uses 10 colors. Target pixel percentages across the 32x32 = 1024 visible
canvas area (minus ~30% transparency at edges):

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline, all edges | 12% |
| `FWV` | Robe mid-tone (torso, upper skirt) | 18% |
| `RFX` | Robe shadow (left torso, skirt folds) | 8% |
| `BLN` | Robe highlight (right torso, shoulder) | 6% |
| `SBR` | Skin base (face, arms, legs) | 14% |
| `DSN` | Skin shadow (right of face, inner arm) | 5% |
| `WTN` | Skin highlight (left of face, left arm) | 3% |
| `WLT` | Belt, sandal straps, sling cord | 4% |
| `SBN` | Staff, sandal sole | 5% |
| `TRC` | Hair | 6% |
| `DUM` | Hair shadow, eye pupil | 2% |
| `SKB` | Eye iris | 1% |

Current error: `FWV` (FLAX_WEAVE) occupies approximately 40% of visible pixels
because the robe has no shading. The target is 18% mid + 8% shadow + 6% highlight
= 32% for the entire robe system, which is correct for a chibi character.

### 1.4 Shading Map

Light source: upper-left (approximately 10 o'clock position).

**Head** (approximately rows 5-12, cols 12-20):
- Left half of face (cols 12-15): `WTN` highlights on forehead and cheekbone
- Center face: `SBR` base
- Right edge (col 20): `DSN` shadow 2px wide, implying the head curves away from light
- Under the chin (row 12): `DSN` — the neck is in shadow from the head above it
- Hair crown: `TRC` mid, with `DUM` shadow on the rightmost 2px and the part line

**Torso** (approximately rows 13-18):
- Left shoulder and left side of chest (cols 11-13): `BLN` — the light catches the
  robe fabric here
- Center chest (cols 14-18): `FWV` mid-tone
- Right side (cols 19-21): `RFX` shadow — the torso curves away from light
- The neckline V-shape: interior is `RFX`, indicating the hollow beneath
- Note a subtle fold crease: a 1px vertical `RFX` line at approximately col 16,
  rows 14-17, suggesting the cloth falls from the shoulders

**Belt** (row 18): solid `WLT` across full torso width, no shading needed at 1px

**Skirt** (rows 19-22):
- The skirt should not be a flat rectangle. At row 19 it tapers slightly inward
  from the belt, then flares back out by row 21. Use this pixel-wide taper.
- Left edge lit: `BLN` at cols 12-13
- Center: `FWV`
- Right edge shadow: `RFX` at cols 19-21
- Bottom hem (row 22): `RFX` — the hem falls in shadow from the skirt fabric above

**Arms** (cols 9-11 left, cols 22-23 right, rows 14-20):
- Left arm holds the staff: slightly in front, so it catches light: `WTN` highlight
  on col 10, `SBR` base on col 11
- Right arm hangs: `SBR` base on col 22, `DSN` shadow on col 23

**Legs** (rows 23-26):
- Left leg: `WTN` highlight on the left pixel column, `SBR` base, `DSN` on right col
- Right leg: `DSN` shadow on the right col (further from light source)
- Between legs at row 23: `RFX` skirt shadow pixel to separate the legs visually

### 1.5 Animation Keyframes — 4-Frame Walk Cycle

This is a front-facing, top-down walk. David bobs slightly and his arms swing.
Each frame description is a delta from the base pose.

**Frame 1 — Contact pose (base)**:
- Body at neutral y position
- Left foot forward: sandal at y=26, right sandal at y=27 (1px lower, implies back foot)
- Left arm: pulled slightly back — the elbow pixel shifts left 1px (col 9 instead of 10)
- Right arm: pushed slightly forward — the sling trails right (x=22 for the hip cord)
- Staff: vertical, no change

**Frame 2 — Down pose (weight on front foot)**:
- Entire body shifts DOWN 1px (global oy = +1)
- Feet: left foot now at y=27, right foot rises to y=26 (legs crossing)
- Left arm: elbow comes forward, col 10 same as base but 1px lower
- Right arm: elbow pulls back, col 23
- Head: no shift (the 1px global shift handles this; do not add extra head movement
  or it will look like the head is separating from the body)

**Frame 3 — Passing pose (mid-stride)**:
- Body at neutral y (same as Frame 1)
- Feet: both at y=26, side by side — this is the moment of equal balance
- Arms: left arm at col 10, right arm at col 22 — centered, no lateral swing
- Staff: tilts 1px right at the top (x=8 top, x=7 bottom), suggesting walking motion

**Frame 4 — Up pose (pushing off back foot)**:
- Entire body shifts UP 1px (global oy = -1)
- Feet: right foot forward at y=26, left foot back at y=27
- Left arm: now swings forward (col 10 pushes to col 9, elbow visible)
- Right arm: pulls back, sling swings left 1px
- This frame is the mirror action of Frame 1

**Do NOT use a single `bodyY` offset for the whole character.** The staff is held
in the ground — if the body bobs 1px up, the staff stays at its ground contact point.
Implement the bob as everything-except-the-bottom-3-rows-of-the-staff moving.

### 1.6 Pixel Art Mistakes to Avoid

- **Do not flatten the robe**: The robe is the biggest surface area on the sprite.
  It must show at least 3 distinct tonal regions or it reads as a game jam placeholder.

- **Do not make the neck disappear**: The current script draws the neck as 3 pixels
  (`SBR` at x=15,16,17, y=12). This is correct but the head outline pixels at y=12
  (x=13 and x=19) must be `BLK`, not skin color, or the neck merges with the chin.

- **Do not use symmetric arms**: The current script draws arms identically on both
  sides. David's left hand holds the staff — that arm should be slightly higher and
  the hand should rest on the staff shaft. The right arm hangs looser.

- **Do not skip the sling pouch**: The current script draws the sling cord but only
  as 4 pixels. The pouch at the end (a 2x2 `WLT` cluster) is what makes it read as
  a sling rather than a random stray pixel. The pouch is David's character prop.

- **Do not use pure `TRC` for all hair**: The hair needs `TRC` mid with `DUM` shadow
  on the right/lower edge pixels and 1px of `WTN` at the crown left corner where
  light hits. Pure `TRC` hair looks like a painted-on helmet.

- **Do not draw legs shorter than 6 rows**: The current legs span rows 23-26 (4 rows).
  Legs should span rows 23-28 (6 rows) to give room for thigh, shin, and sandal as
  distinct regions.

### 1.7 Reference Silhouette — ASCII Map (16x16 grid, each cell = 2x2 px)

```
Col:  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
     [0][1][2][3][4][5][6][7][8][9][A][B][C][D][E][F]
R00:  .  .  .  .  ST .  .  .  .  .  .  .  .  .  .  .
R01:  .  .  .  .  ST .  .  BK BK BK BK BK .  .  .  .
R02:  .  .  .  .  ST .  BK HD HD HD HD HD BK .  .  .
R03:  .  .  .  .  ST BK HH FS FS FH FS HD BK .  .  .
R04:  .  .  .  .  ST BK SK SK EW EY EW SK BK .  .  .
R05:  .  .  .  .  ST BK SK SK SK NZ SK SK BK .  .  .
R06:  .  .  .  .  BK BK NK NK NK NK NK BK BK .  .  .
R07:  .  .  .  BK RL RL RL RL RL RM RM RM BK .  .  .
R08:  .  .  BK RL RL RL BT BT RM RM RM RH RH BK .  .
R09:  .  .  BK RL RL RL BT BT RM RM RM RH RH BK .  .
R10:  .  .  .  BK BT BT BT BT BT BT BK .  .  .  .  .
R11:  .  .  .  .  BK RL RL RM RM RH BK .  .  .  .  .
R12:  .  .  .  .  .  BK LL LL RL RL BK .  .  .  .  .
R13:  .  .  .  .  .  BK LL LL RL RL BK .  .  .  .  .
R14:  .  .  .  .  .  BK SA SA SA BK .  .  .  .  .  .
R15:  .  .  .  .  .  .  BK .  .  BK .  .  .  .  .  .

Key:
BK=outline(BLK)  ST=staff(SBN)  HD=hair(TRC)  HH=hair highlight
FS=face(SBR)  FH=face highlight(WTN)  EW=eye white(STW)  EY=eye(SKB)
NZ=nose(DSN)  NK=neck(SBR)  RL=robe left/lit(BLN+FWV)  RM=robe mid(FWV)
RH=robe highlight(BLN)  BT=belt(WLT)  LL=left leg(SBR)  RL=right leg
SA=sandals(SBN)
```

---

## Sprite 2: Goliath (Final Boss)

**Canvas**: 48x64 (the only non-32x32 sprite)
**File target**: `char_goliath_idle`, `char_goliath_walk`, `char_goliath_death`
**Current problem**: Does not exist yet. Design from scratch.

### 2.1 Silhouette Description

Goliath is an inverted triangle of mass. His shoulders are the widest point — nearly
the full canvas width (40+ pixels across the pauldrons). His helmet plume extends
above his head, giving him even more vertical presence. His legs are as wide as
David's entire torso. The overall shape reads:

```
     [helmet plume, narrow spike]
  [===helmet, wide bronze crown===]
 [====head, wider than David===]
[====shoulders, pauldrons flare====]
[====bronze breastplate, massive====]
 [===belt, slightly narrower===]
  [===legs, wide pillars===]
   [===greaves===]
    [feet, planted firmly]
```

He fills 85-90% of the 48-wide canvas at shoulder level. He should feel like he is
about to step off the edge of the canvas. His spear extends diagonally past the top
of the canvas — only the lower 2/3 of the shaft is visible, which reinforces that
the spear is as long as he is tall.

### 2.2 Key Readable Details (at 48x64)

1. **The feathered helmet crest** — a fan of 5-7 `BLN` / `STW` pixel-wide plume
   strands rising from the top of the bronze helmet, arcing slightly right. This
   is the visual signature of the Philistine warrior. The plume should occupy the top
   10 rows of the canvas.

2. **Scale armor texture** — the breastplate (rows 20-38) is not a flat bronze
   rectangle. It uses a fish-scale tile pattern: alternating rows of `ABR` and `PBR`
   each offset by 2px horizontally, creating visible scales. At 48 wide, you can fit
   10-12 scale columns. This is the most complex pixel pattern in the entire game.

3. **The spear** — a diagonal shaft (`SBN` with `DUM` shadow edge) entering from
   the top-right and ending in the hand at approximately (x=38, y=42). The spear
   tip, if visible, is a bronze `PBR` point. The shaft should be 2 pixels wide.

4. **Bronze greaves** — the shins (rows 50-60) are covered by `ABR` greaves with
   `PBR` highlight on the left edge. These must be visually distinct from the skin
   of the thighs above them.

5. **Expression** — even at this resolution, the face must convey contempt.
   Downturned mouth corners (`DUM` pixels), heavy brow ridge (`DUM` or `TRC`
   shadow pixels above the eye level), and a slightly raised eyebrow on one side.

### 2.3 Color Distribution

Goliath uses the palette's bronze-and-stone subset. His color scheme must contrast
sharply with David's warm earth tones:

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 10% |
| `ABR` | Bronze armor primary | 20% |
| `PBR` | Bronze armor highlight | 8% |
| `DUM` | Deepest shadow (armor crevices, face shadow) | 6% |
| `TRC` | Skin shadow (face, arms, legs) | 8% |
| `DSN` | Skin mid-tone | 10% |
| `WTN` | Skin highlight (exposed face, arms) | 4% |
| `SGG` | Helmet body, cloth under armor | 8% |
| `STW` | Plume, specular on armor | 4% |
| `WLT` | Leather straps, armor binding | 5% |
| `NGT` | Deepest armor shadow, greave creases | 3% |

Goliath should look cold and metallic against David's warm and organic palette.
If you put David and Goliath side by side, David should be primarily warm ochres,
Goliath primarily cool greys and bronzes.

### 2.4 Shading Map

**Helmet** (rows 8-16):
- The helmet is a rounded dome. Left side: `SGG` highlight. Center: `SGG` mid.
  Right side: `DUM` shadow. The dome curves — use a 3-step arc of shading.
- Plume: `STW` at the base where it exits the helmet, `BLN` as the strands fan up,
  `STW` at the very tips as they catch light.

**Face** (rows 17-24):
- Visible face area is approximately 10px wide (the helmet frames it).
- Heavy brow: `TRC` or `DUM` 1px across at eye level, protruding 1px left and right
  of the orbital area to create a ridge.
- Eyes: `DUM` heavy shadow above each eye. Eyes themselves are small and mean:
  `DUM` iris (not the sky blue of David's honest eyes), `STW` tiny white.
- Skin: `DSN` base, `TRC` shadow on the right side, `WTN` on the left cheekbone.

**Breastplate — Scale Pattern**:
This is the most important detail. Code this as a loop, not as individual pixels.
Concept: every even row of scales starts at x=6. Every odd row starts at x=4 (offset
left by 2). Each scale is 4 pixels wide and 3 pixels tall.
- Scale body: `PBR` (top 2px of each scale — the lit top face)
- Scale edge: `ABR` (bottom 1px of each scale — the shadow underneath)
- Scale overlap shadow: `DUM` (1px between scale rows)
- Left column lit: add `STW` 1px specular at the top-left corner of the two
  leftmost scales in each row.

**Arms** (cols 6-10 left, cols 38-42 right):
- The arms are enormous — wider than David's torso.
- Bronze pauldrons (shoulder caps): rows 18-22, full arc from `ABR` to `PBR` to `DUM`
- Upper arm: `DSN` skin if exposed, otherwise `ABR` vambrace
- Fist: `DSN` base, `TRC` shadow on knuckles

**Legs** (rows 44-62):
- Thighs: `DSN` skin with `TRC` shadow on the right/inner side of each leg
- Greaves: `ABR` front face, `PBR` left highlight strip, `DUM` right shadow
- The greave should start at approximately row 52 and end at row 61

### 2.5 Animation Keyframes — Walk Cycle

Goliath's walk conveys weight. Each step is a deliberate STOMP, not a bounce.

**Frame 1 — Right foot planted**:
- Right foot fully down, left foot raised 3px
- Body lists 1px RIGHT (weight shift)
- Right pauldron drops 1px, left pauldron rises 1px (torso rotation)
- Spear arm (right) remains relatively still — it holds the spear upright

**Frame 2 — Mid-stride**:
- Both feet at ground level, body centered
- Torso at neutral rotation
- Armor does not settle instantly — this is the "carry" frame, there is no change
  in the armor yet, the body is in transit

**Frame 3 — Left foot planted**:
- Left foot fully down, right foot raised 3px
- Body lists 1px LEFT
- Left pauldron drops 1px, right rises 1px

**Frame 4 — Mid-stride (return)**:
- Mirror of Frame 2

**Key principle for Goliath's walk**: Do NOT use a 1px bounce. Goliath does not bob
delicately. His weight shift is lateral (1px left/right), not vertical. Only the
footfalls create any vertical motion, and only the raised foot moves — the torso
stays at constant height. This makes him feel immovably heavy.

### 2.6 Pixel Art Mistakes to Avoid

- **Do not make him a rectangle**: Goliath's silhouette must taper at the hips and
  flare at the shoulders. A rectangular torso at 48 wide looks like a wall, not a
  warrior. The shoulders should be 40px wide, the waist 28px wide, the hips 32px.

- **Do not skip the scale pattern**: A flat bronze rectangle for armor is the single
  biggest loss of visual quality possible for this sprite. The scales are what make
  him look like the most armored enemy in the game. Spend the pixel budget here.

- **Do not make the face too small**: At 48x64 there is room for a proper face. Use
  at least 10x8 pixels for the face. Goliath's expression is critical narrative
  information — the contemptuous sneer must be readable.

- **Do not use the same skin tone as David**: David is `SBR` (Sandy Brown). Goliath
  should use `DSN` (Desert Sienna) as his base skin, one step darker. They are from
  different peoples and this contrast reinforces the visual language.

- **Do not make the plume symmetrical**: Philistine feather plumes arc — they do not
  stand straight up. The plume should lean 1-2px to the right, as if caught in
  motion or the wind. A perfectly vertical plume looks painted on.

---

## Sprite 3: Lion

**Canvas**: 32x32
**File target**: `enemy_lion_walk`
**Current problem**: Rectangular body blob, 2px-wide "legs" that are barely
distinguishable from body pixels, no visible muscle structure under the fur

### 3.1 Silhouette Description

The lion is viewed from a 3/4 front-left angle — we see slightly more of its left
side than its right, and the head is facing toward the viewer with a slight angle.
This is the same viewing angle used by many SNES big cat sprites (Secret of Mana's
beasts, Chrono Trigger's Kilwala).

The silhouette has three distinct bumps along the top edge: the mane peak (left of
center, tallest), the shoulder hump, and the haunch hump. The belly curves upward
between the front and rear legs. This is a greyhound-like body tuck — the abdomen
is drawn up, making the beast look powerful and coiled.

The four legs must be visually distinct from the body. Each front leg should be 3px
wide, each back leg 3px wide. Current script draws legs as 2px vertical lines
starting at y=18 — they vanish against the body.

### 3.2 Key Readable Details (at 32x32)

1. **Mane framing the face** — the mane is not just color fill. It should surround
   the face with irregular outer edges — not a perfect arc. The mane pixels on the
   left side should reach x=8, on the right x=24, but with 1-2px of irregularity to
   suggest fur texture (alternate between `TRC` and `DUM` on the mane's outer edge).

2. **Amber eyes** — each eye is: 1px `DUM` outline, 1px `HYL` iris, 1px `DUM` pupil
   slit (vertical). The `HYL` (Harvest Yellow) eyes are the most saturated color on
   the sprite and anchor the viewer's gaze to the face.

3. **Nose and muzzle** — the nose is not a single pixel. The muzzle protrudes as a
   3px-wide bump at rows 8-10. The nose is a 2x1 `DUM` block with a `PWH` specular
   dot at its upper-left corner. The mouth corners (`DUM` pixels) turn downward.

4. **Leg separation** — the gap between the front two legs must be visible as 1px
   of `BLK` between them. Same for the rear legs. Without this gap, legs merge into
   a solid pad.

5. **Tail** — the tail is not 4 random pixels. It is a 2px-wide arc of 8-10 pixels
   starting at the rump (x=6, y=12 approximately), curving up and right, ending in a
   tuft that is 3px wide. The tuft uses `STG` or `DUM` to distinguish it from the
   body. Current script tail is a diagonal string of 4 single pixels — unreadable.

### 3.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline, leg separation | 12% |
| `SBR` | Body fur primary | 22% |
| `WTN` | Body fur highlight (left side, belly) | 10% |
| `DSN` | Body fur shadow (right side, leg tops) | 8% |
| `TRC` | Mane primary | 12% |
| `DUM` | Mane shadow, nose, mouth, pupil | 6% |
| `RFX` | Mane light fringe | 4% |
| `STG` | Tail tuft, paw pads | 3% |
| `HYL` | Eyes (iris) | 1% |

Current error: `TERRACOTTA` (TRC) dominates the mane at about 20% of visible pixels
but is used for a flat-filled rectangle. The redesign uses TRC for approximately 12%
but shapes it as an irregular mane border around the face.

### 3.4 Shading Map

**Mane** (rows 3-10, cols 8-24):
- The mane is darker at its outer ring: `DUM` on the outermost edge pixels
- One step in: `TRC` for the main mane body
- Inner ring where mane meets face: `RFX` as a lighter fringe (mane lightens at the
  face boundary, as lion manes actually do)
- Left side of mane (cols 8-11) receives light from the upper-left: add 1px of `WTN`
  at the top of the left mane column (row 4-5, col 10)

**Head** (rows 4-9, cols 12-20):
- Top of head: `WTN` highlight 3px wide (light falls directly from above-left)
- Center face: `SBR` base
- Right cheek and jaw (cols 18-20): `DSN` shadow
- Muzzle bump (rows 7-9): protrudes from the main face plane, so it gets `WTN`
  on its top surface and `DSN` on its lower/right surface

**Body** (rows 10-18):
- Dorsal ridge (top edge of body): `DSN` — the spine ridge is in partial shadow
  because the back is relatively flat and light falls at an angle
- Mid-body: `SBR` base
- Left flank (cols 8-11): `WTN` highlight — the left flank catches the light
- Right flank (cols 21-23): `DSN` shadow
- Belly tuck (rows 16-18, center): `WTN` — the belly catches upward ambient light
  in desert settings (reflected ground light). This belly highlight is what creates
  the illusion of a tucked, muscular abdomen.

**Legs** (rows 18-22):
- Front legs: left leg `WTN` on front face, `SBR` on sides, `DSN` shadow behind
- Paw pad at bottom: 1px `STG` to differentiate paw from leg

### 3.5 Animation Keyframes — 4-Frame Walk Cycle

A quadruped walk cycle at 4 frames uses the "diagonal gait" pattern (front-left and
back-right move together, then front-right and back-left).

**Frame 1 — Contact (FL+BR pair forward)**:
- Front-left leg: forward 2px (toe at y=22)
- Back-right leg: forward 1px (toe at y=21) — back legs don't stride as far
- Front-right leg: back position (toe at y=23)
- Back-left leg: back position (toe at y=23)
- Body: at base height (no global offset)
- Tail: mid arc position

**Frame 2 — Down (weight loads onto legs)**:
- All four leg tips at maximum downward position (each 1px lower than Frame 1)
- Body drops 1px (global bodyY +1) — the cat's mass loads down
- Tail: slight downward arc (tailOff -1)

**Frame 3 — Passing (legs cross)**:
- Front-left leg returning: toe at y=22.5 (approximated as mid position)
- Back-right returning: back to neutral
- Front-right moves forward: toe at y=22
- Back-left moves forward: toe at y=21
- Body: at base height
- Tail: opposite arc from Frame 1

**Frame 4 — Up (push-off)**:
- All leg tips at highest points (toe 1px above base, ankle region showing)
- Body rises 1px (global bodyY -1)
- The shoulder hump and haunch appear more prominent when the legs are extended

**Critical**: Do NOT animate only the `leftPawOff` and `rightPawOff` as the current
script does. This makes only two legs animate. All four leg positions must be
independent parameters: `frontLeftOff`, `frontRightOff`, `rearLeftOff`, `rearRightOff`.

### 3.6 Pixel Art Mistakes to Avoid

- **Do not merge the mane with the body**: There must be at least 1px of `BLK`
  outline between the mane and the body outline. The current script omits this;
  the mane bleeds into the body color and the lion looks like a mushroom.

- **Do not use leftPawOff and rightPawOff for all four legs**: As noted in 3.5.
  Two-leg animation on a cat looks like a broken toy.

- **Do not draw the tail as a diagonal line of single pixels**: The tail is a
  2px-wide arc. Each row of the tail has 2 horizontally adjacent pixels. The arc
  curves — consecutive rows shift x position by 1 in alternating directions.

- **Do not make the mane a perfect oval**: The outer edge of the mane should have
  1-2px of irregularity (alternate between the mane edge color and `BLK` on
  adjacent pixels along the outline to suggest fur texture).

- **Do not skip the belly highlight**: Without the `WTN` belly tuck, the body reads
  as a flat sausage. The belly highlight is only 4-6 pixels but it transforms the
  silhouette into a readable cat body.

### 3.7 Reference Silhouette — ASCII Map

```
Col:  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
     [0][1][2][3][4][5][6][7][8][9][A][B][C][D][E][F]
R00:  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
R01:  .  .  .  TL .  .  BK BK MK MK MK MK BK .  .  .
R02:  .  .  TL .  .  BK MM MM FM FH FM MM BK .  .  .
R03:  .  .  TL .  BK MD MM FM FH EY FM MM BK .  .  .
R04:  .  .  .  BK MD MM FM FM NZ FM MM MD BK .  .  .
R05:  .  .  .  BK MM MM FM FM MZ FM MD MD BK .  .  .
R06:  .  .  .  .  BK MD MD BK BK BK BK BK .  .  .  .
R07:  .  BK BK FH FB FB FB FB FB FS FS BK .  .  .  .
R08:  BK FH FB FB FB FB FB FB FB FS FS FD BK .  .  .
R09:  BK FL FL FL FL FL FL FB FS FS FS FD FD BK .  .
R10:  .  BK FL FL FL FL FL FS FS FS FD FD BK .  .  .
R11:  .  .  BK BK BK FL FL FS FS FD BK BK .  .  .  .
R12:  .  .  .  LF BK LL LR RR RR RR BK RF .  .  .  .
R13:  .  .  .  LF LL LL LR RR RR RR RF RF .  .  .  .
R14:  .  .  .  .  BK LL LR RR RR BK .  .  .  .  .  .
R15:  .  .  .  .  .  BK BK BK BK .  .  .  .  .  .  .

Key:
TL=tail(SBR)  MK=mane outer dark(DUM)  MM=mane mid(TRC)  MD=mane inner(RFX)
FM=face/body(SBR)  FH=face highlight(WTN)  EY=eye(HYL)  NZ=nose(DUM)
MZ=mouth(DUM)  FB=body(SBR)  FS=body shadow(DSN)  FD=body deep shadow(DUM)
FL=body left lit(WTN)  LL=front left leg  LR=rear left leg
RR=rear right leg  RF=front right leg  LF=tail arc
```

---

## Sprite 4: Wolf

**Canvas**: 32x32
**File target**: `enemy_wolf_walk`
**Current problem**: Does not exist yet (wolf script not present in sprite directory)

### 4.1 Silhouette Description

The wolf is leaner and lower than the lion. Where the lion has a wide mane creating
a top-heavy mass, the wolf has a narrow, aerodynamic profile. The key shape is a
low-slung body with the head thrust forward and down (hunting posture), a pointed
ear silhouette, and a tail held low behind (aggressive hunting tail position, not
raised like a dominant display). The overall silhouette is a forward-leaning
horizontal wedge.

The wolf must be instantly distinguishable from the lion:
- Wolf: grey, lean, head low, ears pointed, no mane
- Lion: tawny, broad, head centered, rounded profile, mane mass

### 4.2 Key Readable Details (at 32x32)

1. **Pointed ears** — two distinct triangular ears (each 3px base, 3px tall) at the
   top of the head. These are the wolf's most distinctive feature at this resolution.
   Use `SGG` for the ear outer surface and `TRC` / `DUM` for the inner ear shadow.

2. **Narrow snout** — the wolf's muzzle is longer and narrower than the lion's.
   It protrudes 2-3px further than the main skull. The snout tip should reach x=25
   approximately. Use `SGG` for the snout with `STW` highlight on the top ridge.

3. **Grey coat with dark dorsal stripe** — a 1px-wide stripe of `DUM` runs from
   the skull crown down the spine. This is the wolf's primary surface detail.

4. **Legs visibly churning** — the wolf is the fastest normal enemy. Its animation
   must convey speed. In the walk cycle, legs should have larger arc offsets (+/-3px)
   than the lion's (+/-2px).

5. **Yellow-green eyes** — use `HYL` for the iris (same as lion) to unify the
   predator family visually. A wolf and a lion share the amber eyes; the scout and
   soldier have darker eyes. This creates a "natural predator" vs "human enemy"
   color language.

### 4.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 12% |
| `SGG` | Coat primary (grey) | 28% |
| `STW` | Coat highlight (left side, muzzle top) | 10% |
| `DUM` | Coat shadow (right side, dorsal stripe) | 8% |
| `TRC` | Paws, muzzle interior | 5% |
| `HYL` | Eyes | 1% |
| `SBR` | Inner ear | 2% |

The wolf is the game's "grey" enemy. Its palette deliberately pulls the cool `SGG`
and `STW` tones while the lion used warm `SBR` and `WTN`. This makes them instantly
distinguishable even when both are on screen simultaneously.

### 4.4 Shading Map

**Head and snout**:
- Top of skull and ear outer face: `STW` highlight
- Left side of head: `SGG` mid
- Right side of head: `DUM` shadow
- Snout top ridge: `STW` (catching direct light from upper-left)
- Snout underside: `DUM` (in shadow)
- Inner ear: `TRC` (suggesting the pink skin visible inside)

**Body**:
- Dorsal top ridge: `DUM` stripe (1px wide, runs from neck to base of tail)
- Left flank: `STW` highlight
- Mid body: `SGG`
- Right flank and belly: `DUM` — the wolf's belly is not lit; it is low to the
  ground and in shadow unlike the lion which has the upward belly light

**Legs**:
- Front faces: `SGG` with `STW` highlight on front edge
- Rear of legs: `DUM`
- Paws: `TRC` with `BLK` outline

### 4.5 Animation Keyframes

Same diagonal gait as the lion (see 3.5) but with larger stride offsets:
- Front leg swing: +/-3px instead of lion's +/-2px
- Body vertical: +/-1px (same as lion, but the low-slung body means this is more
  noticeable as a percentage of the wolf's body height)
- Tail: held low, swings opposite to the dominant rear leg with +/-2px arc

Speed emphasis: at 8 FPS the wolf should feel like it is cycling fast. Consider
reducing to 6 FPS actually — faster FPS makes the frames individually shorter; for
the wolf, making the frame hold shorter via animation speed in code achieves the
same result without requiring additional sprite frames.

### 4.6 Pixel Art Mistakes to Avoid

- **Do not make the wolf look like a grey lion**: The key differentiation is the
  head shape. The lion has a broad rounded head with mane. The wolf has a narrow,
  triangular head with pointed ears. If the ears are not visible and pointed,
  the wolf reads as a small grey lion.

- **Do not use SGG (Slate Grey) as a flat fill**: The coat must show at least
  `STW`, `SGG`, and `DUM` on the body. Pure `SGG` looks like a grey rectangle.

- **Do not position the head at the center of the canvas**: The wolf hunts with
  its head thrust forward. The nose should be at approximately x=25 (right of center),
  leaving the haunches near x=8. This asymmetry is the hunting posture.

---

## Sprite 5: Snake

**Canvas**: 32x32
**File target**: `enemy_snake_move`

### 5.1 Silhouette Description

The snake occupies the canvas in a loose S-curve. The body width is 3px at its
thickest (mid-body), tapering to 2px at the tail and 2px at the neck, with the
head being a distinct 4x3px rounded triangle shape (wider at the back of the skull
than the snout). The S-curve should use most of the canvas width — if the snake
body fits within a 20px column, it is too thin and will disappear against backgrounds.

The S-curve: head at approximately (x=22-26, y=4-8), first curve peaks at (x=8, y=12),
second curve peaks at (x=22, y=20), tail at (x=10, y=28).

### 5.2 Key Readable Details (at 32x32)

1. **Forked tongue** — two 1px pixels extending from the snout tip at 45-degree
   angles (one pixel left and up, one pixel right and up, from a 1px tongue stem).
   The tongue is `DANGER_RED` (`#C04040`). This is the most important detail —
   without it the snake reads as a worm.

2. **Diamond pattern on dorsal side** — alternating `STG` (Straw Gold) diamond
   shapes on the `DSN` base body. At 3px body width, each diamond is 2px wide by
   3px tall: `STG` at the center pixel of every other body segment.

3. **Distinct head** — the head must be noticeably wider than the body at the
   neck. Head: 4px wide. Neck immediately behind: 2px wide. This size contrast is
   the main way the player identifies which end is the front.

4. **Eyes** — single pixel `HYL` on the head, with `BLK` outline. The eye should
   be positioned on the upper-right of the head shape (snakes have lateral eyes).

5. **Body curve visible** — the curves of the S must be distinct. Do not draw the
   snake as a diagonal zigzag. The curves should be smooth — each consecutive row
   shifts the body center x by 1px maximum, creating a gradual arc.

### 5.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 15% |
| `DSN` | Body base | 30% |
| `TRC` | Body shadow (inside curves) | 10% |
| `WTN` | Body highlight (outside curves, catching light) | 8% |
| `STG` | Diamond pattern | 6% |
| `DUM` | Underside scales (belly row) | 5% |
| `HYL` | Eye | 1% |
| `DANGER_RED` | Tongue | 1% |

Note the high `BLK` outline percentage (15%): because the body is only 3px wide,
the outline pixels are proportionally more of the total than on a wider sprite.
This means the body fill colors have very little room — every fill pixel must count.

### 5.4 Shading Map

A 3px-wide body has limited shading room. Use this consistent rule across all body
segments:
- Left pixel of each body row: `WTN` highlight (upper-left light source)
- Center pixel: `DSN` base
- Right pixel: `TRC` shadow
- Exception: inside the curves, the highlight and shadow flip, because the inside
  of a curve faces away from the light source.

For the outside of a curve (the convex side): `WTN` — `DSN` — `TRC` (light to shadow)
For the inside of a curve (the concave side): `TRC` — `DSN` — `WTN` (shadow to light)

This single rule, applied consistently to every body segment based on which side
is convex/concave, creates the illusion of a cylindrical body without any additional
colors.

### 5.5 Animation Keyframes — S-Curve Undulation

The snake moves by shifting its S-curve forward. At 4 frames, the entire S-curve
body shifts its x-position along the spine by approximately 4px per frame (one
full wavelength every 4 frames).

**Frame 1**: S-curve in base position (as described in 5.1)
**Frame 2**: Every body segment's x position shifts 1px. The head moves along the
  curve toward its destination. The tail follows where the previous body segment was.
**Frame 3**: 2px total shift from Frame 1
**Frame 4**: 3px total shift from Frame 1

The implementation should calculate the spine as a list of (x,y) control points,
then shift the starting phase of the snake along that spine. This is best done with
a `bodyPhase` parameter (0-3) that the drawing function uses to index into a
pre-computed spine array.

### 5.6 Pixel Art Mistakes to Avoid

- **Do not make the body thinner than 3px**: At 2px, the snake becomes nearly
  invisible against any non-blank background. 3px is the minimum readable width.

- **Do not draw the tongue as a single pixel**: One pixel is a dot, not a tongue.
  The tongue needs the forked Y-shape (3 pixels total: 1 stem + 2 fork tips) to
  read as a tongue at all. The fork tips must use `DANGER_RED`.

- **Do not make the S-curve too tight**: If the snake curves sharply, the body
  segments become corners rather than curves. Each row should shift x by at most
  1px from the previous row. The snake spans 20+ rows of canvas, and the S must
  complete approximately 1.5 wavelengths within those rows.

- **Do not make the head the same width as the body**: The head must be 4px at its
  widest versus the 3px body. This 1px difference is the most important structural
  distinction on the sprite.

---

## Sprite 6: Bear

**Canvas**: 32x32 (should feel cramped — bear fills canvas edge to edge)
**File target**: `enemy_bear_walk`

### 6.1 Silhouette Description

The bear's silhouette is the bulkiest of all 32x32 sprites. It should fill
approximately 90% of the canvas width (29-30px) and 85% of the canvas height at
its widest point. The profile shows a massive rounded torso, a domed skull with
small rounded ears, short thick legs, and a very short tail that is essentially
invisible against the rump.

Critical shape feature: the bear has a distinct shoulder hump (1-2px higher than
the rump line) and a large domed skull approximately 12px wide. The muzzle extends
1-2px forward from the skull dome.

### 6.2 Key Readable Details (at 32x32)

1. **Shoulder hump** — the top silhouette edge must show a visible peak above
   the shoulder (approximately x=10-14, y=4) that is higher than both the head
   (y=5) and the rump (y=7). This hump is the bear's signature silhouette feature.

2. **Lighter muzzle** — the muzzle area (approximately 6px wide, 4px tall, centered
   on the face) should be `DSN` or `WTN` rather than the dark body `DUM`/`TRC`.
   This color break is essential to distinguish the face from the body mass.

3. **Visible claws** — each paw should end in 3 tiny `BLK` claw pixels (each 1px
   wide, 1px tall, spaced 1px apart). At 32x32, these are micro-details but they
   transform "brown rectangles" into bear paws.

4. **Small round ears** — two rounded ear bumps (each 2-3px wide, 2px tall) at the
   top of the skull. Use `DUM` for the outer ear, `TRC` for the inner ear.

5. **Dark nose** — a 2x1 `BLK` or `DUM` block at the muzzle tip. The nose is
   the darkest point on the face and draws the eye to the correct end of the sprite.

### 6.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 10% |
| `DUM` | Body primary (dark brown fur) | 35% |
| `TRC` | Body highlight (left flank, ear inner) | 15% |
| `WLT` | Deepest body shadow (right side, under belly) | 8% |
| `DSN` | Muzzle, paw pads | 8% |
| `WTN` | Muzzle highlight | 3% |
| `STW` | Eye white | 1% |
| `DUM` | Nose, claws | already counted above |

The bear uses a very dark, narrow palette — primarily `DUM`, `TRC`, `WLT`. This
makes it the darkest-colored enemy in the game, which reinforces its role as the
most threatening natural predator encounter.

### 6.4 Shading Map

**Body**: The light source hits the upper-left corner of the massive body.
- Left shoulder and upper-left body: `TRC` (lighter, catching light)
- Central body mass: `DUM`
- Right side and underside: `WLT` (the darkest non-outline tone)
- The transition from `TRC` to `DUM` should happen at approximately the center
  vertical axis (col 14-16 in canvas coordinates)

**Face**:
- Skull dome: `TRC` on the left half, `DUM` on the right — same left-light rule
- Ear outer: `DUM`, ear inner: `TRC`
- Muzzle: `DSN` base — lighter than the skull to create the muzzle-as-separate-form
  effect. Left muzzle edge: `WTN` highlight. Right muzzle edge: `DSN`.

**Legs**:
- Front face of each leg: `TRC`
- Rear of each leg: `WLT`
- Paw top: `TRC`
- Paw bottom pad: `DSN` with `BLK` claw pixels at leading edge

### 6.5 Animation Keyframes

The bear uses the same 4-frame diagonal gait but with the largest stride offsets
because its legs are shortest relative to its body (bear legs look stubby compared
to body mass):

**Frame 1**: Front-left and rear-right forward (+2px), other pair back (-2px)
**Frame 2**: Weight-load: all legs at neutral, body drops 1px
**Frame 3**: Front-right and rear-left forward (+2px), other pair back (-2px)
**Frame 4**: Weight-load return: all legs neutral, body drops 1px

**Bear-specific**: Add a head-bob to the bear walk. On frames 2 and 4 (weight-load),
the head drops 1px additional compared to the body. Bears move with a characteristic
head-swing when walking. This is a 1px shift on the head region only, separate from
the global bodyY offset.

### 6.6 Pixel Art Mistakes to Avoid

- **Do not make the bear smaller than 28px wide**: If the bear fits comfortably in
  the 32px canvas, it does not look massive. It should feel cramped. The outer
  outline pixels should touch x=1 on the left and x=30 on the right.

- **Do not use brown for the whole bear**: The bear palette is `DUM` (very dark
  near-black brown), not the warm `SBR` or `TRC` of the lion. A bear that looks
  like a dark lion is an art failure. The bear is DARK.

- **Do not forget the shoulder hump**: Without the hump, the bear reads as a fat
  dog or large boar. The hump is the single most important silhouette feature.

- **Do not skip the muzzle color break**: A `DUM`-colored face blends into a
  `DUM`-colored body. The lighter muzzle is not decorative — it is structural.

---

## Sprite 7: Wild Boar

**Canvas**: 32x32
**File target**: `enemy_boar_walk`, `enemy_boar_charge`

### 7.1 Silhouette Description

The boar is low and forward-thrusting. The head is large relative to the body — the
skull and snout account for approximately 40% of the sprite's total length. The body
is stocky and barrel-shaped with a humped back. Most importantly: the boar's silhouette
has a horizontal thrust. Where the bear is tall and wide, the boar is long and low.

The tusks are the boar's defining silhouette feature. Two white upward-curving arcs
(`STW`) extend from the corners of the snout, reaching approximately 3px above the
snout level. They are visible from any angle.

### 7.2 Key Readable Details (at 32x32)

1. **Tusks** — each tusk is a 3-4px arc in `STW` (near-white) curving upward from
   the jaw corners. They should be visible as curved lines, not single dots. Without
   clearly curved tusks, the boar reads as a generic pig.

2. **Bristled spine** — a row of 1px `DUM` spikes along the dorsal edge (spine
   line), 3-4 spikes total, each 1px tall. These irregular spikes break the smooth
   back silhouette and communicate "wild boar" vs "domestic pig."

3. **Snout disc** — the snout end is a flattened oval, 4px wide, in `TRC` or `DSN`
   with a `BLK` nose center. This is the character's focal point.

4. **Stocky legs** — four legs, each 3px wide, barely extending below the belly
   line. The boar is close to the ground. Legs should span only 4-5 rows.

5. **Small tail** — a tight curled S of 3 pixels at the rump. Use `SBN` for the
   tail. The curl (even just 3px) reads instantly as a pig tail.

### 7.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 11% |
| `SGG` | Body primary (grey-brown bristle) | 25% |
| `DUM` | Body shadow, spine bristles | 10% |
| `STW` | Tusks | 3% |
| `TRC` | Snout, underbelly | 8% |
| `WTN` | Body left-side highlight | 6% |
| `DSN` | Snout side, ear | 4% |

The boar uses a grey-brown palette (`SGG`, `DUM`, `TRC`) to create visual separation
from the bear (which is dark brown, `DUM`-heavy) and the wolf (which is cool grey,
`SGG`/`STW`-heavy). The boar sits between them: grey-brown with warm snout tones.

### 7.4 Shading Map

**Body**: Standard upper-left light.
- Left and top surfaces: `WTN` or `SGG` highlight
- Center: `SGG` mid
- Right and under: `DUM` shadow
- Dorsal spine: `DUM` with `BLK` bristle spikes above outline

**Head/Snout**: The head angles slightly downward (a charging boar leads with its
snout down).
- Top of skull: `SGG` with `WTN` highlight on upper-left 2 pixels
- Sides of skull: `SGG`
- Snout disc face: `TRC` with `DSN` shadow at bottom edge
- Under-snout: `DUM` (in shadow)

### 7.5 Animation Keyframes — Charge vs. Walk

**Walk cycle** (4 frames): Same diagonal gait as other quadrupeds, but with smaller
stride offsets (+/-1px) because the legs are short. The body does not bob much.
Primary animation is leg cycling.

**Charge cycle** (4 frames): Dramatically different from walk.
- Frame 1 (Load): Body shifts back 2px (weight loads onto rear). Head drops 1px.
  Rear legs push forward under body.
- Frame 2 (Launch): Body surges forward 1px. Head rises back to level.
  Front legs extend fully forward.
- Frame 3 (Sprint): Body at neutral position. All four legs are in mid-stride at
  maximum extension — front legs reach x+4, rear legs reach x-4. Hooves should
  show a 1px STG "spark" pixel adjacent to each hoof (contact flash).
- Frame 4 (Recover): Return to Frame 1 position, cycle repeats.

The charge animation is shorter in hold time than the walk: 80ms per frame vs 125ms.

### 7.6 Pixel Art Mistakes to Avoid

- **Do not draw the tusks as straight lines**: Straight white lines on a snout look
  like teeth, not tusks. Tusks curve. Each tusk should shift 1px in the curve
  direction over its 3-4px length.

- **Do not make the body taller than the head**: The boar's body sits low. If the
  body height exceeds the head height, the proportions feel off. Head and body should
  be approximately equal height in the canvas.

- **Do not use a full-size stride in the charge**: The charge animation's speed comes
  from the frame rate change (80ms vs 125ms), not from exaggerating the stride. An
  exaggerated stride at 4 frames looks choppy, not fast.

---

## Sprite 8: Philistine Scout

**Canvas**: 32x32
**File target**: `enemy_scout_walk`
**Current problem**: Does not exist yet

### 8.1 Silhouette Description

The scout is the first human enemy David encounters. Its silhouette must immediately
read as "human soldier, lighter armor." Key shape features:

- Head: slightly smaller relative to body than David's (less chibi, more proportional)
  — the Philistines look more like "real" warriors, David looks like a child underdog
- Helmet: a simple dome with a short feather fan extending from the crown (3-4px fan,
  angling right). The helmet adds 4-5px of visual height.
- Torso: leather jerkin, visible as a darker layer over the tunic beneath
- Spear: held diagonally in the right hand, shaft extending from roughly (x=20, y=4)
  down to (x=24, y=20). The spear tip at the top and the shaft at the bottom both
  extend past the figure's natural outline.
- Legs: slightly longer relative to torso than David's (adult proportions vs child)

### 8.2 Key Readable Details (at 32x32)

1. **Feathered helmet** — 3-4 `BLN` (Bleached Linen) pixel-wide strands fanning
   from the helmet crown. They must be clearly asymmetric (fanning, not a hat brim).
   Without the feathers, the scout reads as a generic armored human.

2. **The spear shaft** — a 1px-wide diagonal line running from upper-right to
   lower-center. Use `SBN` for the shaft, `PBR` for the bronze spear tip. The spear
   extends past the canvas top — only the lower 2/3 of the shaft is visible.

3. **Leather jerkin** — the torso color should show two layers: an outer `WLT`
   leather jerkin over an inner `FWV` or `BLN` tunic. Represent this as a 1px
   jerkin-edge visible at the tunic neckline and armholes.

4. **Distinct skin from David**: The scout's skin should be `DSN` (Desert Sienna)
   as base, not `SBR` (Sandy Brown). This Mediterranean-darker skin differentiates
   the Philistine humans from David visually.

5. **Alert posture** — the scout leans slightly forward (the body's center of mass
   is shifted 1px left/forward in the canvas). David stands upright; the scouts
   always look like they are about to spring into action.

### 8.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 11% |
| `WLT` | Leather jerkin, belt, boot | 15% |
| `ABR` | Bronze helmet | 8% |
| `PBR` | Helmet highlight, spear tip | 4% |
| `DSN` | Skin base | 12% |
| `TRC` | Skin shadow | 5% |
| `WTN` | Skin highlight | 3% |
| `FWV` | Tunic showing at collar, hem | 6% |
| `BLN` | Helmet plume | 4% |
| `SBN` | Spear shaft | 5% |
| `SGG` | Optional: stone detail on helmet | 2% |

### 8.4 Shading Map

**Helmet**: Bronze dome — same shading logic as Goliath's helmet but smaller.
- Left face: `PBR` highlight
- Center: `ABR` mid
- Right face: `DUM` shadow
- Plume strands: `BLN` fanning right, thicker at the base, 1px at tips

**Torso / Jerkin**:
- Jerkin left edge: `SBN` highlight (lighter edge catching light)
- Jerkin center: `WLT`
- Jerkin right edge: `DUM` shadow
- Tunic peeking out at collar: `BLN` (the brighter linen creates a nice light/dark
  contrast with the leather above and below it)

**Spear**: A 1px diagonal line. For each row the spear occupies, draw the shaft
pixel and 1 shadow pixel adjacent (on the right/lower side). Use `SBN` for the
shaft, `WLT` for the shadow. The tip: `PBR` with a `PWH` 1px specular.

### 8.5 Animation Keyframes — 4-Frame Walk

The scout uses the humanoid biped walk, but with a forward lean in all frames.

**Frame 1**: Right foot forward, left foot back. Right arm (spear arm) slightly back.
  Left arm slightly forward (counter-swing to spear).
**Frame 2**: Mid-stride. Both feet at neutral. Body at base height.
**Frame 3**: Left foot forward, right foot back. Left arm back, right arm (spear)
  swings slightly forward — the spear's tip angle changes by 1px as the arm moves.
**Frame 4**: Mid-stride return. Mirror of Frame 2.

**Spear animation note**: As the right arm swings, the spear shaft angle changes.
This means the spear diagonal line must be redrawn each frame with a 1px tip shift.
Frame 1: tip at (x=20, y=3). Frame 3: tip at (x=21, y=3). This 1px shift is subtle
but gives the spear a sense of mass that a completely static held object lacks.

### 8.6 Pixel Art Mistakes to Avoid

- **Do not make the scout the same height as David**: The scout should be 1-2px
  taller in total sprite height (longer legs). David is a boy; the scouts are adults.

- **Do not use `SBR` for the scout's skin**: `SBR` is David's skin color. It is a
  design rule — every character with `SBR` skin is an Israelite. Philistines use
  `DSN`. This is a systematic color-coding decision, not aesthetic preference.

- **Do not place feathers symmetrically**: Symmetrical feathers look like a hat brim.
  The feathers should all fan to the right from a single base point at the helmet
  crown, in a loose fan shape.

---

## Sprite 9: Philistine Archer

**Canvas**: 32x32
**File target**: `enemy_archer_walk`, `enemy_archer_attack`
**Current problem**: Does not exist yet

### 9.1 Silhouette Description

The archer is the scout's sibling — same Philistine visual language — but with these
key differences: no spear, lighter armor (tunic more visible than jerkin), and the
bow as the defining prop. The bow is a recurve curve extending from the left hand
upward (4-5px total arc visible). The archer's body turns slightly to present a
smaller profile to the player (a real archer's instinct).

### 9.2 Key Readable Details (at 32x32)

1. **The bow arc** — a 2-3px curved arc in `SBN` (Staff Brown). The arc should be
   visible as a curve, not a straight line. This requires at minimum 3 pixels to
   suggest a curve: one pixel left, one center, one right, with the center 1px
   indented from the endpoints. The string is a 1px vertical line in `BLK` from
   the upper tip to the lower tip.

2. **Feathered helmet** (same as scout) — `BLN` plume, same design, same specification.
   This visual match with the scout communicates "same army, different role."

3. **Slightly lighter jerkin** — the archer has less body armor. Show more of the
   tunic (`FWV` visible on the sides of the torso where the scout would have full
   leather coverage).

4. **Quiver at hip** — a 2x4 rectangle of `WLT` at the right hip, with 2-3 `SBN`
   vertical lines representing arrow fletching tops. This small detail completes the
   "archer" read when the bow is not in the attack animation frame.

### 9.3 Attack Animation — Draw-Hold-Release (5 frames)

**Frame 1 — Idle Draw**: Bow held at hip level, right hand at bowstring, not yet
  drawing. Bow arc faces left (the bow arm is the left arm, the string arm is right).

**Frame 2 — Draw**: Right arm pulls back 2px. Bowstring visually tightens (the
  string center moves 1px to the right, toward the drawing hand). Left arm (bow arm)
  extends 1px forward.

**Frame 3 — Full Draw (hold frame, 2x duration)**: Maximum draw. Right elbow is at
  maximum extension (shoulder level, arm horizontal). Bowstring center is 2px right
  of the bow body. Left arm fully extended. This frame holds for 200ms (2x normal
  duration) for gameplay clarity.

**Frame 4 — Release**: Bow arm snaps back 1px. String returns to neutral. Right arm
  starts returning. Arrow is no longer in the sprite — it has become a projectile
  sprite at this point.

**Frame 5 — Follow-through**: Both arms return to idle position. Body rocks back
  1px on this frame (recoil) before settling.

### 9.4 Pixel Art Mistakes to Avoid

- **Do not make the bow a straight vertical line**: A 1px vertical line is a rod,
  not a bow. Use at minimum a 3-pixel arc with the center pixel 1px to the left of
  the endpoints.

- **Do not skip the bowstring**: The `BLK` string line is what makes the bow
  readable as a bow. Without the string connecting the two tips, it looks like a
  bent stick.

- **Do not use the same animation timing for the draw as the walk**: The draw
  animation is asymmetric — Frame 3 (full draw) must hold longer than all other
  frames. This is both a gameplay signal (the player sees the telegraph) and a
  dramatic emphasis.

---

## Sprite 10: Philistine Soldier

**Canvas**: 32x32
**File target**: `enemy_soldier_walk`
**Current problem**: Does not exist yet

### 10.1 Silhouette Description

The soldier is the most armored regular human enemy. Its silhouette should read as
"heavily armored" — wider at the shoulders due to pauldrons, with the round shield
adding significant width to one side. The shield is on the left arm, making the
sprite asymmetric: left side extends further (shield) than right (spear arm).

The Philistine feathered crest is larger on the soldier than on the scout: 5-6
feather pixels vs 3-4, forming a more dramatic fan.

### 10.2 Key Readable Details (at 32x32)

1. **Round shield** — a circle of `ABR`/`PBR` approximately 8px in diameter on the
   left side of the sprite. The shield should overlap the left arm completely. It
   has a central boss (1px `PBR` highlight at center) and a rim of `DUM` shadow.
   The shield dominates the left half of the sprite below the shoulder.

2. **Bronze breastplate** — unlike the scout's leather, the soldier wears a full
   bronze breastplate. Use `ABR` as the breastplate body, `PBR` for the two breast
   ridges (left and right pectoral plates), and `DUM` for the gap between the plates.

3. **Full feathered crest** — 5-6 `BLN` feather pixels in a large arc from the
   helmet crown. The soldier's crest is the most dramatic of the three soldier types
   and is the key visual rank indicator.

4. **Spear** — same specification as the scout's spear. The spear must still be
   readable alongside the shield; position it extending from behind/to-the-right of
   the shield.

5. **Greaves** — like Goliath's but smaller: `ABR` shin covers on both legs,
   distinguished from the thigh skin by the color break at the knee.

### 10.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 10% |
| `ABR` | Breastplate, helmet, shield | 20% |
| `PBR` | Armor highlights | 8% |
| `DUM` | Armor shadow | 6% |
| `WLT` | Leather straps, arm padding | 8% |
| `DSN` | Skin (minimal — mostly covered by armor) | 6% |
| `BLN` | Plume | 5% |
| `SBN` | Spear shaft | 4% |

The soldier is the most bronze-dominant sprite in the regular enemy roster. It and
the shieldbearer should look like they belong together (same bronze/leather palette)
while differing in silhouette (soldier is taller and slimmer; shieldbearer is
shorter and wider with the massive rectangular shield).

### 10.4 Pixel Art Mistakes to Avoid

- **Do not center the shield on the body**: The shield is carried on the left arm.
  It should extend from approximately x=4 to x=12, while the body center is at
  x=16. The left-heavy silhouette is the soldier's defining pose.

- **Do not make the breastplate the same flat color as Goliath's scales**: The
  soldier has a breastplate, not scales. The breastplate has two smooth pectoral
  lobes with a vertical center crease. Represent the crease as a 1px `DUM` line.

---

## Sprite 11: Philistine Shieldbearer

**Canvas**: 32x32
**File target**: `enemy_shieldbearer_walk`
**Current problem**: Does not exist yet

### 11.1 Silhouette Description

The shieldbearer is unique in the entire enemy roster: its defining feature is that
the shield covers the majority of its own sprite. The shield is rectangular, held
front-and-center, and should cover approximately 60% of the sprite's visible area.
The enemy body (head, feet, weapon arm) peeks out around the shield edges.

This is an intentional gameplay-art merger: the player visually sees a "wall of
shield" approaching, which correctly communicates the gameplay reality (high HP,
difficult to damage from the front).

Shield size: 14px wide, 18px tall, centered at approximately (x=12-26, y=10-28).

### 11.2 Key Readable Details (at 32x32)

1. **The shield face** — the shield is the primary visual element. It must have:
   - A painted `NGT` (Night Blue) border/frame (1px thick around the shield edge)
   - The Philistine ship-bird emblem: a simple 4px-wide stylized bird shape in `PBR`
     centered on the shield face (2-3 body pixels, 2 wing pixels angling up)
   - A central horizontal bar in `DUM` dividing the shield into upper and lower halves
   - A `STW` central boss (the round metal shield center) at the middle of the shield

2. **Head visible above shield** — the helmet and feather plume must be visible
   above the shield top edge. Only 2-3 helmet pixels and the plume (3-4 `BLN` pixels)
   are visible. This "peek over the shield" silhouette is the shieldbearer's identity.

3. **Feet visible below shield** — 2-3px of each foot/greave visible below the
   shield bottom edge. The shieldbearer's movement is communicated only through
   these feet, so they must animate even though the rest of the body is hidden.

4. **Weapon arm to the right** — a short sword arm extends to the right of the
   shield. Only the right arm (from elbow to hand) and the sword (3px `SGG` blade)
   are visible to the right of the shield edge.

5. **Low HP variant** — cracks on the shield: add 2-3px diagonal `BLK` lines
   extending from the shield corners inward. This must be a separate sprite function
   parameter (a boolean `cracked` flag in the Lua drawing function).

### 11.3 Color Distribution

| Color | Region | Target % |
|-------|---------|----------|
| `BLK` | Outline | 10% |
| `ABR` | Shield face, helmet | 30% |
| `PBR` | Shield emblem, boss highlight | 6% |
| `NGT` | Shield border, emblem detail | 5% |
| `DUM` | Shield shadow, armor crevices | 8% |
| `STW` | Shield boss, eye white | 3% |
| `BLN` | Helmet plume (visible above shield) | 3% |
| `DSN` | Skin (face peeking above shield) | 3% |
| `SGG` | Short sword blade | 2% |
| `WLT` | Leather straps visible at edges | 3% |

### 11.4 Shading Map

**Shield face** — the shield is a slightly convex surface:
- Left third: `PBR` (catching upper-left light)
- Center: `ABR`
- Right third: `DUM` (shadow from the convex curve)
- The shield boss (`STW` circle at center, 2px diameter) has a `PWH` 1px specular

**Around the shield**:
- Upper portion (helmet above shield): same bronze dome shading as scout/soldier
- Left edge of shield: `PBR` — the very edge of the convex shield face catches
  the most direct light and should be the brightest point on the sprite
- Right edge of shield: `DUM` shadow

### 11.5 Death Animation: Shield Falls First

The shieldbearer's death animation (5 frames) is structurally different from all
other enemies:

**Frame 1**: Shield tilts 2px left at the top (rotates clockwise — falls forward).
  Body remains standing. Plume tilts with the shield.
**Frame 2**: Shield tilts further — top now 4px left of center, bottom 2px right.
  Shield is at 45 degrees effectively. Body starts to lean.
**Frame 3**: Shield contacts ground (is now horizontal — draw it as a wide flat
  trapezoid). Body lurches forward 1px, arm is outstretched.
**Frame 4**: Body begins to fall — legs bend (knees become visible as bent pixels).
  Shield is on the ground (1-2px visible at bottom of frame).
**Frame 5**: Body prone. Shield is a flat shape at frame bottom. Begin sparkle
  dissolve (add `HYL` sparkle pixels at sprite edges for the dissolve effect).

### 11.6 Pixel Art Mistakes to Avoid

- **Do not make the shield smaller than 14px wide**: A small shield makes the
  shieldbearer look like a regular soldier with a buckler. The shield must dominate.

- **Do not skip the painted emblem**: A plain bronze shield rectangle looks like
  generic armor. The ship-bird emblem (even as a rough 5px symbol) gives the
  Philistines cultural identity and makes this the most visually distinctive
  enemy in the game.

- **Do not show too much of the soldier body behind the shield**: If the body is
  clearly visible through/around the shield, the "walking wall" threat is lost.
  Only head (above), feet (below), and sword arm (right side) should be visible.

- **Do not animate the body independently of the shield**: The shield and body move
  as one unit in the walk animation. Only the feet animate under the shield.

---

## Cross-Sprite Consistency Rules

These rules apply to every sprite in this document and must be enforced during
implementation review:

### Color Identity System

This is a systematic color-coding decision that must not be violated:

| Color | Semantic Meaning | Who Uses It |
|-------|-----------------|-------------|
| `SBR` (Sandy Brown) skin | Israelite | David only |
| `DSN` (Desert Sienna) skin | Philistine human | Scout, Archer, Soldier, Shieldbearer |
| `HYL` (Harvest Yellow) eyes | Natural predator | Lion, Wolf only |
| `SKB` (Sky Blue) eyes | Divine/anointed | David only |
| `PBR` (Polished Bronze) armor | Philistine military | Scout helmet, Soldier, Shieldbearer, Goliath |
| `BLN` (Bleached Linen) plume | Philistine military rank | Scout, Archer, Soldier, Shieldbearer, Goliath |
| `DUM` (Dark Umber) eyes | Human enemy | Scout, Archer, Soldier (non-divine, non-predator) |

If any of these are violated in implementation, it is an art error that must be
corrected before the sprite ships.

### Outline Consistency

All sprites use `BLK` (`#1A0A00`) as the outer outline color. No exceptions.
Inner separating lines (between armor plates, between belt and robe) may use
`DUM` (`#3D1F00`) as a softer internal separator.

### Specular Consistency

The `PWH` (`#FFFFFF`) pure white specular dot appears ONLY on:
- Shiny bronze surfaces (Goliath's armor, soldier breastplate, shields)
- Wet surfaces (snake/wolf eyes, bear nose)
- Never on fabric, fur, or skin
- Maximum size: 1x1 pixel. If a surface needs a 2x2 specular, it is the wrong
  material type — use a 1px `STW` instead.

### Canvas Usage Targets

| Enemy | Minimum canvas fill |
|-------|---------------------|
| Goliath | 85% of 48x64 |
| Bear | 88% of 32x32 |
| Lion | 78% of 32x32 |
| Boar | 72% of 32x32 |
| Soldier/Shieldbearer | 70% of 32x32 |
| Wolf | 68% of 32x32 |
| Scout/Archer | 65% of 32x32 |
| Snake | 60% of 32x32 (S-curve inherently leaves corner space) |
| David | 55% of 32x32 (intentionally small — the underdog) |

These targets prevent the "floating spec on white" problem where sprites look tiny
and cheap in the game world.

---

## Implementation Priority

Write and test Lua scripts in this order. Earlier entries unblock later entries
(David must be correct before Goliath can be sized relative to him; animals must be
complete before Philistines, as the player encounters them in this order):

1. David (redesign existing) — foundation for proportion reference
2. Lion (redesign existing) — most existing code to improve
3. Wolf — simplest new animal (grey, lean, reuses lion gait logic)
4. Bear — most complex new animal (size, shading, hump)
5. Snake — unique movement, isolated system
6. Boar — charge animation needed for gameplay
7. Philistine Scout — first human enemy, sets template for 8-10
8. Philistine Archer — extends Scout with bow logic
9. Philistine Soldier — extends Scout with shield + breastplate
10. Philistine Shieldbearer — most complex human (shield-dominant design, cracked variant)
11. Goliath — last, most complex, 48x64 canvas, phase 2 variant

---

*Document complete. All specifications are ready for Lua implementation.*
*Next step: Implement `char_david_walk.lua` as the first test of the redesign spec.*
*Review the output against Section 1.7 (ASCII reference silhouette) before proceeding.*
