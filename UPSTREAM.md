# Upstream

The skills, agents and references listed below are vendored from
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT, see
`licenses/agent-skills-LICENSE`).

Commit: 1401c8b8030e023baeebb31781a6653fe8e93026

Three mechanical rewrites are applied by `scripts/sync-upstream.sh`, nothing else:

1. Skill references `agent-skills:<skill>` become `sdlc:<skill>`.
2. Artifact paths `SPEC.md`, `tasks/plan.md` and `tasks/todo.md` become
   `sdlc/<branch>/spec.md`, `plan.md` and `todo.md`.
3. Command names `/spec`, `/plan`, `/build`, `/test`, `/review`, `/code-simplify`
   and `/pr` become `/sdlc:spec` and so on, because plugin commands are namespaced.

To update, run `scripts/sync-upstream.sh <commit>` and review the diff.

## Vendored skills

- api-and-interface-design
- browser-testing-with-devtools
- ci-cd-and-automation
- code-review-and-quality
- code-simplification
- constraint-driven-development
- context-engineering
- debugging-and-error-recovery
- deprecation-and-migration
- documentation-and-adrs
- doubt-driven-development
- frontend-ui-engineering
- git-workflow-and-versioning
- idea-refine
- incremental-implementation
- interview-me
- observability-and-instrumentation
- performance-optimization
- planning-and-task-breakdown
- security-and-hardening
- shipping-and-launch
- source-driven-development
- spec-driven-development
- test-driven-development
- using-agent-skills

## Vendored agents and references

- agents/code-reviewer.md
- agents/security-auditor.md
- agents/test-engineer.md
- agents/web-performance-auditor.md
- references/accessibility-checklist.md
- references/definition-of-done.md
- references/observability-checklist.md
- references/orchestration-patterns.md
- references/performance-checklist.md
- references/security-checklist.md
- references/testing-patterns.md
