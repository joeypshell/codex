# AGENTS.md

## Project Posture

This is an AI-assisted Godot project. Treat this file as the living operating guide for Codex and other coding agents working in this repository.

Keep guidance practical and compact. Add rules only when they prevent repeated mistakes or preserve a workflow future agents need.

## Repository Shape

- Godot project config: `project.godot`
- Scenes: `scenes/`
- GDScript source: `scripts/`
- Web export preset: `export_presets.cfg`
- GitHub Actions: `.github/workflows/`
- Local verification wrapper: `tools/verify-godot.ps1`
- Current-state gameplay docs: `docs/current/`
- Backlog snapshot: `docs/BACKLOG.md`; live task state stays in GitHub Issues
- Agent workflow docs: `docs/GITHUB_ISSUE_WORKFLOW.md`, `docs/AGENT_HANDOFF_TEMPLATE.md`
- Generated files not to commit: `.godot/`, `build/`, local editor/cache files

## Source-of-Truth Rules

- `docs/current/` describes implemented behavior.
- Planning docs are proposals until accepted and reflected in current docs or GitHub issues.
- GitHub issues are the active task contract once work is ticketed.
- If gameplay, runtime, export behavior, input, or project workflow changes, update the matching current doc before closing the issue.

## Development Workflow

- Read the issue, linked docs, and nearby scene/script files before editing.
- Prefer existing scene/script patterns over new abstractions.
- Keep changes scoped to the issue.
- If new work appears, create or request a follow-up issue instead of expanding the ticket.
- Do not revert unrelated user changes.
- Do not commit generated `.godot/` or `build/` output.

## GitHub Issue Workflow

Use GitHub issues for meaningful feature, bug, workflow, and demo work.

Issues should include:

- summary or user story
- acceptance criteria
- relevant docs and code areas
- dependencies or blockers
- implementation notes
- verification steps

Record durable decisions, blockers, commit hashes, and verification results in issue comments.

## Feature Planning Workflow

For broad features, write a compact plan under `docs/planning/` before implementation. Split the plan into small issues that one agent can complete and verify. Use a `codex/<feature>-dev` integration branch only when multiple issues must be reviewed together before merging to `main`.

## Verification Commands

Preferred checks when Godot is available:

```powershell
.\tools\verify-godot.ps1
```

Run automated rule tests with:

```powershell
.\tools\test-godot.ps1
```

If Godot is not on PATH, pass an explicit binary path:

```powershell
.\tools\verify-godot.ps1 -GodotBin "C:\path\to\Godot.exe"
.\tools\test-godot.ps1 -GodotBin "C:\path\to\Godot.exe"
```

Manual checks:

- Open `project.godot` in Godot 4.7 and press Play.
- Verify the web build through GitHub Pages after deployment.

Documentation-only checks:

```powershell
git diff --check
git status --short
```

## Commit Hygiene

- Run `git status --short` before staging and before final response.
- Stage files explicitly.
- Do not commit `.godot/` or `build/`.
- PR descriptions should reference issues and include verification commands.

## Agent Learning Loop

When a bug or workflow takes real effort to understand, propose a short `AGENTS.md` update. Keep it specific enough that future agents will actually read it.
