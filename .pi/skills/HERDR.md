# /rts-pi herdr

You are invoked with `/rts-pi herdr`. Show the user concise herdr CLI recipes they can use — or execute them yourself when appropriate.

## Recipes

### Notify

```bash
herdr notification show "TICKET-42 done" --body "PR opened" --sound done
```

Sounds: `none`, `done`, `request`.

### Create workspace

```bash
herdr workspace create --cwd /abs/path/to/repo --label api
```

### Split pane

```bash
herdr pane split 1-1 --direction right
```

### List agents

```bash
herdr agent list
```

### Read pane output

```bash
herdr pane read 1-1 --source recent --lines 80
```

### Wait for agent state

```bash
herdr wait agent-status 1-1 --status done
```

## Behavior

If the user passed an extra argument like `/rts-pi herdr notify`, execute that recipe directly with sensible defaults. Otherwise, print this list.
