# /rts-pi apm

APM = actions per minute. In this workflow it means worker spawns, status checks, and completions.

## Procedure

1. Read `~/.rts-workflow-state.json`.
2. Count tickets spawned in the last 60 minutes and last 24 hours.
3. Count state transitions to `done` in the last 24 hours.
4. Count currently `working` tickets.
5. Report velocity.

## Output format

```
RTS Throughput
- Workers spawned (last hour): N
- Workers spawned (last 24h): N
- Workers completed (last 24h): N
- Active workers: N
```

## Note

True per-tool-call APM requires event hooks (pi extension or herdr integration). This command tracks macro throughput (spawn/completion rate), which is the most important RTS metric anyway.
