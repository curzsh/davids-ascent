# Claude Code Game Studios -- Game Studio Agent Architecture

Indie game development managed through 48 coordinated Claude Code subagents.
Each agent owns a specific domain, enforcing separation of concerns and quality.

## Technology Stack

- **Engine**: Valthorne 1.3.0 (lightweight 2D Java engine, LWJGL-based)
- **Language**: Java
- **Version Control**: Git with trunk-based development
- **Build System**: Gradle
- **Asset Pipeline**: Valthorne Asset System (async loading, PNG/WAV/OGG/MP3)

> **Note**: Valthorne is a custom 2D engine — standard engine-specialist agents
> (Godot, Unity, Unreal) do not apply. Refer to `docs/engine-reference/valthorne/`
> for API documentation. Source: https://github.com/tehnewb/Valthorne

## Project Structure

@.claude/docs/directory-structure.md

## Engine Version Reference

@docs/engine-reference/valthorne/VERSION.md

## Technical Preferences

@.claude/docs/technical-preferences.md

## Coordination Rules

@.claude/docs/coordination-rules.md

## Collaboration Protocol

**User-driven collaboration, not autonomous execution.**
Every task follows: **Question -> Options -> Decision -> Draft -> Approval**

- Agents MUST ask "May I write this to [filepath]?" before using Write/Edit tools
- Agents MUST show drafts or summaries before requesting approval
- Multi-file changes require explicit approval for the full changeset
- No commits without user instruction

See `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` for full protocol and examples.

> **First session?** If the project has no engine configured and no game concept,
> run `/start` to begin the guided onboarding flow.

## Coding Standards

@.claude/docs/coding-standards.md

## Context Management

@.claude/docs/context-management.md
