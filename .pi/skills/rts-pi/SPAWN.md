# /rts-pi spawn

You are invoked with `/rts-pi spawn <ticket-id> <mission>`. Spawn a new autonomous worker that takes the ticket all the way to PR in its own git worktree and herdr pane.

## Pre-flight checklist

- [ ] Extract `<ticket-id>` and `<mission>` from the user message.
- [ ] Verify the current directory is a git repo root. If not, `cd` to the repo root first.
- [ ] Ensure `kb/AGENTS.md` exists. If not, offer to create it from a sensible template.
- [ ] **Discover available extensions.** Read `.pi/extensions/` or `.pi/skills/` if present. Also check `~/.pi/agent/extensions/` for globally available tools. Build a list of candidate extensions that workers might need.

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
| **default** | Quick fix, refactor, test, local-only work | `--no-session --no-context-files --no-extensions --no-skills --no-prompt-templates` |
| **research** | Needs docs, new dependency, external API, current web info | `--no-session --no-context-files --no-skills --no-prompt-templates` + load web search extension if available |
| **complex** | Multi-file, multi-step, unknown scope | `--no-session --no-context-files --no-prompt-templates` + load todo tracker if available |
| **custom** | Specific project needs (DB, deploy, specific tools) | `--no-session --no-context-files` + load explicitly named extensions |

## Decision tree

1. Does the mission mention "API", "docs", "version", "latest", "search", or "find"? → **research**
2. Does the mission mention "refactor", "architecture", "multiple", "epic", or "unknown scope"? → **complex**
3. Does the project have a `.pi/rts-profiles/<ticket-type>.json`? → **custom**
4. Otherwise → **default**

## Worker profiles in detail

### Default worker
```bash
pi --no-session \
   --no-context-files \
   --no-extensions \
   --no-skills \
   --no-prompt-templates \
   -p @/tmp/worker-prompt-<ticket-id>.txt
```

### Research worker
```bash
pi --no-session \
   --no-context-files \
   --no-skills \
   --no-prompt-templates \
   -e <path-to-web-search-extension> \
   -p @/tmp/worker-prompt-<ticket-id>.txt
```

If no web search extension is found, use `bash` to run `curl` or `python` for light web scraping, or ask the user to install one.

### Complex worker
```bash
pi --no-session \
   --no-context-files \
   --no-prompt-templates \
   -e <path-to-todo-tracker-extension> \
   -p @/tmp/worker-prompt-<ticket-id>.txt
```

### Custom worker
Read from `.pi/rts-profiles/<profile>.json` or similar:
```json
{
  "name": "db-worker",
  "extensions": ["./.pi/extensions/db-query.ts"],
  "tools": ["read", "bash", "edit", "write", "db_query"],
  "flags": "--no-session --no-context-files --no-skills --no-prompt-templates"
}
```

## Worker prompt file

The worker prompt file must be a single text file passed to `-p @/tmp/worker-prompt-<ticket-id>.txt`. It should contain:

1. **Worker rules** from [WORKER.md](WORKER.md)
2. **Knowledge base** — read `kb/AGENTS.md` and `kb/KNOWLEDGE_BASE.md` and embed their contents inline
3. **Mission** — the one-line mission description

Example structure:

```
--- WORKER RULES ---
(your rules here)

--- KNOWLEDGE BASE ---
(project conventions here)

--- MISSION ---
Integrate ball and paddle into main.lua
```

## Spawn procedure

1. **Classify the ticket** using the decision tree above.
2. **Build the spawn command** with the matching profile.
3. **Write the worker prompt file** to `/tmp/worker-prompt-<ticket-id>.txt`.
   - Include worker rules, knowledge base content, and mission.
4. **Create the worktree.**
   - `herdr worktree create --cwd <repo-root> --branch <branch>`
   - If exists: `herdr worktree open --cwd <repo-root> --branch <branch>`
5. **Spawn the worker.**
   - `herdr pane run --cwd <worktree-root> "<built-pi-command>"`
6. **Record the ticket.**
   - Read `~/.rts-workflow-state.json` (create if missing).
   - Append `{ id, branch, worktree, profile, state: "working", created_at: <now>, updated_at: <now> }`.
   - Write atomically.
7. **Report back.**
   - Branch, worktree path, profile used, pane id if known.

## Anti-patterns

- Do not spawn inside the main repo checkout.
- Do not ask the user clarifying questions during the worker mission; bake assumptions into the prompt.
- Do not load the orchestrator's soul or extensions onto workers.
- Do not auto-discover all global extensions. Only load what the profile explicitly requires.
- Do not pass multiple files to `-p`. Build a single prompt file.
