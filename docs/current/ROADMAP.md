# Current Roadmap

This roadmap is a compact guide for issue-driven Codex work. GitHub Issues remain the active task contract; this file explains what should be tackled next and what should stay out of scope.

Current direction: evolve Firefly Courier from a one-screen delivery arcade game into an endless, browser-playable roguelike courier run.

## Current Playable State

- Firefly Courier is a one-screen Godot 4.7 arcade game.
- The player moves with WASD or arrow keys.
- The player collects one parcel at a time and delivers it to the mailbox.
- Normal and fragile parcels appear during a round.
- Hazards patrol the arena and apply normal or fragile parcel penalties.
- The game has start, win, loss, and restart states.
- GitHub Actions exports the web build and publishes it through GitHub Pages.
- `tools/verify-godot.ps1` provides a repeatable local Godot scene/export check.

## Next Product Direction

The next version should become an endless roguelike run:

- The run starts on Floor 1.
- Each floor requires 5 deliveries.
- Completing a floor advances to the next floor instead of ending the game.
- There is no final floor or final win state.
- The timer reaching 0 ends the run.
- Restart begins a fresh run at Floor 1.
- Between floors, the player will eventually choose temporary upgrades that last only for the current run.

## Near-Term Epics

- [#13 Epic: Infinite roguelike run foundation](https://github.com/joeypshell/codex/issues/13)
  Add endless floors, floor advancement, formula-driven difficulty, and floor-based fragile parcel scaling.
- [#14 Epic: Upgrade choices between floors](https://github.com/joeypshell/codex/issues/14)
  Add temporary current-run upgrades chosen between floors.
- [#15 Epic: Endless run scoring and summary](https://github.com/joeypshell/codex/issues/15)
  Show current floor, total deliveries, session best, and run-over summary.
- [#16 Epic: Arena layout variety](https://github.com/joeypshell/codex/issues/16)
  Add fixed layout presets and choose layouts per floor before procedural generation.

## Near-Term Issue Order

1. [#17 Add floor state](https://github.com/joeypshell/codex/issues/17)
2. [#18 Advance floors instead of winning](https://github.com/joeypshell/codex/issues/18)
3. [#19 Add floor difficulty formula](https://github.com/joeypshell/codex/issues/19)
4. [#20 Add floor-based fragile parcel chance](https://github.com/joeypshell/codex/issues/20)
5. [#21 Add upgrade choice screen between floors](https://github.com/joeypshell/codex/issues/21)
6. [#24 Add run score HUD](https://github.com/joeypshell/codex/issues/24)
7. [#26 Introduce layout preset data](https://github.com/joeypshell/codex/issues/26)

## Concrete Scaling Rules

- Floor timer: `max(35, 60 - floor_number * 2)` seconds.
- Hazard count: `min(6, 3 + floor_number / 3)`.
- Hazard speed multiplier: `min(1.8, 1.0 + floor_number * 0.08)`.
- Deliveries required: always 5 for now.
- Floor 1 fragile parcels: keep deterministic fragile deliveries after deliveries `1` and `3`.
- Floor 2+ fragile parcel chance: `min(0.75, 0.25 + floor_number * 0.08)`.

## Upgrade Pool

- Brighter Wings: player speed +10%, max 3 stacks.
- Moonlit Minute: +8 seconds at the start of each floor, max 3 stacks.
- Gentle Handling: fragile hazard penalty -2 seconds, max 2 stacks.
- Lucky Satchel: normal hazard penalty -1 second, max 2 stacks.
- Wide Glow: pickup radius +15%, max 2 stacks.

## Out Of Scope For Now

- Persistent save data, accounts, shops, currencies, or long-term progression systems.
- Procedural map generation before fixed layout presets work.
- Large custom art or audio asset production.
- Mobile/touch controls.
- Dialogue, inventory, NPC systems, or combat.
- Major scene/script refactors without a specific issue.

## Later Tooling Evaluation

- Evaluate the Godot AI MCP plugin before a scene-heavy polish issue. Treat it as an editor-assist tool for inspecting scenes, screenshots, UI, particles, and node setup, not as a replacement for the GitHub issue workflow.

## Later Testing Work

- [#28 Add first automated Godot tests](https://github.com/joeypshell/codex/issues/28)
  Start with small checks for floor config lookup, fragile parcel rules, hazard penalties, and restart reset behavior.
