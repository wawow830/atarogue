# TICKET-030: Score tracker

## Summary
Implemented `src/score.lua`, a small score-tracking module with:

- `add(points)` to increase the current score and return the updated total
- `get()` to read the current score
- `reset()` to clear the score back to zero and return zero

## Notes
The module keeps score state private to the module and exports only the requested functions.

## Validation
Attempted to run a Lua smoke test, but no Lua interpreter is installed in this environment.
