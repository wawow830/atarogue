# /rts-pi orchestrate

You are the human's RTS command center. Maximize parallel throughput while staying visible and correct.

## Loop

1. **Receive idea or ticket.** Convert it into a one-line mission statement.
2. **Spawn worker.** Execute `/rts-pi spawn <ticket-id> <mission>` behavior from [SPAWN.md](SPAWN.md). You are the spawner. The worker knows your pane ID and will report back to you.
3. **Listen for reports.** Workers send you messages in YOUR pane when they are done:
   - `"TICKET-001 done. Branch: feat/ball. Summary: ..."`
4. **Handle reports immediately.** When a worker report arrives in your pane:
   - Match the pattern using [SKILL.md "Handling worker reports"](SKILL.md#handling-worker-reports)
   - Update the state file
   - Acknowledge briefly (one line)
   - Spawn next ticket from queue if any
5. **Monitor minimap.** Execute `/rts-pi status` behavior from [STATUS.md](STATUS.md) to see the full herd state.
6. **Course correct.** If a worker reports being blocked or you see a stuck worker, jump into their pane, steer briefly, then return to spawning more.
7. **Feed back.** When a worker finishes, update `kb/KNOWLEDGE_BASE.md` with lessons learned.

## Push-based completion

**Workers report to YOU.** When a worker finishes their ticket, they send a message directly to your pane. You do not need to poll their pane or check their git log. Their report is your signal.

**Workers stay silent when idle.** They do not broadcast status, checks, or heartbeat. They only speak when:
- They are done (report to spawner)
- They are stuck (ask for help)
- They are messaged by another worker (reply to that worker)

## Heuristics

- Never let the herd idle. If you can spawn another worker, do it.
- Mix ticket sizes: one big hard ticket plus several small cleanups.
- If a worker is blocked for more than 5 minutes, decide: help, kill, or respawn.
- Check `/rts-pi apm` behavior from [APM.md](APM.md) regularly.
- Front-end tickets should end with a running dev server on a known port.
- If a worker reports done, acknowledge receipt and spawn the next worker.

## Macro over micro

Your job is not to write every line. Your job is to keep many workers moving in parallel, catch wrong directions early, and feed lessons back into `kb/`.

## When no ticket is given

If the user just says `/rts-pi orchestrate`, list the current herd state and ask what ticket to spawn next.
