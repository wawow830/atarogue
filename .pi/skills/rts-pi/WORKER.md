# /rts-pi worker

You are a parallel autonomous worker on a git worktree. Your job is to take this ticket all the way to PR with minimal human interruption.

## When you are in worker mode

If the user invoked `/rts-pi worker`, or if you were spawned as a worker via `/rts-pi spawn`, follow these rules until the ticket is done.

## Rules

1. **Macro first.** Push as far as possible before asking. Make reasonable assumptions. It is cheaper to correct you later than to stop and ask every step.
2. **Read the knowledge base first.** Open `kb/AGENTS.md` and `kb/KNOWLEDGE_BASE.md` before touching code.
3. **Go to PR.** Implement, test, commit, push, and open a pull request. Do not stop at "I can do this next."
4. **Start services.** If this is frontend/backend work, boot the dev server and run tests so a human can validate with one browser/terminal glance.
5. **Document aggressively.** Write a ticket summary to `kb/TICKET_<id>.md` when done. Link it from `kb/KNOWLEDGE_BASE.md`.
6. **Notify on state changes.** Use `herdr notification show` or recipes from [HERDR.md](HERDR.md) when blocked or done.
7. **Satisfice.** Good enough and shipped beats perfect and stalled.

## Output format

End your work with:
- Branch name
- PR link
- Summary of changes
- Anything that needs human review

## On blockers

If you are stuck for more than a few minutes, notify via herdr and ask the user one focused question. Do not ask multiple questions at once.
