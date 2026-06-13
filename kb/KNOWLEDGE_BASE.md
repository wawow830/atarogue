# Atarogue Knowledge Base

## Project
Roguelike Atari Breakout in Love2D. Break bricks, gain roguelike upgrades, descend levels.

## Current State
- Ball and paddle are integrated into main.lua
- Ball bounces off walls, ceiling, and paddle; resets when falling below screen
- Paddle moves left/right, clamped to screen
- Score and lives globals exist
- Game over screen with restart (SPACE) implemented
- No bricks, no ball-brick collision
- TODO comments remain for powerup system, brick system, level progression
- FIXME: collision is hacky
- BROWNFIELD comments: messy globals, no state table, duplicated logic, magic numbers, dead code

## Tickets
- [TICKET-001](TICKET_001.md) -- Integrate ball and paddle into main.lua
- [TICKET-005](TICKET_005.md) -- Add game-over screen with restart button

## Decisions
- Keep it simple: pure Lua, no external libs
- Screen size: 800x600
