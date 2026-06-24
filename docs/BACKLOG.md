# Backlog

GitHub Issues are the active backlog and task contract for agents. This file is only a compact snapshot of the first issue set created from the workflow cleanup.

## Epics

### [#6 Epic: V1 playable browser polish](https://github.com/joeypshell/codex/issues/6)

Outcome: the public browser build is live, first-time players understand the goal and controls, and core game events have clear feedback.

- [#1 Verify GitHub Pages web deployment](https://github.com/joeypshell/codex/issues/1)
  Confirm the browser build is live, playable, and backed by the Deploy Web workflow.
- [#3 Add start screen and concise in-game instructions](https://github.com/joeypshell/codex/issues/3)
  Add a pre-round overlay so first-time players understand the goal and controls.
- [#2 Add basic game-feel polish for parcel and hazard events](https://github.com/joeypshell/codex/issues/2)
  Add small visible cues for pickup, delivery, hazard penalties, and end states.

### [#7 Epic: Repeatable Godot verification workflow](https://github.com/joeypshell/codex/issues/7)

Outcome: agents have one documented local path for checking scene load and web export behavior before reporting completion.

- [#4 Add repeatable Godot verification command](https://github.com/joeypshell/codex/issues/4)
  Add a small local verification command for scene-load and web-export checks.

### [#8 Epic: First post-V1 gameplay expansion](https://github.com/joeypshell/codex/issues/8)

Outcome: add fragile parcels as the first gameplay expansion, split into agent-sized implementation issues.

- [#5 Plan the first gameplay expansion slice](https://github.com/joeypshell/codex/issues/5)
  Plan the next small gameplay expansion before implementation.
- [#9 Add parcel type state](https://github.com/joeypshell/codex/issues/9)
  Add normal/fragile parcel state and a visible fragile parcel distinction.
- [#10 Spawn fragile parcels occasionally](https://github.com/joeypshell/codex/issues/10)
  Introduce fragile parcels into the round after the base delivery loop is established.
- [#11 Add fragile parcel hazard penalty](https://github.com/joeypshell/codex/issues/11)
  Make hazard contact riskier when carrying a fragile parcel.
- [#12 Tune and document fragile parcels](https://github.com/joeypshell/codex/issues/12)
  Tune frequency/penalty and document the accepted behavior.

## Suggested Order

1. Start with #1 to confirm the game is actually playable from the public web URL.
2. Add #3 so a first-time browser player can understand the game in-game.
3. Add #2 for the smallest player-facing polish pass.
4. Do #4 when verification friction starts slowing future work.
5. Use #9 as the first fragile-parcel implementation issue.

## Rules

- Keep issue comments focused on durable findings, blockers, commits, and verification.
- If work grows beyond an issue's acceptance criteria, create a follow-up issue instead of broadening the current ticket.
- Update `docs/current/GAMEPLAY.md` when accepted gameplay, controls, runtime, or export behavior changes.
