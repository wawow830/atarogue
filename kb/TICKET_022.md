# TICKET-022: Entity System

## Summary
Added a simple component-based entity system in `src/entity.lua`.

## API
- `create_entity()` creates a new entity table with a unique `id` and `components` table.
- `add_component(entity, name, component)` stores `component` under `name` and returns the component.
- `get_component(entity, name)` returns the stored component or `nil` if absent.

## Notes
The module uses the existing project style of returning a Lua table of functions and has no external dependencies.
