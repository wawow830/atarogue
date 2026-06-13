# TICKET-002: Add Brick System with Grid Layout and Collision

## Summary
Implemented a brick grid system and integrated ball-brick collision into the Atarogue game loop.

## Changes
- **src/brick.lua**: New Brick entity with:
  - `Brick.new(x, y, width, height, color)` constructor
  - `active` boolean field (default true)
  - `hit()` method that deactivates the brick and returns score value (10)
  - `draw()` that only renders active bricks and sets/restores color
- **main.lua**:
  - Added `Brick` require
  - Created 8x5 brick grid in `love.load()` with 4px gaps, centered horizontally
  - Row colors: red, orange, yellow, green, blue
  - Brick collision detection (AABB) in `love.update()`
  - Brick drawing loop in `love.draw()`
  - Removed `TODO: brick system` and `FIXME: collision is hacky` comments

## Testing
- Verified all Lua files pass `luajit -bl` syntax check
- Ran unit-style test for brick grid layout (40 bricks, correct positions)
- Confirmed `love .` starts without code errors (window creation blocked in headless env)

## PR
- https://github.com/wawow830/atarogue/pull/2
