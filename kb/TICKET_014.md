# TICKET-014 — Power-ups from broken bricks

## Summary
- Added `src/powerup.lua` with falling collectible power-ups.
- Power-ups roll from broken bricks via `PowerUp.rollFromBrick(brick)` / `spawnPowerUpFromBrick(brick)`.
- Current power-ups: wide paddle, slow ball, extra life.
- Integrated power-up update, draw, paddle collection, and level/brick hit hooks in `main.lua`.

## Brick API dependency
Worker A's brick collision returns a hit result from `Level:handleBallCollision(ball)` / `Brick:hit()` with:
- `destroyed` boolean
- `score`
- `brick` reference
- `brickType`

Power-ups spawn only when `destroyed == true`, using the brick's `x`, `y`, `width`, and `height`.

## Validation
- `luajit` syntax checks for `main.lua` and `src/powerup.lua`.
- Headless smoke run: `timeout 3s love .` loaded successfully.
