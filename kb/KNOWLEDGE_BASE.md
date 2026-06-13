# Atarogue Knowledge Base

## Project
Roguelike Atari Breakout in Love2D. Break bricks, gain roguelike upgrades, descend levels.

## Current State
- Ball and paddle are integrated into main.lua
- Ball bounces off walls, resets when falling below screen, decreases lives
- Paddle can be moved left/right and is clamped to screen bounds
- Score and lives globals exist
- Brick system active: 8x5 grid, ball-brick collision, score increases by 10 per brick
- No powerups, no level progression, no game over screen

## Tickets
- [TICKET-001](TICKET_001.md) -- Integrate ball and paddle into main.lua
- [TICKET-002](TICKET_002.md) -- Add brick system with grid layout and collision

## Decisions
- Keep it simple: pure Lua, no external libs
- Screen size: 800x600
