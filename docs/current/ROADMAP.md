# Current Roadmap

This roadmap is a compact guide for issue-driven Codex work. GitHub Issues remain the active task contract; this file explains what should be tackled next and what should stay out of scope for now.

## Current Playable State

- Firefly Courier is a one-screen Godot 4.7 arcade game.
- The player moves with WASD or arrow keys.
- The player collects one parcel at a time and delivers it to the mailbox.
- Hazards patrol the arena and apply a time/drop penalty.
- The game has win, loss, and restart states.
- GitHub Actions exports the web build and publishes it through GitHub Pages.

## Near-Term Candidate Issues

- Verify the public GitHub Pages build is live and playable.
- Add a start screen with concise goal and control instructions.
- Add small feedback cues for pickup, delivery, hazard contact, and end states.
- Add a repeatable local verification command for scene-load and web-export checks.
- Plan the first gameplay expansion before adding new systems.

## Out Of Scope For Now

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

### 1. Verify GitHub Pages Web Deployment

Acceptance criteria:

- GitHub Pages uses GitHub Actions as its source.
- The Deploy Web workflow succeeds on `main`.
- `https://joeypshell.github.io/codex/` loads the game.
- Keyboard input works in the browser.

Verification:

- Inspect the Deploy Web workflow result.
- Open the public Pages URL.
- Manual smoke: move, collect a parcel, deliver it, and restart after an end state.

### 2. Add Start Screen And Concise Instructions

Acceptance criteria:

- The game shows the goal and controls before play begins.
- The timer waits until the player starts the round.
- Active play, win, loss, and restart still work.

Verification:

- Open `project.godot` in Godot 4.7 and run the game.
- Confirm the timer waits on the start screen.
- Confirm active play and restart behavior still work.

### 3. Add Basic Game-Feel Feedback

Acceptance criteria:

- Parcel pickup has a visible cue.
- Mailbox delivery has a visible cue.
- Hazard contact clearly communicates the penalty.
- Win and loss messages remain readable.

Verification:

- Run the main scene in Godot.
- Manual smoke: pickup, delivery, hazard contact, win, loss, restart.
- Update `docs/current/GAMEPLAY.md` if accepted visible behavior changes.
