# /rts-pi status

Show the herd minimap: all running agents, their states, and recent output.

## Procedure

1. Run `herdr agent list`.
2. If available, run `herdr workspace list`.
3. For every agent that is `blocked` or `done`, offer the user concrete next actions:
   - Jump into its pane: `herdr agent focus <target>`
   - Read recent output: `herdr pane read <pane-id> --source recent --lines 80`
   - Spawn a follow-up worker
4. Summarize the herd in one scannable block.

## Output format

```
Worker          State    Pane    Location
fix-login       working  2-1     ../repo-fix-login
auth-refactor   blocked  3-1     ../repo-auth-refactor
```

## State sync

Also read `~/.rts-workflow-state.json` and reconcile any tickets whose `.state` does not match herdr's reported state. Update the file if you can determine the true state.
