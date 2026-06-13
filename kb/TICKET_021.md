# TICKET-021: Health Component System

## Summary
Implemented `src/health.lua`, a reusable health component following the project's entity-style Lua module pattern.

## API
- `Health.new(health)` creates a component with `health` as both current and maximum health.
- `health:take_damage(amount)` reduces current health, clamped at `0`, and returns current health.
- `health:heal(amount)` restores current health, clamped at `max_health`, and returns current health.
- `health:is_alive()` returns `true` while current health is greater than `0`.

## Notes
- Missing health defaults to `1`.
- Missing, zero, or negative damage/healing amounts are ignored.
