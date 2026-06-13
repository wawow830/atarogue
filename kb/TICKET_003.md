# TICKET-003 — Refactor messy main.lua into clean state management system

## Summary
Extracted all game logic, drawing, and mutable state from `main.lua` into a dedicated `src/state.lua` module. This is a pure refactor: no new features, no changes to ball or paddle entities.

## Changes

### New file: `src/state.lua`
- `State` table with `__index` metatable
- `State.new()` initializes:
  - `ball`, `paddle`, `score`, `lives`, `paused`
  - Screen dimensions captured once (`screenWidth`, `screenHeight`)
  - All magic numbers stored as descriptive fields (`ballRadius`, `paddleYOffset`, `ballInitialVx`, etc.)
- `State:resetBall()` — resets ball position/velocity to starting values
- `State:reset()` — resets score, lives, and ball
- `State:update(dt)` — handles:
  - Paddle clamping to screen bounds
  - Ball wall bouncing (top, left, right)
  - Ball falling below screen → `resetBall()` + decrement lives
  - Ball-paddle collision
  - Respects `self.paused`
- `State:draw()` — handles:
  - Title, score, lives text
  - Ball and paddle draw calls

### Modified: `main.lua`
- Single global: `gameState = State.new()`
- `love.update(dt)` delegates to `gameState:update(dt)` (skips when paused)
- `love.draw()` delegates to `gameState:draw()`
- `love.keypressed("space")` toggles `gameState.paused`
- Removed all BROWNFIELD/TODO/FIXME comments
- Consolidated remaining future TODOs (powerup, brick, level progression, game over) at the top of the file

### Unchanged
- `src/ball.lua` — no modifications
- `src/paddle.lua` — no modifications
- `conf.lua` — no modifications

## Testing
- `love .` runs with no console errors
- Ball moves, bounces off walls, resets when falling below screen
- Paddle moves left/right and clamps to screen bounds
- Score and lives display correctly
- Spacebar pauses and resumes the game
- Behavior is identical to pre-refactor

## PR
- https://github.com/wawow830/atarogue/pull/3
