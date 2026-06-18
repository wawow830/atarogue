# TICKET-004: Roguelike Power-Up System

## Summary
Added a power-up system with random drops and temporary effects.

## Files Changed
- `src/powerup.lua` — new power-up entity
- `main.lua` — integration of power-up spawn, collection, and effect timers

## Power-Up Types
- `wide` — doubles paddle width for 5 seconds
- `multiball` — increases ball speed by 1.5x for 5 seconds (placeholder for real multiball)
- `slow` — halves ball speed for 5 seconds
- `fast` — doubles ball speed for 5 seconds
- `life` — grants +1 life permanently

## Spawn Mechanic
- One power-up drops every 5th paddle hit
- Power-ups fall from near the top at a random x position
- Collected by catching with paddle; missed ones fall off-screen and disappear

## Effect System
- `applyEffect` returns a revert closure and a duration
- Main loop tracks active effects and calls revert closures after their duration expires
- Effects overwrite each other (only one speed effect active at a time)
- Console prints activation and expiration messages

## Testing
- Run `love .` and verify normal gameplay, power-up drops, collection, and timeouts
- No console errors on startup
