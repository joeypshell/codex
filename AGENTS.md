# AGENTS.md

## Project Posture

This is an AI-assisted project. Treat this file as the living operating guide for Codex and other coding agents working in this repository.

Keep guidance practical and compact. Add to this file when a workflow repeatedly helps, when a mistake recurs, or when debugging teaches a rule future agents should inherit. Prefer concrete commands, ownership boundaries, and verification steps over broad philosophy.

## Repository Shape

Update this section as the repository grows:

- Source code:
- Tests:
- Documentation:
- Runtime and deployment configuration:
- Generated artifacts that should not be committed:
- Common project commands:

When docs disagree, current-state docs and active GitHub issues are the source of truth for implemented behavior. Planning, roadmap, tracking, and archive docs are historical context unless an active issue says otherwise.

## Development Workflow

- Prefer existing repository patterns over new abstractions.
- Use `rg` / `rg --files` for search.
- Use focused edits and keep unrelated refactors out of task branches.
- Do not revert unrelated user changes.
- Keep generated, local, or machine-specific files out of commits unless explicitly requested.
- Capture durable decisions in docs when implementation changes architecture, APIs, runtime behavior, or project workflow.

## Feature Planning Workflow

For broad new features or redesigns, do discovery before implementation:

- Capture product direction, constraints, and open questions in a planning doc under `docs/`.
- Audit current code and current-state docs before decomposing work.
- Convert the plan into GitHub-ready tickets with acceptance criteria, implementation notes, blockers, related work, and verification steps.
- Use GitHub Issues for execution tracking, ownership, status, discussion, and PR linkage.
- Once a GitHub issue exists for the work, treat the issue as the active task contract.
- Prefer small tickets that one agent can complete and verify.
- Split design/schema decisions from implementation when the implementation depends on unresolved architecture.

## GitHub Issue Workflow

Use GitHub Issues as the execution backlog for meaningful project work.

Create or select an issue before starting:

- new product features or user stories
- bug fixes with user-visible behavior
- architecture, schema, service-boundary, protocol, or data-model changes
- tech debt cleanup that changes maintainability risk
- documentation work meant to shape project presentation or onboarding

Do not require a new issue for:

- typos, tiny formatting edits, or one-line cleanup
- local experiments that are not committed
- small follow-up edits already covered by the active issue

Issue contents should be useful to a future agent:

- user story or problem statement
- acceptance criteria
- relevant docs and code areas
- dependencies, blockers, and related issues
- implementation checklist when the work is non-trivial
- verification commands expected before close

During work:

- Read the issue and linked docs before editing.
- Add issue comments only for durable information: design decisions, scope changes, blockers, important discoveries, commit hashes, and verification results.
- If new work appears, prefer creating a linked follow-up issue instead of expanding the current ticket until it becomes vague.
- Keep Markdown docs for product vision, architecture rationale, and durable decisions; keep GitHub Issues for execution status, discussion, and history.

Recommended GitHub CLI commands when available:

```powershell
gh issue list --limit 30
gh issue view <number> --comments
gh issue comment <number> --body "..."
gh issue close <number> --comment "Completed in <commit>. Verified with <command>."
```

## Feature Integration Branch Workflow

For broad multi-ticket features or redesigns, use a feature integration branch instead of merging partial work directly into `main`.

- Name feature integration branches with the `codex/` prefix, for example `codex/search-redesign-dev`.
- Agents may complete individual GitHub issues on the integration branch or on smaller task branches that merge into the integration branch.
- Close a GitHub issue when its work has landed in the feature integration branch and verification has been recorded.
- Keep `main` stable.
- Before merging an integration branch into `main`, a human should review the feature end to end, run the agreed verification, and confirm current-state docs are accurate.
- The final PR from the integration branch to `main` should reference completed issues with `Refs #123` or `Closes #123` as appropriate.

## Verification

Favor deterministic checks before manual exploration.

Use the strongest available repo command:

```powershell
task verify
```

If no project-level verification command exists yet, use the checks that match the repository:

```powershell
go test ./...
npm test
npm run build
pnpm test
pnpm build
python -m pytest
cargo test
dotnet test
```

Record the exact commands run in issue comments, PR descriptions, and final handoff notes.

## Commit Hygiene

- Check `git status --short` before staging and before final response.
- Stage files explicitly. Avoid `git add .` unless the task truly includes every changed file.
- Reference relevant issues in commit messages when practical.
- PR descriptions should reference issues with `Closes #123` for completed work or `Refs #123` for partial or related work.
- PR descriptions should include verification commands run.
- Do not stage generated artifacts unless the repository explicitly tracks them.

## Learning Loop

When a bug takes real effort to understand, or a successful workflow would be useful next time, propose an `AGENTS.md` update. Keep each addition short enough that future agents will actually read it.
