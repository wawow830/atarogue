# TICKET-013 -- Brick System, Levels, and Scoring

## Summary
Implemented the v1.0 brick foundation for Atarogue:
- `src/brick.lua`: brick entity with typed HP, score values, colors, hit/destroy behavior, and save data helpers.
- `src/level.lua`: level manager with authored brick patterns, collision handling, scoring, clear bonuses, progression, draw/update hooks, and save data helpers.
- `main.lua`: integrated levels into gameplay, brick collision, scoring HUD, level HUD, clear progression, ball reset, paddle angle response, and game-over restart.

## Brick API
- `local Brick = require("src.brick")`
- `Brick.new(x, y, width, height, typeId)`
- `brick:hit(damage)` returns `{ hit, destroyed, score, brick }`
- `brick:isAlive()` / `brick:isBreakable()`
- `brick:toSaveData()` and `Brick.fromSaveData(data)`

Brick types: `basic`, `tough`, `crystal`, `stone`, `steel` (indestructible).

## Level API
- `local Level = require("src.level")`
- `Level.new(screenWidth)`
- `level:load(number)`
- `level:update(dt)` / `level:draw()`
- `level:handleBallCollision(ball)` returns a brick hit result or `nil`.
  - Destroy results include `brickType`, `x`, `y`, `score`, and `level`, intended as the hook for power-up spawning.
- `level:remainingBreakableBricks()` / `level:isCleared()` / `level:advance()`
- `level:toSaveData()` and `level:fromSaveData(data)`

## Notes for Parallel Tickets
- Power-ups can listen for `local hit = level:handleBallCollision(ball)` in `main.lua`; when `hit.destroyed` is true, spawn at `hit.x`, `hit.y` and inspect `hit.brickType`.
- Save/load can persist `level:toSaveData()` plus globals like `score`, `lives`, `ball`, and `paddle`; restore level via `level:fromSaveData(saved.level)`.

## Validation
- `luajit` syntax/API smoke tests passed.
- `timeout 3 love .` booted successfully and printed `Atarogue loaded!` before timeout stopped the app.
