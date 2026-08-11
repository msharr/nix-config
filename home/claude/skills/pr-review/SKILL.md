---
name: pr-review
description: Review a GitHub pull request — judge intent first, then hunt KISS/SOLID/YAGNI/DRY violations, then approve or request changes on GitHub. Use when the user asks to review a PR, review this branch, or says "review PR 123".
---

# PR review

Review a PR properly, then commit to a verdict on GitHub. Two failure modes to
avoid: rubber-stamping, and nitpicking a PR whose _purpose_ you never checked.

**All written output — review body, inline comments — is 1–2 sentences per point.
No preamble, no praise padding, no hedging ("maybe consider possibly"). Fewer
words is better.**

## Target

Default to the PR for the current branch; otherwise take the number/URL given.

```bash
gh pr view <n> --json title,body,author,url,baseRefName,headRefName,additions,deletions,files,commits
gh pr diff <n>
gh pr checks <n>
```

## 1. Understand the spirit first

Before judging any line of code, answer these for yourself:

- **Why** does this exist — what problem, whose pain? Read the body and the
  linked issue/ticket (fetch it if linked; Linear tools if it's a Linear ID).
- **Who is it for** — end user, teammate, ops, future maintainer?
- **Does it actually address that?** Map the stated goal to the diff. Look for
  the gap: partial fixes, symptom-patching over root cause, and scope creep
  (changes unrelated to the stated goal).

If intent is unclear from the PR and the ticket, say so and ask — don't guess.
If the diff doesn't serve the stated intent, that's the review's headline; code
quality is secondary.

If there is a linear code on the PR, read using Linear MCP

## 2. Read the code, not just the diff

Open the changed files and their callers/tests. A diff reads fine in isolation
and still be wrong in context. Check tests exist for new behaviour.

Then look for real violations:

- **KISS** — simpler equivalent available? Needless indirection, layers,
  config, or clever code where plain code works.
- **SOLID** — mainly: does one unit do one job (SRP), and do dependencies point
  at abstractions rather than concrete details? Flag god-objects and
  bidirectional coupling.
- **YAGNI** — speculative generality: options, hooks, interfaces, and
  extensibility with no current caller.
- **DRY** — genuine duplicated _knowledge_ (a rule encoded twice that must
  change together). Coincidentally similar code is not duplication; apply the
  rule of three before asking for an abstraction.

Also flag correctness, security, and data-loss risks — principles never outrank
a bug.

Skip what tooling owns: formatting, lint, import order, style preference. Don't
propose rewrites of code the PR didn't touch.

## 3. Approve or request changes

Rank findings: **blocking** (wrong, unsafe, or misses the intent) vs **note**
(worth fixing, not worth blocking).

- Blocking findings exist → `--request-changes`.
- None → `--approve`, listing any notes as non-blocking.

```bash
gh pr review <n> --approve --body "..."
gh pr review <n> --request-changes --body "..."
```

Inline comments, when a point belongs on a line:

```bash
# review.json: {"event":"REQUEST_CHANGES","body":"...",
#   "comments":[{"path":"src/a.ts","line":42,"side":"RIGHT","body":"..."}]}
gh api repos/{owner}/{repo}/pulls/<n>/reviews --input review.json
```

Review body shape — keep it this tight:

```
Intent: <one line: what this is for, and whether the diff delivers it>

Blocking
- src/foo.ts:42 — <problem>. <fix>.

Notes
- src/bar.ts:10 — <problem>. <fix>.
```

GitHub refuses approval on your own PR — fall back to `--comment` and state the
verdict in the body. Never approve without having read the diff.
