---
description: Grill the request one question at a time, then write and approve sdlc/<branch>/spec.md before any code
argument-hint: "[what you want to build]"
---

Paths, the status line and the gates come from the `agentic-sdlc:sdlc-artifacts` skill.

1. **Resolve the folder.** On the default branch or a detached HEAD, stop and ask the user to
   create a feature branch.
2. **Don't overwrite silently.** If `$DIR/spec.md` already exists, show its status and ask
   whether to revise it.
3. **Read before you ask.** Read the code and docs the request touches (and the project's
   `CLAUDE.md`), so your questions are about real decisions, not things you could look up.
4. **Grill.** Invoke `agentic-sdlc:interview-me` on the request: `$ARGUMENTS`, or ask for it
   if empty. One question at a time, each with your best guess. Make sure you cover:
   - edge cases: empty, zero, ties, duplicates, limits, invalid input
   - what is explicitly **out** of scope
   - how we'll know it works (observable, testable outcomes)

   Stop when you can predict the user's answers.
5. **Write the spec.** Invoke `agentic-sdlc:spec-driven-development` and write
   `$DIR/spec.md` from the skill's `templates/spec.md`, with `Status: Draft`. Every answer
   from the grilling lands in "Edge cases and decisions". Success criteria are numbered and
   testable.
6. **Approve.** Show the spec and ask for approval. Only on an explicit yes, set
   `Status: Approved (<today>)` and commit `spec.md` (plus any ADR) as
   `docs(sdlc): spec for <feature>`. A decision with a real trade-off becomes an ADR
   (`agentic-sdlc:documentation-and-adrs`).
7. **Stop.** Don't plan or write code. The next step is `/plan`, which records `/spec` in the
   coverage checklist.
