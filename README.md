# Firefly Courier

Firefly Courier is a tiny 2D cozy arcade game built in Godot 4.7 with GDScript. You guide a firefly through a garden, collect glowing parcels, avoid drifting hazards, and deliver five parcels to the mailbox before the night timer runs out.

## Controls

- Move: WASD or arrow keys
- Restart after win/lose: R

## How to Run

1. Download Godot 4.7 from the official Godot website.
2. Open Godot and import this repository by selecting `project.godot`.
3. Press Play.

## Game Rules

- Collect one parcel at a time.
- Touch the mailbox while carrying a parcel to deliver it.
- Deliver 5 parcels before the timer reaches 0 to win.
- Touching a hazard drops your carried parcel and costs time.

## Project Shape

- `scenes/` contains Godot scene files.
- `scripts/` contains GDScript behavior.
- `.github/workflows/verify.yml` keeps the existing GitHub workflow scaffold.
