---
name: code-style
description: House rules for writing code — no comments, minimum additions, KISS/SOLID/YAGNI/DRY, core-only tests. Use whenever writing, editing, or refactoring code in any language, before the first line is written.
---

# Code style

Write code that would pass the `pr-review` skill on the first read. These rules
apply to every change, not just the ones headed for a PR.

## No comments

- **Default is zero.** Express intent through names and structure. If a comment
  is explaining *what* the code does, rename or split instead.
- **Only exception:** a *why* that cannot be read from the code — a non-obvious
  constraint, a workaround with a link, a deliberate deviation. **Two lines max.**
- Never write: section banners, JSDoc restating the signature, TODOs,
  commented-out code, or narration of the change ("now handles X").
- Delete stale comments in code you're already touching. Leave the rest alone.

## Minimum diff

Additions are the cost. Removals are free.

- Ship the smallest change that fully does the job. Nothing staged for later.
- Extend what exists before adding a file, abstraction, or dependency — search
  the repo first.
- No drive-by refactors, renames, or reformatting. They bury the real change.
- No options, flags, or extension points nobody asked for.
- A diff that deletes more than it adds is a good outcome, not a suspicious one.

## Principles

- **KISS** — plain code over clever. No indirection that doesn't earn itself.
- **SOLID** — one job per unit; depend on abstractions, not concrete details.
- **YAGNI** — no generality without a current caller.
- **DRY** — deduplicate *knowledge* (a rule that must change in two places), not
  code that merely looks alike. Rule of three before abstracting.

## Tests

Core coverage, not full coverage.

- One test per behaviour that would actually break something if wrong. Stop there.
- Test the public behaviour, not the implementation.
- Skip: getters, wiring, type-only changes, framework and library behaviour,
  permutations of an already-covered path.
- Extend the existing test file and its conventions rather than adding a new one.
- If a change genuinely isn't worth a test, say so instead of writing a hollow one.

## Match the codebase

Read the neighbouring code before writing. Copy its naming, structure, error
handling, and idiom — consistency beats your preference. Use the repo's existing
helpers and libs; don't add a dependency without asking.

## Before finishing

Re-read your own diff and cut everything that isn't needed, then run the
project's checks (`done-check`).
