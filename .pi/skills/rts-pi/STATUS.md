# /rts-pi status

Show the herd minimap: all running agents, their states, and recent output.

## Procedure

1. Run `herdr agent list`.
2. If available, run `herdr workspace list`.
3. For each known ticket in `~/.rts-workflow-state.json`, check its actual state:
   - Read the worktree's git log: `cd <worktree> && git log --oneline --since="1 hour ago"`
   - If there are new commits (especially with `TICKET-<id>` in the message), the worker is likely done.
   - If the state file says "working" but git shows commits, update the state file to `"done"`.
   - If the state file says "working" and git shows no new commits, the worker is still working.
   - If the pane shows errors or the pi command is not running, mark as "blocked".
4. For any agent that is `blocked` or `done`, offer the user concrete next actions:
   - Jump into its pane: `herdr agent focus <target>`
   - Read recent output: `herdr pane read <pane-id> --source recent --lines 80`
   - Send a message: `herdr pane send-text <pane-id> "New instruction"`
   - Spawn a follow-up worker
5. Summarize the herd in one scannable block.

## Output format

```
Worker          State    Pane                 Location
fix-login       done     w6541-1              worktree-fix-login
auth-refactor   working  w6541-2              worktree-auth-refactor
api-docs        blocked  w6541-3              worktree-api-docs
```

## State sync

Reconcile the state file with reality:
- Read `~/.rts-workflow-state.json`
- For each ticket with `state == "working"`, check the worktree git log
- Update the state file if the worker has finished
- Report any discrepancies
