# Current Gameplay

This file describes the implemented Firefly Courier behavior. If gameplay, controls, runtime, or web export behavior changes, update this file before closing the related issue.

Near-term work is tracked in `docs/current/ROADMAP.md` and GitHub Issues.

## Game Loop

Firefly Courier is a one-screen cozy arcade game built in Godot 4.7 with GDScript.

- The player controls a firefly courier in a garden arena.
- The game opens on a start screen with the goal and controls.
- Press Enter, Space, or any movement key to start active play.
- The goal is to deliver 5 glowing parcels before the night timer reaches 0.
- The timer waits on the start screen and starts when active play begins.
- The player can carry one parcel at a time.
- Parcels spawn at safe positions away from the player and mailbox.
- The first parcel in a round is normal; after that, fragile parcels appear every other delivery, so a five-delivery win path has two fragile parcels.
- Fragile parcels use a pink/yellow visual treatment and carried-parcel indicator.
- Picking up a parcel shows a short HUD cue.
- Delivering a parcel to the mailbox increments the delivery count and spawns the next parcel.
- Delivering a parcel shows a short HUD cue.
- Hazards patrol the arena. Touching a hazard drops the carried parcel, spawns a replacement parcel, subtracts 6 seconds for a normal parcel or 12 seconds for a fragile parcel, and shows a short warning cue. This is the accepted first-pass tuning: fragile parcels are noticeable but not constant, and the stronger penalty is meaningful without ending a full round by itself.
- The game ends in a win after 5 deliveries or a loss when time reaches 0.
- Press `R` after a win/loss to return to the start screen for another round.

## Controls

- Move: WASD or arrow keys
- Start round: Enter, Space, or any movement key
- Return to start screen after win/loss: `R`

## Scene Responsibilities

- `scenes/Main.tscn`: arena, round state, spawning, score, timer, win/loss flow
- `scenes/Player.tscn`: player movement, collision, pickup area, carried-parcel indicator
- `scenes/Parcel.tscn`: collectible parcel
- `scenes/Hazard.tscn`: moving hazard
- `scenes/Mailbox.tscn`: delivery target
- `scenes/HUD.tscn`: score, timer, carried state, win/loss messages

## Script Responsibilities

- `scripts/main.gd`: round lifecycle, spawn rules, win/loss rules, hazard penalties
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

## Verification

Preferred checks when Godot is available:

```powershell
.\tools\verify-godot.ps1
```

Use `.\tools\verify-godot.ps1 -GodotBin "C:\path\to\Godot.exe"` if Godot is not on PATH. The script writes web export output under ignored `build/web`.

Manual smoke:

- Confirm the start screen shows the goal and controls.
- Confirm the timer waits until the round starts.
- Move in all directions.
- Pick up a parcel.
- Deliver it to the mailbox.
- Touch a hazard while carrying a parcel and confirm the penalty.
- Deliver 5 parcels and confirm the win state.
- Let the timer expire and confirm the loss state.
- Press `R` after an end state and confirm the start screen returns.
