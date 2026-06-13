# Atarogue Agent Playbook

## Stack
- Love2D 11.4
- Lua
- No external libraries yet

## Conventions
- One entity per file in `src/`
- Use `local Entity = {}` pattern with `__index`
- All game state lives in `main.lua` globals or a dedicated `state.lua`
- Colors are RGBA tables: `{r, g, b, a}`
- Screen is 800x600

## Testing
- Run with `love .` from project root
- Check for console errors in terminal

## File Structure
```
main.lua          -- entry point
conf.lua          -- love config
src/ball.lua      -- ball entity
src/paddle.lua    -- paddle entity
src/              -- other entities
```
