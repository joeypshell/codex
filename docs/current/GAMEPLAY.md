# Current Gameplay

This file describes the implemented Firefly Courier behavior. If gameplay, controls, runtime, or web export behavior changes, update this file before closing the related issue.

Near-term work is tracked in `docs/current/ROADMAP.md` and GitHub Issues.

## Game Loop

Firefly Courier is a one-screen cozy arcade game built in Godot 4.7 with GDScript.

- The player controls a firefly courier in a garden arena.
- Arena setup is represented as layout data: player start, mailbox position, and hazard definitions.
- Layout A is the original arena setup; Layout B and Layout C add alternate mailbox and hazard arrangements.
- Each floor chooses one available layout and avoids repeating the previous layout when possible.
- The game opens on a start screen with the goal and controls.
- Press Enter, Space, or any movement key to start active play.
- The run starts on Floor 1.
- Each floor requires 5 glowing parcel deliveries before the night timer reaches 0.
- The timer waits on the start screen and starts when active play begins.
- The HUD shows the current floor, best floor for the current browser session, floor deliveries, total deliveries for the current run, timer, and carried parcel state.
- The player can carry one parcel at a time.
- Parcels spawn at safe positions away from the player and mailbox.
- Floor 1 keeps a deterministic fragile parcel pattern after deliveries `1` and `3`.
- Floor 2+ rolls fragile parcels with `min(0.75, 0.25 + floor_number * 0.08)` chance for each spawn.
- Normal parcels can still appear on later floors.
- Fragile parcels use a pink/yellow visual treatment and carried-parcel indicator.
- Picking up a parcel shows a short HUD cue.
- Delivering a parcel to the mailbox increments the delivery count and spawns the next parcel.
- Delivering a parcel shows a short HUD cue.
- Hazards patrol the arena. Touching a hazard drops the carried parcel, spawns a replacement parcel, subtracts 6 seconds for a normal parcel or 12 seconds for a fragile parcel, and shows a short warning cue. This is the accepted first-pass tuning: fragile parcels are noticeable but not constant, and the stronger penalty is meaningful without ending a full round by itself.
- Completing 5 deliveries clears the current floor instead of ending the run.
- The floor-clear screen shows three upgrade choices.
- Press `1`, `2`, or `3` to choose an upgrade and start the next floor.
- Upgrade choices are stored in the current run state.
- Brighter Wings increases player speed by 10% per stack, up to 3 stacks.
- Moonlit Minute adds 8 seconds at each future floor start, up to 3 stacks.
- Gentle Handling reduces fragile hazard penalties by 2 seconds per stack, up to 2 stacks.
- Lucky Satchel reduces normal hazard penalties by 1 second per stack, up to 2 stacks.
- Wide Glow increases pickup radius by 15% per stack, up to 2 stacks.
- Upgrades that reach their stack cap stop appearing in the choice pool.
- There is no final floor or final win state.
- The run ends only when time reaches 0.
- The run-over screen shows floor reached, total deliveries, and chosen upgrades with stack counts.
- Press `R` after a run ends to return to the start screen for a fresh Floor 1 run.
- Total deliveries reset for each fresh run.
- Chosen upgrades and their effects reset for each fresh run.
- Best floor is kept only in memory for the current browser session; there is no persistent save data.

## Floor Scaling

- Floor timer: `max(35, 60 - floor_number * 2)` seconds.
- Hazard count: `min(6, 3 + floor_number / 3)` using whole-floor steps.
- Hazard speed multiplier: `min(1.8, 1.0 + floor_number * 0.08)`.
- Deliveries required stays fixed at 5.
- Floor 1 fragile parcels are deterministic; Floor 2+ fragile parcels use the floor-based chance.
- Hazard penalty rules stay the same across floors.

## Controls

- Move: WASD or arrow keys
- Move on mobile/touch: on-screen D-pad
- Start run: Enter, Space, or any movement key
- Start run on mobile/touch: press any D-pad direction
- Choose upgrade after floor clear: `1`, `2`, or `3`
- Choose upgrade on mobile/touch: tap an upgrade button
- Return to start screen after run over: `R`
- Return to start screen on mobile/touch: tap Restart

## Scene Responsibilities

- `scenes/Main.tscn`: arena, run/floor state, spawning, score, timer, floor-clear/loss flow
- `scenes/Player.tscn`: player movement, collision, pickup area, carried-parcel indicator
- `scenes/Parcel.tscn`: collectible parcel
- `scenes/Hazard.tscn`: moving hazard
- `scenes/Mailbox.tscn`: delivery target
- `scenes/HUD.tscn`: floor, session best, floor deliveries, run total, timer, carried state, upgrade choices, floor-clear/loss messages

## Script Responsibilities

- `scripts/main.gd`: run and floor lifecycle, run score state, upgrade choice state, spawn rules, difficulty scaling, hazard penalties
- `scripts/player.gd`: input, movement, carrying state, parcel pickup signal
- `scripts/parcel.gd`: collectible state and cleanup
- `scripts/hazard.gd`: patrol motion
- `scripts/mailbox.gd`: delivery request signal
- `scripts/hud.gd`: display updates

## Runtime and Web Export

- Local play starts by opening `project.godot` in Godot 4.7 and pressing Play.
- The tracked web export preset is `Web` in `export_presets.cfg`.
- `.github/workflows/deploy-web.yml` exports the game for the web and deploys it with GitHub Pages.
- Generated web output goes under `build/web` and should not be committed.
- The expected public URL after a successful Pages deployment is `https://joeypshell.github.io/codex/`.
- The web build uses responsive canvas scaling for desktop and mobile browser viewports.
- Phone-sized browser play is supported as a web target, with touch controls tracked under the mobile web playability issues.
- Mobile HUD layout keeps movement controls, upgrade/restart buttons, and central messages in separate screen regions so upgrade choices and run summaries stay readable.

## Verification

Preferred checks when Godot is available:

```powershell
.\tools\verify-godot.ps1
```

Automated rule tests:

```powershell
.\tools\test-godot.ps1
```

Use `.\tools\verify-godot.ps1 -GodotBin "C:\path\to\Godot.exe"` if Godot is not on PATH. The script writes web export output under ignored `build/web`.

Manual smoke:

- Confirm the start screen shows the goal and controls.
- Confirm the timer waits until the run starts.
- Confirm the HUD starts at Floor 1, Best 1, and Total 0.
- Confirm player, mailbox, hazards, and parcels remain visible and reachable as floors change layouts.
- Move in all directions.
- Pick up a parcel.
- Deliver it to the mailbox.
- Touch a hazard while carrying a parcel and confirm the penalty.
- Deliver 5 parcels and confirm the floor-clear state.
- Confirm three upgrade choices appear after floor clear.
- Press `1`, `2`, or `3` after floor clear and confirm Floor 2 starts.
- Confirm total deliveries and best floor update as floors advance.
- Confirm fragile parcels appear more often on later floors but normal parcels still appear.
- Let the timer expire and confirm the run-over state.
- Confirm the run-over summary shows floor reached, total deliveries, and upgrades chosen.
- Press `R` after run over and confirm the start screen returns with Floor 1.

Mobile web smoke through GitHub Pages:

- Open `https://joeypshell.github.io/codex/` on a phone browser.
- Check portrait and landscape readability where practical.
- Confirm the canvas is visible and not awkwardly cropped.
- Start a run with the on-screen D-pad.
- Move in all directions with touch controls.
- Pick up a parcel and deliver it to the mailbox.
- Clear a floor and choose an upgrade by tapping an upgrade button.
- Let the timer expire and confirm the run-over summary is readable.
- Tap Restart and confirm a fresh Floor 1 run starts.
