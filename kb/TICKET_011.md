# TICKET-011 -- Health System

## Summary
- Added `src/health.lua` with a reusable Health entity.
- Health tracks max/current hearts, damage, healing, reset, death, and brief invulnerability after damage.
- Integrated health into `main.lua`: missed balls now deal damage, hearts render in the HUD, and the ball stops when health reaches zero.

## Testing
- Ran `timeout 3 love .` and confirmed the project boots with no console errors.
