# agentic-sdlc

The software lifecycle we always agreed on, run by the agent instead of skipped.

```text
/spec  →  /plan  →  /build  →  /test  →  /review  →  /code-simplify  →  /pr
grill     slice     test-first  close     fresh-eyes   tidy, same       gates +
& write   tasks     one commit  gaps      review       behavior         evidence
```

Each command has one job, backed by a skill that knows how to do it well. Each one leaves
evidence in `sdlc/<branch>/`, so the next session, the reviewer and `/pr` can see what
actually happened. You approve at the gates: the spec, the plan and the PR.

## Install

### Claude Code (recommended)

```text
/plugin marketplace add haco29/agentic-sdlc
/plugin install agentic-sdlc@haco29
```

Restart Claude Code, type `/`, and you should see `/spec` through `/pr`. If another plugin
or your own config already defines a command with the same name, use the namespaced form,
e.g. `/agentic-sdlc:spec`.

### Cursor, or Claude Code without plugins

```bash
git clone https://github.com/haco29/agentic-sdlc.git
cd agentic-sdlc
scripts/install.sh            # Claude Code: ~/.claude
scripts/install.sh --cursor   # Cursor: ~/.cursor
```

Existing files are skipped unless you pass `--force`.

## The commands

| Command | Does | Leaves behind |
|---|---|---|
| `/spec` | Grills you one question at a time, then writes the spec and asks for approval | `spec.md` with `Status: Approved` |
| `/plan` | Slices the spec into 2–5 vertical tasks, each with acceptance criteria and its test | `plan.md`, `todo.md` |
| `/build` | Next task: failing test, smallest fix, full suite, one commit. `/build auto` runs them all after one approval | Commits, ticked `todo.md`, test evidence |
| `/test` | Maps every success criterion and edge case to a test and closes the gaps; or reproduces a bug test-first | New tests, a criteria → tests table |
| `/review` | Five-axis review (correctness, readability, architecture, security, performance) by a reviewer agent in its own context | `review.md` with a status per finding |
| `/code-simplify` | Simplifies without changing behavior, one change at a time, tests green throughout | A `refactor:` commit, or "nothing to simplify" |
| `/pr` | Checks the gates and opens a PR that carries the evidence; writes `pr.md` when there's no GitHub | A PR, or `pr.md` |

## Artifacts and gates

```text
sdlc/<branch>/
├── spec.md      objective, scope, numbered success criteria, edge-case decisions, status
├── plan.md      approach, tasks, risks, command coverage, test evidence log
├── todo.md      one checkbox per task
├── review.md    findings and what happened to each
└── pr.md        only when no PR could be opened
```

`plan.md` carries a **command coverage** checklist. Each command ticks its own line, and a
skip is fine when it's written down as `skipped: <reason>`. `/pr` won't open a ready PR until
six gates pass: approved spec, a real plan, all tasks closed, tests and linters green now,
every success criterion mapped to code and a test, and full command coverage. The rules live
in [`skills/sdlc-artifacts`](skills/sdlc-artifacts/SKILL.md).

## What's in the box

| Part | Source |
|---|---|
| `commands/`, `skills/sdlc-artifacts`, `skills/open-pull-request` | This repo: the loop, the artifact layout, the gates and `/pr` |
| `skills/*` (everything else), `agents/`, `references/` | Vendored from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) at a pinned commit, see [UPSTREAM.md](UPSTREAM.md) |

The vendored files get two mechanical rewrites (skill namespace and artifact paths) and are
otherwise unchanged. To update them:

```bash
scripts/sync-upstream.sh <commit>   # then review the diff
```

## Changing the process

Treat the kit like code. When a review keeps flagging the same thing, or a step keeps
feeling wrong, change the skill or command in a PR, not in your head. That's the Red Queen
loop applied to the process itself.

## License

MIT, see [LICENSE](LICENSE). Vendored files are © Addy Osmani, MIT, see
[licenses/agent-skills-LICENSE](licenses/agent-skills-LICENSE).
