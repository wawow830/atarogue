# TICKET-005: Game-Over Screen with Restart Button

## Summary
Added a game-over screen that appears when the player runs out of lives, with a restart option triggered by pressing SPACE.

## Changes
- **`main.lua`:**
  - Added `gameState` global variable, initialized to `"playing"`
  - In `love.update(dt)`: early return if `gameState == "gameover"`, skipping all game updates and collision
  - When ball falls below screen: decrement lives, and if `lives <= 0`, set `gameState = "gameover"` without resetting ball position
  - In `love.draw()`: draw a dark overlay (`{0, 0, 0, 0.7}`) and centered text for `"GAME OVER"`, score, and `"Press SPACE to restart"` when in gameover state
  - In `love.keypressed(key)`: if `gameState == "gameover"` and `key == "space"`, reset score, lives, ball, paddle to initial state and set `gameState = "playing"`
  - Removed "TODO: game over screen" and "TODO: pause" dead-code comments

## Files Modified
- `main.lua`

## Files NOT Modified
- `src/ball.lua` (kept exactly as-is per requirements)
- `src/paddle.lua` (kept exactly as-is per requirements)

## Testing
- Ran `love .` from project root
- No console errors
- Ball and paddle work normally during gameplay
- Game over screen appears after ball falls below screen 3 times
- Game over screen shows score, "GAME OVER", and "Press SPACE to restart"
- Pressing SPACE fully restarts the game
- Game does not continue updating while in game over state

## PR
- https://github.com/wawow830/atarogue/pull/5
