# TICKET-023: Combat System

## Summary
Implemented `src/combat.lua`, `src/entity.lua`, `src/health.lua`, and `src/events.lua` providing attack resolution, raw damage dealing, and a dodge mechanic.

## API

### `Combat.dodge_chance(attacker, defender) -> boolean`
Returns `true` 25% of the time (RNG-based). When `true`, the attack is evaded and damage is prevented.

### `Combat.attack(attacker, defender) -> number`
Resolves an attack from `attacker` to `defender`.

- Reads `attacker.components.attack` (defaults to `1`)
- Retrieves `defender.components.health` via `Entity.get_component`
- Emits `combat.miss` with `reason="no_health"` if no health component
- Emits `combat.miss` with `reason="dead"` if defender not alive
- Calls `Combat.dodge_chance(attacker, defender)`
- Emits `combat.miss` with `reason="dodged"` if dodge succeeds
- Calls `health:take_damage(attack_power)` on hit
- Emits `combat.hit` with `{ attacker, defender, damage, remaining }`
- Emits `combat.kill` if the hit reduces health to zero
- Returns damage dealt (or `0` on miss / dodge)

### `Combat.deal_damage(defender, amount) -> number`
Applies raw damage directly to `defender`.

- Same event flow as `Combat.attack` but uses supplied `amount` instead of reading attack power
- `attacker` field in emitted events will be `nil`
- Returns damage dealt (or `0` on miss)

## Events

| Event | Payload |
|-------|---------|
| `combat.miss` | `{ attacker, defender, reason }` |
| `combat.hit` | `{ attacker, defender, damage, remaining }` |
| `combat.kill` | `{ attacker, defender, damage }` |

## Files Changed
- `src/combat.lua` (updated)
- `src/entity.lua` (new)
- `src/health.lua` (new)
- `src/events.lua` (new)

## Dependencies
- `src/entity.lua`
- `src/health.lua`
- `src/events.lua`
