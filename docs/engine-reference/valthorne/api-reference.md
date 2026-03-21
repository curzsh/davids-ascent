# Valthorne 1.3.0 API Reference

> **Verified from JAR: 2026-03-21**
> This reference was verified against the actual Valthorne 1.3.0 JAR package
> structure. All import paths reflect the real class locations. Wiki-based
> descriptions have been preserved where accurate, but all packages and class
> names are confirmed correct.

*Source: JAR inspection + https://github.com/tehnewb/Valthorne/wiki*

---

## Core (`valthorne`)

| Class | Description |
|-------|-------------|
| `valthorne.Application` | Interface: `init()`, `update(float delta)`, `render()`, `dispose()` |
| `valthorne.JGL` | Runtime controller — initialization, main loop, event bus, frame timing |
| `valthorne.Window` | Window management (size, title, display mode) |
| `valthorne.Keyboard` | Keyboard input polling and event registration |
| `valthorne.Mouse` | Mouse input polling and event registration |
| `valthorne.Audio` | Audio system initialization and management |

### Application Lifecycle

```java
import valthorne.Application;
import valthorne.JGL;

public class Game implements Application {
    @Override public void init() { /* one-time startup */ }
    @Override public void update(float delta) { /* per-frame logic */ }
    @Override public void render() { /* per-frame drawing */ }
    @Override public void dispose() { /* cleanup */ }
}

// Launch
JGL.init(new Game(), "My Game", 1280, 720);
```

### JGL Timing

| Method | Returns |
|--------|---------|
| `JGL.getDeltaTime()` | Seconds since last frame (float) |
| `JGL.getFramesPerSecond()` | Current FPS (int) |
| `JGL.getTime()` | Total seconds since init |

### JGL Event Bus

```java
JGL.subscribe(MyEvent.class, listener);
JGL.unsubscribe(MyEvent.class, listener);
JGL.publish(new MyEvent());
```

### Keyboard Input

```java
import valthorne.Keyboard;

if (Keyboard.isKeyDown(Keyboard.W)) { /* move up */ }
if (Keyboard.isKeyDown(Keyboard.SPACE)) { /* action */ }
if (Keyboard.isShiftDown()) { /* sprint */ }
if (Keyboard.isCtrlDown()) { /* modifier */ }
```

Key constants: `Keyboard.W`, `Keyboard.A`, `Keyboard.S`, `Keyboard.D`,
`Keyboard.SPACE`, `Keyboard.ESCAPE`, `Keyboard.UP`, `Keyboard.DOWN`,
`Keyboard.LEFT`, `Keyboard.RIGHT`, etc.

### Mouse Input

```java
import valthorne.Mouse;

float mx = Mouse.getX();
float my = Mouse.getY();
boolean left = Mouse.isButtonDown(Mouse.LEFT);
float scrollX = Mouse.getScrollX();
float scrollY = Mouse.getScrollY();
```

---

## Graphics (`valthorne.graphics`)

| Class | Import | Description |
|-------|--------|-------------|
| `Sprite` | `valthorne.graphics.Sprite` | Renderable object with transform, tint, flip |
| `Color` | `valthorne.graphics.Color` | RGBA color representation |
| `Drawable` | `valthorne.graphics.Drawable` | Interface for drawable objects |
| `DrawFunction` | `valthorne.graphics.DrawFunction` | Functional draw callback |

### Sprites

```java
import valthorne.graphics.Sprite;

Sprite sprite = new Sprite(texture);
sprite.setPosition(x, y);
sprite.setSize(width, height);
sprite.setScale(scaleX, scaleY);
sprite.setRotation(degrees);
sprite.setOriginCenter();
sprite.setColor(r, g, b, a);
sprite.setFlipX(true);
sprite.draw(batch);
```

---

## Textures (`valthorne.graphics.texture`)

| Class | Import |
|-------|--------|
| `Texture` | `valthorne.graphics.texture.Texture` |
| `TextureData` | `valthorne.graphics.texture.TextureData` |
| `TextureRegion` | `valthorne.graphics.texture.TextureRegion` |
| `TextureAtlas` | `valthorne.graphics.texture.TextureAtlas` |
| `TextureBatch` | `valthorne.graphics.texture.TextureBatch` |
| `TextureFilter` | `valthorne.graphics.texture.TextureFilter` |
| `TexturePacker` | `valthorne.graphics.texture.TexturePacker` |
| `TextureLoader` | `valthorne.graphics.texture.TextureLoader` |
| `TextureParameters` | `valthorne.graphics.texture.TextureParameters` |
| `FrameBuffer` | `valthorne.graphics.texture.FrameBuffer` |
| `NinePatchTexture` | `valthorne.graphics.texture.NinePatchTexture` |

### Loading and Drawing

```java
import valthorne.graphics.texture.Texture;
import valthorne.graphics.texture.TextureBatch;
import valthorne.graphics.texture.TextureRegion;

Texture tex = new Texture("assets/player.png");
TextureBatch batch = new TextureBatch(5000);

batch.begin();
batch.draw(tex, x, y, width, height);
batch.drawRegion(region, x, y, width, height);
batch.end();

tex.dispose();
```

### Filtering

- `TextureFilter.NEAREST` — pixel-perfect (pixel art)
- `TextureFilter.LINEAR` — smooth scaling

### Clipping

```java
batch.beginScissor(x, y, w, h);
// draw clipped content
batch.endScissor();
```

### Texture Regions and Atlases

- `TextureRegion` — sub-rectangle of a texture (for sprite sheets)
- `TextureAtlas` — packed sprite sheet with named regions
- `NinePatchTexture` — stretchable texture for UI backgrounds

---

## Fonts (`valthorne.graphics.font`)

| Class | Import |
|-------|--------|
| `Font` | `valthorne.graphics.font.Font` |
| `FontData` | `valthorne.graphics.font.FontData` |
| `FontLoader` | `valthorne.graphics.font.FontLoader` |
| `FontParameters` | `valthorne.graphics.font.FontParameters` |
| `FontSource` | `valthorne.graphics.font.FontSource` |
| `FontStyler` | `valthorne.graphics.font.FontStyler` |
| `Glyph` | `valthorne.graphics.font.Glyph` |
| `GlyphContext` | `valthorne.graphics.font.GlyphContext` |
| `GlyphStyle` | `valthorne.graphics.font.GlyphStyle` |

Load via `FontParameters` through the asset system. Render text via TextureBatch.

---

## Particles (`valthorne.graphics.particle`)

| Class | Import |
|-------|--------|
| `Particle` | `valthorne.graphics.particle.Particle` |
| `ParticleEmitter` | `valthorne.graphics.particle.ParticleEmitter` |
| `ParticleSystem` | `valthorne.graphics.particle.ParticleSystem` |
| `SpawnDistributor` | `valthorne.graphics.particle.SpawnDistributor` |

### Spawn Distributors

All in `valthorne.graphics.particle`: `Box`, `Circle`, `Cone`, `Line`, `Point`,
`RadialBurst`, `RectEdge`, `Ring`, `Spiral`.

CPU-based pooled particle system. Each `Particle` stores position, velocity, age,
life, rotation, scale interpolation (start/end), and color interpolation (start/end).
Particles implement `Poolable` for allocation-free reuse.

---

## Shaders (`valthorne.graphics.shader`)

| Class | Import |
|-------|--------|
| `Shader` | `valthorne.graphics.shader.Shader` |
| `BlurShader` | `valthorne.graphics.shader.BlurShader` |
| `BurnShader` | `valthorne.graphics.shader.BurnShader` |
| `FlashShader` | `valthorne.graphics.shader.FlashShader` |
| `GlowShader` | `valthorne.graphics.shader.GlowShader` |
| `OutlineShader` | `valthorne.graphics.shader.OutlineShader` |
| `ReflectionShader` | `valthorne.graphics.shader.ReflectionShader` |
| `WaterShader` | `valthorne.graphics.shader.WaterShader` |

TextureBatch auto-flushes on shader change. Custom shaders must support the batch
vertex attributes.

---

## Animation (`valthorne.graphics.animation`)

| Class | Import |
|-------|--------|
| `Animation` | `valthorne.graphics.animation.Animation` |
| `AnimationFrame` | `valthorne.graphics.animation.AnimationFrame` |
| `AnimationListener` | `valthorne.graphics.animation.AnimationListener` |
| `PlaybackMode` | `valthorne.graphics.animation.PlaybackMode` |

---

## Tiled Maps (`valthorne.graphics.map.tiled`)

| Class | Import |
|-------|--------|
| `TiledMap` | `valthorne.graphics.map.tiled.TiledMap` |
| `TiledMapData` | `valthorne.graphics.map.tiled.TiledMapData` |
| `TiledMapLoader` | `valthorne.graphics.map.tiled.TiledMapLoader` |
| `TiledMapParameters` | `valthorne.graphics.map.tiled.TiledMapParameters` |
| `MapLayer` | `valthorne.graphics.map.tiled.MapLayer` |
| `MapChunk` | `valthorne.graphics.map.tiled.MapChunk` |
| `TileSet` | `valthorne.graphics.map.tiled.TileSet` |
| `TileDefinition` | `valthorne.graphics.map.tiled.TileDefinition` |

Additional tiled classes exist in this package for tile properties, object layers,
and map rendering.

---

## Camera (`valthorne.camera`)

| Class | Import | Description |
|-------|--------|-------------|
| `Camera` | `valthorne.camera.Camera` | Abstract base camera |
| `OrthographicCamera` | `valthorne.camera.OrthographicCamera` | Standard 2D camera |
| `UIOrthographicCamera` | `valthorne.camera.UIOrthographicCamera` | Top-left origin, inverted Y for UI |

```java
import valthorne.camera.OrthographicCamera;
import valthorne.math.Matrix4f;

OrthographicCamera camera = new OrthographicCamera();
camera.setCenter(playerX, playerY);
camera.setZoom(1.0f);
Matrix4f projection = camera.getProjection();
```

---

## Viewports (`valthorne.viewport`)

| Class | Import | Aspect | Bars | Distortion |
|-------|--------|--------|------|------------|
| `Viewport` | `valthorne.viewport.Viewport` | Base class | — | — |
| `FitViewport` | `valthorne.viewport.FitViewport` | Fixed | Yes | No |
| `FillViewport` | `valthorne.viewport.FillViewport` | Fixed | No (crops) | No |
| `ScreenViewport` | `valthorne.viewport.ScreenViewport` | 1:1 | No | No |
| `StretchViewport` | `valthorne.viewport.StretchViewport` | No | No | Yes |

```java
import valthorne.viewport.FitViewport;
import valthorne.math.Vector2f;

FitViewport viewport = new FitViewport(800, 600);
viewport.update(windowWidth, windowHeight);
Vector2f world = viewport.screenToWorld(mouseX, mouseY);
```

---

## Scene Management (`valthorne.scene`)

| Class | Import | Description |
|-------|--------|-------------|
| `Scene` | `valthorne.scene.Scene` | Base scene class |
| `GameScreen` | `valthorne.scene.GameScreen` | Built-in scene/screen management |

---

## State Machine (`valthorne.state`)

| Class | Import |
|-------|--------|
| `StateMachine` | `valthorne.state.StateMachine` |
| `State` | `valthorne.state.State` |
| `StateContext` | `valthorne.state.StateContext` |
| `Transition` | `valthorne.state.Transition` |
| `TransitionAction` | `valthorne.state.TransitionAction` |
| `Guard` | `valthorne.state.Guard` |
| `Condition` | `valthorne.state.Condition` |
| `Trigger` | `valthorne.state.Trigger` |

---

## Event System (`valthorne.event`)

### Core

| Class | Import |
|-------|--------|
| `Event` | `valthorne.event.Event` |
| `EventListener` | `valthorne.event.EventListener` |
| `EventPriority` | `valthorne.event.EventPriority` |
| `EventPublisher` | `valthorne.event.EventPublisher` |

### Built-in Events (`valthorne.event.events`)

| Event | Description |
|-------|-------------|
| `KeyPressEvent` | Key pressed |
| `KeyReleaseEvent` | Key released |
| `KeyEvent` | Base key event |
| `MouseMoveEvent` | Cursor movement (no buttons) |
| `MouseDragEvent` | Movement with button held |
| `MousePressEvent` | Mouse button pressed |
| `MouseReleaseEvent` | Mouse button released |
| `MouseScrollEvent` | Scroll wheel |
| `WindowResizeEvent` | Window resized |

### Listener Adapters (`valthorne.event.listeners`)

| Class | Import |
|-------|--------|
| `KeyAdapter` | `valthorne.event.listeners.KeyAdapter` |
| `KeyListener` | `valthorne.event.listeners.KeyListener` |
| `MouseAdapter` | `valthorne.event.listeners.MouseAdapter` |
| `MouseListener` | `valthorne.event.listeners.MouseListener` |
| `MouseScrollListener` | `valthorne.event.listeners.MouseScrollListener` |
| `WindowResizeListener` | `valthorne.event.listeners.WindowResizeListener` |

### Usage

```java
import valthorne.event.Event;
import valthorne.event.EventListener;
import valthorne.event.EventPublisher;

public class EnemyDeathEvent extends Event {
    private final Enemy enemy;
    public EnemyDeathEvent(Enemy enemy) { this.enemy = enemy; }
    public Enemy getEnemy() { return enemy; }
}

EventPublisher bus = new EventPublisher();
bus.register(EnemyDeathEvent.class, new ScoreListener());
bus.publish(new EnemyDeathEvent(deadEnemy));
```

- `@EventPriority(priority = 10)` — higher runs first (default 0)
- `event.consume()` — stops further listener execution
- Override `canHandle()` to filter without consuming

---

## Audio / Sound (`valthorne.sound`)

| Class | Import |
|-------|--------|
| `SoundData` | `valthorne.sound.SoundData` |
| `SoundPlayer` | `valthorne.sound.SoundPlayer` |
| `SoundSource` | `valthorne.sound.SoundSource` |
| `SoundLoader` | `valthorne.sound.SoundLoader` |
| `SoundParameters` | `valthorne.sound.SoundParameters` |
| `SoundDecoder` | `valthorne.sound.SoundDecoder` |
| `Mp3Decoder` | `valthorne.sound.Mp3Decoder` |
| `OggDecoder` | `valthorne.sound.OggDecoder` |
| `WaveDecoder` | `valthorne.sound.WaveDecoder` |
| `SoundFileFormat` | `valthorne.sound.SoundFileFormat` |

```java
import valthorne.sound.SoundData;
import valthorne.sound.SoundPlayer;

SoundData data = SoundData.load("assets/hit.wav"); // WAV, OGG, or MP3
SoundPlayer player = new SoundPlayer(data);

player.play();
player.setVolume(0.5f);     // 0.0 - 1.0
player.setPitch(1.2f);       // 0.1 - 8.0
player.setLooping(true);     // for music/ambience
player.seek(5.0f);           // jump to 5 seconds

player.dispose();
```

Reuse `SoundPlayer` instances when possible. Pool for simultaneous SFX.

---

## Assets (`valthorne.asset`)

| Class | Import |
|-------|--------|
| `Assets` | `valthorne.asset.Assets` |
| `AssetLoader` | `valthorne.asset.AssetLoader` |
| `AssetParameters` | `valthorne.asset.AssetParameters` |

### Async Loading

```java
import valthorne.asset.Assets;
import valthorne.graphics.texture.TextureParameters;
import valthorne.graphics.texture.Texture;

Assets.loadAsync(new TextureParameters("player.png"), Texture.class)
    .thenAccept(texture -> { /* use texture */ });
```

### Batch Loading

```java
Assets.resetProgress();
Assets.prepare(new TextureParameters("player.png"), Texture.class);
Assets.prepare(new SoundParameters("hit.wav"), SoundData.class);
Assets.load();

float progress = Assets.getProgress(); // 0.0 - 1.0
Texture tex = Assets.get("player.png", Texture.class);
```

### Built-in Loaders

- `TextureParameters` (`valthorne.graphics.texture`) -> `Texture`
- `SoundParameters` (`valthorne.sound`) -> `SoundData`
- `FontParameters` (`valthorne.graphics.font`) -> `Font`

---

## Math (`valthorne.math`)

| Class | Import | Description |
|-------|--------|-------------|
| `MathUtils` | `valthorne.math.MathUtils` | Common math helpers |
| `Matrix4f` | `valthorne.math.Matrix4f` | 4x4 float matrix (projection, transforms) |
| `Vector2f` | `valthorne.math.Vector2f` | 2D float vector |

---

## Geometry (`valthorne.math.geometry`)

| Class | Import |
|-------|--------|
| `Shape` | `valthorne.math.geometry.Shape` (abstract) |
| `Circle` | `valthorne.math.geometry.Circle` |
| `Rectangle` | `valthorne.math.geometry.Rectangle` |
| `Polygon` | `valthorne.math.geometry.Polygon` |
| `Triangle` | `valthorne.math.geometry.Triangle` |
| `Area` | `valthorne.math.geometry.Area` |
| `Border` | `valthorne.math.geometry.Border` |

---

## Pooling (`valthorne.io.pool`)

| Class | Import | Description |
|-------|--------|-------------|
| `Pool` | `valthorne.io.pool.Pool` | Object pool for allocation-free reuse |
| `Poolable` | `valthorne.io.pool.Poolable` | Interface for poolable objects |

---

## Collections (`valthorne.collections`)

### Arrays (`valthorne.collections.array`)

| Class | Description |
|-------|-------------|
| `Array` | Generic resizable array |
| `SwapOnRemoveArray` | Array with O(1) removal (swap with last element) |

Primitive variants also available (IntArray, FloatArray, etc.).

### Stacks (`valthorne.collections.stack`)

| Class | Description |
|-------|-------------|
| `FastStack` | Generic stack implementation |

Primitive variants also available.

### Bits (`valthorne.collections.bits`)

| Class | Description |
|-------|-------------|
| `Bits` | Bitset implementation |

Primitive variants also available.

### Maps (`valthorne.collections.map`)

| Class | Description |
|-------|-------------|
| `StringObjectMap` | String-keyed object map |

### Trees (`valthorne.collections.tree`)

| Class | Description |
|-------|-------------|
| `IntBinaryTree` | Integer binary tree |

---

## UI System (`valthorne.ui`)

### Core

| Class | Import |
|-------|--------|
| `UIRoot` | `valthorne.ui.UIRoot` |
| `UINode` | `valthorne.ui.UINode` |
| `UIContainer` | `valthorne.ui.UIContainer` |
| `Layout` | `valthorne.ui.Layout` |
| `LayoutValue` | `valthorne.ui.LayoutValue` |
| `Dimensional` | `valthorne.ui.Dimensional` |
| `Locatable` | `valthorne.ui.Locatable` |
| `Sizeable` | `valthorne.ui.Sizeable` |
| `NodeAction` | `valthorne.ui.NodeAction` |
| `UIConstants` | `valthorne.ui.UIConstants` |

### Layout Enums (`valthorne.ui.enums`)

`Align`, `Alignment`, `FlexDirection`, `FlexWrap`, `JustifyContent`,
`LayoutUnit`, `Overflow`, `PositionType`

### UI Nodes (`valthorne.ui.nodes`)

| Widget | Import |
|--------|--------|
| `Button` | `valthorne.ui.nodes.Button` |
| `Checkbox` | `valthorne.ui.nodes.Checkbox` |
| `Grid` | `valthorne.ui.nodes.Grid` |
| `Image` | `valthorne.ui.nodes.Image` |
| `Label` | `valthorne.ui.nodes.Label` |
| `Modal` | `valthorne.ui.nodes.Modal` |
| `Panel` | `valthorne.ui.nodes.Panel` |
| `ProgressBar` | `valthorne.ui.nodes.ProgressBar` |
| `ScrollPanel` | `valthorne.ui.nodes.ScrollPanel` |
| `Slider` | `valthorne.ui.nodes.Slider` |
| `TextField` | `valthorne.ui.nodes.TextField` |
| `Tooltip` | `valthorne.ui.nodes.Tooltip` |

### Theming (`valthorne.ui.theme`)

| Class | Import |
|-------|--------|
| `Theme` | `valthorne.ui.theme.Theme` |
| `ThemeData` | `valthorne.ui.theme.ThemeData` |
| `ThemeRule` | `valthorne.ui.theme.ThemeRule` |
| `StyleKey` | `valthorne.ui.theme.StyleKey` |
| `StyleMap` | `valthorne.ui.theme.StyleMap` |
| `StyleState` | `valthorne.ui.theme.StyleState` |
| `ResolvedStyle` | `valthorne.ui.theme.ResolvedStyle` |
| `ThemeListener` | `valthorne.ui.theme.ThemeListener` |
| `ThemeDataChangeEvent` | `valthorne.ui.theme.ThemeDataChangeEvent` |

---

## Utilities

### General (`valthorne.utility`)

| Class | Import |
|-------|--------|
| `FileUtility` | `valthorne.utility.FileUtility` |
| `NumberUtility` | `valthorne.utility.NumberUtility` |
| `ReflectionUtility` | `valthorne.utility.ReflectionUtility` |
| `TextUtility` | `valthorne.utility.TextUtility` |
| `TimeUtility` | `valthorne.utility.TimeUtility` |

### IO / Buffers (`valthorne.io.buffer`)

| Class | Import |
|-------|--------|
| `DynamicByteBuffer` | `valthorne.io.buffer.DynamicByteBuffer` |
| `ByteOrder` | `valthorne.io.buffer.ByteOrder` |

### File System (`valthorne.io.file`)

| Class | Import |
|-------|--------|
| `ValthorneFiles` | `valthorne.io.file.ValthorneFiles` |

---

## Timing (`valthorne.tick`)

| Class | Import | Description |
|-------|--------|-------------|
| `Tick` | `valthorne.tick.Tick` | Timing utilities |

---

## Plugins (`valthorne.plugin`)

| Class | Import | Description |
|-------|--------|-------------|
| `Plugin` | `valthorne.plugin.Plugin` | Plugin interface |
| `PluginLoader` | `valthorne.plugin.PluginLoader` | Plugin discovery and loading |
