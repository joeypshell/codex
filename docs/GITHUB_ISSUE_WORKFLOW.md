# GitHub Issue Workflow

Use GitHub issues as the execution backlog for meaningful work. Keep the process light: this is a small Godot game, so tiny cleanups do not need tickets.

## When To Create An Issue

Create or select an issue before starting:

- new gameplay features
- player-visible bugs
- web export or deployment changes
- workflow/documentation changes meant to guide future agents
- refactors that change maintainability risk

Do not require an issue for:

- typo fixes
- tiny formatting edits
- local experiments that will not be committed
- small follow-up edits already covered by an active issue

## Agent Rules

- Treat the issue as the active task contract.
- Read `AGENTS.md`, linked docs, and nearby scene/script files before editing.
- Keep scope tight. If new work appears, create or request a linked follow-up issue.
- Record durable decisions, blockers, commit hashes, and verification results in issue comments.
- Update `docs/current/` when accepted gameplay, runtime, export behavior, input, or workflow changes.

## Issue Template

```markdown
## Summary

<One or two sentences describing the task.>

## User Story or Problem Statement

As a <player/developer/reviewer>, I want <capability/fix>, so that <outcome>.

## Acceptance Criteria

- [ ] <Observable result>
- [ ] <Observable result>
- [ ] Existing behavior that must not regress: <behavior>

## Relevant Docs

- `AGENTS.md`
- `README.md`
- `docs/current/GAMEPLAY.md`

## Relevant Code Areas

- `scenes/...`
- `scripts/...`
- `.github/workflows/...` if deployment changes

## Dependencies / Blockers

- None, or list issue/doc/decision blockers.

## Implementation Notes

- Keep the first slice small.
- Prefer existing scene/script patterns.
- Do not commit generated `build/` or `.godot/` output.

## Verification Steps

- [ ] Open `project.godot` in Godot 4.7 and run the game.
- [ ] Run the main scene headless if Godot CLI is available.
- [ ] Export the `Web` preset if web behavior changes.
- [ ] Manual smoke: <specific gameplay check>.

## Follow-up Work

- <Optional linked future issue ideas.>
```
