# /rts-pi spawn

You are invoked with `/rts-pi spawn <ticket-id> <mission>`. Spawn a new autonomous worker that takes the ticket all the way to PR in its own git worktree and herdr pane.

## Pre-flight checklist

- [ ] Extract `<ticket-id>` and `<mission>` from the user message.
- [ ] Verify the current directory is a git repo root. If not, `cd` to the repo root first.
- [ ] Ensure `kb/AGENTS.md` exists. If not, offer to create it from a sensible template.
- [ ] **Discover available extensions.** Read `.pi/extensions/` or `.pi/skills/` if present. Also check `~/.pi/agent/extensions/` for globally available tools. Build a list of candidate extensions that workers might need.
- [ ] **Capture your pane ID.** You are the spawner. The worker needs to know your pane ID so it can report back when done. Determine your own pane ID from context, herdr agent list, or the user's message.

## Discovering capabilities

Before spawning, inspect the environment:

```bash
# Discover project-local extensions
ls .pi/extensions/ 2>/dev/null || echo "none"

# Discover global extensions
ls ~/.pi/agent/extensions/ 2>/dev/null || echo "none"

# Check for custom worker profiles
ls .pi/rts-profiles/ 2>/dev/null || echo "none"
```

## Classifying the ticket

Based on the mission, classify the worker profile:

| Profile | When to use | Flags |
|---------|-------------|-------|
| **default** | Quick fix, refactor, test, local-only work | `--no-context-files --no-extensions --no-prompt-templates` |
| **research** | Needs docs, new dependency, external API, current web info | `--no-context-files --no-prompt-templates` + load web search extension if available |
| **complex** | Multi-file, multi-step, unknown scope | `--no-context-files --no-prompt-templates` + load todo tracker if available |
| **custom** | Specific project needs (DB, deploy, specific tools) | `--no-context-files` + load explicitly named extensions |

## Decision tree

1. Does the mission mention "API", "docs", "version", "latest", "search", or "find"? → **research**
2. Does the mission mention "refactor", "architecture", "multiple", "epic", or "unknown scope"? → **complex**
3. Does the project have a `.pi/rts-profiles/<ticket-type>.json`? → **custom**
4. Otherwise → **default**

## Worker profiles in detail

### Default worker
```bash
pi --name "rts:<ticket-id>" \
   --no-context-files \
   --no-extensions \
   --no-prompt-templates \
   --system-prompt @.pi/skills/rts-pi/WORKER.md
```

### Research worker
```bash
pi --name "rts:<ticket-id>" \
   --no-context-files \
   --no-prompt-templates \
   -e <path-to-web-search-extension> \
   --system-prompt @.pi/skills/rts-pi/WORKER.md
```

If no web search extension is found, use `bash` to run `curl` or `python` for light web scraping, or ask the user to install one.

### Complex worker
```bash
pi --name "rts:<ticket-id>" \
   --no-context-files \
   --no-prompt-templates \
   -e <path-to-todo-tracker-extension> \
   --system-prompt @.pi/skills/rts-pi/WORKER.md
```

### Custom worker
Read from `.pi/rts-profiles/<profile>.json` or similar:
```json
{
  "name": "db-worker",
  "extensions": ["./.pi/extensions/db-query.ts"],
  "tools": ["read", "bash", "edit", "write", "db_query"],
  "flags": "--no-context-files --no-prompt-templates"
}
```

## Worker system prompt

The system prompt is the canonical `WORKER.md` from the skill directory:

```bash
--system-prompt @.pi/skills/rts-pi/WORKER.md
```

This file contains all worker rules: inter-agent communication, idle silence, spawner reporting, Enter-key protocol. No drift. No copy-paste.

When `WORKER.md` is updated, every new worker automatically gets the new rules.

## Spawn procedure

1. **Classify the ticket** using the decision tree above.
2. **Determine your pane ID.** You are the spawner. Capture it from context or check `herdr agent list`.
3. **Build the spawn command** with the matching profile.
4. **Create the worktree.**
   - `herdr worktree create --cwd <repo-root> --branch <branch>`
   - If exists: `herdr worktree open --cwd <repo-root> --branch <branch>`
5. **Spawn the worker.**
   - `herdr pane run --cwd <worktree-root> "<built-pi-command>"`
   - The worker is **interactive**. It stays alive in the pane. No `--print` flag.
6. **Send the mission as a user message.** The worker's system prompt is `WORKER.md` (rules only). The actual ticket, mission, and spawner details arrive as a normal user message:
   ```bash
   herdr pane send-text <pane-id> "TICKET-<ticket-id>: <mission>" && \
   herdr pane send-text <pane-id> "Your spawner: <your-pane-id>" && \
   herdr pane send-keys <pane-id> Enter
   ```
   **Always press Enter after send-text.** Text in the terminal is invisible to pi until Enter is pressed.
7. **Record the ticket.**
   - Read `~/.rts-workflow-state.json` (create if missing).
   - Append `{ id, branch, worktree, profile, spawner_pane: "<your-pane>", state: "working", created_at: <now>, updated_at: <now> }`.
   - Write atomically.
8. **Report back.**
   - Branch, worktree path, profile used, pane id if known.

## Communicating with workers

The orchestrator can send messages to workers at any time:

```bash
# Send text to a worker's pane
herdr pane send-text <pane-id> "Add collision detection too."

# CRITICAL: Always press Enter after send-text
herdr pane send-keys <pane-id> Enter

# Read the worker's output
herdr pane read <pane-id> --source recent --lines 80

# Focus on the worker
herdr agent focus <pane-id>
```

**Why two commands?** `herdr pane send-text` puts text in the terminal buffer. But pi only reads user input after Enter is pressed. If you skip `send-keys Enter`, the worker never sees your message.

**Workers report back to you.** When a worker finishes, it sends a message to your pane:
- `"TICKET-001 done. Branch: feat/ball. Summary: implemented ball physics and collision."`

Listen for these messages. They are your signal that a worker is complete.

## Anti-patterns

- Do not use `--print` or `-p`. Workers must stay alive and interactive.
- Do not use `--no-session`. Workers must persist so they can receive messages.
- Do not spawn inside the main repo checkout.
- Do not ask the user clarifying questions during the worker mission; bake assumptions into the prompt.
- Do not load the orchestrator's soul or extensions onto workers.
- Do not auto-discover all global extensions. Only load what the profile explicitly requires.
- Do not write a custom system prompt. Use `@.pi/skills/rts-pi/WORKER.md` directly.
- Do not broadcast team info to all workers. Workers stay idle and silent until directly messaged.
