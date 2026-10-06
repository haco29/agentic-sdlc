---
description: Simplify the branch's code without changing behavior; tests stay green throughout
---

Invoke `agentic-sdlc:code-simplification`. Paths and the evidence format come from
`agentic-sdlc:sdlc-artifacts`.

1. **Start green.** Run the full suite. If anything fails, stop: only simplify working code.
2. **Scope.** The files changed on this branch, unless the user names a wider scope.
3. **One change at a time.** Apply each simplification, run the tests, and revert it if
   anything turns red.
4. **Nothing to simplify** is a valid outcome. Say so and record it.
5. Log the final run in Test evidence and tick `/code-simplify` in the coverage checklist.
6. **Commit separately**, as `refactor: <what>`, with `plan.md`. No behavior change, so no
   test should need editing; if one does, that change wasn't a simplification. With nothing
   to simplify, commit `plan.md` alone as `docs(sdlc): nothing to simplify`.
