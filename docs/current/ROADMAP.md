# Current Roadmap

This roadmap is a compact guide for issue-driven Codex work. GitHub Issues remain the active task contract; this file explains what should be tackled next and what should stay out of scope for now.

Current direction: finish and polish the current one-screen browser game before expanding it.

## Current Playable State

- Firefly Courier is a one-screen Godot 4.7 arcade game.
- The player moves with WASD or arrow keys.
- The player collects one parcel at a time and delivers it to the mailbox.
- Hazards patrol the arena and apply a time/drop penalty.
- The game has win, loss, and restart states.
- GitHub Actions exports the web build and publishes it through GitHub Pages.

## V1 Finish Line

The first version is "done enough" when:

- The public GitHub Pages build is live and playable.
- A first-time player can understand the goal and controls without reading the README.
- Pickup, delivery, hazard contact, win, loss, and restart all have clear feedback.
- Future agents can run one documented verification path before reporting completion.
- `docs/current/GAMEPLAY.md` matches the accepted playable behavior.

## Near-Term Epics

- [#6 V1 playable browser polish](https://github.com/joeypshell/codex/issues/6)
  Finish the current web-playable game before adding new systems.
- [#7 Repeatable Godot verification workflow](https://github.com/joeypshell/codex/issues/7)
  Add one documented verification path for scene-load and web-export checks.
- [#8 First post-V1 gameplay expansion](https://github.com/joeypshell/codex/issues/8)
  Plan one small gameplay expansion after V1 is complete.

## Near-Term Issue Order

1. [#1 Verify the public GitHub Pages build is live and playable.](https://github.com/joeypshell/codex/issues/1)
2. [#3 Add a start screen with concise goal and control instructions.](https://github.com/joeypshell/codex/issues/3)
3. [#2 Add small feedback cues for pickup, delivery, hazard contact, and end states.](https://github.com/joeypshell/codex/issues/2)
4. [#4 Add a repeatable local verification command for scene-load and web-export checks.](https://github.com/joeypshell/codex/issues/4)
5. [#5 Plan one gameplay expansion slice after the current game feels complete.](https://github.com/joeypshell/codex/issues/5)

## Out Of Scope For Now

- New gameplay systems before the V1 finish line above is met.
- Save data, accounts, shops, currencies, or progression systems.
- Large custom art or audio asset production.
- Mobile/touch controls.
- Multiple worlds, dialogue, inventory, or NPC systems.
- Major scene/script refactors without a specific issue.

## What Makes A Good First Codex Issue

- It changes one small behavior or one small doc/process surface.
- It names exact files or scene areas to inspect first.
- It has observable acceptance criteria.
- It includes verification steps that can be run locally.
- It avoids broad design decisions unless the issue is explicitly a planning task.

## Suggested First Issues

### [#1 Verify GitHub Pages Web Deployment](https://github.com/joeypshell/codex/issues/1)

Acceptance criteria:

- GitHub Pages uses GitHub Actions as its source.
- The Deploy Web workflow succeeds on `main`.
- `https://joeypshell.github.io/codex/` loads the game.
- Keyboard input works in the browser.

Verification:

- Inspect the Deploy Web workflow result.
- Open the public Pages URL.
- Manual smoke: move, collect a parcel, deliver it, and restart after an end state.

### [#3 Add Start Screen And Concise Instructions](https://github.com/joeypshell/codex/issues/3)

Acceptance criteria:

- The game shows the goal and controls before play begins.
- The timer waits until the player starts the round.
- Active play, win, loss, and restart still work.

Verification:

- Open `project.godot` in Godot 4.7 and run the game.
- Confirm the timer waits on the start screen.
- Confirm active play and restart behavior still work.

### [#2 Add Basic Game-Feel Feedback](https://github.com/joeypshell/codex/issues/2)

Acceptance criteria:

- Parcel pickup has a visible cue.
- Mailbox delivery has a visible cue.
- Hazard contact clearly communicates the penalty.
- Win and loss messages remain readable.

Verification:

- Run the main scene in Godot.
- Manual smoke: pickup, delivery, hazard contact, win, loss, restart.
- Update `docs/current/GAMEPLAY.md` if accepted visible behavior changes.

## After V1

Once the finish line is met, plan exactly one expansion slice. Good candidates:

- A new parcel type with a simple delivery rule.

The selected first expansion is documented in `docs/planning/first-gameplay-expansion.md`: add fragile parcels as one new parcel type that reuses the current delivery loop.
