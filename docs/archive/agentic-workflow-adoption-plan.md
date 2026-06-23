# Agentic Workflow Adoption Plan

This report studies the public `Walt-Raymond-Williams/sunny-town-hq` repository and extracts a practical agentic development workflow for this Godot project.

Sunny Town HQ is much larger than this repository, so the goal is not to copy every document or process. The useful adoption pattern is: keep current truth easy to find, turn broad ideas into small GitHub-ready issues, make issues the active contract for agents, verify deterministically, and promote repeated lessons back into `AGENTS.md`.

## 1. What Sunny Town HQ Is Doing Well

- `AGENTS.md` is a real operating guide, not a generic note. It tells future agents the repository shape, ownership boundaries, source-of-truth rules, issue workflow, branch workflow, verification commands, commit hygiene, and learning loop.
- Current-state docs are separated from historical planning. `docs/current/` describes implemented architecture, APIs, database, runtime, and package boundaries. `docs/archive/` preserves old plans without letting them override current behavior.
- Broad ideas become discovery docs, roadmap docs, GitHub issues, tracking docs, and focused handoff docs. The NPC life/work epic is a strong example: an epic issue defines the outcome, discovery goals, candidate slices, and related docs; child issues carry acceptance criteria and verification steps.
- GitHub issues are the active task contract. Good issues include a user story or problem statement, acceptance criteria, implementation notes, blockers, related docs/code, and verification commands.
- Agents are told to read linked docs before editing. The issue plus handoff doc narrows the task while `docs/current/` prevents stale planning docs from misleading implementation.
- New work is split into follow-up issues instead of expanding vague tickets. This keeps one agent pass focused and reviewable.
- Durable decisions get captured in `docs/current/` when architecture, API, schema, service boundaries, runtime behavior, or durable workflows change.
- Multi-ticket work uses a `codex/<feature>-dev` integration branch. Individual issues can land there, while `main` stays stable until a coherent slice is reviewed.
- Verification is explicit and deterministic. `Taskfile.yml` centralizes commands such as `task verify`, and issues/PRs record the exact checks run.
- Commit hygiene is concrete: check status before staging/final response, stage explicitly, avoid generated assets, reference issues, and include verification in PR descriptions.
- The learning loop is lightweight: when a mistake recurs or a workflow proves useful, propose a short `AGENTS.md` update.

## 2. Practices We Should Adopt

### Agent Operating Instructions

- Keep `AGENTS.md` as the first stop for future agents.
- Make it short, specific, and operational: repo shape, source-of-truth docs, issue rules, verification commands, and generated files to avoid.
- Add lessons only when they prevent repeated mistakes or preserve a useful workflow.

### Documentation Structure

- Add `docs/current/` only when there is enough current truth to justify it.
- For this repo, start with one current-state doc: `docs/current/GAMEPLAY.md`.
- Add `docs/current/RUNTIME.md` when local/web/export instructions outgrow the README.
- Add `docs/archive/` only after there are planning docs worth preserving but no longer treating as source of truth.
- Avoid creating database, API, or service-boundary docs until this project actually has those surfaces.

### GitHub Issue Workflow

- Use GitHub issues for meaningful feature, bug, workflow, and demo work.
- Require issues to include acceptance criteria and verification steps before agents implement them.
- Keep small tasks small. If a new feature idea appears during work, create a follow-up issue rather than stretching the current one.
- Issue comments should record durable findings, blockers, scope changes, commits, and verification results.

### Feature Planning Workflow

- For broad changes, create a compact planning doc under `docs/planning/`.
- Convert the plan into one ready issue at a time when early implementation could change later decisions.
- Create a tracking doc only for multi-ticket work that needs an integration branch or multiple handoffs.
- Use handoff docs only when the issue needs more local context than comfortably fits in GitHub.

### Verification Workflow

- Prefer deterministic checks before manual play.
- Keep the current Godot checks simple:
  - open `project.godot` in Godot 4.7 and run the game
  - run Godot headless against `res://scenes/Main.tscn`
  - export the `Web` preset and smoke-check `index.html`, `index.wasm`, and `index.pck`
- Add a `Taskfile.yml` later if these commands become repetitive.

### Branch and PR Workflow

- Keep `main` stable.
- Use short branches for small issues, such as `codex/web-export-docs`.
- Use `codex/<feature>-dev` integration branches only for multi-ticket features such as level progression, menus, or save data.
- PRs should link issues, summarize behavior, and list verification commands.

### Commit Hygiene

- Check `git status --short` before staging and before final response.
- Stage files explicitly.
- Do not commit `.godot/`, `build/`, local logs, or generated web exports.
- Commit Godot metadata that belongs to source stability, such as tracked `.uid` and `.import` files already produced by the editor/export process.

### Agent Learning Loop

- If a Godot export setting, scene setup, or workflow mistake takes effort to rediscover, add one short rule to `AGENTS.md`.
- Do not turn `AGENTS.md` into a changelog. Keep durable rules only.

## 3. Proposed Repository Structure

Recommended now:

```text
AGENTS.md
README.md
docs/
  agentic-workflow-adoption-plan.md
  current/
    GAMEPLAY.md
  GITHUB_ISSUE_WORKFLOW.md
  AGENT_HANDOFF_TEMPLATE.md
```

Recommended later, only when needed:

```text
docs/
  current/
    RUNTIME.md
  planning/
    <feature-name>.md
  archive/
    <old-plan>.md
Taskfile.yml
```

Do not add these yet:

- `docs/current/API.md`, because there is no app API.
- `docs/current/DATABASE.md`, because there is no database.
- `docs/issues/`, because GitHub Issues should hold execution state.
- Many per-feature handoff docs, because the project is still small.

## 4. Proposed AGENTS.md

````markdown
# AGENTS.md

## Project Posture

This is an AI-assisted Godot project. Treat this file as the living operating guide for Codex and other coding agents.

Keep guidance practical and compact. Add rules only when they prevent repeated mistakes or preserve a workflow future agents need.

## Repository Shape

- Godot project config: `project.godot`
- Scenes: `scenes/`
- GDScript source: `scripts/`
- Web export preset: `export_presets.cfg`
- GitHub Actions: `.github/workflows/`
- Current gameplay docs: `docs/current/`
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

Preferred checks:

```powershell
godot --headless --path . --scene res://scenes/Main.tscn --quit-after 5
godot --headless --path . --export-release Web build/web/index.html
```

Manual checks:

- open `project.godot` in Godot 4.7 and press Play
- verify the web build through GitHub Pages after deployment

## Commit Hygiene

- Run `git status --short` before staging and before final response.
- Stage files explicitly.
- Do not commit `.godot/` or `build/`.
- PR descriptions should reference issues and include verification commands.

## Agent Learning Loop

When a bug or workflow takes real effort to understand, propose a short `AGENTS.md` update. Keep it specific enough that future agents will actually read it.
````

## 5. Proposed GitHub Issue Template

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

## 6. Proposed Agent Handoff Template

````markdown
# <Task Name> Agent Handoff

## Issue Link or Task ID

<GitHub issue URL or number>

## Goal

<One-sentence outcome.>

## Context

<Brief project/gameplay context needed to avoid rediscovery.>

## Files / Docs To Read First

- `AGENTS.md`
- `<GitHub issue>`
- `docs/current/GAMEPLAY.md`
- `<specific scene/script paths>`

## Constraints

- Keep scope to the issue.
- Do not commit `.godot/` or `build/`.
- Preserve current controls and web export unless the issue says otherwise.

## Expected Implementation Areas

- `scenes/...`
- `scripts/...`
- `README.md` or `docs/current/...` if behavior changes

## Verification Commands

```powershell
godot --headless --path . --scene res://scenes/Main.tscn --quit-after 5
godot --headless --path . --export-release Web build/web/index.html
```

## Definition of Done

- Acceptance criteria are met.
- Verification results are recorded.
- Docs/current is updated if accepted behavior changed.
- Git status is clean or only expected local generated files remain ignored.

## What Not To Change

- <Explicitly out-of-scope files or behavior.>
````

## 7. Gap Analysis

Already close:

- `AGENTS.md` exists and already mirrors the broad Sunny Town workflow.
- README explains the game, controls, local run path, web URL, and project shape.
- GitHub Actions already include web deployment.
- Generated output is mostly ignored.

Missing:

- No `docs/current/` source of truth yet.
- No compact issue workflow doc or issue template.
- No handoff template.
- No planning/archive convention.
- No project-level repeatable verification command such as `task verify`.
- Current `AGENTS.md` still has generic multi-language verification examples that do not fit a Godot-only repo.

Change first:

1. Add `docs/current/GAMEPLAY.md` with current rules, controls, scene responsibilities, and web deployment behavior.
2. Add `docs/GITHUB_ISSUE_WORKFLOW.md` with the compact issue template and rules.
3. Add `docs/AGENT_HANDOFF_TEMPLATE.md`.
4. Tighten `AGENTS.md` so verification and docs rules are Godot-specific.

Do not change first:

- Do not create a large harness.
- Do not add API/database docs.
- Do not create many planning folders before there is planning content.
- Do not move existing files just to resemble Sunny Town HQ.

## 8. Recommended First Pull Request

Smallest useful first PR: documentation and workflow scaffolding only.

Title:

```text
Adopt compact agentic workflow docs
```

Contents:

- Add `docs/current/GAMEPLAY.md`.
- Add `docs/GITHUB_ISSUE_WORKFLOW.md`.
- Add `docs/AGENT_HANDOFF_TEMPLATE.md`.
- Update `AGENTS.md` to use the compact Godot-specific version above.
- Optionally add a short README link to `docs/current/GAMEPLAY.md`.

Verification:

```powershell
git diff --check
git status --short
```

Manual review:

- Confirm the docs are short enough for future agents to read.
- Confirm no product features, scene files, scripts, export assets, or generated files changed.

Next after that PR:

- Create the first real GitHub issue using the template, such as "Document current Firefly Courier gameplay state" or "Add a second level plan."
- Only add a `Taskfile.yml` after the Godot verification commands become repetitive.
