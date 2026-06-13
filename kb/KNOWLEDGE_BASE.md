# Atarogue Knowledge Base

## Project
Roguelike Atari Breakout in Love2D. Break bricks, gain roguelike upgrades, descend levels.

## Current State
- Basic project scaffold exists
- Ball and paddle entities created but not integrated into main.lua
- No bricks, no collision, no game loop

## Tickets
- [TICKET-001](TICKET_001.md) -- Integrate ball and paddle into main.lua
- [TICKET-013](TICKET_013.md) -- Brick system, level progression, and scoring

## Decisions
- Keep it simple: pure Lua, no external libs
- Screen size: 800x600
- Brick API lives in `src/brick.lua`; level/scoring/progression API lives in `src/level.lua`
