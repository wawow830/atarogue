# Atarogue Knowledge Base

## Project
Roguelike Atari Breakout in Love2D. Break bricks, gain roguelike upgrades, descend levels.

## Current State
- Ball and paddle are integrated into main.lua
- All game logic lives in `src/state.lua` (clean state management)
- Ball bounces off walls, resets when falling below screen, decreases lives
- Paddle can be moved left/right and is clamped to screen bounds
- Score and lives globals live on `gameState` (single global in main.lua)
- Pause/resume works with spacebar
- No bricks, no ball-brick collision
- TODOs consolidated at top of main.lua for: powerup system, brick system, level progression, game over screen

## Tickets
- [TICKET-001](TICKET_001.md) -- Integrate ball and paddle into main.lua
- [TICKET-003](TICKET_003.md) -- Refactor messy main.lua into clean state management system

## Decisions
- Keep it simple: pure Lua, no external libs
- Screen size: 800x600
- One entity per file in `src/`
- All game state lives in `src/state.lua`; `main.lua` is the thin entry point
