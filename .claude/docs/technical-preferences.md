# Technical Preferences

<!-- Populated by /setup-engine. Updated as the user makes decisions throughout development. -->
<!-- All agents reference this file for project-specific standards and conventions. -->

## Engine & Language

- **Engine**: Valthorne 1.3.0 (LWJGL-based 2D Java engine)
- **Language**: Java
- **Rendering**: TextureBatch (instanced sprite batching, shader-driven)
- **Physics**: Custom (no built-in physics — collision detection rolled in-project)

## Naming Conventions

- **Classes**: PascalCase (e.g., `PlayerController`)
- **Variables**: camelCase (e.g., `moveSpeed`)
- **Methods**: camelCase (e.g., `takeDamage()`)
- **Events**: PascalCase suffixed with Event (e.g., `EnemyDeathEvent`)
- **Files**: PascalCase matching class name (e.g., `PlayerController.java`)
- **Packages**: lowercase dot-separated (e.g., `game.systems.combat`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_HEALTH`)

## Performance Budgets

- **Target Framerate**: 60 FPS
- **Frame Budget**: 16.6ms
- **Draw Calls**: Minimize via TextureBatch (target < 10 batches per frame)
- **Memory Ceiling**: [TO BE CONFIGURED — profile during prototype]

## Testing

- **Framework**: JUnit 5
- **Minimum Coverage**: Game jam scope — test balance formulas and core systems
- **Required Tests**: Balance formulas, gameplay systems

## Forbidden Patterns

- Fixed-function OpenGL (use TextureBatch, not raw GL calls)
- Hardcoded gameplay values (use config/data files)
- Blocking asset loads on the main thread (use Assets.loadAsync)

## Allowed Libraries / Addons

- Valthorne 1.3.0 (io.github.tehnewb:Valthorne:1.3.0)
- LWJGL (bundled with Valthorne)

## Architecture Decisions Log

- [No ADRs yet — use /architecture-decision to create one]
