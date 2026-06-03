# Global Codex Working Agreements

## Commit Gate

- Before creating any Git commit, run `git fetch --all --prune` or the narrowest appropriate `git fetch` for the repository remote setup.
- Before creating any Git commit, inspect the current change set with `git status` and the relevant diff.
- Before creating any Git commit, perform a code-review pass focused on bugs, behavioral regressions, security risks, and missing tests.
- Resolve every actionable code-review finding before committing. If a finding cannot be resolved, do not commit until the user explicitly accepts the residual risk.
- Do not create a commit when fetch failed, review was skipped, review findings remain unresolved, or verification needed for the change could not run.

## Commit Message Format

- Write commit messages in Markdown format.
- Make commit messages detailed enough for review: include a concise subject, a clear summary of changed behavior, important implementation notes, and verification performed.
- Keep the commit focused on the reviewed and resolved change set only.
