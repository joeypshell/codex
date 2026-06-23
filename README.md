# Firefly Courier

Firefly Courier is a tiny 2D cozy arcade game built in Godot 4.7 with GDScript. You guide a firefly through a garden, collect glowing parcels, avoid drifting hazards, and deliver five parcels to the mailbox before the night timer runs out.

## Controls

- Move: WASD or arrow keys
- Restart after win/lose: R

## How to Run

1. Download Godot 4.7 from the official Godot website.
2. Open Godot and import this repository by selecting `project.godot`.
3. Press Play.

## Play on the Web

The `Deploy Web` GitHub Actions workflow exports the game for the web and publishes it with GitHub Pages whenever `main` changes.

After the first successful deployment, the browser build should be available at:

https://joeypshell.github.io/codex/

If the page is not live yet, open the repository settings on GitHub, go to Pages, and make sure the source is set to GitHub Actions.

## Game Rules

- Collect one parcel at a time.
- Touch the mailbox while carrying a parcel to deliver it.
- Deliver 5 parcels before the timer reaches 0 to win.
- Touching a hazard drops your carried parcel and costs time.

## Project Shape

- `scenes/` contains Godot scene files.
- `scripts/` contains GDScript behavior.
- `export_presets.cfg` contains the tracked Godot web export preset.
- `.github/workflows/verify.yml` keeps the existing GitHub workflow scaffold.
- `.github/workflows/deploy-web.yml` exports and deploys the browser build.
