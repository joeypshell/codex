# Backlog

GitHub Issues are the active backlog and task contract for agents. This file is only a compact snapshot of the first issue set created from the workflow cleanup.

## Active Issues

- [#1 Verify GitHub Pages web deployment](https://github.com/joeypshell/codex/issues/1)
  Confirm the browser build is live, playable, and backed by the Deploy Web workflow.
- [#2 Add basic game-feel polish for parcel and hazard events](https://github.com/joeypshell/codex/issues/2)
  Add small visible cues for pickup, delivery, hazard penalties, and end states.
- [#3 Add start screen and concise in-game instructions](https://github.com/joeypshell/codex/issues/3)
  Add a pre-round overlay so first-time players understand the goal and controls.
- [#4 Add repeatable Godot verification command](https://github.com/joeypshell/codex/issues/4)
  Add a small local verification command for scene-load and web-export checks.
- [#5 Plan the first gameplay expansion slice](https://github.com/joeypshell/codex/issues/5)
  Plan the next small gameplay expansion before implementation.

## Suggested Order

1. Start with #1 to confirm the game is actually playable from the public web URL.
2. Do #4 next if verification friction slows future work.
3. Pick #3 or #2 for the first player-facing improvement.
4. Use #5 when ready to plan the next gameplay slice.

## Rules

- Keep issue comments focused on durable findings, blockers, commits, and verification.
- If work grows beyond an issue's acceptance criteria, create a follow-up issue instead of broadening the current ticket.
- Update `docs/current/GAMEPLAY.md` when accepted gameplay, controls, runtime, or export behavior changes.
