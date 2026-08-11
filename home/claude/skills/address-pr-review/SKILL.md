---
name: address-pr-review
description: Work through review comments received on your own PR — fix valid ones (commit, push, reply, resolve) and push back on invalid ones (reply, resolve). Use when the user says "address the PR comments", "handle my review feedback", or "respond to the review on PR 123".
---

# Address PR review

Clear every open review thread on the user's PR. Each thread ends in exactly one
of two states: **fixed** or **answered** — and resolved either way.

**All replies are 1–2 sentences. No apologies, no restating the comment, no
thanks-for-the-feedback. Fewer words is better.**

## 1. Collect the threads

Default to the current branch's PR. Get thread IDs, resolution state, and the
first comment's `databaseId` (needed to reply):

```bash
gh repo view --json owner,name
gh api graphql -f query='
query($owner:String!,$repo:String!,$pr:Int!){
  repository(owner:$owner,name:$repo){ pullRequest(number:$pr){
    reviewThreads(first:100){ nodes{ id isResolved isOutdated path line
      comments(first:20){ nodes{ databaseId author{login} body } } } } } } }' \
  -F owner=OWNER -F repo=REPO -F pr=N
```

Skip already-resolved threads. Also check top-level review bodies
(`gh pr view <n> --json reviews`) — those get a plain `gh pr comment` reply.

## 2. Judge each comment

Read the actual code before deciding. A comment is **valid** if it's correct, or
if the reviewer was misled by unclear code (then the fix is clarity). It's
**invalid** if it's factually wrong about the code, or already handled elsewhere.

Don't fold just because a reviewer is senior, and don't argue to save face.

## 3. If valid: fix → commit → push → reply → resolve

1. Make the fix. Scope it to the comment — no drive-by refactors.
2. Commit per comment (or per tight group), matching the repo's message style
   (`git log --oneline -10`).
3. Run the project's checks before pushing (see `done-check`), then push once
   after all fixes.
4. Reply with what changed + the commit sha:

```bash
gh api repos/{owner}/{repo}/pulls/<n>/comments/<comment_databaseId>/replies \
  -f body="Fixed in <sha> — <what changed>."
```

5. Resolve:

```bash
gh api graphql -f query='mutation($id:ID!){
  resolveReviewThread(input:{threadId:$id}){ thread{ isResolved } } }' -F id=THREAD_ID
```

## 4. If invalid: reply → resolve

Reply with the reason — cite the code or behaviour that makes the comment moot,
then resolve. Same two commands as above, minus the fix.

> `Intentional — X guards this at src/a.ts:12.`
> `Already handled by Y; no change needed.`

## Exceptions — leave unresolved

- The comment asks a question only the user or reviewer can answer → reply
  asking, leave open, tell the user.
- The valid fix is bigger than this PR → reply proposing a follow-up issue,
  leave open.

## Finish

Report a one-line-per-thread summary: fixed (with sha), pushed back (with
reason), or left open (with why). Say plainly if any check failed.
