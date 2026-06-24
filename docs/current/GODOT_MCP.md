# Godot MCP Tooling

This file records the current decision for Godot MCP/server tooling in Firefly Courier.

## Decision

Adopt Godot AI MCP as an optional local development tool for scene-aware Codex work. Do not vendor the addon into this repository yet.

Use it when an issue benefits from a live Godot editor view, such as scene tree inspection, node property checks, screenshots, UI/layout debugging, particle/material setup, or editor-side validation. Keep GitHub issues, docs, and deterministic checks as the source of truth for the project workflow.

## Evaluated Tool

- Tool: Godot AI
- Source: https://github.com/hi-godot/godot-ai
- Asset page: https://store.godotengine.org/asset/dlight/godot-ai/
- Evaluated: 2026-06-24
- Reported requirements: Godot 4.3+ with Godot 4.7+ recommended, `uv`, and an MCP-compatible client.
- Reported Codex MCP endpoint: `http://127.0.0.1:8000/mcp`

Godot AI advertises MCP tools for live scene, node, script, UI, material, animation, particle, camera, input map, project setting, screenshot, and test workflows. That is a useful fit for this project because many future issues will be about scenes, HUD layout, web/mobile presentation, and visual polish.

## Repository Policy

- Treat Godot AI MCP as a local editor-assist tool, not a required runtime dependency.
- Do not commit local Godot AI addon files, MCP client config, cache files, secrets, or generated output.
- Keep work issue-driven. Agents must still read the GitHub issue and linked docs before editing.
- If Godot AI MCP is available, agents may use it to inspect scenes and verify editor state before changing `.tscn` files.
- If Godot AI MCP is not available, agents should continue with normal text-based scene/script edits and document that limitation.
- Any durable lesson from using the tool should be promoted into `AGENTS.md` only if it helps future agents avoid repeated mistakes.

## Local Setup Notes

These are local-machine steps, not repository setup steps:

1. Install `uv` if needed.
2. Install Godot AI from the Godot Asset Library, Godot Asset Store, or the upstream GitHub release.
3. Enable the plugin in Godot: Project Settings -> Plugins -> Godot AI.
4. Open the Godot AI dock and configure Codex, or add this to `~/.codex/config.toml`:

```toml
[mcp_servers."godot-ai"]
url = "http://127.0.0.1:8000/mcp"
enabled = true
```

5. Keep the Godot editor open with this project loaded when using the MCP server.
6. If telemetry is not desired, set `GODOT_AI_DISABLE_TELEMETRY=true` or `DISABLE_TELEMETRY=true` in the local environment before running the tool.

## Good Uses

- Inspect the current scene hierarchy before editing a scene file.
- Check node positions, sizes, anchors, collision shapes, and signal wiring.
- Capture screenshots during UI/mobile layout work.
- Validate editor-visible errors after changing scenes or scripts.
- Explore scene-heavy polish issues where text diffs alone are slow or risky.

## Poor Uses

- Replacing GitHub issues as the task contract.
- Making broad scene rewrites without a focused issue.
- Committing plugin/addon files just because they were installed locally.
- Treating the tool as a substitute for deterministic checks, manual phone testing, or GitHub Actions.

## Current Status

Adopted as optional local tooling. Setup was not completed in this repository during #36 because it requires local editor/plugin installation and client configuration. The next useful follow-up is a local setup issue or manual setup session, then a small issue that uses Godot AI MCP to inspect #35.
