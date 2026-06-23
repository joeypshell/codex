# Agent Handoff Template

Use this template when a future Codex agent needs more startup context than fits comfortably in a GitHub issue. Do not create handoff docs for every tiny task.

````markdown
# <Task Name> Agent Handoff

## Issue Link or Task ID

<GitHub issue URL or number>

## Goal

<One-sentence outcome.>

## Context

<Brief project/gameplay context needed to avoid rediscovery.>

## Files / Docs To Read First

- `AGENTS.md`
- `<GitHub issue>`
- `docs/current/GAMEPLAY.md`
- `<specific scene/script paths>`

## Constraints

- Keep scope to the issue.
- Do not commit `.godot/` or `build/`.
- Preserve current controls and web export unless the issue says otherwise.

## Expected Implementation Areas

- `scenes/...`
- `scripts/...`
- `README.md` or `docs/current/...` if behavior changes

## Verification Commands

```powershell
godot --headless --path . --scene res://scenes/Main.tscn --quit-after 5
godot --headless --path . --export-release Web build/web/index.html
```

## Definition of Done

- Acceptance criteria are met.
- Verification results are recorded.
- `docs/current/` is updated if accepted behavior changed.
- Git status is clean or only expected local generated files remain ignored.

## What Not To Change

- <Explicitly out-of-scope files or behavior.>
````
