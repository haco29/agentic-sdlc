---
description: Prove it works. Close test gaps against the spec, or reproduce a bug test-first.
argument-hint: "[behavior or bug to test]"
---

Invoke `sdlc:test-driven-development`. Paths and the evidence format come from
`sdlc:sdlc-artifacts`.

## With an argument

- **A bug** (Prove-It): write a test that reproduces it, confirm it fails, fix it, confirm
  it passes, run the full suite.
- **A behavior**: test first, then the code that makes it pass.

## Without an argument: a gap pass for this branch

1. List every success criterion and edge-case decision in `$DIR/spec.md`.
2. Ask the `test-engineer` agent, in its own context, to map each one to an existing test
   and report the gaps. Give it the spec and the branch diff.
3. For each gap, write the test and run it. A failing test means a bug: fix it test-first.
4. Show a table: criterion → test → pass or fail.

## Always

Run the full suite and linters, log the run in Test evidence, and tick `/sdlc:test` in the
coverage checklist with a note such as `4 criteria, 2 gaps closed`. Commit the new tests,
any fixes and `plan.md` as `test: <what>`.
