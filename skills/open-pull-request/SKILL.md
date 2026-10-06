---
name: open-pull-request
description: Checks the SDLC gates for the current branch and opens a pull request that carries the evidence, or writes the PR description to sdlc/<branch>/pr.md when no PR can be opened. Use when the user runs /pr or asks to open, raise or prepare a pull request.
---

# Open a pull request

A PR is the end of the loop, so it should prove the loop ran. Paths, gates and the coverage
checklist are defined in `agentic-sdlc:sdlc-artifacts`.

## Steps

1. **Resolve the folder.** On the default branch or a detached HEAD, stop and ask for a
   feature branch.
2. **Check the working tree.** Run `git status --porcelain`. Uncommitted changes inside
   `$DIR/` are artifacts: commit them as `docs(sdlc): artifacts for <feature>`. Any other
   uncommitted change: show it and ask the user to commit or stash it. Don't commit code on
   their behalf here.
3. **Run the gates.** Find the project's test and lint commands (its `CLAUDE.md`, `README`,
   or CI config) and run them yourself for G4. Append the run to Test evidence. Show the
   gate table.
4. **Decide readiness.**
   - All gates pass: open a ready PR.
   - Any gate fails: name the failing gates and ask: fix first (recommended), or open a
     **draft** that lists the failures. Never open a ready PR with a failing gate.
5. **Write the title and body.**
   - Title: conventional-commit style, from the spec's objective, at most 72 characters.
   - Body, in this order:
     - **Why**: the spec's objective, linking `spec.md`.
     - **What changed**: one line per task from `plan.md`.
     - **How it was tested**: the latest Test evidence lines, verbatim.
     - **Gates**: the gate table.
     - **Review**: from `review.md`, what was fixed and what was deferred, with reasons.
     - **Out of scope**: the spec's non-goals and any follow-ups.
6. **Choose the repo and base.** The PR goes to the repository `origin` points at:
   `gh repo view --json nameWithOwner,isFork,defaultBranchRef`. On a fork, `gh` would
   otherwise target the parent, so always pass `--repo <nameWithOwner>` unless the user asks
   for the parent. The base is the branch the user named, else that repo's default branch.
7. **Open it.**
   - When `gh auth status` succeeds and `origin` is on GitHub: `git push -u origin HEAD`,
     write the body to a temporary file, then
     `gh pr create --repo <nameWithOwner> --base <base> --title "<title>" --body-file <file>`
     (add `--draft` when a gate failed). Print the PR URL.
   - Otherwise (no GitHub, no `gh`, no network): write `$DIR/pr.md` with the title, base
     and body, and tell the user to paste it into their review tool.
8. **Tick nothing new.** `/pr` is not in the coverage list; the PR itself is the evidence.

## Never

- Push to the base branch, force-push, or merge.
- Mark a failing gate as passing, or tick coverage lines for commands that didn't run.
- Pad the body with claims that aren't in the artifacts.
