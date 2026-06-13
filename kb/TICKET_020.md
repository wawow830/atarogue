# TICKET-020: Event Bus

## Summary
Implemented a small pure-Lua event bus in `src/events.lua`.

## API
- `Events.on(event, callback)` registers a callback for an event and returns the callback.
- `Events.off(event, callback)` removes a previously registered callback and returns whether one was removed.
- `Events.emit(event, data)` calls each registered callback with `data` and returns the number of callbacks invoked.

## Notes
- Event names must be strings.
- Callbacks must be functions.
- `emit` iterates over a snapshot so listeners can be added or removed safely while an event is being emitted.

## Validation
- Ran a `luajit` smoke test covering register, emit, payload delivery, unregister, and empty emit behavior.
