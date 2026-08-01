# Claude Code Agent Instructions

## Post-Implementation Verification Protocol

After every implementation, refactor, or fix, run through the following checklist **in order**. Apply only what is relevant to the current repo and change scope. Use observable evidence in the codebase before applying any rule.

---

## Core Principles

- Verify only what is applicable to the directory/repository you are working in.
- Use observable repo evidence before applying any rule.
- Apply DRY and YAGNI with judgment, not mechanically.
- No speculative refactors. No forced abstraction.

---

## Container-first defaults (Python + uv + Compose)

When **bootstrapping a new project**, if the user has not already said whether they want containers (e.g. “with Docker” / “no Docker”), **ask once** before adding or withholding `Dockerfile`, Compose, or Dev Container files. If they opt in, apply the bullets below; if they opt out, skip container files until they ask.

Use this when the **target repository** (not necessarily this dotfiles repo) includes a `Dockerfile`, `docker-compose.yml` with a `dev` service, and optionally `.devcontainer/devcontainer.json` aligned with the Astral uv workflow.

- **Run context:** Prefer `docker compose run --rm dev <command>` (or `podman compose` / `podman-compose` on hosts configured that way). Assume workspace `**/app`** and service name `**dev`** unless the repo’s compose file says otherwise.
- **Image / toolchain:** Base image `**ghcr.io/astral-sh/uv:python3.12-bookworm-slim`**; install with `**uv pip install --system`**. Respect `**PYTHONDONTWRITEBYTECODE=1**` and `**PYTHONUNBUFFERED=1**` when present in the `Dockerfile`.
- **Dependencies:** Runtime/prod parity comes from `**requirements.lock.txt`** at **image build** (`COPY` + `RUN uv pip install`). Dev-only tools use `**requirements-dev.lock.txt`**, typically via Dev Container `**postCreateCommand`**. Do not suggest mixing those roles without repo evidence.
- **Volumes:** Common pattern is `**.:/app`** and `**./data:/data`** for live code and local artifacts; prefer durable outputs under `**data/`** when that mount exists.
- **Secrets:** Mount keys/certs **read-only** under `**/run/secrets/`** with stable in-container filenames. In compose, **never** hardcode host-specific paths—use **environment variables** (resolved from `.env`, not committed) for the host-side path of each secret. Do not paste real paths or key filenames into docs or commits.
- **Dev Containers:** When `.devcontainer/devcontainer.json` sets `**dev.containers.dockerPath`** to `**podman`** and compose path to `**podman-compose`**, treat that as authoritative for editor-attached sessions; keep CLI advice consistent with Docker vs Podman on that machine.
- **Edits to the stack:** OS packages → `**Dockerfile`**; published ports and bind mounts → `**docker-compose.yml`**; editor-only wiring → `**.devcontainer/devcontainer.json**`.

If the repo has none of these files, **skip** this section and follow whatever run instructions exist there.

Never do containerized tests or builds on a local machine unless explicitly asked to do so.

---

## 1. Scope + Impact

- List every modified file and module.
- List every interface or contract affected by the change.
- Define intended behavior in concise acceptance bullets (what should now be true).
- Confirm implementation matches intent exactly — no hidden scope expansion, no bonus features.

---

## 2. Organization (Against Existing Structure Only)

- Verify new/updated files follow the current directory and naming conventions already present in the repo.
- If layering exists (e.g., API / domain / persistence, or ingestion / transform / output), confirm boundaries are respected.
- Check imports for circular dependencies or cross-layer leakage.
- **Do not reorganize the project** unless the change itself introduced a structural inconsistency that must be resolved.

---

## 3. Intelligent DRY (Change-Scoped Only)

- Look **only** for duplication introduced by this change — not pre-existing duplication.
- Refactor only if:
  - The duplication is meaningful (not 2–3 trivial lines), **and**
  - Consolidation improves clarity and aligns with patterns already in the repo.
- Do not introduce new abstraction layers unless the repo already uses that pattern.
- Prefer readability over theoretical reuse.

---

## 4. Sensible YAGNI (Strict)

- Confirm no speculative utilities, configs, flags, extension hooks, or abstractions were added.
- Remove any unused scaffolding introduced in the change.
- Do not generalize code for hypothetical future use cases.
- If a structure supports exactly one real use case, keep it simple and direct.

---

## 5. Always Maintain These Files

### README.md

- Must exist and describe what the code does, how to run it, and what dependencies are required.
- Update on every change that alters behavior, inputs, outputs, or setup steps.

### Unit Tests

- Write or update unit tests for every new or modified function/module.
- Tests should cover the happy path, edge cases, and expected failure modes.
- Use the test framework already present in the repo (do not introduce a new one).

### Logging

- All pipeline steps, data loads, and non-trivial functions should log their inputs, outputs, and any errors.
- Use Python's standard `logging` module (not `print`) unless the repo uses something else.
- Log levels: `DEBUG` for verbose detail, `INFO` for milestones, `WARNING` for recoverable issues, `ERROR` for failures.

### .env.example

- Must exist at the repo root for any project that uses environment variables.
- List every required key with a best-guess placeholder value (e.g., `DATABASE_URL=postgresql://user:password@localhost:5432/dbname`).
- Update whenever a key is added, removed, or renamed.

### resume_prompt.md (Session Recovery File)

- Maintain a `resume_prompt.md` at the repo root for any project with non-trivial in-progress work.
- Write or update it proactively after significant work, or immediately when the user asks.
- Its purpose is to let Claude cold-start a new session with full context — treat it as a briefing document, not a task list.
- Include:
  - **Goal:** What the project/task is trying to accomplish.
  - **Current state:** What has been completed and what is in progress.
  - **Next steps:** The immediate actions needed to continue.
  - **Key decisions:** Any non-obvious choices made and why.
  - **Open questions:** Anything unresolved that needs human input.
  - **File map:** The most important files and what they do.
- Keep it concise — it should be readable in under two minutes.
- Update it whenever the state of work changes meaningfully.

---

### ISSUES.md (Running To-Do / Validation List)

- Maintain a running `ISSUES.md` file at the repo root.
- Add any item that needs human validation, manual testing, or future follow-up.
- Format:

```markdown
## Open Issues

| # | Description | Priority | Added |
|---|-------------|----------|-------|
| 1 | Validate output row counts against source | High | 2025-01-01 |

## Resolved Issues

| # | Description | Resolved |
|---|-------------|----------|
| 1 | Fixed connector import path | 2025-01-02 |
```

---

## Project Initialization Checklist

When creating or scaffolding a new project, complete the following in order:

1. Create and push `main` branch.
2. Create and switch to `dev-container` branch — all development work originates here.
3. Seed the `memory/` system with initial project context: goals, stack, key decisions, and any known constraints.
4. Create a `CLAUDE.md` at the repo root with project-specific rules and context.
5. Ask about containerization preference if not already stated.

---

## Project CLAUDE.md

- Every project repo must have a `CLAUDE.md` at its root.
- Keep it focused on project-specific conventions, stack details, known constraints, and any overrides to global rules — the global `CLAUDE.md` covers the rest.
- Update it whenever something changes that would affect how Claude should behave in that repo.

---

## Memory (Cross-Session History)

- Seed the `memory/` system at project initialization with project goals, stack, architecture decisions, and non-obvious context.
- Update memories as key decisions change or new constraints emerge.
- Before acting on a recalled memory, verify it against the current state of the repo — memories can go stale.
- Do not save ephemeral task details, in-progress work, or anything only relevant to the current session.

---

## Branch Strategy

- **Initialization:** After seeding a new repo, create and push a `main` branch, then immediately switch to a `dev-container` branch. All development work originates from `dev-container`.
- **Feature branches** branch off `dev-container` using the prefix `feature/`.
- **Bug fix branches** use the prefix `fix/`.
- **Maintenance/chore branches** use the prefix `chore/`.
- **PRs to `main`** are created only when explicitly requested by the user.
- **Before every commit or push**, confirm the current working branch and surface it to the user.
- All PRs are created as text to be manually run, not attempted as automatic
- Always perform a git pull before creating a new branch

---

## Error Handling

- **Raise, don't return:** Signal failure by raising an appropriate exception, not by returning `None`, `-1`, or error dicts. Failures should be loud and explicit.
- **Only catch when you can recover:** Catch exceptions only when you have a concrete recovery action (retry, fallback, user-facing error at a boundary). Do not catch to suppress or log-and-continue when the program is in an unknown state. Bare `except: pass` is almost always wrong.
- **Log once at the boundary:** When catching at a system boundary (API handler, pipeline entry point), log the full error with context before responding or re-raising. Do not log the same exception multiple times as it propagates — log once where it is handled.

---

## Security

- Validate and sanitize all user-controlled input at system entry points (API endpoints, CLI args, file uploads, env vars consumed at runtime).
- Never trust data from external APIs or user input deeper in the stack — treat it as untrusted until validated.
- Avoid common injection vectors: SQL injection, shell injection, and path traversal.
- Never expose raw error messages, stack traces, or internal paths to end users.

---

## CI/CD (GitHub Actions)

- All repos should have a GitHub Actions workflow that runs linting and tests on pushes and PRs targeting `main`, `dev-container`, and `staging` (if it exists).
- Do not apply CI workflows to feature, fix, or chore branches.
- Before pushing to a protected branch, confirm tests pass and there are no linting errors locally.
- Never knowingly push code that breaks the CI pipeline — fix the issue first.

---

## General Behavior

- **New projects / scaffolding:** When the user asks you to **create, scaffold, or bootstrap** a project (new codebase, new app, or substantial greenfield layout), **ask explicitly** whether they want **containerization** (e.g. `Dockerfile`, Compose `dev` service, `.devcontainer`) **before** you implement—unless they already stated a preference in the same message. Do not assume “no containers” or “containers included” without that answer. If they say no, omit container files unless they ask later; if yes, follow **Container-first defaults** where it fits the stack.
- Never commit `.env` files, credentials, or private keys.
- Never modify `main` directly.
- Prefer small, focused commits with clear messages.
- When in doubt about scope, do less and ask.
- Always assign authorship of git PR and commit messages to claude if you wrote them
- When doing writing tables of any kind in sql or snowflake or anywhere else, only do a create if not exists, do not replace any tables unless explicitly told to do so
- Write resume prompts to a resume_prompt.md in the root directory of the project when prompted, or ask the user after a significant amount of work has been done without one
- Only automatically modify the working directory. for any changes in an external directory you must prompt me for permission first
- If you are taking a destructive action you must prompt me before doing it, even if it is described in an approved plan
- Never use an m dash anywhere
- If making a github worktree, create it as a sibling directory of the main/dev-container directory
- Store all plan files in a plan directory within the project

