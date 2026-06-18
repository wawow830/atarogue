# TICKET-015 Save/Load and High Scores

## Summary
- Added `src/persistence.lua` for Love2D-friendly save game and high score persistence using `love.filesystem`.
- Added F5/S save and F9/L load hotkeys in `main.lua`.
- Added automatic high score recording when lives reach zero, plus top-score display.
- Save snapshots include ball, paddle, score, lives, level, brick data, and power-up data.

## Cross-worker compatibility
- TICKET-013 scoring/brick support:
  - Persists `score` plus richer `scoring`/`scoreState`/`scoreData` tables if present.
  - Persists `level:toSaveData()` / restores with `level:fromSaveData()` when available.
  - Falls back to raw `bricks` / `brickState` persistence.
- TICKET-014 power-up support:
  - Persists `powerUps`, `powerups`, `activePowerUps`, or `powerUpState` without field renames.
  - Rehydrates saved `src.powerup` instances with their module metatable when available.

## Controls
- `F5` or `S`: save game to `savegame.lua`.
- `F9` or `L`: load game from `savegame.lua`.

## Validation
- Ran LuaJIT module/syntax checks for `main.lua` and `src/persistence.lua`.
