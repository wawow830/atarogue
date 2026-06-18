# TICKET-005: Add Game-Over Screen with Restart Button

## Status
Done

## PR
- https://github.com/wawow830/atarogue/pull/6

## Summary
Added a game-over screen that appears when the player runs out of lives (ball drops below the screen 3 times). The screen displays "Game Over" text and a "Restart" button that resets the game state and returns to gameplay.

## Files Changed
- `src/gameover.lua` — new entity for the game-over screen overlay
- `main.lua` — game state management, reset logic, input handling

## Key Decisions
- Used a simple `gameState` string global (`"playing"` / `"gameover"`) rather than a full state machine, consistent with the existing brownfield approach.
- `resetGame()` centralizes all reset logic so restart is a single function call.
- Game Over entity follows the `local Entity = {}` with `__index` pattern.
- Mouse click and keyboard (Enter/Space) both trigger restart.

## Testing
- Ran `love .` and verified no console errors.
- Gameplay state pauses correctly when gameover is active.
