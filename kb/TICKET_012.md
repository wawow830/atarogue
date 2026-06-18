# TICKET-012 Enemy Spawner

## Summary
- Added falling enemy entities and an `EnemySpawner` that periodically creates enemies at the top of the screen.
- Enemies damage the player when they collide with the paddle/player and are then removed.
- Integrated with the TICKET-011 health API via `playerHealth:damage(amount)` and `playerHealth:update(dt)` when `src.health` is available.
- Kept a temporary `lives` fallback so this branch remains runnable before the health ticket is merged.

## Validation
- `luajit` module/smoke tests for enemy collision damage and health API calls.
- `timeout 5s love .` launched successfully and printed `Atarogue loaded!` with no console errors before timeout.
