# TICKET-018

## Summary
Implemented `src/goodbye.lua` as a simple Lua module.

## Changes
- Added `Goodbye.say_goodbye()`.
- The function returns `"goodbye world"`.

## Validation
- Loaded the module with Lua and verified `say_goodbye()` returns the expected string.
