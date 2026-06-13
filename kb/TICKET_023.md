# TICKET-023: Combat System

## Summary
Implemented `src/combat.lua` providing attack resolution and raw damage dealing integrated with the existing `Entity`, `Health`, and `Events` modules.

## API

### `Combat.attack(attacker, defender) -> number`
Resolves an attack from `attacker` to `defender`.

- Reads `attacker.components.attack` (defaults to `1`)
- Retrieves `defender.components.health` via `Entity.get_component`
- Emits `combat.miss` with `reason="no_health"` if no health component
- Emits `combat.miss` with `reason="dead"` if defender not alive
- Calls `health:take_damage(attack_power)` on hit
- Emits `combat.hit` with `{ attacker, defender, damage, remaining }`
- Emits `combat.kill` if the hit reduces health to zero
- Returns damage dealt (or `0` on miss)

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
- `src/combat.lua` (new)

## Dependencies
- `src/entity.lua`
- `src/health.lua`
- `src/events.lua`
