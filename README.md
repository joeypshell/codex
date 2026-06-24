# Firefly Courier

Firefly Courier is a tiny 2D cozy arcade game built in Godot 4.7 with GDScript. You guide a firefly through a garden, collect glowing parcels, avoid drifting hazards, and clear as many delivery floors as possible before the night timer runs out.

## Controls

- Start run: Enter, Space, or any movement key
- Move: WASD or arrow keys
- Choose upgrade after floor clear: 1, 2, or 3
- Return to start screen after run over: R

## How to Run

1. Download Godot 4.7 from the official Godot website.
2. Open Godot and import this repository by selecting `project.godot`.
3. Press Play.

## Local Verification

When Godot is available locally, run the scene-load and web-export check with:

```powershell
.\tools\verify-godot.ps1
```

If Godot is not on PATH, pass the executable path:

```powershell
.\tools\verify-godot.ps1 -GodotBin "C:\path\to\Godot.exe"
```

The script writes export output under `build/web`, which is ignored by git.

Run automated rule tests with:

```powershell
.\tools\test-godot.ps1
```

If Godot is not on PATH, pass the executable path:

```powershell
.\tools\test-godot.ps1 -GodotBin "C:\path\to\Godot.exe"
```

## Play on the Web

The `Deploy Web` GitHub Actions workflow exports the game for the web and publishes it with GitHub Pages whenever `main` changes.

After the first successful deployment, the browser build should be available at:

https://joeypshell.github.io/codex/

If the page is not live yet, open the repository settings on GitHub, go to Pages, and make sure the source is set to GitHub Actions.

After mobile-related changes, smoke test the GitHub Pages build from a phone in portrait and landscape. Confirm portrait shows a rotate prompt, landscape is readable in the available browser viewport, touch-and-slide movement works, upgrades can be tapped, and Restart works from the run-over screen.

The web export is installable as a PWA. On a phone browser, use **Add to Home Screen** or **Install app** when available, then launch Firefly Courier from the home screen for a standalone landscape-first experience with less browser chrome on supported browsers.

## Game Rules

- Collect one parcel at a time.
- Touch the mailbox while carrying a parcel to deliver it.
- Deliver 5 parcels before the timer reaches 0 to clear the current floor.
- Choose one of three upgrades after a floor clear to advance to the next floor.
- Brighter Wings increases movement speed for the current run.
- Moonlit Minute adds time to future floors for the current run.
- Gentle Handling lowers fragile hazard penalties.
- Lucky Satchel lowers normal hazard penalties.
- Wide Glow increases pickup radius.
- When the run ends, the summary shows floor reached, total deliveries, and chosen upgrades.
- There is no final win state; the run continues until the timer reaches 0.
- The first parcel is normal. Later parcels alternate between fragile and normal.
- Fragile parcels are pink/yellow and use a matching carried-parcel indicator.
- Touching a hazard drops your carried parcel and costs time: 6 seconds for normal parcels, 12 seconds for fragile parcels.
- Later floors shorten the timer and increase hazard count and speed.

## Project Shape

- `scenes/` contains Godot scene files.
- `scripts/` contains GDScript behavior.
- `tools/verify-godot.ps1` runs the local Godot scene-load and web-export verification.
- `tools/test-godot.ps1` runs automated Godot rule tests.
- `docs/current/GAMEPLAY.md` describes the current implemented gameplay and verification expectations.
- `docs/current/ROADMAP.md` describes the near-term issue-driven roadmap.
- `docs/BACKLOG.md` links the first GitHub issue backlog.
- `docs/GITHUB_ISSUE_WORKFLOW.md` contains the lightweight issue template for future agent work.
- `docs/AGENT_HANDOFF_TEMPLATE.md` contains the optional handoff template for larger tasks.
- `export_presets.cfg` contains the tracked Godot web export preset.
- `.github/workflows/verify.yml` keeps the existing GitHub workflow scaffold.
- `.github/workflows/deploy-web.yml` exports and deploys the browser build.
