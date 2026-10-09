---
name: sdlc-artifacts
description: Defines where SDLC artifacts live (sdlc/<branch>/spec.md, plan.md, todo.md, review.md), the command coverage checklist, the test evidence log, and the gates a branch must pass before a ready PR. Use whenever running /sdlc:spec, /sdlc:plan, /sdlc:build, /sdlc:test, /sdlc:review, /sdlc:code-simplify or /sdlc:pr, when writing or reading a spec, plan or task list, or when asked whether a branch is ready for review.
---

# SDLC artifacts and gates

The loop is `/sdlc:spec → /sdlc:plan → /sdlc:build → /sdlc:test → /sdlc:review → /sdlc:code-simplify → /sdlc:pr`. Every
command leaves evidence in the repo, so the next session, the reviewer and `/sdlc:pr` can see
what actually happened. Chat history is not evidence.

## Where artifacts live

Resolve the folder at the start of every command:

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
DEFAULT=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
DIR="sdlc/$BRANCH"
```

- On the default branch (`$DEFAULT`, or `main`/`master` when there is no remote) or a
  detached HEAD: **stop**. Ask the user to create a feature branch first
  (`git checkout -b feat/<name>`). Artifacts on a shared branch collide.
- A branch name with `/` becomes nested folders (`sdlc/feat/percentages/`). That's expected.
- Never write `SPEC.md`, `tasks/plan.md` or `tasks/todo.md` at the repo root. In this kit
  those are always `$DIR/spec.md`, `$DIR/plan.md` and `$DIR/todo.md`.

| File | Written by | Holds |
|---|---|---|
| `spec.md` | `/sdlc:spec` | Status, objective, scope and non-goals, success criteria, edge-case decisions, open questions |
| `plan.md` | `/sdlc:plan`, then updated by every command | Approach, tasks with acceptance criteria, risks, command coverage, test evidence |
| `todo.md` | `/sdlc:plan`, ticked by `/sdlc:build` | One checkbox per task, same numbering as `plan.md` |
| `review.md` | `/sdlc:review` | Findings and what happened to each |
| `pr.md` | `/sdlc:pr`, only when no PR can be opened | Title, base branch, body, gate results |

A decision with a real trade-off goes in `docs/decisions/NNNN-<title>.md` as an ADR, linked
from `spec.md` or `plan.md` (see `sdlc:documentation-and-adrs`).

Templates for the three main files are in `templates/` next to this skill.

## Committing artifacts

Artifacts are committed, so the history shows the loop ran in order and the PR carries them:

- `/sdlc:spec` commits `spec.md` once it's approved: `docs(sdlc): spec for <feature>`.
- `/sdlc:plan` commits `plan.md` and `todo.md` once the plan is approved: `docs(sdlc): plan for <feature>`.
- `/sdlc:build`, `/sdlc:test`, `/sdlc:review` and `/sdlc:code-simplify` include the artifact lines they changed
  (`todo.md`, coverage, test evidence, `review.md`) in the same commit as the code they
  belong to.

Stage files by name. Never `git add -A`.

## The spec status line

`spec.md` starts with:

```markdown
# Spec: <feature>

Status: Draft
```

`/sdlc:spec` changes it to `Status: Approved (YYYY-MM-DD)` only after the user explicitly says
yes. Downstream commands warn when the spec is still a draft.

## Command coverage

`plan.md` carries this section. Each command ticks **its own** line when it finishes, with a
short note. Skipping a step is allowed when it's a conscious choice: write
`skipped: <reason>` instead of a tick.

```markdown
## SDLC command coverage

- [x] /sdlc:spec: approved 2026-10-06 after 6 questions
- [x] /sdlc:plan: 3 tasks
- [ ] /sdlc:build
- [ ] /sdlc:test
- [ ] /sdlc:review
- [ ] /sdlc:code-simplify
```

A tick is a claim. Only tick a line after that command actually ran on this branch.

## Test evidence

`plan.md` also carries an append-only log. Record the exact command and its result, never a
summary from memory:

```markdown
## Test evidence

- 2026-10-06 14:02 · task 2 RED · `pytest tests/test_core.py -q` → 1 failed (expected)
- 2026-10-06 14:05 · task 2 GREEN · `pytest -q && ruff check .` → 14 passed, lint clean
```

A red-then-green pair is the strongest evidence a test tests something.

## Gates

A PR is ready only when every gate passes. `/sdlc:pr` checks them. Any command may report them.

| Gate | Passes when |
|---|---|
| G1 Spec | `spec.md` exists, is specific to this feature (no template text left), and is Approved |
| G2 Plan | `plan.md` has tasks with acceptance criteria, plus the coverage and evidence sections |
| G3 Tasks | every box in `todo.md` is ticked, or marked `skipped: <reason>` |
| G4 Evidence | the full test suite and linters pass **now**, after the last code change, and that run is in Test evidence |
| G5 Alignment | every success criterion in `spec.md` maps to code and a test, and nothing outside the spec's scope changed |
| G6 Coverage | every coverage line is ticked or explicitly skipped |

Report gates as a table: gate, pass or fail, and the evidence (a `file:line` or the command
output). Evidence over confidence: "should pass" is a fail.
