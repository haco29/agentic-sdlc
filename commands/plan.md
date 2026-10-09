---
description: Slice the approved spec into small, testable tasks; writes sdlc/<branch>/plan.md and todo.md
---

Paths, the coverage checklist and the gates come from the `sdlc:sdlc-artifacts` skill.

1. **Read the spec.** Missing `$DIR/spec.md`: stop and suggest `/sdlc:spec`. `Status: Draft`: say
   so and ask whether to continue anyway.
2. **Plan, read-only.** Invoke `sdlc:planning-and-task-breakdown`. No code changes in
   this step.
3. **Don't overwrite work in progress.** If `$DIR/plan.md` or `todo.md` exists with unticked
   tasks for different work, stop and ask.
4. **Write `$DIR/plan.md`** from `skills/sdlc-artifacts/templates/plan.md`:
   - Approach: where the change lives and why, following the project's conventions.
   - Tasks: vertical slices, each with acceptance criteria (mapped to spec success
     criteria), the test that proves it, and the files it touches. Prefer 2–5 tasks.
   - Risks.
   - SDLC command coverage: tick `/sdlc:spec` (if the spec is Approved) and `/sdlc:plan`.
   - Test evidence: empty.
5. **Write `$DIR/todo.md`**: one checkbox per task, same numbering.
6. **Review together.** Present the plan and wait for approval. Revise until the user says
   yes, then commit `plan.md` and `todo.md` as `docs(sdlc): plan for <feature>`.
7. Stop. The next step is `/sdlc:build`.
