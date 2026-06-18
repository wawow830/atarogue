# Atarogue Knowledge Base

## Project
Roguelike Atari Breakout in Love2D. Break bricks, gain roguelike upgrades, descend levels.

## Current State
- Ball and paddle integrated into main.lua
- Ball bounces, resets, decreases lives
- Paddle moves left/right, clamped to screen
- Score and lives globals
- Power-up system implemented with random drops and timed effects
- No bricks yet (TICKET-002 in progress on separate worktree)
- main.lua still has brownfield TODOs/FIXMEs

## Tickets
- [TICKET-001](TICKET_001.md) -- Integrate ball and paddle into main.lua
- [TICKET-004](TICKET_004.md) -- Roguelike power-up system

## Decisions
- Keep it simple: pure Lua, no external libs
- Screen size: 800x600
