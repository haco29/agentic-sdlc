---
description: Implement the next task test-first, verify, commit, and tick it off. "/sdlc:build auto" runs every task after one approval.
argument-hint: "[auto]"
---

Invoke `sdlc:incremental-implementation` together with
`sdlc:test-driven-development`. Paths and the evidence format come from
`sdlc:sdlc-artifacts`.

## Default: the next task, then stop

1. Read `$DIR/plan.md` and `$DIR/todo.md`. Pick the first unticked task. None left: say so
   and suggest `/sdlc:test` or `/sdlc:review`.
2. Load only the context this task needs (`sdlc:context-engineering`).
3. **RED**: write a test for the task's acceptance criteria, run it, and see it fail for the
   right reason. Log it in Test evidence.
4. **GREEN**: make the smallest change that passes, following the project's conventions
   (`CLAUDE.md`).
5. Run the full test suite and the linters. Log the result in Test evidence.
6. Tick the task in `todo.md`. The first time, also tick `/sdlc:build` in the coverage checklist.
7. Commit the files this task touched plus `todo.md` and `plan.md`, staged by name (never
   `git add -A`), with a message like `feat: <task>`.
8. Stop and summarize what changed and what's next.

## `/sdlc:build auto`: every task, one approval

When `$ARGUMENTS` is `auto`:

1. Require an Approved spec and a plan. If either is missing, stop.
2. Require a clean working tree (`git status --porcelain`), apart from the `$DIR/` files.
3. Show the remaining tasks and wait for an explicit yes.
4. Run the default loop for each task in order: test first, one commit per task.
5. Stop and ask instead of pushing through when a test can't be made to pass without an
   obvious fix (`sdlc:debugging-and-error-recovery`), the spec doesn't answer a
   question, or a step can't be undone with `git revert`.
6. Summarize: tasks done, tests added, commits made, anything skipped.
