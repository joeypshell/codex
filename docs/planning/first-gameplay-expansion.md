# First Gameplay Expansion Plan

Parent issue: [#5](https://github.com/joeypshell/codex/issues/5)

## Chosen Direction

Add one new parcel type: a **fragile parcel**.

Fragile parcels keep the current one-screen delivery loop, but add a small decision: the player can deliver them like normal parcels, but touching a hazard while carrying one breaks it and costs extra time. This gives the existing hazards more meaning without adding new arenas, inventory, dialogue, shops, or large art/audio work.

## Why This First

- Reuses the current parcel, mailbox, hazard, HUD, and round-state structure.
- Adds one understandable rule instead of a new system.
- Creates a visible gameplay difference that can be tested in the browser.
- Can be split into small agent-sized issues.

## Scope

In scope:

- A fragile parcel visual state using simple shape/color changes.
- Spawn logic that occasionally creates a fragile parcel.
- Carry state that knows whether the current parcel is normal or fragile.
- Hazard penalty behavior for fragile parcels.
- HUD feedback and current gameplay docs.

Out of scope:

- Multiple levels or arenas.
- Permanent progression, saves, currency, shops, or accounts.
- Custom art/audio asset production.
- New input modes.
- Major scene or script rewrites.

## Proposed Child Issues

### 1. [#9 Add Parcel Type State](https://github.com/joeypshell/codex/issues/9)

Summary: Let parcels represent a normal or fragile type without changing the current delivery loop yet.

Acceptance criteria:

- Parcel instances can be normal or fragile.
- Fragile parcels have a visible color/shape difference.
- Existing normal parcel pickup and delivery behavior still works.
- The player still carries only one parcel at a time.

Relevant areas:

- `scenes/Parcel.tscn`
- `scripts/parcel.gd`
- `scripts/player.gd`
- `scripts/main.gd`

Verification:

- Run the main scene in Godot or the web build.
- Confirm normal parcels still spawn, collect, and deliver.
- Force or temporarily spawn a fragile parcel and confirm it is visually distinct.

### 2. [#10 Spawn Fragile Parcels Occasionally](https://github.com/joeypshell/codex/issues/10)

Summary: Update parcel spawning so some parcels are fragile while keeping the first round readable.

Acceptance criteria:

- Fragile parcels spawn occasionally after the first delivery.
- Normal parcels remain the default.
- Spawn positions stay safe.
- Win/loss/restart behavior does not regress.

Relevant areas:

- `scripts/main.gd`
- `docs/current/GAMEPLAY.md`

Verification:

- Run a full round.
- Confirm both normal and fragile parcels can appear.
- Confirm restart resets parcel state.

### 3. [#11 Add Fragile Parcel Hazard Penalty](https://github.com/joeypshell/codex/issues/11)

Summary: Make hazard contact while carrying a fragile parcel break it and apply a stronger penalty.

Acceptance criteria:

- Hazard contact while carrying a normal parcel keeps the current drop/time penalty.
- Hazard contact while carrying a fragile parcel applies a clearly documented stronger penalty.
- HUD feedback communicates that the fragile parcel broke.
- The game does not spawn duplicate active parcels.

Relevant areas:

- `scripts/main.gd`
- `scripts/hud.gd`
- `scenes/HUD.tscn`
- `docs/current/GAMEPLAY.md`

Verification:

- Pick up a normal parcel, hit a hazard, and confirm existing behavior.
- Pick up a fragile parcel, hit a hazard, and confirm the stronger penalty/cue.
- Confirm the round can continue and still end in win or loss.

### 4. [#12 Tune And Document Fragile Parcels](https://github.com/joeypshell/codex/issues/12)

Summary: Tune the fragile parcel frequency and penalty after browser testing.

Acceptance criteria:

- Fragile parcels feel noticeable but not constant.
- The penalty is understandable and not round-ending by accident.
- README or current gameplay docs explain the rule.
- Any follow-up ideas are filed as new issues instead of expanding scope.

Relevant areas:

- `README.md`
- `docs/current/GAMEPLAY.md`
- `scripts/main.gd`

Verification:

- Browser smoke test: start, deliver normal parcels, deliver or break a fragile parcel, win/loss, restart.
- `git diff --check`.

## Recommended First Child Issue

Start with [#9 Add Parcel Type State](https://github.com/joeypshell/codex/issues/9). It creates the smallest foundation and can be verified without changing round balance.
