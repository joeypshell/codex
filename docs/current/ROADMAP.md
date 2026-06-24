# Current Roadmap

This roadmap is a compact guide for issue-driven Codex work. GitHub Issues remain the active task contract; this file explains what should be tackled next and what should stay out of scope.

Current direction: evolve Firefly Courier from a one-screen delivery arcade game into an endless, browser-playable roguelike courier run that works well on desktop and mobile browsers.

## Current Playable State

- Firefly Courier is a one-screen Godot 4.7 arcade game.
- The player moves with WASD or arrow keys.
- The player collects one parcel at a time and delivers it to the mailbox.
- Normal and fragile parcels appear during a round.
- Hazards patrol the arena and apply normal or fragile parcel penalties.
- The game has start, active play, floor-clear, run-over, and restart states.
- The run advances through endless floors instead of ending after the first 5 deliveries.
- Later floors shorten the timer and increase hazard count and speed.
- Later floors can produce fragile parcels more often.
- The HUD shows total deliveries and best floor for the current browser session.
- Clearing a floor presents three upgrade choices, then starts the next floor after a choice.
- Upgrade choices now apply current-run effects for speed, floor-start time, hazard penalties, and pickup radius.
- Run over shows a summary with floor reached, total deliveries, and chosen upgrades.
- Floors now choose from Layout A, Layout B, and Layout C while avoiding immediate repeats when possible.
- The web build has responsive/mobile viewport settings.
- Phone/touch play has touch-and-slide movement, upgrade choice, and restart controls.
- Mobile smoke-test steps are documented for GitHub Pages.
- `tools/test-godot.ps1` runs automated rule tests for deterministic gameplay helpers.
- GitHub Actions exports the web build and publishes it through GitHub Pages.
- `tools/verify-godot.ps1` provides a repeatable local Godot scene/export check.
- Godot AI MCP has been adopted as optional local editor-assist tooling; see `docs/current/GODOT_MCP.md`.

## Next Product Direction

The next version should continue improving mobile-friendly web play:

- Test the live GitHub Pages build on real phones and tune landscape fill, readability, and touch feel from feedback.
- Keep broadening automated coverage when gameplay rules become harder to verify manually.
- Use optional Godot AI MCP tooling on scene-heavy issues when it is available locally.

## Near-Term Epics

- [#29 Epic: Mobile web playability](https://github.com/joeypshell/codex/issues/29)
  Add responsive/mobile HUD behavior, touch movement controls, touch upgrade/restart controls, and mobile smoke-test docs.
- [#13 Epic: Infinite roguelike run foundation](https://github.com/joeypshell/codex/issues/13)
  Add endless floors, floor advancement, formula-driven difficulty, and floor-based fragile parcel scaling.
- [#14 Epic: Upgrade choices between floors](https://github.com/joeypshell/codex/issues/14)
  Add temporary current-run upgrades chosen between floors.
- [#15 Epic: Endless run scoring and summary](https://github.com/joeypshell/codex/issues/15)
  Show current floor, total deliveries, session best, and run-over summary.
- [#16 Epic: Arena layout variety](https://github.com/joeypshell/codex/issues/16)
  Add fixed layout presets and choose layouts per floor before procedural generation.

## Near-Term Issue Order

- [#35 Bug: mobile web viewport does not fit correctly in portrait and landscape](https://github.com/joeypshell/codex/issues/35)
  Fix the live mobile browser viewport behavior after real-phone testing showed portrait squishing and incomplete landscape fill.
- [#37 Setup: install and verify Godot AI MCP for local Codex scene inspection](https://github.com/joeypshell/codex/issues/37)
  Confirm the optional Godot AI MCP tool can connect locally and inspect a live Godot scene.

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
- Dialogue, inventory, NPC systems, or combat.
- Major scene/script refactors without a specific issue.

## Later Tooling Evaluation

- After local Godot AI MCP setup is confirmed, use it on a small scene/UI issue and promote any useful repeatable workflow back into `AGENTS.md`.

## Later Testing Work

- Add browser-level smoke automation only if manual Pages checks become a bottleneck.
- Add focused rule tests alongside future gameplay tuning issues.
