# TICKET-001: Integrate ball and paddle into main.lua

## Status
Completed. Pushed to branch `worktree/TICKET-001` and PR opened to `master`.

## Changes Made
- Modified `main.lua`:
  - `require("src.ball")` and `require("src.paddle")` loaded at top.
  - `love.load()` creates a `Ball` and `Paddle` at sensible positions (paddle bottom center, ball just above).
  - `love.update(dt)` calls `ball:update(dt)` and `paddle:update(dt)`.
  - `love.draw()` calls `ball:draw()` and `paddle:draw()`.
  - Added ball bounce off top, left, and right screen edges.
  - Ball resets to starting position when falling off bottom.
  - Added basic ball-paddle collision (AABB vs circle approximation).
  - Paddle is clamped to screen bounds.

## Testing
- Ran `love .` from project root. No console errors. Game window opens and entities are visible.

## Branch
`worktree/TICKET-001`

## PR
https://github.com/wawow830/atarogue/pull/1

## Human Review Needed
- Ball-paddle collision uses a simple AABB approximation; may want more refined physics later.
- Ball reset on bottom is instantaneous; consider adding lives or a delay.
