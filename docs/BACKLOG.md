# Backlog

GitHub Issues are the active backlog and task contract for agents. This file is only a compact snapshot of the current issue structure.

## Active Epics

### [#13 Epic: Infinite roguelike run foundation](https://github.com/joeypshell/codex/issues/13)

Outcome: turn the current single-round game into an endless floor-based run.

- [#17 Add floor state](https://github.com/joeypshell/codex/issues/17)
  Track and display Floor 1 without changing win behavior yet.
- [#18 Advance floors instead of winning](https://github.com/joeypshell/codex/issues/18)
  Clear floors endlessly until the timer reaches 0.
- [#19 Add floor difficulty formula](https://github.com/joeypshell/codex/issues/19)
  Apply formula-driven timer, hazard count, and hazard speed scaling.
- [#20 Add floor-based fragile parcel chance](https://github.com/joeypshell/codex/issues/20)
  Scale fragile parcel frequency on later floors.

### [#14 Epic: Upgrade choices between floors](https://github.com/joeypshell/codex/issues/14)

Outcome: add temporary roguelike upgrades that last only for the current run.

- [#21 Add upgrade choice screen between floors](https://github.com/joeypshell/codex/issues/21)
  Show 3 upgrade choices after a floor clear.
- [#22 Implement movement and timer upgrades](https://github.com/joeypshell/codex/issues/22)
  Add Brighter Wings and Moonlit Minute effects.
- [#23 Implement penalty and pickup upgrades](https://github.com/joeypshell/codex/issues/23)
  Add Gentle Handling, Lucky Satchel, and Wide Glow effects.

### [#15 Epic: Endless run scoring and summary](https://github.com/joeypshell/codex/issues/15)

Outcome: show run progress and a useful run-over summary.

- [#24 Add run score HUD](https://github.com/joeypshell/codex/issues/24)
  Show current floor, total deliveries, and session best.
- [#25 Add run summary screen](https://github.com/joeypshell/codex/issues/25)
  Show floor reached, total deliveries, and chosen upgrades at run over.

### [#16 Epic: Arena layout variety](https://github.com/joeypshell/codex/issues/16)

Outcome: add fixed layout variety before procedural generation.

- [#26 Introduce layout preset data](https://github.com/joeypshell/codex/issues/26)
  Extract the current arena into Layout A data.
- [#27 Add random layout per floor](https://github.com/joeypshell/codex/issues/27)
  Add Layout B/C and choose a layout per floor.

## Later Testing

- [#28 Add first automated Godot tests](https://github.com/joeypshell/codex/issues/28)
  Add lightweight automated checks for deterministic game rules.

## Suggested Order

1. Start with #17, then #18, so the run structure exists before scaling.
2. Do #19 and #20 to make later floors meaningfully different.
3. Add #24 once floors exist, so progress is visible.
4. Add #21-#23 once the floor-clear transition exists.
5. Add #26-#27 after the run loop is stable.
6. Add #28 when the run rules settle enough to test.

## Rules

- Keep issue comments focused on durable findings, blockers, commits, and verification.
- If work grows beyond an issue's acceptance criteria, create a follow-up issue instead of broadening the current ticket.
- Update `docs/current/GAMEPLAY.md` when accepted gameplay, controls, runtime, or export behavior changes.
