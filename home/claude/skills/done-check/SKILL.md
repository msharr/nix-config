---
name: done-check
description: Verify that code changes actually pass before telling the user a task is done. Use after implementing or editing code in a JS/TS project — before claiming completion, before committing, or before opening a PR. Runs typecheck, tests, and lint and reports the real results.
---

# Done check

Do not tell the user a coding task is "done", "working", or "ready" until the
project's checks actually pass. "It should work" is not done. Run the checks,
read the output, and report what really happened.

## What to run

These tools are not on the global PATH — run everything through the nix
devShell with `nix develop -c` (see the `nix-dev` skill).

1. **Discover the real commands first.** Read `package.json` `scripts` (or the
   project's task runner / `Makefile` / `CLAUDE.md`) to find the actual script
   names. Don't assume — projects vary (`typecheck` vs `tsc --noEmit`, `test`
   vs `vitest run`, `lint` vs `eslint .`). Use whichever package manager the
   repo uses (`bun`/`pnpm` — check the lockfile).

2. Run the relevant checks for what you changed, typically:
   - **Typecheck** — e.g. `nix develop -c bun run typecheck`
   - **Tests** — e.g. `nix develop -c bun test` (or scope to affected tests for
     speed, but run the full suite before a final "done"/commit/PR)
   - **Lint / format** — e.g. `nix develop -c bun run lint`

3. If a check script genuinely doesn't exist, say so rather than inventing one.

## Rules

- **Run, don't assume.** Actually execute the commands. Allow a generous timeout
  on the first `nix develop -c` call (devShell build).
- **Report honestly.** If something fails, show the failing output and say it's
  failing. Never round a failure up to success or bury it.
- **Fix and re-run.** If a check fails, fix the cause and run it again until it
  passes (or until you're genuinely stuck — then surface the blocker with the
  error).
- **Don't disable checks to make them pass.** No deleting tests, `// @ts-ignore`,
  `eslint-disable`, or skipping suites just to get green, unless the user
  explicitly asks. Flag it if that seems like the only option.
- **Then report.** End with a short status: which checks ran and their result
  (e.g. "typecheck ✓, tests ✓ 142 passed, lint ✓"). Only now is it "done".
