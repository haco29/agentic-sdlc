---
description: Five-axis review of the branch in a fresh context; findings go to sdlc/<branch>/review.md
---

Invoke `agentic-sdlc:code-review-and-quality`. Paths come from `agentic-sdlc:sdlc-artifacts`.

1. **Scope.** The branch diff against its base (`git diff $(git merge-base HEAD <default>)`),
   plus `spec.md` and `plan.md`.
2. **Fresh eyes.** Run the review in the `code-reviewer` agent, so the reviewer doesn't
   inherit the author's reasoning. Give it the diff, the spec and the plan. Ask for five
   axes: correctness (including alignment with the spec), readability, architecture,
   security and performance. Each finding needs a severity (Critical, Important or
   Suggestion), a `file:line` and a concrete fix.
3. **Record.** Write the findings to `$DIR/review.md` as a table with a Status column, all
   starting as `open`.
4. **Decide together.** Present the findings and ask which to fix. Fix each chosen one in
   its own commit, re-run the tests, and set its status to `fixed` or
   `won't fix: <reason>`.
5. **Red Queen.** When a finding is something a rule should have prevented (it recurs, or
   it breaks a project convention), propose the rule text and where it belongs
   (`CLAUDE.md` or a skill). Don't apply it without approval.
6. Tick `/review` in the coverage checklist, for example `5 findings: 3 fixed, 2 won't fix`,
   and commit `review.md` and `plan.md` as `docs(sdlc): review for <feature>`.
